# Final Project, Brian Dinh ----
# Setup pre-processing/recipes, feature engineered

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load split data
load(here("data_splits/cars_split.rda"))

# feature engineered recipe for regression
engineered_reg_recipe <- recipe(price_usd ~ .,
                                data = cars_train) |>
  step_rm(model_name,
          location_region,
          engine_fuel,
          color,
          engine_has_gas) |>
  step_dummy(all_nominal_predictors()) |>
  step_impute_knn(engine_capacity) |>
  step_log(engine_capacity, number_of_photos) |>
  step_interact(terms = ~ starts_with("duration_listed"):up_counter) |>
  step_interact(terms = ~ starts_with("engine_type"):engine_capacity) |>
  step_interact(terms = ~ starts_with("is_exchangeable"):duration_listed) |>
  step_interact(terms = ~ starts_with("manufacturer_name"):year_produced) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

prep(engineered_reg_recipe) |>
  bake(new_data = NULL) |>
  head(n = 5)

# save the recipe
save(engineered_reg_recipe,
     file = here("recipes/engineered_reg_recipe.rda"))

# tree recipe feature engineered
engineered_tree_recipe <- recipe(price_usd ~ .,
                                 data = cars_train) |>
  step_rm(model_name,
          location_region,
          engine_fuel,
          color,
          engine_has_gas) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_impute_knn(engine_capacity) |>
  step_interact(terms = ~ starts_with("duration_listed"):up_counter) |>
  step_interact(terms = ~ starts_with("engine_type"):engine_capacity) |>
  step_interact(terms = ~ starts_with("is_exchangeable"):duration_listed) |>
  step_interact(terms = ~ starts_with("manufacturer_name"):year_produced) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

prep(engineered_tree_recipe) |>
  bake(new_data = NULL) |>
  head(n = 5)

# save the recipe
save(engineered_tree_recipe,
     file = here("recipes/engineered_tree_recipe.rda"))
