# clean slate
rm(list=ls())

##
## data process
##

require(readr)
require(dplyr)
require(tidyr)
require(Amelia)
require(glmnet)

# load imputed right hand side data
load("imputed.RData")


# load raw right hand side data
# bg <- read_csv('background.csv')
final_d <- a.out.more$imputations$imp1

# set.seed
set.seed(2018)

# impute the left hand data, using argument "ords"
# to indicate the ordinal (binary) nature of certain variables
test <- read_csv('train.csv')
print(head(test))
a.out.more_outcomes <- amelia(test, m = 5, idvars = "challengeID",
                              ords = c("eviction", "layoff", "jobTraining"))
outcome <- a.out.more_outcomes$imputations$imp3
saveRDS(outcome, file = 'figures/outcome.rds')

## merge the training data
# note that we na.omitted the merged dataset. This is because, in the train.csv,
# there are 655 observations that are completely missing (having NAs for all of the
# six outcome variables). Na.omit does not reduce the number of useful observations
# for us at all, because all the right hand side variables have no missing
# (they are already imputed).
# Na.omit is also necessary because glmnet does not take in NAs.
final_train <- na.omit(merge(outcome, final_d, by = "challengeID", all.x = T))
saveRDS(final_train, file = "final_train.rds")

lasso_whole <- final_train[, -which(colnames(final_train) == "challengeID")] # get rid of the ID variable
head(final_train$gpa)
# get all the left handside variables
lasso_x <- lasso_whole[, -which(colnames(lasso_whole) %in% colnames(outcome)[-1])] # original value is -1
lasso_x_matrix <- data.matrix(lasso_x) # making it a matrix


#TESTING#
print(colnames(lasso_x_matrix))
print(colnames(final_d))
summary(lasso_x_matrix)
summary(final_d)
#TESTING#
# get DVs as vectors
y_gpa <- final_train$gpa
length(y_gpa)
y_grit <- final_train$grit
length(y_grit)
y_hardship <- final_train$materialHardship
length(y_hardship)
y_eviction <- final_train$eviction
length(y_eviction)
y_layoff <- final_train$layoff
length(y_layoff)
y_jobtraining <- final_train$jobTraining
length(y_jobtraining)


### Prepare a platform to receive predicted outcomes for the TESTING dataset
## First, get the X for the rest of the observations
# get their IDs
theirID <- setdiff(final_d$challengeID, final_train$challengeID)
# subset
theirData <- final_d[theirID, ]
# get their X
theirX <- final_d[theirID, -1]

### Making predictions with LASSO
## GPA
print("compare dimensions of lasso x matrix")
print(dim((lasso_x_matrix)))
cvfit_gpa = cv.glmnet(y = y_gpa, x = lasso_x_matrix, type.measure = "mse", nfolds = 5)
length(cvfit_gpa)
cvfit_gpa$lambda.min
print("A")
lasso_gpa <- glmnet(y = y_gpa, x = lasso_x_matrix, family = 'gaussian',
                          lambda = cvfit_gpa$lambda.min,
                          alpha = 1, intercept = FALSE, standardize = FALSE)
print("B")
# get names of the variables selected
gpa_variables_lasso <- colnames(lasso_x[, which(lasso_gpa$beta != 0)])

## predict outcomes.
# predict outcomes for the 1466 observations (2121 minus 655 that are completely missing)
predicted.gpa_restricted <- predict(cvfit_gpa, newx = lasso_x_matrix, s = "lambda.min")
print("C")
# predict outcomes for all the 2121 observations
newx = as.matrix(final_d[,-1]) # originally -1
print(dim(newx))
predicted.gpa_full <- predict(cvfit_gpa, newx = as.matrix(final_d[ ,-1]), s = "lambda.min") # originally -1
print("D")
## Getting final predicted outcomes
final_outcome_gpa <- predict(cvfit_gpa, newx = as.matrix(theirX), s = "lambda.min")
print("E")
theirData$gpa <- final_outcome_gpa
gpa_data <- subset(theirData, select=c(challengeID, gpa))
gpa_data$gpa <- as.numeric(gpa_data$gpa)
gpa_tmp <- subset(final_train, select = c(challengeID, gpa))
# Finalize stuff
GPA_FINAL <- rbind(gpa_data, gpa_tmp)
GPA_FINAL <- GPA_FINAL[order(GPA_FINAL$challengeID),]

saveRDS(list("train" = predicted.gpa_restricted, "test" = final_outcome_gpa),
        file = "figures/prediction_gpa.rds")





## grit

cvfit_grit = cv.glmnet(y = y_grit, x = lasso_x_matrix, type.measure = "mse", nfolds = 5)
cvfit_grit$lambda.min
print("F")

lasso_grit <- glmnet(y = y_grit, x = lasso_x_matrix, family = 'gaussian',
                    lambda = cvfit_grit$lambda.min,
                    alpha = 1, intercept = FALSE, standardize = FALSE)
print("G")
# get names of the variables selected
grit_variables_lasso <- colnames(lasso_x[, which(lasso_grit$beta != 0)])

## predict outcomes.
# predict outcomes for the 1466 observations
predicted.grit_restricted <- predict(cvfit_grit, newx = lasso_x_matrix, s = "lambda.min")
print("H")
# predict outcomes for all the 2121 observations
predicted.grit_full <- predict(cvfit_grit, newx = as.matrix(final_d[,-1]), s = "lambda.min") # edited
print("I")
## Getting final predicted outcomes
final_outcome_grit <- predict(cvfit_grit, newx = as.matrix(theirX), s = "lambda.min")
print("J")
theirData$grit <- final_outcome_grit
grit_data <- subset(theirData, select=c(challengeID, grit))
grit_data$grit <- as.numeric(grit_data$grit)
grit_tmp <- subset(final_train, select = c(challengeID, grit))
# Finalize stuff
grit_FINAL <- rbind(grit_data, grit_tmp)
grit_FINAL <- grit_FINAL[order(grit_FINAL$challengeID),]


saveRDS(list("train" = predicted.grit_restricted, "test" = final_outcome_grit),
        file = "figures/prediction_grit.rds")


## hardship
cvfit_hardship = cv.glmnet(y = y_hardship, x = lasso_x_matrix, type.measure = "mse", nfolds = 5)
cvfit_hardship$lambda.min

lasso_hardship <- glmnet(y = y_hardship, x = lasso_x_matrix, family = 'gaussian',
                     lambda = cvfit_hardship$lambda.min,
                     alpha = 1, intercept = FALSE, standardize = FALSE)

# get names of the variables selected
hardship_variables_lasso <- colnames(lasso_x[, which(lasso_hardship$beta != 0)])

## predict outcomes.
# predict outcomes for the 1466 observations
predicted.hardship_restricted <- predict(cvfit_hardship, newx = lasso_x_matrix, s = "lambda.min")
print("K")
# predict outcomes for all the 2121 observations
predicted.hardship_full <- predict(cvfit_hardship, newx = as.matrix(final_d[,-1]), s = "lambda.min") # edited
print("L")

## Getting final predicted outcomes
final_outcome_hardship <- predict(cvfit_hardship, newx = as.matrix(theirX), s = "lambda.min")
print("M")
theirData$hardship <- final_outcome_hardship
hardship_data <- subset(theirData, select=c(challengeID, hardship))
hardship_data$hardship <- as.numeric(hardship_data$hardship)
hardship_tmp <- subset(final_train, select = c(challengeID, materialHardship))
colnames(hardship_data)[2] <- "materialHardship"
# Finalize stuff
hardship_FINAL <- rbind(hardship_data, hardship_tmp)
hardship_FINAL <- hardship_FINAL[order(hardship_FINAL$challengeID),]



saveRDS(list("train" = predicted.hardship_restricted, "test" = final_outcome_hardship),
        file = "figures/prediction_hardship.rds")


### Below is for binary variables.
## eviction
cvfit_eviction = cv.glmnet(y = as.factor(y_eviction), x = lasso_x_matrix,
                           family = "binomial", type.measure = "mse", nfolds = 5)
cvfit_eviction$lambda.min
print("N")

lasso_eviction <- glmnet(y = as.factor(y_eviction), x = lasso_x_matrix,
                         lambda = cvfit_eviction$lambda.min, family = "binomial",
                         alpha = 1, intercept = FALSE, standardize = FALSE)
print("O")
# get names of the variables selected
eviction_variables_lasso <- colnames(lasso_x[, which(lasso_eviction$beta != 0)])

## predict outcomes.
# note that I'm not sure what to do with the output from "predict" function.
# This is because the output is a vector of non-binary values. I thought that
# the values should be binary but they are not. I take these values as latent
# utilities. Therefore, I did an ifelse.
# predict outcomes for the 1466 observations
predicted.eviction_restricted <- ifelse(predict(cvfit_eviction, newx = lasso_x_matrix, s = "lambda.min") > 0, 1,0)
print("P")
# predict outcomes for all the 2121 observations
predicted.eviction_full <- ifelse(predict(cvfit_eviction, newx = as.matrix(final_d[,-1]), s = "lambda.min") > 0, 1, 0)
print("Q")
## Getting final predicted outcomes
final_outcome_eviction <- predict(cvfit_eviction, newx = as.matrix(theirX), s = "lambda.min", type = "response")
print("R")
theirData$eviction <- final_outcome_eviction
eviction_data <- subset(theirData, select=c(challengeID, eviction))
eviction_data$eviction <- as.numeric(eviction_data$eviction)
eviction_tmp <- subset(final_train, select = c(challengeID, eviction))
# Finalize stuff
eviction_FINAL <- rbind(eviction_data, eviction_tmp)
eviction_FINAL <- eviction_FINAL[order(eviction_FINAL$challengeID),]

saveRDS(list("train" = predicted.eviction_restricted, "test" = final_outcome_eviction),
        file = "figures/prediction_eviction.rds")


## layoff
cvfit_layoff = cv.glmnet(y = as.factor(y_layoff), x = lasso_x_matrix,
                           family = "binomial", type.measure = "mse", nfolds = 5)
print("S")
cvfit_layoff$lambda.min

lasso_layoff <- glmnet(y = as.factor(y_layoff), x = lasso_x_matrix,
                         lambda = cvfit_layoff$lambda.min, family = "binomial",
                         alpha = 1, intercept = FALSE, standardize = FALSE)
print("T")

# get names of the variables selected
layoff_variables_lasso <- colnames(lasso_x[, which(lasso_layoff$beta != 0)])

## predict outcomes.
# note that I'm not sure what to do with the output from "predict" function.
# This is because the output is a vector of non-binary values. I thought that
# the values should be binary but they are not. I take these values as latent
# utilities. Therefore, I did an ifelse.
# predict outcomes for the 1466 observations
predicted.layoff_restricted <- ifelse(predict(cvfit_layoff, newx = lasso_x_matrix, s = "lambda.min") > 0, 1,0)
print("U")
# predict outcomes for all the 2121 observations
predicted.layoff_full <- ifelse(predict(cvfit_layoff, newx = as.matrix(final_d[,-1]), s = "lambda.min") > 0, 1, 0)
print("V")

## Getting final predicted outcomes
final_outcome_layoff <- predict(cvfit_layoff, newx = as.matrix(theirX), s = "lambda.min", type = "response")
print("W")
theirData$layoff <- final_outcome_layoff
layoff_data <- subset(theirData, select=c(challengeID, layoff))
layoff_data$layoff <- as.numeric(layoff_data$layoff)
layoff_tmp <- subset(final_train, select = c(challengeID, layoff))
# Finalize stuff
layoff_FINAL <- rbind(layoff_data, layoff_tmp)
layoff_FINAL <- layoff_FINAL[order(layoff_FINAL$challengeID),]


saveRDS(list("train" = predicted.layoff_restricted, "test" = final_outcome_layoff),
        file = "figures/prediction_layoff.rds")


## jobtraining
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
# predict outcomes for the 1466 observations
predicted.jobtraining_restricted <- ifelse(predict(cvfit_jobtraining, newx = lasso_x_matrix, s = "lambda.min") > 0, 1,0)
# predict outcomes for all the 2121 observations
predicted.jobtraining_full <- ifelse(predict(cvfit_jobtraining, newx = as.matrix(final_d[,-1]), s = "lambda.min") > 0, 1, 0)

## Getting final predicted outcomes
final_outcome_jobtraining <- predict(cvfit_jobtraining, newx = as.matrix(theirX), s = "lambda.min", type = "response")
theirData$jobtraining     <- final_outcome_jobtraining
jobtraining_data          <- subset(theirData, select=c(challengeID, jobtraining))
jobtraining_data$jobtraining <- as.numeric(jobtraining_data$jobtraining)
jobtraining_tmp <- subset(final_train, select = c(challengeID, jobTraining))
colnames(jobtraining_data)[2] <- "jobTraining"
print("X")
# Finalize stuff
jobtraining_FINAL <- rbind(jobtraining_data, jobtraining_tmp)
jobtraining_FINAL <- jobtraining_FINAL[order(jobtraining_FINAL$challengeID),]


saveRDS(list("train" = predicted.jobtraining_restricted, "test" = final_outcome_jobtraining),
        file = "figures/prediction_job.rds")


print("Y")
#Print all the outcomes
print(dim(GPA_FINAL))
print(dim(grit_FINAL))
print(dim(hardship_FINAL))
print(dim(eviction_FINAL))
print(dim(layoff_FINAL))
print(dim(jobtraining_FINAL))
lapply(list(GPA_FINAL, grit_FINAL, hardship_FINAL, eviction_FINAL, layoff_FINAL, jobtraining_FINAL), nrow)
summary(GPA_FINAL)
summary(grit_FINAL)
summary(hardship_FINAL)
summary(eviction_FINAL)
summary(layoff_FINAL)
summary(jobtraining_FINAL)
test_merge <- merge(GPA_FINAL, grit_FINAL, all = TRUE)
print("GPA and grit are ok")
test_merge <- merge(hardship_FINAL, eviction_FINAL, all = TRUE)
print("hardship and eviction are ok")
test_merge <- merge(layoff_FINAL, jobtraining_FINAL, all = TRUE)
print("layoff and jt are ok")
# Inspect data frames
summary(GPA_FINAL)
summary(grit_FINAL)
summary(hardship_FINAL)
summary(eviction_FINAL)
summary(layoff_FINAL)
# Check column names
names(GPA_FINAL)
names(grit_FINAL)
names(hardship_FINAL)
names(eviction_FINAL)
names(layoff_FINAL)


##

FINALIZED <- Reduce(function(x, y) merge(x, y, all=TRUE),
       list(GPA_FINAL, grit_FINAL, hardship_FINAL, eviction_FINAL,
            layoff_FINAL, jobtraining_FINAL))


write.csv(FINALIZED, file = "FINALIZED.csv")
write.csv(FINALIZED, file = "prediction.csv")

saveRDS(lasso_x_matrix, file = "figures/lasso_x_matrix.rds")
saveRDS(cvfit_hardship, file = "figures/cvfit_hardship.rds")
saveRDS(cvfit_gpa, file = "figures/cvfit_gpa.rds")
saveRDS(cvfit_grit, file = "figures/cvfit_grit.rds")
saveRDS(cvfit_layoff, file = "figures/cvfit_layoff.rds")
saveRDS(cvfit_eviction, file = "figures/cvfit_eviction.rds")
saveRDS(cvfit_jobtraining, file = "figures/cvfit_jobtraining.rds")
