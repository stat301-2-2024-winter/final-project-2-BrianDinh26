# load packages ----
library(tidyverse)
library(tidymodels)
library(naniar)
library(here)

# handle common conflicts
tidymodels_prefer()

# note: need to add the cleaning for gas type, gasoline = gas but they're counted differently

# data read-in
cars <- read_csv("data/cars.csv") |> 
  mutate(
    log_price_usd = log(price_usd),
    has_warranty = ordered(factor(has_warranty)),
    engine_has_gas = ordered(factor(engine_has_gas)),
    is_exchangeable = ordered(factor(is_exchangeable)),
    feature_0 = ordered(factor(feature_0)),
    feature_1 = ordered(factor(feature_1)),
    feature_2 = ordered(factor(feature_2)),
    feature_3 = ordered(factor(feature_3)),
    feature_4 = ordered(factor(feature_4)),
    feature_5 = ordered(factor(feature_5)),
    feature_6 = ordered(factor(feature_6)),
    feature_7 = ordered(factor(feature_7)),
    feature_8 = ordered(factor(feature_8)),
    feature_9 = ordered(factor(feature_9))
  )

cars$engine_fuel[cars$engine_fuel == "gasoline"] <- "gas"

class(cars$engine_has_gas)

gg_miss_var(cars)

# appears to be missingness with engine_capacity, but they are only for 10 instances out of 38,531 observations
# so not significant.

# code below will be cleaned later.

cars |>
  ggplot(aes(x = price_usd)) +
  geom_density() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()

cars |>
  ggplot(aes(x = log(price_usd))) +
  geom_histogram() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()
#consider removing outliers.
summary(cars$price_usd)

sd_log <- sd(cars$log_price_usd)
sd_mean <- mean(cars$log_price_usd)

cars_data_clean <- cars |> 
  filter(
    !(log_price_usd > (sd_log * 2 + sd_mean) | log_price_usd < (sd_mean - sd_log * 2))
  )

cars_data_clean |>
  ggplot(aes(x = log_price_usd)) +
  geom_histogram() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()

cars_data_clean |>
  ggplot(aes(x = duration_listed)) +
  geom_histogram()

cars_data_clean |>
  ggplot(aes(x = log_price_usd)) +
  geom_density() +
  labs(x = "Price (USD)",
       y = "Density") +
  theme_classic()
# still skewed but much less than before.

# consider imputing engine capacity in the recipe.

# split the data
set.seed(925)
cars_split <- initial_split(cars_data_clean, prop = 0.80, strata = log_price_usd)
cars_train <- training(cars_split)
cars_test <- testing(cars_split)

# write out results
save(cars_train, cars_test, file = here("results/cars_split.rda"))

