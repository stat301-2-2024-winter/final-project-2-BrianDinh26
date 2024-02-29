# Final Project, Brian Dinh ----
# EDA, Contained in Appendix

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(corrr)

# load training data
load(here("data_splits/cars_split.rda"))

# split the data
set.seed(925)
cars_training_eda_split <-
  initial_split(cars_train, prop = 0.80, strata = price_usd)
cars_train_eda <- training(cars_training_eda_split)

# data exploration

## distribution of price_usd
price_original_distribution <- cars |>
  mutate(price_usd = exp(price_usd)) |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()

log_price_distribution <- cars |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  labs(x = "Log Transformed Price (USD)",
       y = "Density") +
  theme_classic()


## distribution of engine_capacity
engine_capacity_distribution <- cars_train_eda |>
  ggplot(aes(x = engine_capacity)) +
  geom_density() +
  labs(x = "Engine Capacity",
       y = "Density") +
  theme_classic()

engine_capacity_log_distribution <- cars_train_eda |>
  ggplot(aes(x = log(engine_capacity))) +
  geom_density() +
  labs(x = "Enginge Capacity (Log Transformed)",
       y = "Density") +
  theme_classic()

## distribution of number of photos
photos_distribution <- cars_train_eda |>
  ggplot(aes(x = number_of_photos)) +
  geom_density() +
  labs(x = "Number of Photos",
       y = "Density") +
  theme_classic()

photos_log_distribution <- cars_train_eda |>
  ggplot(aes(x = log(number_of_photos))) +
  geom_density() +
  labs(x = "Number of Photos (Log Transformed)",
       y = "Density") +
  theme_classic()

## correlation matrix
cars_train_corr <- cars_train_eda |>
  correlate()

# slight categorical explorations.

numb_exch <- cars_train_eda |>
  ggplot(aes(x = number_of_photos)) +
  geom_density() +
  facet_wrap( ~ is_exchangeable) +
  labs(x = "Number of Photos",
       y = "Density",
       title = "Number of Photos Depending on if Car is Exchangeable") +
  theme_classic()

numb_body <- cars_train_eda |>
  ggplot(aes(x = number_of_photos)) +
  geom_density() +
  facet_wrap( ~ body_type) +
  labs(x = "Number of Photos",
       y = "Density",
       title = "Number of Photos Depending on Body Type of Vehicle") +
  theme_classic()


dur_list <- cars_train_eda |>
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap( ~ transmission) +
  labs(x = "Duration Listed",
       y = "Density",
       title = "Duration Listed by Transmission Type") +
  theme_classic()

dur_drive <- cars_train_eda |>
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap( ~ drivetrain) +
  labs(x = "Duration Listed",
       y = "Density",
       title = "Duration Listed by Drive Train") +
  theme_classic()


cars_train_eda |>
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap( ~ drivetrain) +
  xlim(0, 250)

cars_train_eda |>
  ggplot(aes(x = engine_capacity)) +
  geom_density() +
  facet_wrap( ~ engine_type)

cars_train_eda |>
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap( ~ is_exchangeable) +
  xlim(0, 250)

cars_train_eda |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap( ~ color)


cars_train_eda |>
  ggplot(aes(x = year_produced)) +
  geom_density() +
  facet_wrap( ~ manufacturer_name)


cars_train_eda |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap( ~ engine_has_gas)

cars_train_eda |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap( ~ body_type)

cars_train_eda |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap( ~ state)

cars_train_eda |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap( ~ has_warranty)

cars_train_eda |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap( ~ feature_9)

cars_train_eda |>
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap( ~ manufacturer_name)

e_cap_type <- cars_train_eda |>
  ggplot(aes(x = engine_capacity)) +
  geom_density() +
  facet_wrap( ~ engine_type) +
  labs(y = "Density",
       x = "Engine Capacity",
       title = "Engine Capacity by Type")

dur_exch <- cars_train_eda |>
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap( ~ is_exchangeable) +
  xlim(0, 250) +
  labs(title = "Is Exchangeable Compared to Duration Listed",
       x = "Duration Listed",
       y = "Density")

manf <- cars_train_eda |>
  ggplot(aes(x = year_produced)) +
  geom_density() +
  facet_wrap( ~ manufacturer_name) +
  theme(panel.spacing = unit(1.2, "lines")) +
  labs(x = "Year Produced",
       y = "Density",
       title = "Car Year Produced Compared to Manufacturer")


# create patchwork graphs for data
og_v_log_price <-
  (price_original_distribution | log_price_distribution)
log_original_engine <-
  (engine_capacity_distribution | engine_capacity_log_distribution)
categorical_exploration_1 <- (dur_exch / e_cap_type)
log_original_photos <-
  (photos_distribution | photos_log_distribution)

# save out the data

save(
  og_v_log_price,
  log_original_engine,
  log_original_photos,
  cars_train_corr,
  categorical_exploration_1,
  manf,
  file = here("figures/data_exploration.rda")
)
