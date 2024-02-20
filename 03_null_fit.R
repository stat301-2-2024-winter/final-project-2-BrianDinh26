# Final Project, Brian Dinh ----
# Define and fit null model.
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
# model specifications
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression")

# set workflow
null_workflow <- workflow() |>  
  add_model(null_spec) |>  
  add_recipe(olr_recipe)

set.seed(925)
null_fit <- null_workflow |> 
  fit_resamples(
    resamples = cars_folds, 
    control = control_resamples(save_workflow = TRUE)
  )



# save out results
save(null_fit, file = here("results/null_fit.rda"))

load(here("results/olr_lm_fit.rda"))

null_fit |> collect_metrics()
