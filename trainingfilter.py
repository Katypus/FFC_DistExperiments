import pandas as pd

train = pd.read_csv('train.csv', encoding_errors='ignore')

# filters by Mother race (baseline own report)

wnh = pd.read_csv('NAME_OF_CSV_WITH_WNH_MOTHERS')
wnh = wnh['challengeID']
wnh = pd.merge(wnh, train, on='challengeID', how='inner')
wnh.to_csv('Twnh.csv')

bnh = pd.read_csv('NAME_OF_CSV_WITH_BNH_MOTHERS')
bnh = bnh['challengeID']
bnh = pd.merge(bnh, train, on='challengeID', how='inner')
bnh.to_csv('Tbnh.csv')

h = pd.read_csv('NAME_OF_CSV_WITH_H_MOTHERS')
h = h['challengeID']
h = pd.merge(h, train, on='challengeID', how='inner')
h.to_csv('Th.csv')

o = pd.read_csv('NAME_OF_CSV_WITH_O_MOTHERS')
o = o['challengeID']
o = pd.merge(o, train, on='challengeID', how='inner')
o.to_csv('To.csv')


