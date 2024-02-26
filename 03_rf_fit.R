# Final Project, Brian Dinh ----
# Define and fit a random forest model.
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
load(here("results/cars_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/tree_recipe.rda"))
load(here("results/engineered_tree_recipe.rda"))

set.seed(925)
# model specifications ----
rf_spec <- 
  rand_forest(
    mode = "regression",
    trees = 100, 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger")

# define workflows ----
rf_workflow <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(tree_recipe)

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec)

# change hyperparameter ranges (for later tuning)

# this is the part that isn't working.
rf_params <- parameters(rf_spec) |> 
  update(mtry = mtry(c(1, 14)),
         min_n = min_n(c(2, 15)))

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
set.seed(925)
rf_fit <- tune_grid(rf_workflow, 
                        resamples = cars_folds,
                        grid = rf_grid,
                        control = control_resamples(save_workflow = TRUE))

# save out results
save(rf_fit, file = here("results/rf_fit.rda"))

load(here("results/rf_fit.rda"))

rf_fit |> collect_metrics() |> 
  filter(.metric == "rmse") |> 
  arrange((mean))

# the feature engineered rf model

rf_workflow_eng <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(engineered_tree_recipe)

fake_workflow <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(tester_recipe)

set.seed(925)
rf_fit_eng <- tune_grid(rf_workflow_eng, 
                    resamples = cars_folds,
                    grid = rf_grid,
                    control = control_resamples(save_workflow = TRUE))

rf_fit_eng |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  arrange((mean))

save(rf_fit_eng, file = here("results/rf_fit_eng.rda"))
