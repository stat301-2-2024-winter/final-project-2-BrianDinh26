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
load(here("data_splits/cars_split.rda"))
load(here("results/final_fit.rda"))

final_metrics <- metric_set(rmse, mae, rsq)

set.seed(925)
final_predict <- predict(final_fit, new_data = cars_test) |> 
  bind_cols(cars_test |> select(price_usd))

final_predict_stats <- final_predict |> 
  final_metrics(truth = price_usd, estimate = .pred) |> 
  rename(
    Metric = .metric,
    Estimate = .estimate
  )

predict_vs_obs_plot <- ggplot(final_predict, aes(x = price_usd, y = .pred)) + 
  geom_abline(lty = 2, color = "red") + 
  geom_point(alpha = 0.5) +
  labs(x = "Log Transformed Price (USD)",
       y = "Long Transformed Predicted Price (USD)",
       title = "Observed vs. Predicted Log Transformed Prices (USD)") +
  coord_obs_pred()

predict_vs_obs_plot_original <- ggplot(final_predict, aes(x = exp(price_usd), y = exp(.pred))) + 
  geom_abline(lty = 2, color = "red") + 
  geom_point(alpha = 0.5) +
  labs(x = "Price (USD)",
       y = "Predicted Price (USD)",
       title = "Observed vs. Predicted Prices (USD)") +
  coord_obs_pred()

# save out results
save(final_predict_stats, predict_vs_obs_plot, predict_vs_obs_plot_original,
     file = here("figures/assess_final.rda"))

