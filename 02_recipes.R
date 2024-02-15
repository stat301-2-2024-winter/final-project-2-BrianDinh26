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

#better recipe...
better_recipe <- recipe(price_usd ~ .,
                  data = cars_train) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_impute_knn(engine_capacity) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(better_recipe) |> 
  bake(new_data = NULL) |> 
  head(n = 2) |> 
  DT::datatable()

skimr::skim(cars_train)
# too many unique model names and manufacturer names, color. 
# engine type and engine fuel are the same thing. remove engine fuel.

# a test recipe to see if training works at all on the dataset

testrecipe <- recipe(price_usd ~ number_of_photos + duration_listed + odometer_value + 
                       state + feature_0 + feature_1 + engine_capacity,
              data = cars_train) |> 
  step_dummy(all_nominal_predictors()) |> # DO NOT ONE HOT ENCODE.
  step_impute_knn(engine_capacity) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(testrecipe) |> 
  bake(new_data = NULL) |> 
  head(n = 2) |> 
  DT::datatable()

# model specifications ----
lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(testrecipe)

# fit workflows/models ----
# need to add resampling method.
set.seed(925)
lm_testing_fit <- fit_resamples(lm_wflow, 
                        resamples = cars_folds)

#collect metrics
lm_testing_fit |> collect_metrics()

#need to work on the integrity of the recipe
standard_recipe <- recipe(log_price_usd ~ .,
                          data = cars_train) |> 
  step_rm(price_usd, model_name) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(standard_recipe) |> 
  bake(new_data = NULL) |> 
  head(n = 5) |> 
  DT::datatable()

# need at lesat six model types

#alright final olr recipe to use for 03

olr_recipe <- recipe(price_usd ~ .,
                     data = cars_train) |> 
  step_rm(model_name, location_region, model_name, engine_fuel) |> 
  step_dummy(all_nominal_predictors()) |> # DO NOT ONE HOT ENCODE.
  step_impute_knn(engine_capacity) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

save(olr_recipe, file = here("recipes/olr_recipes.rda"))
save(standard_recipe, file = here("recipes/recipes.rda"))
