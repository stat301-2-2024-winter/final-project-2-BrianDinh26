# Final Project, Brian Dinh ----
# Train final model

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

# laod fits
load(here("results/rf_fit_eng.rda"))

# finalize workflow ----
final_wflow <- tuned_elastic_eng |> 
  extract_workflow(tuned_elastic_eng) |>  
  finalize_workflow(select_best(tuned_elastic_eng, metric = "rmse"))

# train final model ----
# set seed
set.seed(925)
final_fit <- fit(final_wflow, cars_train)

final_fit


# save out results
save(final_fit, file = here("results/final_fit.rda"))

