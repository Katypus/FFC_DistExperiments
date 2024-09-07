
## this r script runs all codes to replicate the results 

## Cleaning data
cat("-----------------------------\n")
cat("  Clearning Data!\n")
cat("-----------------------------\n")
#system("unzip background.csv.zip")
system("Rscript Cleaning_Code_Updated.R")


## Imputation (Amelia)
cat("-----------------------------\n")
cat("  Running Amelia for imputation\n")
cat("-----------------------------\n")
system("Rscript Run_Amelia.R")


## Predictions
cat("-----------------------------\n")
cat("  Prediction with Lasso\n")
cat("-----------------------------\n")
system("Rscript code_updated.R")


## post-analysis 
cat("-----------------------------\n")
cat("  Post Analysis\n")
cat("-----------------------------\n")
system("mkdir ./post-analysis/imputation-prediction")
system("mkdir ./post-analysis/mother-prediction")
system("mkdir ./post-analysis/father-prediction/")
system("mkdir ./post-analysis/null-prediction/")
system("Rscript ./post-analysis/mean-imputed-prediction.R")
system("Rscript ./post-analysis/mother-father-prediction.R")
system("Rscript ./post-analysis/null-prediction.R")


cat("-----------------------------\n")
cat("  Making Figures\n")
cat("-----------------------------\n")
system("Rscript ./figures/Figures_Rev.R")
system("Rscript ./figures/Figure_Prediction_updated.R")



cat("-----------------------------\n")
cat("  Making Tables\n")
cat("-----------------------------\n")
# table 1
system("Rscript ./tables/table1_updated.R")

# table 2
system("Rscript ./post-analysis/generate_table.R")


# remove .csv file 
#system("rm background.csv")
