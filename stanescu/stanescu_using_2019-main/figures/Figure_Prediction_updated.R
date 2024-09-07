
prediction_gpa      <- lapply(readRDS("./figures/prediction_gpa.rds"), density)
prediction_grit     <- lapply(readRDS("./figures/prediction_grit.rds"), density)
prediction_hardship <- lapply(readRDS("./figures/prediction_hardship.rds"), density)
prediction_job      <- readRDS("./figures/prediction_job.rds")
prediction_layoff   <- readRDS("./figures/prediction_layoff.rds")
prediction_eviction <- readRDS("./figures/prediction_eviction.rds")


outcome <- na.omit(readRDS("./figures/outcome.rds"))
# lines(density(na.omit(outcome[,'eviction'])), lty = 2, lwd = 1.6, col = 'gray30')
# lines(prediction_eviction[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
# lines(prediction_eviction[[2]], lty = 1, lwd = 1.4, col = '#E84646')


evic_train <- outcome[order(prediction_eviction$train), 'eviction']
evic_pred_train <- prediction_eviction$train[order(prediction_eviction$train)]
evic_pred_test  <- prediction_eviction$test[order(prediction_eviction$test)]

loff_train <- outcome[order(prediction_layoff$train), 'layoff']
loff_pred_train <- prediction_layoff$train[order(prediction_layoff$train)]
loff_pred_test  <- prediction_layoff$test[order(prediction_layoff$test)]


job_train <- outcome[order(prediction_job$train), 'jobTraining']
job_pred_train <- prediction_job$train[order(prediction_job$train)]
job_pred_test  <- prediction_job$test[order(prediction_job$test)]

# plot(1, 1, type = "n")
# image(as.matrix(eviction_train))



## ------------------------------------------ ##
## combination of density and separation plot
## ------------------------------------------ ##
# pdf(file = "outcome_prediction_separation_rev.pdf", width = 8, height = 4)
png(file = "./figures/outcome_prediction_separation_rev.png", width = 700, height = 480)
layout(matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE), heights = c(0.6, 0.4))
par(mar = c(3, 4, 2, 2))
## hardship
plot(1, 1, type = "n", xlim = c(-0.3, 1), ylim = c(0, 10), bty = 'n', main = "Hardship [0, 1]",
    xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'materialHardship'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_hardship[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_hardship[[2]], lty = 1, lwd = 1.6, col = '#E84646')


## GPA
plot(1, 1, type = "n", xlim = c(0, 5), ylim = c(0, 2.5), bty = 'n', main = "GPA [1, 4]",
    xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'gpa'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_gpa[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_gpa[[2]], lty = 1, lwd = 1.4, col = '#E84646')

## GRIT
plot(1, 1, type = "n", xlim = c(0, 5), ylim = c(0, 3), bty = 'n', main = "Grit [1, 4]",
     xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'grit'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_grit[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_grit[[2]], lty = 1, lwd = 1.4, col = '#E84646')
legend("topleft", legend = c("Training data", "In-sample", "Out-of-sample"),
        lty = c(2, 3, 1), col = c('gray30',"#3182bd", '#E84646'), lwd = c(1.5, 1.5, 1.5),
        bty = "n")


par(mar = c(5, 2, 4.7, 2))
## eviction
plot(1, 1, type = "n", xlim = c(0, 100), ylim = c(0, 1),
  yaxs='i', xaxs='i', xaxt = "n", yaxt = "n", xlab = "", ylab = "",
  main = "Eviction (Binary)")
xbin <- seq(0, 100, length.out = length(evic_train)+1)
xbin2 <- seq(0, 100, length.out = length(evic_pred_test))
for (i in 1:length(evic_train)) {
  rect(xbin[i], 0, xbin[i+1], 1.1, col = ifelse(evic_train[i] == 1, "#3182bd", rgb(211,211,211, 50, maxColorValue = 255)),
    border = NA)
}
lines(xbin2, evic_pred_test, col = 'gray40', lwd = 1.2)

## layoff
plot(1, 1, type = "n", xlim = c(0, 100), ylim = c(0, 1),
  yaxs='i', xaxs='i', xaxt = "n", yaxt = "n", xlab = "", ylab = "",
  main = "Layoff (Binary)")
xbin <- seq(0, 100, length.out = length(loff_train)+1)
xbin2 <- seq(0, 100, length.out = length(loff_pred_test))
for (i in 1:length(loff_train)) {
  rect(xbin[i], 0, xbin[i+1], 1.1, col = ifelse(loff_train[i] == 1, "#3182bd", rgb(211,211,211, 50, maxColorValue = 255)),
    border = NA)
}
lines(xbin2, loff_pred_test, col = 'gray40', lwd = 1.2)

## job
plot(1, 1, type = "n", xlim = c(0, 100), ylim = c(0, 1),
  yaxs='i', xaxs='i', xaxt = "n", yaxt = "n", xlab = "", ylab = "",
  main = "Job Training (Binary)")
xbin <- seq(0, 100, length.out = length(job_train)+1)
xbin2 <- seq(0, 100, length.out = length(job_pred_test))
for (i in 1:length(job_train)) {
  rect(xbin[i], 0, xbin[i+1], 1.1, col = ifelse(job_train[i] == 1, "#3182bd", rgb(211,211,211, 50, maxColorValue = 255)),
    border = NA)
}
lines(xbin2, job_pred_test, col = 'gray40', lwd = 1.2)


dev.off()
