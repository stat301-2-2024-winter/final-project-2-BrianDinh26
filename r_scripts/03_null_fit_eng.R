# Final Project, Brian Dinh ----
# Define and fit null model, feature engineered recipe.
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
# model specifications
null_spec <- null_model() |>
  set_engine("parsnip") |>
  set_mode("regression")

# set workflow
null_workflow_eng <- workflow() |>
  add_model(null_spec) |>
  add_recipe(engineered_reg_recipe)

set.seed(925)
null_fit_eng <- null_workflow_eng |>
  fit_resamples(resamples = cars_folds,
                control = control_resamples(save_workflow = TRUE))

# save out results
save(null_fit_eng, file = here("results/null_fit_eng.rda"))