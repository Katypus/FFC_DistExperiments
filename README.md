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

trainingfilter.py:
creates subsets of the training data to train models on; can only be run after running motherracefilter.py or after other subsets of background.csv have been made

leaderboardEval.py:
for models not trained in this repository; calculates r-squared values of
outcomes compared to the actual values in the leaderboard set

DATA FILES:

Any .csv file beginning with a T is a subset of training.csv, and the following
letters represent what subset of the mother's traits the file has (ex: Twnh.csv
is a training subset of white non-hispanic mothers)

*For most of these programs to run, they must be able to access background.csv, leaderboard.csv, and training.csv, all of which you must be authorized to access at the Office of Population Research at Princeton University
