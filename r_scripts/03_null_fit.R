# Final Project, Brian Dinh ----
# Define and fit null model.
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
load(here("recipes/engineered_reg_recipe.rda"))

set.seed(925)
# model specifications
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression")

# set workflow
null_workflow <- workflow() |>  
  add_model(null_spec) |>  
  add_recipe(sink_recipe)

set.seed(925)
null_fit <- null_workflow |> 
  fit_resamples(
    resamples = cars_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

# save out results
save(null_fit, file = here("results/null_fit.rda"))

load(file = here("results/null_fit.rda"))

null_fit |> collect_metrics() |> 
  filter(.metric == 'rmse')

# new recipe version.
null_wflow_eng <-
  workflow() |> 
  add_model(null_spec) |> 
  add_recipe(engineered_reg_recipe)

set.seed(925)
null_fit_eng <- fit_resamples(null_wflow_eng, 
                                resamples = cars_folds,
                                control = control_resamples(save_workflow = TRUE))

null_fit_eng |> collect_metrics()
# ah shoot did I overfit?

# save out results
save(null_fit_eng, file = here("results/null_fit_eng.rda"))

