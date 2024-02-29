# Final Project, Brian Dinh ----
# Define and fit a elastic net model, kitchen sink recipe.
# We use a random process when fitting, so we have to set a seed beforehand.

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

# load pre-processing/feature engineering/recipe
load(here("recipes/sink_recipe.rda"))

set.seed(925)
# model specifications ----
elastic_spec <-
  linear_reg(penalty = tune(),
             mixture = tune()) |>
  set_engine("glmnet") |>
  set_mode("regression")


# define workflows ----
elastic_workflow <- workflow() |>
  add_model(elastic_spec) |>
  add_recipe(sink_recipe)

# set hyperparameters (for later tuning)
elastic_params <-
  hardhat::extract_parameter_set_dials(elastic_spec) |>
  update(mixture = mixture(c(0, 1)),
         penalty = penalty(c(-1.75, 0)))

# grid
elastic_grid <- grid_regular(elastic_params, levels = 5)

# fit workflows/models ----
set.seed(444)
tuned_elastic <- tune_grid(
  elastic_workflow,
  cars_folds,
  grid = elastic_grid,
  control = control_grid(save_workflow = TRUE)
)

tuned_elastic |>
  collect_metrics() |>
  filter(.metric == 'rmse') |>
  slice_min(mean) |>
  arrange(mean)

#write out results
save(tuned_elastic, file = here("results/tuned_elastic.rda"))
