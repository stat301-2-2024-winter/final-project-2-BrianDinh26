# Final Project, Brian Dinh ----
# Model selection/comparison & analysis

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

# load fit data
load(file = here("results/null_fit.rda"))
load(file = here("results/olr_lm_fit.rda"))


# combine initial table for progress memo #2
table_null <- null_fit |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "null")

table_olr <- olr_lm_fit |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "olr")

pm_2_table <- bind_rows(table_null, table_olr) |> 
  select(model, .metric, mean, std_err) |> 
  rename(
    Model = model,
    Metric = .metric,
    Mean = mean,
    "Standard Error" = std_err
  )

# save out results
save(pm_2_table, file = here("results/pm_2_table.rda"))

