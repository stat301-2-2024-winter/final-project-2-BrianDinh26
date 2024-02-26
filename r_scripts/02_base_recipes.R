# Final Project, Brian Dinh ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

load(here("results/cars_split.rda"))

# kitchen sink recipe
sink_recipe <- recipe(price_usd ~ .,
                     data = cars_train) |> 
  step_rm(model_name, location_region, engine_fuel) |> 
  step_dummy(all_nominal_predictors()) |>
  step_impute_knn(engine_capacity) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# tree-based kitchen sink recipe (knn, bt, rf)
tree_recipe <- recipe(price_usd ~ .,
                      data = cars_train) |> 
  step_rm(model_name, location_region, model_name, engine_fuel) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_impute_knn(engine_capacity) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

save(sink_recipe, file = here("recipes/sink_recipe.rda"))
save(tree_recipe, file = here("recipes/tree_recipe.rda"))


