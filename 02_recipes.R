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

standard_recipe <- recipe(log_price_usd ~ .,
                          data = cars_train) |> 
  step_rm(manufacturer_name, model_name, color, location_region)



#old reference
standard_recipe <- recipe(log_10_price ~ .,
                          data = kc_train) |> 
  step_rm(id, date, zipcode, price) |> 
  step_log(sqft_living, sqft_lot, sqft_above,  sqft_living15, sqft_lot15, base = 10) |>
  step_mutate(if_else(sqft_basement >0, 1, 0)) |> 
  step_ns(lat, deg_free = 5) |> 
  step_normalize(all_predictors()) |> 
  step_zv(all_predictors())

prep(standard_recipe) |> 
  bake(new_data = NULL) |> 
  DT::datatable()

