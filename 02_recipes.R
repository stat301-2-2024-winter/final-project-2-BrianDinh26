# Final Project, Brian Dinh ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load(here("results/cars_split.rda"))


#alright final olr recipe to use for 03

#relabel to kitchen sink recipe later before submitting.
olr_recipe <- recipe(price_usd ~ .,
                     data = cars_train) |> 
  step_rm(model_name, location_region, model_name, engine_fuel) |> 
  step_dummy(all_nominal_predictors()) |> # DO NOT ONE HOT ENCODE.
  step_impute_knn(engine_capacity) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

# for rf consider doing tuning instead...
rf_recipe <- recipe(price_usd ~ .,
                    data = cars_train) |> 
  step_rm(model_name, location_region, model_name, engine_fuel) |> 
  step_dummy(all_nominal_predictors()) |> # DO NOT ONE HOT ENCODE.
  step_impute_knn(engine_capacity) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

save(olr_recipe, rf_recipe, file = here("recipes/recipes.rda"))
