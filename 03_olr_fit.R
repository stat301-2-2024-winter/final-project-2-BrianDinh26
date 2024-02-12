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
load(here("recipes/recipes.rda"))

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
  add_recipe(standard_recipe)

# fit workflows/models ----
set.seed(925)
lm_fit <- fit(lm_wflow, abalone_train)

# save out results
save(lm_fit, file = "results/olr_fit.rda")
