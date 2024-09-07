**XGBOOST RANDOM FOREST MODELS**

Kfoldeval-models.py:
uses subsets of data to run K-fold evaluations of an
XGBoost Random Forest model trained on subsets made
by the programs in the stanescu folder

r-squaredmodel.py:
calculated r-squared values of an XGBoost Random Forest model trained on
a .csv file you input on line 15

**STANESCU FOLDER**

Contains code to reproduce the stanescu_using_2019 model, which won the FFC for the
best R squared value in predicting a family's material hardship

To reproduce the model, download the Docker image containing all dependencies from
this link:
https://hub.docker.com/layers/2018dliu/fragilefamilieschallenge_socius_reproducibility/stanescu_using_2020/images/sha256-e8aa9cb1a6597d2a4e61934d5aa38c66ddd8fc373c47f36a58d6a11359587c7a?context=explore

If you are using the Princeton Adroit cluster, you must convert this Docker image to an
Apptainer (.sif) file and upload it. (You can do this directly in the Adroit terminal
following these instructions: https://apptainer.org/docs/user/main/docker_and_oci.html)

After running the stanescu Apptainer, follow the instructions in the stanescu_using_2019
folder's README to replicate the stanescu paper results.

To train the model on specific subsets of training.csv, use the following programs in
the stanescu folder to create subsets. (name the subset training.csv and place it in
the stanescu_using_2019 folder to train the stanescu model on the subset)

motherracefilter.py:

Research on the FFC data suggests that attributes of the mother are more influential
on child outcome than attributes of the father; this file creates subsets of
background.csv based on race + religion of the mother.

trainingfilter.py:

creates subsets of the training data to train models on; can only be run after 
running motherracefilter.py or after other subsets of background.csv have been made

Program for evaluation:

leaderboardEval.py:
for models not trained in this repository; calculates r-squared values of
outcomes compared to the actual values in the leaderboard set

**DATA FILES:**

Any .csv file beginning with a T is a subset of training.csv, and the following
letters represent what subset of the mother's traits the file has (ex: Twnh.csv
is a training subset of white non-hispanic mothers)

*For most of these programs to run, they must be able to access background.csv, leaderboard.csv, and training.csv, all of which you must be authorized to access at the Office of Population Research at Princeton University. Place background.csv in stanescu if you need to create subsets of it, and move it to stanescu_using_2019 if you are training a stanescu model. Similarly, place training.csv in stanescu if making subsets, and stanescu_using_2019 if reproducing the stanescu model. leaderboard.csv should be placed in stanescu for evaluation.
