# Post-Challenge Analysis


In response to reviewer/editors comments, we run a few additional analyses. These analyses are separate results from the original Fragile Family Challenge.


## Prediction with Mather and Father Variables


> Would another way to compare the value of mother and father data be to try to make prediction using just the selected mother variables and just the selected father variables?  Would you expect that the model with just the mother variables would do better?  If so, how much better?  If you generate these predictions, we can score them and you can include them as a footnote as long as it is clearly labeled as a post-Challenge analysis.


1. **Data**: We use `imputed.RData` and `final_train.rds` for the analysis, both of which are produced by `code.R` in Replication folder.
2. **Code**: `mother-father-prediction.R` replicates all the analysis.
3. **Output**: We produce two predictions: one based on mother-related and one based on father-related variables. Outputs are in FFC format, where predicted values for six outcomes are combined into single matrix with `challengeID`. Results are stored in `/mother-prediction/prediction.csv` and `/father-prediction/prediction.csv`.

## Null model

> When presenting the MSE for all six variables, we also think it would help to provide some ways for readers to evaluate the MSE numbers, which are hard to interpret.   Some examples of how to do this might be to include the baseline prediction and the lowest MSE prediction.

> Comparison to Baseline. The authors make a number of claims regarding the MSE score (e.g., “The out-of-sample prediction of Material Hardship using our approach achieves a low MSE of 0.019, the best predictive performance in the FFC for this variable.”). However, no comparison is given to a baseline or dummy model that makes predictions with no input data. Only with an explicit relative comparison can the model be evaluated in terms of it’s use of input data or the impact of input data on the prediction. This is a well known practice in data science, and this information should be included in this journal submission to qualify claims of low prediction accuracy.

1. **Data**: We use `imputed.RData` and `final_train.rds` for the analysis, both of which are produced by `code.R` in Replication folder.
2. **Code**: `null-prediction.R` replicates all the analysis
3. **Output**: Prediction results can be found in `/null-prediction/prediction.csv`. The output file is in the original FFC submission format.

## Imputation

> Do you have any evidence about the effects of imputation on predictive performance?  In other words, if you skip the Amelia step how do the results differ, if at all, in terms of predictive performance?  We realize that you didn?t submit these models to the leaderboard, but if you would like to check this, we can calculate the scores for you and we can include it in the paper in a footnote, clearly indicating that this was a post-hoc analysis done after the Challenge was complete.

1. **Data**: We use `new_d3.RData` and `train.csv` for the analysis. `new_d3.RData` is produced by `Cleaning_Code.R` in Replication folder.
2. **Code**: `mean-imputed-prediction.R` replicates all the analysis.
3. **Output**: We produce one set of predictions. Outputs are in FFC format, where predicted values for six outcomes are combined into single matrix with `challengeID`. Results are stored in `/imputation-prediction/prediction.csv`.


## Results

We asked FFC to evaluate prediction performances on the hold-out data.
The results are stored in `/results/holdout_results_socius.csv`.




