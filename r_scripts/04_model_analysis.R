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
load(here("data_splits/cars_split.rda"))

# load fit data
load(file = here("results/null_fit.rda"))
load(file = here("results/olr_lm_fit.rda"))
load(file = here("results/rf_fit.rda"))
load(file = here("results/tuned_bt.rda"))
load(file = here("results/tuned_elastic.rda"))
load(file = here("results/tuned_knn.rda"))



#combine all models into a table
table_null <- null_fit |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "null")

table_olr <- olr_lm_fit |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "olr")

table_rf <- rf_fit |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "rf")

table_bt <- tuned_bt |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "bt")

table_elastic <- tuned_elastic |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "elastic")

table_knn <- tuned_knn |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "knn")

kitchen_sink_metric_table <- bind_rows(table_null, table_olr, table_rf,
                                       table_bt, table_elastic, table_knn) |> 
  slice_min(mean, by = model) |> 
  arrange(mean) |> 
  select(model, .metric, mean, std_err) |> 
  rename(
    Model = model,
    Metric = .metric,
    Mean = mean,
    "Standard Error" = std_err
  ) |> 
  distinct(Model, .keep_all = TRUE)

pm_2_table <- bind_rows(table_null, table_olr) |> 
  select(model, .metric, mean, std_err) |> 
  rename(
    Model = model,
    Metric = .metric,
    Mean = mean,
    "Standard Error" = std_err
  )

# save out results
save(pm_2_table, file = here("figures/pm_2_table.rda"))
save(kitchen_sink_metric_table, file = here("figures/kitchen_sink_metric_table.rda"))



