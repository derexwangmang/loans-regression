# EDA

# Packages, Data ----------------------------------------------------------

library(tidyverse)
library(ggcorrplot)

set.seed(61234)

load("data/loans_processed.Rda")


# EDA ---------------------------------------------------------------------

# Reviewing the correlation plot, which shed light on variables correlated with
# each other and the outcome variable

corr <- round(cor(loans_train %>% select(where(is.numeric))), 1)
ggcorrplot(corr, type = "lower", lab = T)

