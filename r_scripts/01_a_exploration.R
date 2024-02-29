# Final Project, Brian Dinh ----
# Initial Check and Exploration of Data

# load packages ----
library(tidyverse)
library(tidymodels)
library(naniar)
library(here)
library(corrr)
library(patchwork)

# handle common conflicts
tidymodels_prefer()

# data read-in
cars <- read_csv(here("data/cars.csv")) |>
  mutate(
    price_usd = log(price_usd),
    has_warranty = (factor(has_warranty)),
    engine_has_gas = (factor(engine_has_gas)),
    is_exchangeable = (factor(is_exchangeable)),
    feature_0 = as.factor(feature_0),
    feature_1 = factor(feature_1),
    feature_2 = factor(feature_2),
    feature_3 = factor(feature_3),
    feature_4 = factor(feature_4),
    feature_5 = factor(feature_5),
    feature_6 = factor(feature_6),
    feature_7 = factor(feature_7),
    feature_8 = factor(feature_8),
    feature_9 = factor(feature_9)
  )

missingness_check <- gg_miss_var(cars)

# split the data
set.seed(925)
cars_split <- initial_split(cars, prop = 0.80, strata = price_usd)
cars_train <- training(cars_split)
cars_test <- testing(cars_split)

# resampling
set.seed(925)
cars_folds <- vfold_cv(cars_train,
                       v = 10,
                       repeats = 5,
                       strata = price_usd)

# write out results
save(cars,
     cars_train,
     cars_test,
     cars_folds,
     file = here("data_splits/cars_split.rda"))
save(missingness_check, file = here("figures/missingness_check.rda"))
