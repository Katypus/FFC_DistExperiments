import pandas as pd
from sklearn.metrics import r2_score
from sklearn.metrics import mean_squared_error

y_true = pd.read_csv('stanescu\leaderboard.csv')
y_pred = pd.read_csv('stanescu\prediction(other).csv')
background = pd.read_csv('stanescu/background.csv')

y_true = y_true.dropna(how="all")
y_pred = y_pred.dropna(how="all")
y_indices = y_true['challengeID']
y_pred = pd.merge(y_indices, y_pred, on='challengeID', how="inner")

# edits to test different demographics
selected_cols = ["challengeID", "cm1ethrace"]
back = background[selected_cols]

wnh_indices = back[back["cm1ethrace"] == 1]
wnh_indices = wnh_indices["challengeID"]

bnhm_indices = back[back["cm1ethrace"] == 2]
bnhm_indices = bnhm_indices["challengeID"]

hm_indices = back[back["cm1ethrace"] == 3]
hm_indices = hm_indices["challengeID"]

o_indices = back[back["cm1ethrace"] == 4]
o_indices = o_indices["challengeID"]

# array of outcomes
outcomes = ['gpa', 'grit', 'materialHardship', 'eviction', 'layoff', 
            'jobTraining']

# array of mother races
motherr = [wnh_indices, bnhm_indices, hm_indices, o_indices]

for oc in outcomes:
    oc_true = y_true.dropna(subset=oc)
    oc_indices = oc_true['challengeID']
    oc_pred = y_pred.dropna(subset=oc)
    pred_indices = oc_pred['challengeID']
    ind = pd.merge(oc_indices, pred_indices, on='challengeID', how="inner")
    oc_pred = pd.merge(ind, y_pred, on='challengeID', how="inner")
    oc_true = pd.merge(ind, oc_true, on='challengeID', how="inner")
    leader_true = oc_true[oc]
    leader_pred = oc_pred[oc]
    ocr2 = r2_score(leader_true, leader_pred)
    print(f"leaderboard {oc} R2: {ocr2} \n")
    for mr in motherr:
        mroc_pred = pd.merge(oc_pred, mr, on = 'challengeID', how = 'inner')
        mroc_true = pd.merge(oc_true, mr, on = 'challengeID', how='inner')
        mroc_true = mroc_true[oc]
        mroc_pred = mroc_pred[oc]
        
        mrocr2 = r2_score(mroc_true, mroc_pred)
        print(f"{oc} R2: {mrocr2} \n")
