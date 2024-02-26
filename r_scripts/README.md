## Overview

This folder contains the R scripts used to create, use, and evaluate the predictive regression model for the used cars sales dataset.

## R Scripts
- `01_exploration`: Load in the dataset and explore missingness and distribution of target variable. Split and fold dataset.
- `02_base_recipes`: Create kitchen sink recipe for model fitting.
- `02_feature_engineered_recipes`: Create feature engineered recipe based on data exploration.
- `03_bt_fit`: Define a boosted tree model, define a boosted tree model workflow, tune the hyperparameters for the boosted tree model, build tuning grid, and fit the boosted tree model.
- `03_knn_fit`: Define a k-nearest neighbors model, define a k-nearest neighbors model workflow, tune the hyperparameters for the k-nearest neighbors model, build tuning grid, and fit the k-nearest neighbors model.
- `03_null_fit`: Define a null model and workflow, fit it to dataset.
- `03_olr_fit`: Define an ordinary linaer regression model and workflow, fit it to the dataset.
- `03_rf_fit`:  Define a random forest model, define a random forest model workflow, tune the hyperparameters for the random forest model, build tuning grid, and fit the random forest model.
- `03_en_fit`: Define an elastic net model, define it, tune the hyperparameters for it, build tuning grid, and fit the elastic net model.
- `04_model_analysis`:  Explore the  models and compare results to find the final, best model.
- `05_train_final_model`: After finding the final, best model, train it.
- `06_assess_final_model`: Assess final model.
