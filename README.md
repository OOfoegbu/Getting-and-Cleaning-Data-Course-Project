# Getting-and-Cleaning-Data-Course-Project

## README document for Script run_analysis

The run_analysis script in this repository makes use of the data from the "Human Activity Recognition Using Smartphones Dataset".  
These data are contained in the URL link:
 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
For more explanation of the source of the data, reference the README.txt, and features_info.txt files contained in the URL above.
The run_analysis  script takes take the data from the smartphone dataset, and achieves the following goals, as required by the project.

### Goals
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set.
4.	Appropriately labels the data set with descriptive variable names.
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

To achieve these goals, the run_analysis script follows the following steps:
1.	Downloads the compressed folder to the working directory, unzips the folder, and reads the relevant files. The Codebook.md included in this repo, details which files are read and their relevance to the project.
2.	Individual data sets are created for training and testing set. The data sets include subject, activity columns and measurement values of mean and standard deviation.
3.	The individual data sets were tidied by changing the activities id numbers to descriptive activity names from the activity_label.txt file. Also, the elements in the features.txt file were used as descriptive for the various measurement columns.
4.	Both the training and testing set were merged via bind_rows(). This produced a 679734 X 5 data frame saved as data.
5.	Finally a separate independent tidy data set with the average of each variable for each activity and each subject was created by dcasting the merged data, with the fun.aggregate = mean. This produced a 180 X 68 data frame saved as data_average.
6.	Both data and data_average are displayed on the screen via the View() function.


