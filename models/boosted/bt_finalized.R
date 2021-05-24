# Boosted Tree Finalized Model

# Packages, Data ----------------------------------------------------------

library(tidyverse)
library(tidymodels)

set.seed(61234)

load("data/loans_recipe_folds.Rda")
load("models/boosted/bt_tuned.rds")
load("data/loans_test_processed.Rda")


# Data Model --------------------------------------------------------------

bt_model <- boost_tree(mode = "regression",
                       mtry = tune(),
                       min_n = tune(),
                       learn_rate = tune()) %>%
  set_engine("xgboost")


# Workflow ----------------------------------------------------------------

bt_workflow_finalized <- workflow() %>%
  add_model(bt_model) %>%
  add_recipe(loans_recipe) %>%
  finalize_workflow(select_best(bt_tuned, metric = "rmse"))

# Fitting to entirety of training dataset
bt_trained <- fit(bt_workflow_finalized, loans_train)

# Writing out results
save(bt_trained, file = "models/boosted/bt_finalized.rds")


# Generating Predictions --------------------------------------------------

results <- predict(bt_trained, new_data = loans_test) %>%
  bind_cols(loans_test %>% select(id))

 results <- results %>%
  rename(Id = id,
         Predicted = .pred) %>%
  select(Id, Predicted)

write_csv(results, file = "data/submission_bt.csv")
