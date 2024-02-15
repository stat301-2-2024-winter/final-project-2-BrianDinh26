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
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

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

save(standard_recipe, file = here("recipes/recipes.rda"))
