## make table 

require(knitr)

res <- read.csv("./post-analysis/results/holdout_results_socius.csv")

pred <- res[,ncol(res)]
res <- split(res[,-ncol(res)], seq(nrow(res)))

res_table <- rbind(res[[1]], res[[3]], res[[2]], res[[4]])
rownames(res_table) <- c("Null-model", "Mean-imputation","Mother-only", "Father-only")
colnames(res_table) <- c("Eviction", "GPA", "Grit", "Job", "Layoff", "Mat Hard")

kable(res_table, "latex", digits = 3, booktabs = TRUE, 
caption = "Result of Prediction (MSE)")
