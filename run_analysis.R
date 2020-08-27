#Loading Library dplyr
library(dplyr)

#Creating a directory and downloading the dataset provoided

if(!file.exists(".getcleandata")){dir.create("./getcleandata")}
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./getcleandata/projectdataset.zip")

#file is unzipped here

unzip(zipfile = "./getcleandata/projectdataset.zip",exdir = "./getcleandata" )

#Train data read here

x_train <- read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")

#Test data read here

x_test <- read.table("./getcleandata/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getcleandata/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getcleandata/UCI HAR Dataset/test/subject_test.txt")

#Variable names from read data set stored here

variable_names <- read.table("./getcleandata/UCI HAR Dataset/features.txt")

#Activity labels read here

activity_labels <- read.table("./getcleandata/UCI HAR Dataset/activity_labels.txt")

#1. Training and Test data are combined here

X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

#2. Getting the mean and Standard deviation

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

#3 Naming the activities provided from description file

colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

#4 Data set is labeled here with the descriptive variable names

colnames(X_total) <- variable_names[selected_var[,1],2]

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)





