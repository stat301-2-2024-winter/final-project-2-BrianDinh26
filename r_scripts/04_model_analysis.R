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
load(file = here("results/tuned_knn_eng.rda"))
load(file = here("results/tuned_elastic_eng.rda"))
load(file = here("results/tuned_bt_eng.rda"))
load(file = here("results/rf_fit_eng.rda"))
load(file = here("results/olr_lm_fit_eng.rda"))
load(file = here("results/null_fit_eng.rda"))


#check null model
table_null <- null_fit |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "null") |> 
  select(mean, n, std_err, model) |> 
  rename(
    RMSE = mean,
    Repeats = n,
    "Standard Error" = std_err,
    Model = model
  )

table_olr |> olr_lm_fit |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "null") |> 
  select(mean, n, std_err, model) |> 
  rename(
    RMSE = mean,
    Repeats = n,
    "Standard Error" = std_err,
    Model = model
  )

pm_2_table <- bind_rows(table_null, table_olr) |> 
  select(model, .metric, mean, std_err) |> 
  rename(
    Model = model,
    Metric = .metric,
    Mean = mean,
    "Standard Error" = std_err
  )

# find the best hyperparameters for the models.
knn_select <- select_best(knn_fit_eng, metric = "rmse") |> 
  rename(
    Config = .config,
    Neighbors = neighbors
  )

elastic_select <- select_best(tuned_elastic_eng, metric = "rmse") |> 
  rename(
    Penalty = penalty,
    Mixture = mixture,
    Config = .config
  )

bt_select <- select_best(tuned_bt_eng, metric = "rmse") |> 
  rename(
    Config = .config,
    "Min Num Models" = min_n,
    "Learn Rate" = learn_rate,
    "Number of randomly drawn candidate variables" = mtry
  )

rf_select <- select_best(rf_fit_eng, metric = "rmse") |> 
  rename(
    Config = .config,
    "Min Num Models" = min_n,
    "Number of randomly drawn candidate variables" = mtry
  )

#combine all models into a table (final)
table_null_2 <- null_fit_eng |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "null")


table_olr_eng <- olr_lm_fit_eng |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "olr",
         recipe = "feature engineered")

table_rf_eng <- rf_fit_eng |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "rf",
         recipe = "feature engineered")

table_bt_eng <- tuned_bt_eng |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "bt",
         recipe = "feature engineered")

table_elastic_eng <- tuned_elastic_eng |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "elastic",
         recipe = "feature engineered")

table_knn_eng <- knn_fit_eng |> collect_metrics() |> 
  filter(.metric == 'rmse') |> 
  mutate(model = "knn",
         recipe = "feature engineered")

engineered_final_table <- bind_rows(table_null_2, table_olr_eng, table_rf_eng,
                                       table_bt_eng, table_elastic_eng, table_knn_eng) |> 
  slice_min(mean, by = model) |> 
  arrange(mean) |> 
  select(model, mean, std_err) |> 
  rename(
    Model = model,
    RMSE = mean,
    "Standard Error" = std_err
  ) |> 
  distinct(Model, .keep_all = TRUE)

# save out results
save(pm_2_table, file = here("figures/pm_2_table.rda"))
save(knn_select, elastic_select, bt_select, rf_select, file = here("figures/best_hyperparameters.rda"))
save(table_null, file = here("figures/table_null.rda"))
save(engineered_final_table, file = here("figures/engineered_final_table.rda"))

