## ------------------------------------------------------------ ##
## This code reproduces Table 1 in the *revised* manuscript
## ------------------------------------------------------------ ##

rm(list=ls())
require(xtable)
require(readr)
require(dplyr)
require(tidyr)
require(glmnet)


# load data used for table 1

load("imputed.RData")
load("tables/new_d2.RData")
load("new_d3.RData")
load("tables/table_new_d3.RData")

bg                <- read_csv('background.csv')
train             <- read_csv("train.csv")
outcome           <- readRDS("figures/outcome.rds")
lasso_x_matrix    <- readRDS("figures/lasso_x_matrix.rds")
cvfit_hardship    <- readRDS("figures/cvfit_hardship.rds")
cvfit_gpa         <- readRDS("figures/cvfit_gpa.rds")
cvfit_grit        <- readRDS("figures/cvfit_grit.rds")
cvfit_layoff      <- readRDS("figures/cvfit_layoff.rds")
cvfit_eviction    <- readRDS("figures/cvfit_eviction.rds")
cvfit_jobtraining <- readRDS("figures/cvfit_jobtraining.rds")

# Panel A

selected_hardship <- attr(lasso_x_matrix, 'dimnames')[[2]][which(coef(cvfit_hardship, s = "lambda.min")[-1] != 0)]
selected_gpa <- attr(lasso_x_matrix, 'dimnames')[[2]][which(coef(cvfit_gpa, s = "lambda.min")[-1] != 0)]
selected_grit <- attr(lasso_x_matrix, 'dimnames')[[2]][which(coef(cvfit_grit, s = "lambda.min")[-1] != 0)]
selected_layoff <- attr(lasso_x_matrix, 'dimnames')[[2]][which(coef(cvfit_layoff, s = "lambda.min")[-1] != 0)]
selected_eviction <- attr(lasso_x_matrix, 'dimnames')[[2]][which(coef(cvfit_eviction, s = "lambda.min")[-1] != 0)]
selected_jobtraining <- attr(lasso_x_matrix, 'dimnames')[[2]][which(coef(cvfit_jobtraining, s = "lambda.min")[-1] != 0)]

panel_a <- matrix(c("", "", "", ncol(bg[,-1]), "", "",
                  "", "", "", ncol(new_d2[,-1]), "", "",
                  "", "", "", ncol(table_new_d3[,-1]), "", "",
                  "", "", "", ncol(new_d3[,-1]), "", "",
                  "", "", "", ncol(new_d3[,-1]), "", "",
                  length(selected_gpa), length(selected_grit), 
                  length(selected_eviction), length(selected_layoff), 
                  length(selected_jobtraining), length(selected_hardship)), 
                  ncol=6, byrow=TRUE)
colnames(panel_a) <- c("GPA", "Grit", "Eviction", "Layoff", "Job", "MaterialHardship")
rownames(panel_a) <- c("Original", "Remove Missin (> %60)", "Remove Variables with SD <0.01","LASSO", "Imputation", 
                     "LASSO")

panel_a <- xtable(panel_a)
print(panel_a, file="./tables/panel_a.txt")


# Panel B

panel_b <- matrix(c(sum(is.na(train$materialHardship)), sum(is.na(train$gpa)),
                  sum(is.na(train$grit)),  sum(is.na(train$eviction)),
                  sum(is.na(train$layoff)),  sum(is.na(train$jobTraining)),
                  sum(is.na(outcome$materialHardship)), sum(is.na(outcome$gpa)),
                  sum(is.na(outcome$grit)),  sum(is.na(outcome$eviction)),
                  sum(is.na(outcome$layoff)),  sum(is.na(outcome$jobTraining))), 
                  ncol=6, byrow=TRUE)

colnames(panel_b) <- c("MaterialHardship", "GPA", "Grit", "Eviction", "Layoff", "Job")
rownames(panel_b) <- c("Original Data", "After Imputation")

panel_b <- xtable(panel_b)
print(panel_b, file="./tables/panel_b.txt")
