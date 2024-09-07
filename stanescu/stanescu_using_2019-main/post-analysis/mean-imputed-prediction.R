require(readr)
require(dplyr)
require(tidyr)
require(glmnet)

## cleaned data without imputation
load('new_d3.RData') # covariates
outcome <- read_csv('train.csv') 

## mean imputation on covariates only

new_d3 <- apply(new_d3, 2, function(x){
  miss_idx    <- is.na(x)
  mean_x      <- mean(x, na.rm = TRUE)
  x[miss_idx] <- mean_x
  return(x)
})

new_d3 <- as.data.frame(new_d3)

## merge the training data
final_train <- merge(outcome, new_d3, by = "challengeID", all.x = T)


lasso_whole <- final_train[, -which(colnames(final_train) == "challengeID")] # get rid of the ID variable

# get all the left handside variables
lasso_x        <- lasso_whole[, -which(colnames(lasso_whole) %in% colnames(outcome)[-1])]
lasso_x_matrix <- data.matrix(lasso_x) # making it a matrix

# get DVs as vectors
y_gpa         <- final_train$gpa  
y_grit        <- final_train$grit
y_hardship    <- final_train$materialHardship
y_eviction    <- final_train$eviction
y_layoff      <- final_train$layoff
y_jobtraining <- final_train$jobTraining


### Prepare a platform to receive predicted outcomes for the TESTING dataset
## First, get the X for the rest of the folks
theirID   <- setdiff(new_d3$challengeID, final_train$challengeID)  # get their IDs
theirData <- new_d3[theirID, ]                                     # subset
theirX    <- new_d3[theirID, -1]                                   # get their X

## -------------------------------------------------------- ##
### Making predictions with LASSO
## GPA
## -------------------------------------------------------- ##

## complete cases for y_gpa, so that glmnet can handle

gpa_data <- cbind(y_gpa, lasso_x)
gpa_data <- gpa_data[!is.na(gpa_data$y_gpa),] # 1165
y_gpa          <- gpa_data$y_gpa  
lasso_x        <- gpa_data[-1]
lasso_x_matrix <- as.matrix(lasso_x) # making it a matrix

set.seed(12345)
cvfit_gpa = cv.glmnet(y = y_gpa, x = lasso_x_matrix, type.measure = "mse", nfolds = 5)
cvfit_gpa$lambda.min

lasso_gpa <- glmnet(y = y_gpa, x = lasso_x_matrix, family = 'gaussian', 
                    lambda = cvfit_gpa$lambda.min,
                    alpha = 1, intercept = FALSE, standardize = FALSE)

# get names of the variables selected
gpa_variables_lasso <- colnames(lasso_x[, which(lasso_gpa$beta != 0)])

## predict outcomes.
# predict outcomes for the 1165 observations 
predicted.gpa_restricted <- predict(cvfit_gpa, newx = lasso_x_matrix, s = "lambda.min")
# predict outcomes for all the 2121 observations
predicted.gpa_full <- predict(cvfit_gpa, newx = as.matrix(new_d3[,-1]), s = "lambda.min")

## Getting final predicted outcomes
final_outcome_gpa <- predict(cvfit_gpa, newx = as.matrix(theirX), s = "lambda.min")
theirData$gpa     <- final_outcome_gpa
gpa_data          <- subset(theirData, select=c(challengeID, gpa))
gpa_data$gpa      <- as.numeric(gpa_data$gpa)
gpa_tmp           <- subset(final_train, select = c(challengeID, gpa))

# Finalize stuff
GPA_FINAL <- rbind(gpa_data, gpa_tmp)
GPA_FINAL <- GPA_FINAL[order(GPA_FINAL$challengeID),]

## -------------------------------------------------------- ##
##
## grit
##
## -------------------------------------------------------- ##

# get all the left handside variables
lasso_x        <- lasso_whole[, -which(colnames(lasso_whole) %in% colnames(outcome)[-1])]
lasso_x_matrix <- data.matrix(lasso_x) # making it a matrix

## complete cases for y_grit, so that glmnet can handle

grit_data <- cbind(y_grit, lasso_x)
grit_data <- grit_data[!is.na(grit_data$y_grit),] 
y_grit         <- grit_data$y_grit  
lasso_x        <- grit_data[-1]
lasso_x_matrix <- as.matrix(lasso_x) # making it a matrix

set.seed(12345)
cvfit_grit <- cv.glmnet(y = y_grit, x = lasso_x_matrix, type.measure = "mse", nfolds = 5)
cvfit_grit$lambda.min

lasso_grit <- glmnet(y = y_grit, x = lasso_x_matrix, family = 'gaussian', 
                     lambda = cvfit_grit$lambda.min,
                     alpha = 1, intercept = FALSE, standardize = FALSE)

# get names of the variables selected
grit_variables_lasso <- colnames(lasso_x[, which(lasso_grit$beta != 0)])

##
## predict outcomes.
##

# predict outcomes for the 1418 observations 
predicted.grit_restricted <- predict(cvfit_grit, newx = lasso_x_matrix, s = "lambda.min")
# predict outcomes for all the 2121 observations
predicted.grit_full <- predict(cvfit_grit, newx = as.matrix(new_d3[,-1]), s = "lambda.min")

## Getting final predicted outcomes
final_outcome_grit <- predict(cvfit_grit, newx = as.matrix(theirX), s = "lambda.min")
theirData$grit     <- final_outcome_grit
grit_data          <- subset(theirData, select=c(challengeID, grit))
grit_data$grit     <- as.numeric(grit_data$grit)
grit_tmp           <- subset(final_train, select = c(challengeID, grit))

# Finalize stuff
grit_FINAL <- rbind(grit_data, grit_tmp)
grit_FINAL <- grit_FINAL[order(grit_FINAL$challengeID),]

## -------------------------------------------------------- ##
##
## hardship
##
## -------------------------------------------------------- ##

# get all the left handside variables
lasso_x        <- lasso_whole[, -which(colnames(lasso_whole) %in% colnames(outcome)[-1])]
lasso_x_matrix <- data.matrix(lasso_x) # making it a matrix

## complete cases for y_hardship, so that glmnet can handle

hardship_data <- cbind(y_hardship, lasso_x)
hardship_data <- hardship_data[!is.na(hardship_data$y_hardship),] 
y_hardship         <- hardship_data$y_hardship  
lasso_x        <- hardship_data[-1]
lasso_x_matrix <- as.matrix(lasso_x) # making it a matrix

set.seed(12345)
cvfit_hardship <- cv.glmnet(y = y_hardship, x = lasso_x_matrix, type.measure = "mse", nfolds = 5)
cvfit_hardship$lambda.min

lasso_hardship <- glmnet(y = y_hardship, x = lasso_x_matrix, family = 'gaussian', 
                         lambda = cvfit_hardship$lambda.min,
                         alpha = 1, intercept = FALSE, standardize = FALSE)

# get names of the variables selected
hardship_variables_lasso <- colnames(lasso_x[, which(lasso_hardship$beta != 0)])

## predict outcomes.
# predict outcomes for the 1459 observations 
predicted.hardship_restricted <- predict(cvfit_hardship, newx = lasso_x_matrix, s = "lambda.min")
# predict outcomes for all the 2121 observations
predicted.hardship_full <- predict(cvfit_hardship, newx = as.matrix(new_d3[,-1]), s = "lambda.min")

## Getting final predicted outcomes
final_outcome_hardship <- predict(cvfit_hardship, newx = as.matrix(theirX), s = "lambda.min")
theirData$hardship <- final_outcome_hardship
hardship_data <- subset(theirData, select=c(challengeID, hardship))
hardship_data$hardship <- as.numeric(hardship_data$hardship)
hardship_tmp <- subset(final_train, select = c(challengeID, materialHardship))
colnames(hardship_data)[2] <- "materialHardship"
# Finalize stuff
hardship_FINAL <- rbind(hardship_data, hardship_tmp)
hardship_FINAL <- hardship_FINAL[order(hardship_FINAL$challengeID),]

## eviction

# get all the left handside variables
lasso_x        <- lasso_whole[, -which(colnames(lasso_whole) %in% colnames(outcome)[-1])]
lasso_x_matrix <- data.matrix(lasso_x) # making it a matrix

## complete cases for y_eviction, so that glmnet can handle

eviction_data <- cbind(y_eviction, lasso_x)
eviction_data <- eviction_data[!is.na(eviction_data$y_eviction),] 
y_eviction         <- eviction_data$y_eviction  
lasso_x        <- eviction_data[-1]
lasso_x_matrix <- as.matrix(lasso_x) # making it a matrix

set.seed(12345)
cvfit_eviction = cv.glmnet(y = as.factor(y_eviction), x = lasso_x_matrix, 
                           family = "binomial", type.measure = "mse", nfolds = 5)
cvfit_eviction$lambda.min

lasso_eviction <- glmnet(y = as.factor(y_eviction), x = lasso_x_matrix, 
                         lambda = cvfit_eviction$lambda.min, family = "binomial",
                         alpha = 1, intercept = FALSE, standardize = FALSE)

# get names of the variables selected
eviction_variables_lasso <- colnames(lasso_x[, which(lasso_eviction$beta != 0)])

## predict outcomes.
# note that I'm not sure what to do with the output from "predict" function.
# This is because the output is a vector of non-binary values. I thought that
# the values should be binary but they are not. I take these values as latent 
# utilities. Therefore, I did an ifelse. 
# predict outcomes for the 1459 observations 
predicted.eviction_restricted <- ifelse(predict(cvfit_eviction, newx = lasso_x_matrix, s = "lambda.min") > 0, 1,0)
# predict outcomes for all the 2121 observations
predicted.eviction_full <- ifelse(predict(cvfit_eviction, newx = as.matrix(new_d3[,-1]), s = "lambda.min") > 0, 1, 0)

## Getting final predicted outcomes
final_outcome_eviction <- predict(cvfit_eviction, newx = as.matrix(theirX), s = "lambda.min", type = "response")
theirData$eviction <- final_outcome_eviction
eviction_data <- subset(theirData, select=c(challengeID, eviction))
eviction_data$eviction <- as.numeric(eviction_data$eviction)
eviction_tmp <- subset(final_train, select = c(challengeID, eviction))
# Finalize stuff
eviction_FINAL <- rbind(eviction_data, eviction_tmp)
eviction_FINAL <- eviction_FINAL[order(eviction_FINAL$challengeID),]

## layoff

# get all the left handside variables
lasso_x        <- lasso_whole[, -which(colnames(lasso_whole) %in% colnames(outcome)[-1])]
lasso_x_matrix <- data.matrix(lasso_x) # making it a matrix

## complete cases for y_layoff, so that glmnet can handle

layoff_data <- cbind(y_layoff, lasso_x)
layoff_data <- layoff_data[!is.na(layoff_data$y_layoff),] 
y_layoff         <- layoff_data$y_layoff  
lasso_x        <- layoff_data[-1]
lasso_x_matrix <- as.matrix(lasso_x) # making it a matrix

set.seed(12345)
cvfit_layoff = cv.glmnet(y = as.factor(y_layoff), x = lasso_x_matrix, 
                         family = "binomial", type.measure = "mse", nfolds = 5) # some issues with convergence
cvfit_layoff$lambda.min

lasso_layoff <- glmnet(y = as.factor(y_layoff), x = lasso_x_matrix, 
                       lambda = cvfit_layoff$lambda.min, family = "binomial",
                       alpha = 1, intercept = FALSE, standardize = FALSE)

# get names of the variables selected
layoff_variables_lasso <- colnames(lasso_x[, which(lasso_layoff$beta != 0)])

## predict outcomes.
# note that I'm not sure what to do with the output from "predict" function.
# This is because the output is a vector of non-binary values. I thought that
# the values should be binary but they are not. I take these values as latent 
# utilities. Therefore, I did an ifelse. 
# predict outcomes for the 1277 observations 
predicted.layoff_restricted <- ifelse(predict(cvfit_layoff, newx = lasso_x_matrix, s = "lambda.min") > 0, 1,0)
# predict outcomes for all the 2121 observations
predicted.layoff_full <- ifelse(predict(cvfit_layoff, newx = as.matrix(new_d3[,-1]), s = "lambda.min") > 0, 1, 0)


## Getting final predicted outcomes
final_outcome_layoff <- predict(cvfit_layoff, newx = as.matrix(theirX), s = "lambda.min", type = "response")
theirData$layoff <- final_outcome_layoff
layoff_data <- subset(theirData, select=c(challengeID, layoff))
layoff_data$layoff <- as.numeric(layoff_data$layoff)
layoff_tmp <- subset(final_train, select = c(challengeID, layoff))
# Finalize stuff
layoff_FINAL <- rbind(layoff_data, layoff_tmp)
layoff_FINAL <- layoff_FINAL[order(layoff_FINAL$challengeID),]


## job training

# get all the left handside variables
lasso_x        <- lasso_whole[, -which(colnames(lasso_whole) %in% colnames(outcome)[-1])]
lasso_x_matrix <- data.matrix(lasso_x) # making it a matrix

## complete cases for y_jobtraining, so that glmnet can handle

jobtraining_data <- cbind(y_jobtraining, lasso_x)
jobtraining_data <- jobtraining_data[!is.na(jobtraining_data$y_jobtraining),] 
y_jobtraining         <- jobtraining_data$y_jobtraining  
lasso_x        <- jobtraining_data[-1]
lasso_x_matrix <- as.matrix(lasso_x) # making it a matrix

# fitting
set.seed(12345)
cvfit_jobtraining= cv.glmnet(y = as.factor(y_jobtraining), x = lasso_x_matrix, 
                             family = "binomial", type.measure = "mse", nfolds = 5)
cvfit_jobtraining$lambda.min

lasso_jobtraining <- glmnet(y = as.factor(y_jobtraining), x = lasso_x_matrix, 
                            lambda = cvfit_jobtraining$lambda.min, family = "binomial",
                            alpha = 1, intercept = FALSE, standardize = FALSE)

# get names of the variables selected
jobtraining_variables_lasso <- colnames(lasso_x[, which(lasso_jobtraining$beta != 0)])

## predict outcomes.
# note that I'm not sure what to do with the output from "predict" function.
# This is because the output is a vector of non-binary values. I thought that
# the values should be binary but they are not. I take these values as latent 
# utilities. Therefore, I did an ifelse. 
# predict outcomes for the 1461 observations 
predicted.jobtraining_restricted <- ifelse(predict(cvfit_jobtraining, newx = lasso_x_matrix, s = "lambda.min") > 0, 1,0)
# predict outcomes for all the 2121 observations
predicted.jobtraining_full <- ifelse(predict(cvfit_jobtraining, newx = as.matrix(new_d3[,-1]), s = "lambda.min") > 0, 1, 0)

## Getting final predicted outcomes
final_outcome_jobtraining <- predict(cvfit_jobtraining, newx = as.matrix(theirX), s = "lambda.min", type = "response")
theirData$jobtraining <- final_outcome_jobtraining
jobtraining_data <- subset(theirData, select=c(challengeID, jobtraining))
jobtraining_data$jobtraining <- as.numeric(jobtraining_data$jobtraining)
jobtraining_tmp <- subset(final_train, select = c(challengeID, jobTraining))
colnames(jobtraining_data)[2] <- "jobTraining"
# Finalize stuff
jobtraining_FINAL <- rbind(jobtraining_data, jobtraining_tmp)
jobtraining_FINAL <- jobtraining_FINAL[order(jobtraining_FINAL$challengeID),]

FINALIZED <- Reduce(function(x, y) merge(x, y, all=TRUE), 
                    list(GPA_FINAL, grit_FINAL, hardship_FINAL, eviction_FINAL, 
                         layoff_FINAL, jobtraining_FINAL))

write.csv(FINALIZED, file = "./post-analysis/imputation-prediction/prediction.csv") 
