# Random Forest Finalized Model

# Packages, Data ----------------------------------------------------------

library(tidyverse)
library(tidymodels)

set.seed(61234)

load("data/loans_recipe_folds.Rda")
load("models/rf/rf_tuned.rds")
load("data/loans_test_processed.Rda")


# Data Model --------------------------------------------------------------

rf_model <- rand_forest(mode = "regression",
                        min_n = tune(),
                        mtry = tune()) %>%
  set_engine("ranger")


# Workflow ----------------------------------------------------------------

# Test data includes missing data for `emp_length`, requiring imputation
loans_recipe <- loans_recipe %>%
  step_impute_knn(emp_length)

rf_workflow_finalized <- workflow() %>%
  add_model(rf_model) %>%
  add_recipe(loans_recipe) %>%
  finalize_workflow(select_best(rf_tuned, metric = "rmse"))

# Fitting to entirety of training dataset
rf_trained <- fit(rf_workflow_finalized, loans_train)

# Writing out results
save(rf_trained, file = "models/rf/rf_finalized.rds")


# Generating Predictions --------------------------------------------------

results <- predict(rf_trained, new_data = loans_test) %>%
  bind_cols(loans_test %>% select(id))

results <- results %>%
  rename(Id = id,
         Predicted = .pred) %>%
  select(Id, Predicted)

write_csv(results, file = "data/submission_rf.csv")
