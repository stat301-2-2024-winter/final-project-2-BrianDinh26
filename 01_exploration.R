# load packages ----
library(tidyverse)
library(tidymodels)
library(naniar)
library(here)
library(corrr)


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

gg_miss_var(cars)

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
save(cars_train, cars_test, cars_folds, file = here("results/cars_split.rda"))


# data exploration

cars_train |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()

cars_train |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()

cars_train |> 
  ggplot(aes(x = engine_capacity)) +
  geom_histogram() +
  facet_wrap(~ state)

cars_train |> 
  ggplot(aes(y = duration_listed, x = price_usd )) +
  geom_point()

cars_train_corr <- cars_train |> 
  correlate()
#seems that there's significance in year made and listing price.

cars_train |> 
  ggplot(aes(x = year_produced, y = price_usd)) +
  geom_point() +
  facet_wrap(~ engine_type)

cars_train |> 
  ggplot(aes(x = number_of_photos)) +
  geom_density() +
  facet_wrap(~ is_exchangeable)


