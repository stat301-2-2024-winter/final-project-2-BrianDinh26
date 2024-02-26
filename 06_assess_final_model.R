# Final Project, Brian Dinh ----
# Assess final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# mac user code for parallel processing
library(doMC)

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("results/cars_split.rda"))
load(here("results/final_fit.rda"))

final_metrics <- metric_set(rmse, mae, mape, rsq)

set.seed(925)
final_predict <- predict(final_fit, new_data = cars_test) |> 
  bind_cols(cars_test |> select(price_usd))

final_predict_stats <- final_predict |> 
  final_metrics(truth = price_usd, estimate = .pred) |> 
  rename(
    Metric = .metric,
    Estimator = .estimator,
    Estimate = .estimate
  )



# save out results

