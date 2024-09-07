PROGRAMS:

motherracefilter.py:
Research on the FFC data suggests that attributes of the mother are more influential
on child outcome than attributes of the father; this file creates subsets of
background.csv based on race + religion of the mother.

Kfoldeval-models.py:
uses subsets of data to run K-fold evaluations of an
XGBoost Random Forest model trained on those subsets

r-squaredmodel.py:
calculated r-squared values of an XGBoost Random Forest model trained on
a .csv file you input on line 15

leaderboardEval.py:
for models not trained in this repository; calculates r-squared values of
outcomes compared to the actual values in the leaderboard set

DATA FILES:
Any .csv file beginning with a T is a subset of training.csv, and the following
letters represent what subset of the mother's traits the file has (ex: Twnh.csv
is a training subset of white non-hispanic mothers)

Any .csv file beginning with a C is a subset of background.csv, and the rest of
the name represents what subset of the mother's traits the subset has (ex:
Cblacknonhispanic_mothers.csv is a subset of background.csv of Black
non-Hispanic Mothers)
