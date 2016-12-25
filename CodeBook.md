# Codebook for run_analysis script

This codebook conatins a description of the original data set obtained from the website http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. It also contains explanation of all the codes written to manuipulate the smartphone data, in order to create a tidy data set that merges the training and testing data. It also explains the code written to write an independent tidy data that reports the average value of each variable in the merges dataset, for each subject for each activity.


Human Activity Recognition Using Smartphones Data Set
Abstract: Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
 
Data Set Characteristics:	Multivariate, Time-Series
Number of Instances:	10299	
Area:	Computer	   
Attribute Characteristics:	N/A	
Number of Attributes:	561	
Date Donated	2012-12-10	   
Associated Tasks:	Classification, Clustering	Missing Values?	N/A	
Number of Web Hits:	427478	 

Data Set Information:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

The above information was extracted from the link:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones which contains the codebook for the original datasets.

 

## Run_analysis Script

The run_analysis script starts by loading the tidyr, dplyr, and reshape2 packages in r. Features from these packages will be used in manipulating the data, and creating tidy data sets. 

Then the compressed folder: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is downloaded and saved in a created folder named smartphone in the working directory. The compressed folder was provided with the project. 
The smartphone folder contains 28 .txt files, which could be read into r as data frames using data.table() function. The files are listed below:
The run_analysis, reads the following files from the smartphone folder:

activity_labels.txt - reads as a 6 X2 data frame. The first column contains a number identifier, and the second column contains a description of the 6 activities performed. This data frame is saved under the name activity_labels. The columns in this data frame have been named "ID" and "activity" respectively.
Code:
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("ID", "activity")

features.txt - reads as a 561 X 2 data frame. The first column contains a number identifier, and the second column contains a description of the 561 variables that were estimates from the signals. This data frame is saved under the name features.
Code:
features <- read.table("UCI HAR Dataset/features.txt")

subject_train.txt - reads as a 7352 X 1 data frame. This data frame contains the subject id of the volunteers selected for the training set, for the 7352 observations. This data frame is saved under the name train_subject_id. The column in this data frame has been named "subject".
Code:
train_subject_id <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(train_subject_id) <- c("subject")

X-train.txt - reads as a 7352 X 561 data frame. This data frame contains the measurement values for the 561 variables in the features.txt file, for each of the 7353 observation in the training set. This data frame is saved under the name train_set. The 561 columns of the of this data frames has been named using the 561 variables in the features data frame, in sequential order. The units of the accelerometer measurements are in "g", while the units of the gyroscope measurements are in "radian/sec".
Code:
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
colnames(train_set) <- features[,2]

y-train.txt - reads as 7353 X 1 data frame. This data frame contains the activity id's of the 7353 observation in the training set. This data frame is saved under the name train_activity_label. A column name of "activity" has been assigned to the column. 
Code:
train_activity_label <- read.table("UCI HAR Dataset/train/y_train.txt")
colnames(train_activity_label) <- c("activity")

subject_test.txt - reads as a 2947 X 1 data frame. This data frame contains the subject id of the volunteers selected for the testing set, for the 2947 observations. This data frame is saved under the name test_subject_id. The column in this data frame has been named "subject". 
Code:
test_subject_id <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(test_subject_id) <- c("subject")

X-test.txt - reads as a 2947 X 561 data frame. This data frame contains the measurement values for the 561 variables in the features.txt file, for each of the 2947 observation in the testing set. This data frame is saved under the name test_set. The 561 columns of the of this data frames has been named using the 561 variables in the features data frame, in sequential order. The units of the accelerometer measurements are in "g", while the units of the gyroscope measurements are in "radian/sec".
Code:
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
colnames(test_set) <- features[,2]

y-test.txt - reads as 2947 X 1 data frame. This data frame contains the activity id's of the 2947 observation in the testing set. This data frame is saved under the name test_activity_label. A column name of "activity" has been assigned to the column.
Code:
test_activity_label <- read.table("UCI HAR Dataset/test/y_test.txt")
colnames(test_activity_label) <- c("activity")

Both the training and testing data sets are created, and tidied, prior to merging.

To create the training data set, this script uses the function cbind() to bind train_subject_id, train_activity_label and train_set. The resulting data frame is called train_data. At this stage train_data has a dimension of 7352 X 563.
Code:
train_data <- cbind(train_subject_id, train_activity_label, train_set)

The data frame train_data is modified by extracting only the measurements on the mean and standard deviation (std) for each measurement. The resulting data frame has a dimension of 7352 X 68.
Code:
train_data <- train_data[, c(1:2, grep("mean()|std", names(train_data)))]
train_data <- train_data[, -grep("Freq", names(train_data))]

Descriptive activity names from the activity_labels dataset were used to name the activities in the training data set.
Code:
activity_names <- data.frame(activity = c(1:6), name = activity_labels[["activity"]])
train_data[["activity"]] <- activity_names[match(train_data[["activity"]], activity_names[["activity"]]), 'name']

The train_data data frame was arranged in ascending order of subject, then alphabetical order of activity. This made the data set tidier. The train_data set was further modified by adding a column to the front called analysis_cond. This column described the condition of analysis for this data set as "train". This would be helpful in differentiating training data from test data after both data sets are merged. At this stage, train_data has a dimension of 7352 X 69.
Code:
train_data <- arrange(train_data, subject, activity) %>% mutate(analysis_cond = "train") 
cols <- c("analysis_cond")
train_data <- train_data[, c(cols, setdiff(names(train_data), cols))]

A tidy_train_data was created using the train_data, by gathering all the columns in the data set containing measurement values, and placing them in a column called measurements, and their values in a column called value. This ensures that one variable is in one column, and each row is one observation. The dimension of the tidy_train_data is 485232 X 5. 
Code:
tidy_train_data <- gather(train_data, measurements, value, -(analysis_cond:activity)) %>%
  arrange(subject, activity)

Similar steps were taken to create a tidy test data set.

To create the testing data set, this script uses the function cbind() to bind test_subject_id, test_activity_label and test_set. The resulting data frame is called test_data. At this stage test_data has a dimension of 2947 X 563.
Code:
test_data <- cbind(test_subject_id, test_activity_label, test_set)

The data frame test_data is modified by extracting only the measurements on the mean and standard deviation (std) for each measurement. The resulting data frame has a dimension of 2947 X 68.
Code:
test_data <- test_data[, c(1:2, grep("mean|std", names(test_data)))]
test_data <- test_data[, -grep("Freq", names(test_data))]

Descriptive activity names from the activity_labels dataset were used to name the activities in the testing data set.
Code:
test_data[["activity"]] <- activity_names[match(test_data[["activity"]], activity_names[["activity"]]), 'name']

The test_data data frame was arranged in ascending order of subject, then alphabetical order of activity. This made the data set tidier. The test_data set was further modified by adding a column to the front called analysis_cond. This column described the condition of analysis for this data set as "test". This would be helpful in differentiating training data from test data after both data sets are merged. At this stage, test_data has a dimension of 2947 X 69.
Code:
test_data <- arrange(test_data, subject, activity) %>% mutate(analysis_cond = "test") 
test_data <- test_data[, c(cols, setdiff(names(test_data), cols))]

A tidy_test_data was created using the test_data, by gathering all the columns in the data set containing measurement values, and placing them in a column called measurements, and their values in a column called value. This ensures that one variable is in one column, and each row is one observation. The dimension of the tidy_test_data is 194502 X 5.
Code:
tidy_test_data <- gather(test_data, measurements, value, -(analysis_cond:activity)) %>%
    arrange(subject, activity)

In order to create one data set from the training and testing sets, the function bind_rows is used on both the tidy_train_data and tidy_test_data data frames. The merge data frame is saved as "data". The View() function is used to display the merged data set on the screen. The dimension of the data data frame is 679734 X 5.
Code: 
data <- bind_rows(tidy_train_data, tidy_test_data)
View(data)

Finally to create an independently tidy data set with the average of each variable for each activity and each subject, the function dcast() is used on the data data set. The resulting data frame is saved as "data_average". It has dimensions of 180 X 68. The View() function is used to display data_average  on the screen.
Code:
data_average <- dcast(data, subject + activity ~ measurements, mean)
View(data_average)
 

 


 


