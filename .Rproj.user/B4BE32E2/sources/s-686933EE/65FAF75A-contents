# Model Tuning

# Packages, Data ----------------------------------------------------------

library(tidyverse)
library(tidymodels)

set.seed(61234)

load("data/loans_recipe_folds.Rda")


# Data Model --------------------------------------------------------------

bt_model <- boost_tree(mode = "regression",
                       mtry = tune(),
                       min_n = tune(),
                       learn_rate = tune()) %>%
  set_engine("xgboost")


# Parameters --------------------------------------------------------------

bt_params <- parameters(bt_model) %>%
  update(mtry = mtry(range = c(2, 163)),
         learn_rate = learn_rate(range = c(-1, 0.01)))
bt_grid <- grid_regular(bt_params, levels = 10)


# Workflow ----------------------------------------------------------------

bt_workflow <- workflow() %>%
  add_model(bt_model) %>%
  add_recipe(loans_recipe)

bt_tuned <- bt_workflow %>%
  tune_grid(resamples = loans_folds,
            grid = bt_grid)

# Writing out results
save(bt_tuned, file = "models/boosted/bt_tuned.rds")
