## ------------------------------------------------------------ ##
## This code reproduces all figures in the *revised* manuscript
## ------------------------------------------------------------ ##



## load package
require(RColorBrewer)
require(readr)
require(dplyr)
require(glmnet)


## load data used for plot
load("imputed.RData")
train          <- read_csv("train.csv")
outcome        <- readRDS("outcome.rds")
bg_varnames    <- read_csv("bg_varnames.csv")
cvfit_hardship <- readRDS("cvfit_hardship.rds")
lasso_x_matrix <- readRDS("lasso_x_matrix.rds")

final_d <- a.out.more$imputations$imp1
final_train <- na.omit(merge(outcome, final_d, by = "challengeID", all.x = T))

##
## Generate Correlation figure
##
train <- train %>% na.omit() %>% as.matrix()

xx <- outcome[,-1]
cor_zz <- cor(na.omit(xx))
lab_names <- c("Hardship", "GPA", "Grit", "Eviction", "Layoff", "Job")

png(file = './figures/corr_figure_rev.png', height = 480, width = 480)
par(mar = c(3, 4, 2, 2))
image(x = 1:ncol(cor_zz), y = 1:ncol(cor_zz), z = cor_zz,
        col = NA, xaxt = 'n', yaxt = 'n',
        xlab = "", ylab = "")
box(lwd = 1.4)
grid(6, 6, col = 'gray40')
axis(1, at = 1:ncol(cor_zz), labels = lab_names, cex.axis = 0.7)
axis(2, at = 1:ncol(cor_zz), labels = lab_names, cex.axis = 0.7)
for (i in 1:ncol(cor_zz)) {
    for (j in 1:ncol(cor_zz)) {
        text(i,j, labels = round(cor_zz[i,j], 2), col = 'gray20', cex = 0.85)
    }
}
dev.off()
## end of correlation figure


##
## density plots for outcomes
##
train <- train %>% na.omit() %>% as.matrix()
outcome <- outcome %>% na.omit() %>% as.matrix()

train_density   <- apply(train[,c(4, 2, 3)], 2, function(x) density(x, na.rm = TRUE))  ## density for pre imputation
outcome_density <- apply(outcome[,c(4, 2, 3)], 2, function(x) density(x, na.rm = TRUE)) ## density for post imputation
train_table     <- apply(train[,5:ncol(train)], 2, function(x) table(x) / sum(table(x)))
outcome_table   <- apply(outcome[,5:ncol(train)], 2, function(x) table(x) / sum(table(x)))

lab_names_dens <- c("Hardship [0, 1]", "GPA [1, 4]", "Grit [1, 4]", "Eviction (Binary)", "Layoff (Binary)", "Job (Binary)")

## plot
# pdf(file = "outcome_density_rev.pdf", width = 8.2, height = 6)
png(file = "./figures/outcome_density_rev.png", width = 600, height = 360)
layout(matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE))
par(mar = c(3, 4, 3, 2))
for (i in 2:4) {
    dent_x <- c(train_density[[i-1]]$x, outcome_density[[i-1]]$x)
    dent_y <- c(train_density[[i-1]]$y, outcome_density[[i-1]]$y)
    plot(1,1,type = "n", xlim = c(min(dent_x), max(dent_x)),
        ylim = c(min(dent_y), max(dent_y)),
        bty = 'n',  main = lab_names_dens[i-1],
        ylab = "Density")
    lines(train_density[[i-1]], col = "gray20", lwd = 1.6, lty = 3)
    lines(outcome_density[[i-1]], col = "#3182bd", lwd = 1.4)
    if (i == 4) legend("topleft", legend = c("Original Data", "After Imputation"),
                        lty = c(3, 1), col = c("gray20", "#3182bd"), lwd = c(1.3, 1.4),
                        bty = "n")
}

xloc_bar <- c(0.125, 0.625, 0.3, 0.8); col_bar <- rep(c("gray", "#3182bd"), each = 2)
density_bar <- c(NA, NA, 12, 12); angle_bar <- c(NA, NA, 45, 45)
for (i in 5:ncol(outcome)) {
    plot(1, 1, type = 'n', xlim = c(0,1), ylim = c(0, 1),
        xaxt = 'n', bty = 'n', ylab = "Proportion", xlab = "")
    counts <- c(train_table[,i-4], outcome_table[,i-4])
    for (j in 1:4) {
        rect(xloc_bar[j], 0, xloc_bar[j]+0.125, counts[j],
            col = col_bar[j], density = density_bar[j], angle = angle_bar[j])
    }
    if (i == ncol(outcome)) legend("topleft", legend = c("Original Data", "After Imputation"),
                                    fill = c("gray", NA), density = c(NA, 3), border = c(NA, "#3182bd"),
                                    bty = "n")
    axis(1, at = c(0.25, 0.75), labels = c("0", "1"))
    title(main = lab_names_dens[i-1])
}
dev.off()

##
## plot
##
lab_names_qq <- c("GPA [1, 4]", "Grit [1, 4]", "Hardship [0, 1]", "Eviction (Binary)", "Layoff (Binary)", "Job (Binary)")
xylim <- list(c(1, 4.5), c(1, 4.5), c(0, 1))

# pdf(file = "outcome_qqplot_rev.pdf", width = 8.2, height = 6)
png(file = "./figures/outcome_qqplot_rev.png", width = 600, height = 360)
layout(matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE))
par(mar = c(3, 4, 3, 2))
for (i in c(4, 2, 3)) {

    qqplot(train[,i], outcome[,i], main = lab_names_qq[i-1], pch = 4, col = '#3182bd',
          xlim = xylim[[i-1]], ylim = xylim[[i-1]],
          xlab = "", ylab = "",
          cex = 1.1)
    title(xlab = "Original Data", ylab = "After Imputation", line = 2)
    abline(0, 1, col = 'gray50')
    box(lwd = 1.2)
}

xloc_bar <- c(0.125, 0.625, 0.3, 0.8); col_bar <- rep(c("gray", "#3182bd"), each = 2)
density_bar <- c(NA, NA, 12, 12); angle_bar <- c(NA, NA, 45, 45)
for (i in 5:ncol(outcome)) {
    plot(1, 1, type = 'n', xlim = c(0,1), ylim = c(0, 1),
        xaxt = 'n', bty = 'n', ylab = "Proportion", xlab = "")
    counts <- c(train_table[,i-4], outcome_table[,i-4])
    for (j in 1:4) {
        rect(xloc_bar[j], 0, xloc_bar[j]+0.125, counts[j],
            col = col_bar[j], density = density_bar[j], angle = angle_bar[j])
    }
    if (i == ncol(outcome)) legend("topleft", legend = c("Original Data", "After Imputation"),
                                    fill = c("gray", NA), density = c(NA, 3), border = c(NA, "#3182bd"),
                                    bty = "n")
    axis(1, at = c(0.25, 0.75), labels = c("0", "1"))
    title(main = lab_names_dens[i-1])
}
dev.off()



##
## Prediction plot
##

## load prediction results
prediction_eviction <- lapply(readRDS("./figures/prediction_eviction.rds"), density)
prediction_gpa      <- lapply(readRDS("./figures/prediction_gpa.rds"), density)
prediction_grit     <- lapply(readRDS("./figures/prediction_grit.rds"), density)
prediction_hardship <- lapply(readRDS("./figures/prediction_hardship.rds"), density)
prediction_job      <- lapply(readRDS("./figures/prediction_job.rds"), density)
prediction_layoff   <- lapply(readRDS("./figures/prediction_layoff.rds"), density)


#tikz(file = "outcome_prediction.tex", width = 7, height = 5)

png(file = "./figures/outcome_prediction_rev.png", width = 600, height = 480)
layout(matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE))
par(mar = c(3, 4, 2, 2))
## hardship
plot(1, 1, type = "n", xlim = c(-0.3, 1), ylim = c(0, 10), bty = 'n', main = "Hardship",
    xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'materialHardship'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_hardship[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_hardship[[2]], lty = 1, lwd = 1.6, col = '#E84646')


## GPA
plot(1, 1, type = "n", xlim = c(0, 5), ylim = c(0, 2.5), bty = 'n', main = "GPA",
    xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'gpa'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_gpa[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_gpa[[2]], lty = 1, lwd = 1.4, col = '#E84646')

## GRIT
plot(1, 1, type = "n", xlim = c(0, 5), ylim = c(0, 3), bty = 'n', main = "Grit",
     xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'grit'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_grit[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_grit[[2]], lty = 1, lwd = 1.4, col = '#E84646')
legend("topleft", legend = c("Training data", "In-sample", "Out-of-sample"),
        lty = c(2, 3, 1), col = c('gray30',"#3182bd", '#E84646'), lwd = c(1.5, 1.5, 1.5),
        bty = "n")

## EVICtion
plot(1, 1, type = "n", xlim = c(-0.5, 1.5), ylim = c(0, 27), bty = 'n', main = "Eviction",
     xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'eviction'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_eviction[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_eviction[[2]], lty = 1, lwd = 1.4, col = '#E84646')



## layoff
plot(1, 1, type = "n", xlim = c(-0.5, 1.5), ylim = c(0, 15), bty = 'n', main = "Layoff",
     xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'layoff'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_layoff[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_layoff[[2]], lty = 1, lwd = 1.4, col = '#E84646')


## job
plot(1, 1, type = "n", xlim = c(-0.5, 1.5), ylim = c(0, 10), bty = 'n', main = "Job",
     xlab = "", ylab = "Density")
lines(density(na.omit(outcome[,'jobTraining'])), lty = 2, lwd = 1.6, col = 'gray30')
lines(prediction_job[[1]], lty = 3, lwd = 1.6, col = "#3182bd")
lines(prediction_job[[2]], lty = 1, lwd = 1.4, col = '#E84646')

dev.off()


##
## Variable names
##

get_mv_vars <- function(dat) {
    ## m-f for background.csv
    first_char <- substring(dat,1,1)
    first_three_char <- substring(dat,1,3)

    # mother and father variables
    f_var <- (sum(first_char == "f") - sum(first_three_char == "ffc")) / (length(first_char) - sum(first_three_char == "ffc"))
    m_var <- sum(first_char == "m") / (length(first_char) - sum(first_three_char == "ffc"))

    return(list('m' = m_var, 'f' = f_var))
}


#
selected_hardship <- attr(lasso_x_matrix, 'dimnames')[[2]][which(coef(cvfit_hardship, s = "lambda.min")[-1] != 0)]
mf_ratio <- list(
    unlist(get_mv_vars(bg_varnames$x)),
    unlist(get_mv_vars(colnames(final_d))),
    unlist(get_mv_vars(selected_hardship))
)


##
## barplot
##

var_names <- c("m5e9_0", "m3i23c", "m3i7f", "m4i23d", "m5f23a", "f3i6a")
yes_count <- apply(final_train[,var_names], 2, function(x) sum(x == 1))

xloc <- seq(1, 4, by = 0.5)

# pdf(file = 'covar_bar_rev.pdf', width = 9.5, height = 5)
png(file = './figures/covar_bar_rev.png', width = 680, height = 480)

layout(matrix(1:2, ncol = 2), width = c(0.55, 0.45))
# pdf(file = 'covar_bar.pdf', width = 5.5, height = 5)
par(mar = c(3, 4, 2, 2))
plot(1, 1, type = 'n', xlim = c(0.7, 3.7), ylim = c(0, max(yes_count)+10),
    xaxt = 'n', bty = 'n', ylab = paste("Number of Yes (Out of ", nrow(final_train), " Obs.)", sep = ""), xlab = "",
    main = "Panel (A)")
for (i in 1:length(yes_count)) {
    if (i == length(yes_count)) {
        rect(xloc[i]-0.2, 0, xloc[i]+0.2, yes_count[i], density=12, angle=45,
            border = '#3182bd', col = '#3182bd')
    } else {
        rect(xloc[i]-0.2, 0, xloc[i]+0.2, yes_count[i], col = 'gray')
    }

    text(xloc[i], yes_count[i], labels = yes_count[i], pos = 3, cex = 0.8)
}

axis(1, at = xloc[-7], labels = var_names, lty = 0, padj = -2, cex.axis = 0.85)
legend("topleft", legend = c("Mother-survey", "Father-survey"),
        fill = c("gray", NA), density = c(NA, 3), border = c(NA, "#3182bd"),
        pt.cex = 1.2, bty = 'n')

## Panal (B)
plot(1, 1, type = 'n', xlim = c(0.1, 1.6), ylim = c(0, 0.5), ylab = "Proportion",
        xlab = "", xaxt = "n", bty = "n", main = "Panel (B)")

locs <- c(0.2, 0.4, 0.7, 0.9, 1.2, 1.4)
count <- 1; col_bar <- rep(c("gray", "#3182bd"), 3)
density_bar <- rep(c(NA, 12), 3); angle_bar <- rep(c(NA, 45), 3)

for (i in 1:3) {
    for (j in 1:2) {
        rect(locs[count], 0, locs[count] + 0.14, mf_ratio[[i]][j], col = col_bar[count],
             density = density_bar[count], angle = angle_bar[count])
        # text(locs[count], mf_ratio[[i]][j], labels = yes_count[i], pos = 3, cex = 0.85)

        count <- count + 1
    }
}
axis(1, at = c(0.35, 0.88, 1.35), labels = c("Original", "Imputation", "LASSO"), cex.axis = 0.8)
legend("topleft", legend = c("Mother-survey", "Father-survey"),
        fill = c("gray", NA), density = c(NA, 3), border = c(NA, "#3182bd"),
        bty = "n")
dev.off()
