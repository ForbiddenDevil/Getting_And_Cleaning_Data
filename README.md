Course project for the Getting and Cleaning Data...

The R script, `run_analysis.R`, does the following:

1. Download dataset if it doesn't exist.
2. Load activity and feature information.
3. Loads both the training and test datasets, keeping only those columns which
   reflect mean or standard deviation.
4. Loads the activity and subject data for each dataset, and merges those
   columns with the dataset.
5. Merges the 2 datasets.
6. Converts the `activity` and `subject` columns into factors.
7. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair.

The result is stored in the file `tidy.txt`.
