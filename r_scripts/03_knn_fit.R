# Final Project, Brian Dinh ----
# Define and fit a k-nearest neighbors model, kitchen sink recipe.
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

set.seed(925)
# model specifications ----
knn_spec <-
  nearest_neighbor(mode = "regression",
                   neighbors = tune()) |>
  set_engine("kknn")

# define workflows ----
knn_workflow <-
  workflow() |>
  add_model(knn_spec) |>
  add_recipe(tree_recipe)

# check hyperparameters
knn_params <- hardhat::extract_parameter_set_dials(knn_spec)

# grid
knn_grid <- grid_regular(knn_params, levels = 5)

set.seed(925)
knn_fit <- tune_grid(
  knn_workflow,
  resamples = cars_folds,
  grid = knn_grid,
  control = control_resamples(save_workflow = TRUE)
)

knn_fit |>
  collect_metrics() |>
  filter(.metric == "rmse") |>
  arrange((mean))

# write out results
save(knn_fit, file = here("results/tuned_knn.rda"))
