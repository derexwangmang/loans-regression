# Model Tuning

# Packages, Data ----------------------------------------------------------

library(tidyverse)
library(tidymodels)

set.seed(61234)

load("data/loans_recipe_folds.Rda")


# Data Model --------------------------------------------------------------

rf_model <- rand_forest(mode = "regression",
                        min_n = tune(),
                        mtry = tune()) %>%
  set_engine("ranger")


# Parameters --------------------------------------------------------------

rf_params <- parameters(rf_model) %>%
  update(mtry = mtry(range = c(1, 90)))
rf_grid <- grid_regular(rf_params, levels = 5)


# Workflow ----------------------------------------------------------------

rf_workflow <- workflow() %>%
  add_model(rf_model) %>%
  add_recipe(loans_recipe)

rf_tuned <- rf_workflow %>%
  tune_grid(resamples = loans_folds,
            grid = rf_grid)

# Write out results & workflow
save(rf_tuned, file = "models/rf/rf_tuned.rds")
