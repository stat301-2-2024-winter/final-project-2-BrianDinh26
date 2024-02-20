# Final Project, Brian Dinh ----
# Define and fit ordinary linear regression model.
# We use a random process when fitting, so we have to set a seed beforehand.

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("results/cars_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/sink_recipe.rda"))

set.seed(925)
# model specifications ----
lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(sink_recipe)

# fit workflows/models ----
set.seed(925)
olr_lm_fit <- fit_resamples(lm_wflow, 
                        resamples = cars_folds,
                        control = control_resamples(save_workflow = TRUE))

# save out results
save(olr_lm_fit, file = here("results/olr_lm_fit.rda"))

load(here("results/olr_lm_fit.rda"))

olr_lm_fit |> collect_metrics()
