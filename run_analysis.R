# Load the relevant packages used in this script
library(tidyr)
library(dplyr)
library(reshape2)

# create folder called smartphone in working directory to store the compressed files
# download the url for the compressed files and save as run_analysis.zip in the smartphone folder
# unzip the compressed files 
if(!file.exists("./smartphone")){dir.create("./smartphone")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./smartphone/run_analysis.zip")
file <- unzip("./smartphone/run_analysis.zip", list = TRUE)

# Read the datasets common to both the testing set and training set
# assign column names to the activity_label data frame
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("ID", "activity")
features <- read.table("UCI HAR Dataset/features.txt")

# Read the datasets relevant to the training set
train_subject_id <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(train_subject_id) <- c("subject") # assign column names to the train_subject_id dataset
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
colnames(train_set) <- features[,2] # assign the elements of the feature vector as descriptive column names for the train_set
train_activity_label <- read.table("UCI HAR Dataset/train/y_train.txt")
colnames(train_activity_label) <- c("activity") # assign column name for the train_activity_label dataset

# create the training data set, that extracts only the measurements
# on the mean and standard deviation for each measurement
train_data <- cbind(train_subject_id, train_activity_label, train_set)
train_data <- train_data[, c(1:2, grep("mean()|std", names(train_data)))]
train_data <- train_data[, -grep("Freq", names(train_data))]
# Using descriptive activity names from the activity_labels dataset 
# to name the activities in the training data set
activity_names <- data.frame(activity = c(1:6), name = activity_labels[["activity"]])
train_data[["activity"]] <- activity_names[match(train_data[["activity"]], activity_names[["activity"]]), 'name']
train_data <- arrange(train_data, subject, activity) %>% 
  mutate(analysis_cond = "train") # add a column describing the analysis condition to be train
cols <- c("analysis_cond")
train_data <- train_data[, c(cols, setdiff(names(train_data), cols))]
# Tidying up the training data set
tidy_train_data <- gather(train_data, measurements, value, -(analysis_cond:activity)) %>%
  arrange(subject, activity)

# Read the datasets relevant to the test set
test_subject_id <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(test_subject_id) <- c("subject") # assign column names to the test_subject_id dataset
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
colnames(test_set) <- features[,2] # assign the elements of the feature vector as descriptive column names for the test_set
test_activity_label <- read.table("UCI HAR Dataset/test/y_test.txt")
colnames(test_activity_label) <- c("activity") # assign column name for the test_activity_label dataset

# create the testing data set, that extracts only the measurements
# on the mean and standard deviation for each measurement
test_data <- cbind(test_subject_id, test_activity_label, test_set)
test_data <- test_data[, c(1:2, grep("mean|std", names(test_data)))]
test_data <- test_data[, -grep("Freq", names(test_data))]
# Using descriptive activity names from the activity_labels dataset 
# to name the activities in the testing data set
test_data[["activity"]] <- activity_names[match(test_data[["activity"]], activity_names[["activity"]]), 'name']
test_data <- arrange(test_data, subject, activity) %>% 
  mutate(analysis_cond = "test") # add a column describing the analysis condition to be test
test_data <- test_data[, c(cols, setdiff(names(test_data), cols))]
# Tidying up the testing data set
tidy_test_data <- gather(test_data, measurements, value, -(analysis_cond:activity)) %>%
    arrange(subject, activity)


# Merges the training and test set to create one dataset
data <- bind_rows(tidy_train_data, tidy_test_data)
View(data)

# Using the merged data, creating a tidy data, that with average mean and std values
# for each measurement (signal, axial), for each activity, for each subject.
data_average <- dcast(data, subject + activity ~ measurements, mean)
View(data_average)