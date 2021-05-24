# Packages, Seed ----------------------------------------------------------

library(tidyverse)
library(tidymodels)
library(lubridate)
library(stringr)

set.seed(61234)

load("data/loans_processed.Rda")

# Data Recipe -------------------------------------------------------------

# Using k-fold cross validation and stratifying by the target outcome 
loans_folds <- vfold_cv(loans_train, v = 5, repeats = 3, strata = money_made_inv)

loans_recipe <- recipe(money_made_inv ~ ., loans_train) %>%
  # id is a label for the row, providing no information
  step_rm(id) %>%
  # step_unknown(all_nominal()) %>%
  step_dummy(all_nominal(), -all_outcomes(), one_hot = T) %>%
  step_normalize(all_predictors())

save(loans_train, loans_recipe, loans_folds, file = "data/loans_recipe_folds.Rda")