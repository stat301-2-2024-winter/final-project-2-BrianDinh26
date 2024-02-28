# load packages ----
library(tidyverse)
library(tidymodels)
library(naniar)
library(here)
library(corrr)
library(patchwork)

# handle common conflicts
tidymodels_prefer()

# note: need to add the cleaning for gas type, gasoline = gas but they're counted differently

# DO NOT ORDER YOUR FACTORS

# data read-in
cars <- read_csv(here("data/cars.csv")) |> 
  mutate(
    price_usd = log(price_usd),
    has_warranty = (factor(has_warranty)),
    engine_has_gas = (factor(engine_has_gas)),
    is_exchangeable = (factor(is_exchangeable)),
    feature_0 = as.factor(feature_0),
    feature_1 = factor(feature_1),
    feature_2 = factor(feature_2),
    feature_3 = factor(feature_3),
    feature_4 = factor(feature_4),
    feature_5 = factor(feature_5),
    feature_6 = factor(feature_6),
    feature_7 = factor(feature_7),
    feature_8 = factor(feature_8),
    feature_9 = factor(feature_9)
  )

missingness_check <- gg_miss_var(cars)

# split the data
set.seed(925)
cars_split <- initial_split(cars, prop = 0.80, strata = price_usd)
cars_train <- training(cars_split)
cars_test <- testing(cars_split)

# resampling
set.seed(925)
cars_folds <- vfold_cv(cars_train, v = 10, repeats = 5,
                       strata = price_usd)

# write out results
save(cars_train, cars_test, cars_folds, file = here("data_splits/cars_split.rda"))


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
engine_capacity_distribution <- cars_train |> 
  ggplot(aes(x = engine_capacity)) + 
  geom_density() +
  labs(x = "Engine Capacity",
       y = "Density") +
  theme_classic()

engine_capacity_log_distribution <- cars_train |> 
  ggplot(aes(x = log(engine_capacity))) + 
  geom_density() +
  labs(x = "Enginge Capacity (Log Transformed)",
       y = "Density") +
  theme_classic()

## distribution of number of photos
photos_distribution <- cars_train |> 
  ggplot(aes(x = number_of_photos)) + 
  geom_density() +
  labs(x = "Number of Photos",
       y = "Density") +
  theme_classic()

photos_log_distribution <- cars_train |> 
  ggplot(aes(x = log(number_of_photos))) + 
  geom_density() +
  labs(x = "Number of Photos (Log Transformed)",
       y = "Density") +
  theme_classic()

## correlation matrix
cars_train_corr <- cars_train |> 
  correlate()

# slight categorical explorations.

numb_exch <- cars_train |> 
  ggplot(aes(x = number_of_photos)) +
  geom_density() +
  facet_wrap(~ is_exchangeable) +
  labs(x = "Number of Photos",
       y = "Density",
       title = "Number of Photos Depending on if Car is Exchangeable") +
  theme_classic()

numb_body <- cars_train |> 
  ggplot(aes(x = number_of_photos)) +
  geom_density() +
  facet_wrap(~ body_type) +
  labs(x = "Number of Photos",
       y = "Density",
       title = "Number of Photos Depending on Body Type of Vehicle") +
  theme_classic()


dur_list <- cars_train |> 
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap(~ transmission) +
  labs(x = "Duration Listed",
       y = "Density",
       title = "Duration Listed by Transmission Type") +
  theme_classic()

dur_drive <- cars_train |> 
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap(~ drivetrain) +
  labs(x = "Duration Listed",
       y = "Density",
       title = "Duration Listed by Drive Train") +
  theme_classic()


cars_train |> 
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap(~ drivetrain) +
  xlim(0, 250)

cars_train |> 
  ggplot(aes(x = engine_capacity)) +
  geom_density() +
  facet_wrap(~ engine_type)

cars_train |> 
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap(~ is_exchangeable) +
  xlim(0, 250)

cars_train |> 
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap(~ color)


cars_train |> 
  ggplot(aes(x = year_produced)) +
  geom_density() +
  facet_wrap(~ manufacturer_name)


cars_train |> 
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap(~ engine_has_gas)

cars_train |> 
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap(~ body_type)

cars_train |> 
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap(~ state)

cars_train |> 
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap(~ has_warranty)

cars_train |> 
  ggplot(aes(x = price_usd)) +
  geom_density() +
  facet_wrap(~ feature_9)

cars_train |> 
  ggplot(aes(x = duration_listed)) +
  geom_density() +
  facet_wrap(~ manufacturer_name)

og_v_log_price <- (price_original_distribution | log_price_distribution)
log_original_engine <- (engine_capacity_distribution | engine_capacity_log_distribution)
categorical_exploration_1 <- (numb_exch / numb_body)
categorical_exploration_2 <-  (dur_list / dur_drive)
log_original_photos <- (photos_distribution | photos_log_distribution)

save(og_v_log_price,
     log_original_engine,
     log_original_photos,
     cars_train_corr,
     categorical_exploration_1,
     categorical_exploration_2,
     missingness_check,
     file = here("figures/data_exploration.rda"))

