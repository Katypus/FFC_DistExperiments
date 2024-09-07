---
title:  Readme
author:
- Diana Stanescu
- Erik Wang
- Soichiro Yamauchi
---


# Procedures for Replication

This folder contains necessary files to make the predictions that we submitted in May under account name haixiaow.

To run the whole procedure in a single step, run `Replication.R`

```bash
~$ Rscript Replication.R
```

Or you can run the individual code in the following order: 

1. `Clearning_Code_Updated.R` (Please unzip `background.csv.zip` manually if you're not running `Replication.R`)
2. `Run_Amelia.R`
3. `code_updated.R`
4. `Figures_Rev.R` (located in `/figures`)
5. `Figure_Prediction_update.R` (located in `/figures`)
6. `table1_updated.R` (located in `/tables`)
7. `generate_table.R` (located in `/post-analysis`)


**Note** Scripts depend on the following R packages that should be installed prior to the implementation of codes.

+ `Amelia`, `dplyr`, `glmnet`, `RColorBrewer`, `readr`, `tidyr` and `xtable`


# Score files

+ `./tables/Scores_for_Socius Submission.csv`: Leaderboard MSE results
+ `./post-analysis/result/holdout_results_socius.csv`: Out of sample MSE results for post analysis models

