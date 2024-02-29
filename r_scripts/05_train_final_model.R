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
load(here("data_splits/cars_split.rda"))

# load fits
load(here("results/tuned_bt.rda"))

# finalize workflow ----
final_wflow <- tuned_bt |>
  extract_workflow(tuned_bt) |>
  finalize_workflow(select_best(tuned_bt, metric = "rmse"))

# train final model ----
# set seed
set.seed(925)
final_fit <- fit(final_wflow, cars_train)

# save out results
save(final_fit, file = here("results/final_fit.rda"))
