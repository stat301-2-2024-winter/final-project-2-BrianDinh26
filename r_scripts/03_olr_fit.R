# Final Project, Brian Dinh ----
# Define and fit ordinary linear regression model, kitchen sink recipe.
# We use a random process when fitting, so we have to set a seed beforehand.

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# mac user code for parallel processing
library(doMC)

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/cars_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/sink_recipe.rda"))

set.seed(925)
# model specifications ----
lm_spec <-
  linear_reg() |>
  set_engine("lm") |>
  set_mode("regression")

# kitchen sink recipe
lm_wflow <-
  workflow() |>
  add_model(lm_spec) |>
  add_recipe(sink_recipe)

set.seed(925)
olr_lm_fit <- fit_resamples(lm_wflow,
                            resamples = cars_folds,
                            control = control_resamples(save_workflow = TRUE))

olr_lm_fit |> collect_metrics()

# save out results
save(olr_lm_fit, file = here("results/olr_lm_fit.rda"))
