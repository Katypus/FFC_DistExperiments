import xgboost
from numpy import mean
from numpy import std
from xgboost import XGBRFClassifier, XGBRFRegressor
import xgboost as xgb
import numpy as np
import pandas as pd
from sklearn.datasets import make_classification
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedKFold

### INSERT NAME OF CSV FILE HERE ###

current = 'whitenonhispanic_mothers.csv'

print(current + '\n')
############CLASSIFICATION MODEL###################
#define model
Cmodel = XGBRFClassifier(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)

# evaluate the model
cv = RepeatedKFold(n_splits = 10, n_repeats=3, random_state=1)

#################JOBTRAINING##################################
# data model is trained on
jobTraining_x = pd.read_csv(current)
jobTraining_x = jobTraining_x[(jobTraining_x.jobTraining == 0) | (jobTraining_x.jobTraining == 1)]
jobTraining_y = jobTraining_x['jobTraining']

# evaluate the model and collect the scores
n_scores = cross_val_score(Cmodel, jobTraining_x, jobTraining_y, scoring='accuracy', cv=cv, n_jobs=-1)

# report performances
print('Job Training Mean Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

####################EVICTION##################################
# data model is trained on
eviction_x = pd.read_csv(current)
eviction_x = eviction_x[(eviction_x.eviction == 0) | (eviction_x.eviction == 1)]
eviction_y = eviction_x['eviction']

# evaluate the model and collect the scores
n_scores = cross_val_score(Cmodel, eviction_x, eviction_y, scoring='accuracy', cv=cv, n_jobs=-1)

# report performance
print('Eviction Mean Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

####################LAYOFF##################################
# data model is trained on
layoff_x = pd.read_csv(current)
layoff_x = layoff_x[(layoff_x.layoff == 0) | (layoff_x.layoff == 1)]
layoff_y = layoff_x['layoff']

# evaluate the model and collect the scores
n_scores = cross_val_score(Cmodel, layoff_x, layoff_y, scoring='accuracy', cv=cv, n_jobs=-1)

# report performance
print('Layoff Mean Accuracy: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

#################REGRESSION MODEL#############################################
#define model
Rmodel = XGBRFRegressor(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
# evaluate the model
cv = RepeatedKFold(n_splits = 10, n_repeats=3, random_state=1)

##############################GPA#################################
# data model is trained on
gpa_x = pd.read_csv(current)
gpa_y = gpa_x['gpa']

# evaluate the model and collect the scores
n_scores = cross_val_score(Rmodel, gpa_x, gpa_y, scoring='neg_mean_absolute_error', cv=cv, n_jobs=-1)
# report performance
print('GPA MAE: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

##############################GRIT#################################
# data model is trained on
grit_x = pd.read_csv(current)
grit_y = grit_x['grit']

# evaluate the model and collect the scores
n_scores = cross_val_score(Rmodel, grit_x, grit_y, scoring='neg_mean_absolute_error', cv=cv, n_jobs=-1)
# report performance
print('grit MAE: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

#######################MATERIALHARDSHIP############################
# data model is trained on
materialHardship_x = pd.read_csv(current)
materialHardship_y = materialHardship_x['materialHardship']

# evaluate the model and collect the scores
n_scores = cross_val_score(Rmodel, materialHardship_x, materialHardship_y, scoring='neg_mean_absolute_error', cv=cv, n_jobs=-1)
# report performance
print('materialHardship MAE: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))