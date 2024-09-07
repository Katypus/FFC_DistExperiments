import xgboost
from numpy import mean
from numpy import std
from xgboost import XGBRFClassifier, XGBRFRegressor
import xgboost as xgb
import numpy as np
import pandas as pd
from sklearn.metrics import r2_score
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedKFold
from sklearn.model_selection import train_test_split

### INSERT NAME OF CSV FILE HERE ###

current = pd.read_csv("cleanedDataWInputedMeans.csv")
train, test = train_test_split(current, test_size = 0.3, random_state=42)

############CLASSIFICATION MODELS###################

#################JOBTRAINING##################################
# data model is trained on
jobTraining_x = train[(train.jobTraining == 0) | (train.jobTraining == 1)]
jobTraining_y = jobTraining_x['jobTraining']
jtxtest = test[(test.jobTraining == 0) | (test.jobTraining == 1)]
jtytest = jtxtest['jobTraining']

# train model
jtModel = XGBRFClassifier(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
jtModel.fit(jobTraining_x, jobTraining_y)

jtpredict = jtModel.predict(jtxtest)
jtr2 = r2_score(jtytest, jtpredict)

# report performances
print(f"Job Training R2: {jtr2}")

####################EVICTION##################################
# data model is trained on
eviction_x = train[(train.eviction == 0) | (train.eviction == 1)]
eviction_y = eviction_x['eviction']
extest = test[(test.eviction == 0) | (test.eviction == 1)]
eytest = extest['eviction']

# train model
eModel = XGBRFClassifier(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
eModel.fit(eviction_x, eviction_y)

epredict = eModel.predict(extest)
er2 = r2_score(eytest, epredict)

# report performances
print(f"Eviction R2: {er2}")

####################LAYOFF##################################
# data model is trained on
layoff_x = train[(train.layoff == 0) | (train.layoff == 1)]
layoff_y = layoff_x['layoff']
lxtest = test[(test.layoff == 0) | (test.layoff == 1)]
lytest = lxtest['layoff']

# train model
lModel = XGBRFClassifier(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
lModel.fit(layoff_x, layoff_y)

lpredict = lModel.predict(lxtest)
lr2 = r2_score(lytest, lpredict)

# report performances
print(f"Layoff R2: {lr2}")

#################REGRESSION MODEL#############################################
#define model
Rmodel = XGBRFRegressor(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
# evaluate the model
cv = RepeatedKFold(n_splits = 10, n_repeats=3, random_state=1)

##############################GPA#################################
# data model is trained on
gpa_y = train['gpa']
gytest = test['gpa']

# train model
gModel = XGBRFRegressor(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
gModel.fit(train, gpa_y)

gpredict = gModel.predict(test)
gr2 = r2_score(gytest, gpredict)

# report performances
print(f"GPA R2: {gr2}")
##############################GRIT#################################
# data model is trained on
grit_y = train['grit']
grytest = test['grit']

# train model
grModel = XGBRFRegressor(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
grModel.fit(train, gpa_y)

grpredict = grModel.predict(test)
grr2 = r2_score(grytest, grpredict)

# report performances
print(f"GRIT R2: {grr2}")

#######################MATERIALHARDSHIP############################
# data model is trained on
mh_y = train['materialHardship']
mhytest = test['materialHardship']

# train model
mhModel = XGBRFRegressor(n_estimators=100, subsample =0.9, colsample_bynode=0.0083)
mhModel.fit(train, mh_y)

mhpredict = mhModel.predict(test)
mhr2 = r2_score(mhytest, mhpredict)

# report performances
print(f"Material Hardship R2: {mhr2}")