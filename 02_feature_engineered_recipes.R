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
  step_rm(model_name, location_region, engine_fuel) |> 
  step_dummy(all_nominal_predictors()) |>
  step_impute_knn(engine_capacity) |> 
  step_log(engine_capacity, number_of_photos) |> 
  #step_interact(terms = ~starts_with("price_usd"):year_produced) |>
  step_interact(terms = ~starts_with("duration_listed"):up_counter) |>
  step_interact(terms = ~starts_with("is_exchangeable"):price_usd) |>
  step_interact(terms = ~starts_with("duration_listed"):number_of_photos) |>
  step_interact(terms = ~starts_with("odometer_value"):year_produced)  |> 
  step_interact(terms = ~starts_with("drivetrain"):price_usd)  |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# price usd and year produced overfits the model too much

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

test_null_fit |> 
  collect_metrics()

hey <- test_null_fit |> collect_metrics()
#baseline is 1.0274980 for kitchen sink null model btw

# improved to 1.021047, best i can get.
load(here("results/kitchen_sink_metric_table.rda"))
kitchen_sink_metric_table

# save the recipe
save(engineered_reg_recipe, file = here("results/engineered_reg_recipe.rda"))

# tree recipe feature engineered
engineered_tree_recipe <- recipe(price_usd ~ .,
                                data = cars_train) |> 
  step_rm(model_name, location_region, engine_fuel) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_impute_knn(engine_capacity) |> 
  step_log(engine_capacity, number_of_photos) |> 
  #step_interact(terms = ~starts_with("price_usd"):year_produced) |>
  step_interact(terms = ~starts_with("duration_listed"):up_counter) |>
  step_interact(terms = ~starts_with("is_exchangeable"):price_usd) |>
  step_interact(terms = ~starts_with("duration_listed"):number_of_photos) |>
  step_interact(terms = ~starts_with("odometer_value"):year_produced)  |> 
  step_interact(terms = ~starts_with("drivetrain"):price_usd)  |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

prep(engineered_tree_recipe) |> 
  bake(new_data = NULL) |> 
  head(n = 5)

save(engineered_tree_recipe, file = here("results/engineered_tree_recipe.rda"))
