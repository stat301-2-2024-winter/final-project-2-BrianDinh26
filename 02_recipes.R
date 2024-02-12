# Final Project, Brian Dinh ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load(here("results/cars_split.rda"))

#i have to make all the logical variables into factor variables...
#possibly use thresholds?

#need to work on the integrity of the recipe
standard_recipe <- recipe(log_price_usd ~ .,
                          data = cars_train) |> 
  step_rm(manufacturer_name, model_name, color, location_region, price_usd) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_normalize()

prep(standard_recipe) |> 
  bake(new_data = NULL) |> 
  head(n = 5) |> 
  DT::datatable()

# random forest recipe.
rf_recipe <- recipe(log_price_usd ~.,
                    data = cars_train) |> 
  step_rm(manufacturer_name, model_name, color, location_region, price_usd) |> 
  step_impute_knn(engine_capacity) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_normalize(all_predictors())

prep(rf_recipe) |> 
  bake(new_data = NULL) |> 
  head(n = 5) |> 
  DT::datatable()

# need at lesat six model types

save(standard_recipe, rf_recipe, file = here("recipes/recipes.rda"))

