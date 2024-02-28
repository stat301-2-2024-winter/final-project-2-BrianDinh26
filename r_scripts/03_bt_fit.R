# Final Project, Brian Dinh ----
# Define and fit a boosted tree model.
# We use a random process when fitting, so we have to set a seed beforehand.

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xgboost)

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
bt_model <- boost_tree(
  mode = "regression",
  min_n = tune(),
  mtry = tune(),
  trees = 500,
  learn_rate = tune()) |>
  set_engine("xgboost")

# define workflows ----
boost_workflow_eng <- workflow() |>
  add_model(bt_model) |>
  add_recipe(engineered_tree_recipe)

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_model)

# change hyperparameter ranges
bt_params <- hardhat::extract_parameter_set_dials(bt_model) |> 
  update(mtry = mtry(c(1, 9)),
         min_n = min_n(c(2, 15)),
         learn_rate = learn_rate(range = c(-5, -0.2))
  ) 

# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
set.seed(925)
tuned_bt_eng <- tune_grid(boost_workflow_eng,
                          cars_folds,
                          grid = bt_grid,
                          control = control_grid(save_workflow = TRUE))

tuned_bt_eng |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  arrange((mean))

# save out results
save(tuned_bt_eng, file = here("results/tuned_bt_eng.rda"))


