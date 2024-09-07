## ------------------------------------------- ##
## post-challenge analysis
##
## predictions with mother / father variable 
## ------------------------------------------- ##

## load packages 
require(dplyr)
require(glmnet)
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


## get mother related variables 
predictors <- final_train %>% 
  select(-challengeID, -gpa, -grit, -materialHardship, -eviction, -layoff, -jobTraining)

var_names  <- colnames(predictors)
first_char <- substr(var_names,1,1)
mother_var <- first_char == "m"
father_var <- first_char == "f"

mother_df  <- predictors[,mother_var]
father_df  <- predictors[,father_var]


##
## predictions 
##
set.seed(12345)

## fit lasso 
mother_fit <- father_fit <- list()
for (v in 1:6) {
  ## prediction with mother variables 
  mother_fit[[v]] <- cv.glmnet(
    y = outcome[[v]], x = data.matrix(mother_df), 
    type.measure = "mse", nfolds = 5
  )
  
  ## prediction with father variables 
  father_fit[[v]] <- cv.glmnet( 
    y = outcome[[v]], x = data.matrix(father_df), 
    type.measure = "mse", nfolds = 5
  )
}

## prediction 
mother_pred <- father_pred <- list() 
test_id <- !(final_d$challengeID %in% final_train$challengeID)

for (v in 1:6) {
  ## prediction with mother variables 
  mother_pred[[v]] <- predict(
    mother_fit[[v]], 
    newx = data.matrix(testX[test_id, mother_var]), s = "lambda.min"
  )
  
  ## prediction with father variables 
  father_pred[[v]] <- predict(
    father_fit[[v]], 
    newx = data.matrix(testX[test_id, father_var]), s = "lambda.min"
  )
}


## create output file 
prediction <- list()
zeros <- rep(0, length(final_d$challengeID))
prediction[[1]] <- prediction[[2]] <- data.frame(
  "challengeID" = final_d$challengeID, "gpa" = zeros, "grit" = zeros, 
  "materialHardship" = zeros, "eviction" = zeros, "layoff" = zeros,
  "jobTraining" = zeros
)

for (v in 1:6) {
  prediction[[1]][test_id, (v+1)] <- mother_pred[[v]]
  prediction[[2]][test_id, (v+1)] <- father_pred[[v]]
}


## output in FFC format 
write_csv(prediction[[1]], "./post-analysis/mother-prediction/prediction.csv")
write_csv(prediction[[2]], "./post-analysis/father-prediction/prediction.csv")
