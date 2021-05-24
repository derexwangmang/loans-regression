# Packages, Seed ----------------------------------------------------------

library(tidyverse)
library(zoo)
library(tidymodels)
library(stringr)

set.seed(61234)


# Train Data Processing ---------------------------------------------------

loans_train <- read_csv("data/train.csv") %>%
  # Capturing only the number (0-10) for employment length
  mutate(emp_length = gsub(" year.*", "", emp_length)) %>%
  # Converting to numeric string by dissolving categories with other characters
  mutate(emp_length = case_when(
    emp_length == "< 1" ~ "0",
    emp_length == "10+" ~ "10",
    TRUE ~ emp_length)) %>%
  # Removing N/A value (may be unemployed)
  filter(emp_length != "n/a") %>%
  # Converting to numeric data
  mutate(emp_length = as.numeric(emp_length)) %>%
  # Converting character to factored data
  mutate_if(is.character, as.factor) %>%
  # Below variables tend to be problematic
  # Many, many levels, some of which appear in testing but not in training
  # (Traditionally performed within the recipe step, but recipe did not behave
  # as expected when prepped and baked due to unknown bug.
  # Instead, advised to remove during data processing step.)
  select(-c(earliest_cr_line, last_credit_pull_d, purpose,
            emp_title, sub_grade))

save(loans_train, file = "data/loans_processed.Rda")


# Test Data Processing ----------------------------------------------------

# Repeating the same steps for testing dataset

loans_test <- read_csv("data/test.csv") %>%
  mutate(emp_length = gsub(" year.*", "", emp_length)) %>%
  mutate(emp_length = case_when(
    emp_length == "< 1" ~ "0",
    emp_length == "10+" ~ "10",
    TRUE ~ emp_length)) %>%
  # Can't filter out test data
  # filter(emp_length != "n/a") %>%
  mutate(emp_length = as.numeric(emp_length)) %>%
  mutate_if(is.character, as.factor) %>%
  select(-c(earliest_cr_line, last_credit_pull_d, purpose,
            emp_title, sub_grade))

save(loans_test, file = "data/loans_test_processed.Rda")
