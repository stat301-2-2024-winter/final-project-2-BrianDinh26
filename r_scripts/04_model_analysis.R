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
table_null <- null_fit |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "null",
         recipe = "kitchen sink (parametric)")

table_olr <- olr_lm_fit |>
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "olr",
         recipe = "kitchen sink (parametric)")

table_knn <- knn_fit |> 
  show_best("rmse") |>
  slice_min(mean) |> 
  mutate(model = "knn",
         recipe = "kitchen sink (tree based)")

table_elastic <- tuned_elastic |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "elastic",
         recipe = "kitchen sink (parametric)")

table_bt <- tuned_bt |>
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "bt",
         recipe = "kitchen sink (tree based)")

table_rf <- rf_fit |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "rf",
         recipe = "kitchen sink (tree based)")

pm_2_table <- bind_rows(table_null, table_olr) |> 
  select(model, .metric, mean, std_err) |> 
  rename(
    Model = model,
    Metric = .metric,
    Mean = mean,
    "Standard Error" = std_err
  )

# kitchen sink table
kitchen_sink_table <- bind_rows(table_null, table_olr, table_rf,
                                    table_bt, table_elastic, table_knn) |> 
  slice_min(mean, by = model) |> 
  arrange(mean) |> 
  select(model, mean, std_err, recipe) |> 
  rename(
    Model = model,
    RMSE = mean,
    "Standard Error" = std_err,
    Recipe = recipe
  )

# find the best hyperparameters for kitchen sink recipes
knn_select_1 <- select_best(knn_fit, metric = "rmse") |> 
  rename(
    Config = .config,
    Neighbors = neighbors
  )

elastic_select_1 <- select_best(tuned_elastic, metric = "rmse") |> 
  rename(
    Penalty = penalty,
    Mixture = mixture,
    Config = .config
  )

bt_select_1 <- select_best(tuned_bt, metric = "rmse") |> 
  rename(
    Config = .config,
    "Min Num Models" = min_n,
    "Learn Rate" = learn_rate,
    "Number of randomly drawn candidate variables" = mtry
  )

rf_select_1 <- select_best(rf_fit_eng, metric = "rmse") |> 
  rename(
    Config = .config,
    "Min Num Models" = min_n,
    "Number of randomly drawn candidate variables" = mtry
  )

#combine all models into a table (final)
table_null_2 <- null_fit_eng |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "null",
         recipe = "feature engineered (parametric)")


table_olr_eng <- olr_lm_fit_eng |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "olr",
         recipe = "feature engineered (parametric)")

table_rf_eng <- rf_fit_eng |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "rf",
         recipe = "feature engineered (tree based)")

table_bt_eng <- tuned_bt_eng |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "bt",
         recipe = "feature engineered (tree based)")

table_elastic_eng <- tuned_elastic_eng |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "elastic",
         recipe = "feature engineered (parametric)")

table_knn_eng <- knn_fit_eng |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  mutate(model = "knn",
         recipe = "feature engineered (tree based)")

engineered_final_table <- bind_rows(table_null_2, table_olr_eng, table_rf_eng,
                                       table_bt_eng, table_elastic_eng, table_knn_eng) |> 
  slice_min(mean, by = model) |> 
  arrange(mean) |> 
  select(model, mean, std_err, recipe) |> 
  rename(
    Model = model,
    RMSE = mean,
    "Standard Error" = std_err,
    Recipe = recipe
  )

# best parameters
knn_select_2 <- select_best(knn_fit_eng, metric = "rmse") |> 
  rename(
    Config = .config,
    Neighbors = neighbors
  )

elastic_select_2 <- select_best(tuned_elastic_eng, metric = "rmse") |> 
  rename(
    Penalty = penalty,
    Mixture = mixture,
    Config = .config
  )

bt_select_2 <- select_best(tuned_bt_eng, metric = "rmse") |> 
  rename(
    Config = .config,
    "Min Num Models" = min_n,
    "Learn Rate" = learn_rate,
    "Number of randomly drawn candidate variables" = mtry
  )

rf_select_2 <- select_best(rf_fit_eng, metric = "rmse") |> 
  rename(
    Config = .config,
    "Min Num Models" = min_n,
    "Number of randomly drawn candidate variables" = mtry
  )

# the complete table
comparison_table <- bind_rows(table_null, table_null_2, table_olr, table_olr_eng, table_rf, table_rf_eng,
                              table_bt, table_bt_eng, table_elastic, table_elastic_eng, table_knn, table_knn_eng) |> 
  arrange(mean) |> 
  select(model, mean, std_err, recipe) |> 
  rename(
    Model = model,
    RMSE = mean,
    "Standard Error" = std_err,
    Recipe = recipe
  )

# autoplot for final model
bt_autoplot <- autoplot(tuned_bt, metric = "rmse")

# save out results
save(pm_2_table, file = here("figures/pm_2_table.rda"))
save(knn_select_2, elastic_select_2, bt_select_2, rf_select_2, file = here("figures/best_hyperparameters_2.rda"))
save(knn_select_1, elastic_select_1, bt_select_1, rf_select_1, file = here("figures/best_hyperparameters_1.rda"))
save(engineered_final_table, comparison_table, kitchen_sink_table, file = here("figures/rmse_tables.rda"))
save(bt_autoplot, file = here("figures/bt_autoplot.rda"))

# bizzarre results. we ball.

