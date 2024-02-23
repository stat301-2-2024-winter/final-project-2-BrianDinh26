# Final Project, Brian Dinh ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load split data
load(here("results/cars_split.rda"))

# feature engineered recipe for regression
engineered_reg_recipe <- recipe(price_usd ~ .,
                      data = cars_train) |> 
  step_rm(model_name, location_region, model_name, engine_fuel) |> 
  step_dummy(all_nominal_predictors()) |>
  step_impute_knn(engine_capacity) |> 
  step_interact(terms = ~starts_with("price_usd"):year_produced) |>
  step_interact(terms = ~starts_with("duration_listed"):up_counter) |>
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(engineered_reg_recipe) |> 
  bake(new_data = NULL) |> 
  head(n = 5)

# test fit using null model
set.seed(925)
# model specifications
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression")

# set workflow
null_workflow <- workflow() |>  
  add_model(null_spec) |>  
  add_recipe(engineered_reg_recipe)

set.seed(925)
test_null_fit <- null_workflow |> 
  fit_resamples(
    resamples = cars_folds
  )

test_null_fit |> collect_metrics()
kitchen_sink_metric_table
