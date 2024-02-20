# Final Project, Brian Dinh ----
# Define and fit a random forest model.
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
load(here("recipes/olr_recipes.rda"))

set.seed(925)
# model specifications ----
rf_spec <- 
  rand_forest() |> 
  set_engine("ranger") |> 
  set_mode("regression")

# define workflows ----
rf_workflow <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(rf_recipe)

# fit workflows/models ----
set.seed(925)
rf_fit <- fit(rf_workflow, cars_train)

# save out results
save(rf_fit, file = here("results/rf_fit.rda"))

rf_fit
