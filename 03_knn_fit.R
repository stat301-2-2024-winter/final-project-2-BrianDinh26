# Final Project, Brian Dinh ----
# Define and fit a k-nearest neighbors model.
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
load(here("results/cars_split.rda"))

# load pre-processing/feature engineering/recipe


set.seed(925)
# model specifications ----


# define workflows ----

# fit workflows/models ----
set.seed(925)


# save out results

