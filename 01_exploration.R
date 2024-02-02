# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

# handle common conflicts
tidymodels_prefer()

# data read-in
cars <- read_csv("data/cars.csv")

gg_miss_var(cars)

# appears to be missingness with engine_capacity, but they are only for 10 instances out of 38,351 observations
# so not significant.

cars |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()

summary(cars$price_usd)

cars |>
  ggplot(aes(x = log(price_usd))) +
  geom_density() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()
