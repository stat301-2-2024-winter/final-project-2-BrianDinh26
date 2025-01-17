# Final Project, Brian Dinh ----
# Define and fit ordinary linear regression model, feature engineered recipe.
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
load(here("recipes/engineered_reg_recipe.rda"))

set.seed(925)
# model specifications ----
lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# new recipe version.
lm_wflow_eng <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(engineered_reg_recipe)

set.seed(925)
olr_lm_fit_eng <- fit_resamples(lm_wflow_eng, 
                                resamples = cars_folds,
                                control = control_resamples(save_workflow = TRUE))

olr_lm_fit_eng |> collect_metrics()

# save out results
save(olr_lm_fit_eng, file = here("results/olr_lm_fit_eng.rda"))

