# Final Project, Brian Dinh ----
# Define and fit a k-nearest neighbors model.
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
load(here("recipes/tree_recipe.rda"))
load(here("recipes/engineered_tree_recipe.rda"))

set.seed(925)
# model specifications ----
knn_spec <- 
  nearest_neighbor(mode = "regression", 
                   neighbors = tune()) |> 
  set_engine("kknn")


# define workflows ----
knn_workflow_eng <-
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(engineered_tree_recipe)


# check hyperparameters
knn_params <- hardhat::extract_parameter_set_dials(knn_spec)
# not set yet

# grid
knn_grid <- grid_regular(knn_params, levels = 5)

set.seed(925)
knn_fit_eng <- tune_grid(knn_workflow_eng, 
                        resamples = cars_folds,
                        grid = knn_grid,
                        control = control_resamples(save_workflow = TRUE))

knn_fit_eng |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  arrange((mean))

save(knn_fit_eng, file = here("results/tuned_knn_eng.rda"))

