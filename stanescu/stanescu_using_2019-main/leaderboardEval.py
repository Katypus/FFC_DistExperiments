import pandas as pd
from sklearn.metrics import r2_score

y_true = pd.read_csv("leaderboard.csv")
y_pred = pd.read_csv("prediction.csv")

y_true = y_true.dropna(how="all")
y_indices = y_true["challengeID"]
y_pred = pd.merge(y_indices, y_pred, on="challengeID", how="inner")

#gpa
gpa_true = y_true['gpa']
gpa_pred = y_pred['gpa']

jtr2 = r2_score(gpa_true, gpa_pred)

print(f"Job Training R2: {jtr2}")

#grit
grit_true = y_true['grit']
grit_pred = y_pred['grit']

gr2 = r2_score(grit_true, grit_pred)

print(f"grit R2: {gr2}")

#materialHardship
mat_true = y_true['materialHardship']
mat_pred = y_pred['materialHardship']

matr2 = r2_score(mat_true, mat_pred)

print(f"Mat Hardship R2: {matr2}")

#eviction

eviction_true = y_true['eviction']
eviction_pred = y_pred['eviction']

evictionr2 = r2_score(eviction_true, eviction_pred)

print(f"eviction R2: {evictionr2}")

#layoff
layoff_true = y_true['layoff']
layoff_pred = y_pred['layoff']

layoffr2 = r2_score(layoff_true, layoff_pred)

print(f"layoff R2: {layoffr2}")

#jobTraining

jobTraining_true = y_true['jobTraining']
jobTraining_pred = y_pred['jobTraining']

jobTrainingr2 = r2_score(jobTraining_true, jobTraining_pred)

print(f"jobTraining R2: {jobTrainingr2}")

