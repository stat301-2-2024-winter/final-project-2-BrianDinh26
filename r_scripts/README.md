## Overview

This folder contains the R scripts used to create, use, and evaluate the predictive regression model for the used cars sales dataset.

## R Scripts
- `01_a_exploration`: Load in the dataset and explore missingness and distribution of target variable. Split and fold dataset.
- `01_b_eda`: Exploratory data analysis of variables in the dataset.
- `02_base_recipes`: Create kitchen sink recipe for model fitting.
- `02_feature_engineered_recipes`: Create feature engineered recipe based on data exploration.
- `03_bt_fit`: Define a boosted tree model, define a boosted tree model workflow, tune the hyperparameters for the boosted tree model, build tuning grid, and fit the boosted tree model using the kitchen sink recipe.
- `03_bt_fit_eng`: Define a boosted tree model, define a boosted tree model workflow, tune the hyperparameters for the boosted tree model, build tuning grid, and fit the boosted tree model using the feature engineered recipe.
- `03_knn_fit`: Define a k-nearest neighbors model, define a k-nearest neighbors model workflow, tune the hyperparameters for the k-nearest neighbors model, build tuning grid, and fit the k-nearest neighbors model using the kitchen sink recipe.
- `03_knn_fit_eng`: Define a k-nearest neighbors model, define a k-nearest neighbors model workflow, tune the hyperparameters for the k-nearest neighbors model, build tuning grid, and fit the k-nearest neighbors model using the feature engineered recipe.
- `03_null_fit`: Define a null model and workflow, and fit it to the dataset using the kitchen sink recipe.
- `03_null_fit_eng`: Define a null model and workflow, and fit it to the dataset using the feature engineered recipe.
- `03_olr_fit`: Define an ordinary linear regression model and workflow, and fit it to the dataset using the kitchen sink recipe.
- `03_olr_fit_eng`: Define an ordinary linear regression model and workflow, and fit it to the dataset using the feature engineered recipe.
- `03_rf_fit`:  Define a random forest model, define a random forest model workflow, tune the hyperparameters for the random forest model, build tuning grid, and fit the random forest model using the kitchen sink recipe.
- `03_rf_fit_eng`:  Define a random forest model, define a random forest model workflow, tune the hyperparameters for the random forest model, build tuning grid, and fit the random forest model using the feature engineered recipe.
- `03_en_fit`: Define an elastic net model, define it, tune the hyperparameters for it, build tuning grid, and fit the elastic net model using the kitchen sink recipe.
- `03_en_fit_eng`: Define an elastic net model, define it, tune the hyperparameters for it, build tuning grid, and fit the elastic net model using the feature engineered recipe.
- `04_model_analysis`:  Explore the  models and compare results to find the final, best model.
- `05_train_final_model`: After finding the final, best model, train it.
- `06_assess_final_model`: Assess final model.
