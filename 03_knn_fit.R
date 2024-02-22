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
load(here("results/cars_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/tree_recipe.rda"))

set.seed(925)
# model specifications ----
knn_spec <- 
  nearest_neighbor(mode = "regression", 
                   neighbors = tune()) |> 
  set_engine("kknn")


# define workflows ----
knn_workflow <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(tree_recipe)

# check hyperparameters
knn_params <- hardhat::extract_parameter_set_dials(knn_spec)
# not set yet

# grid
elastic_grid <- grid_regular(knn_params, levels = 7)

# fit workflows/models ----
set.seed(925)
tuned_knn <- tune_grid(knn_workflow,
                       cars_folds,
                       grid = elastic_grid,
                       control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_knn, file = here("results/tuned_knn.rda"))

tuned_knn |> 
  collect_metrics() |>
  filter(.metric == "rmse") |> 
  arrange((mean))
