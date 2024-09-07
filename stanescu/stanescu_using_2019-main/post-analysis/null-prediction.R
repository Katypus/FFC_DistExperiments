## ------------------------------------------- ##
## post-challenge analysis
##
## predictions with the null model
## ------------------------------------------- ##

## load packages
require(dplyr)
require(readr)

## get background for testing set
load("imputed.RData")
final_d <- a.out.more$imputations$imp1  %>% tbl_df()
testX   <- final_d %>% select(-challengeID)

## use final_train.rds for the training set
final_train <- readRDS("final_train.rds") %>% tbl_df()


# dependent variables
outcome <- list()
outcome[[1]] <- final_train$gpa
outcome[[2]] <- final_train$grit
outcome[[3]] <- final_train$materialHardship
outcome[[4]] <- final_train$eviction
outcome[[5]] <- final_train$layoff
outcome[[6]] <- final_train$jobTraining


## prediction with sample mean of observed outcome in training set
null_model <- lapply(outcome, mean)

## assign to
test_id <- !(final_d$challengeID %in% final_train$challengeID)
zeros <- rep(0, length(final_d$challengeID))
prediction <- data.frame(
  "challengeID" = final_d$challengeID, "gpa" = zeros, "grit" = zeros,
  "materialHardship" = zeros, "eviction" = zeros, "layoff" = zeros,
  "jobTraining" = zeros
)

for (v in 1:6) {
  prediction[test_id, (v+1)] <- rep(null_model[[v]], sum(test_id))
}

write_csv(prediction, "./post-analysis/null-prediction/prediction.csv")
