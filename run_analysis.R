setwd("/Users/duanliu/Downloads/Coursera R/UCI HAR Dataset")
getwd()

library(data.table)
library(reshape2)
library(plyr)
library(dplyr)

##You should create one R script called run_analysis.R 
##that does the following.

activity_labels<-read.table("./activity_labels.txt",header = FALSE)
features<-read.table("./features.txt",header=FALSE)
x_test<-read.table("./test/X_test.txt",header=FALSE)
y_test<-read.table("./test/y_test.txt",header=FALSE)
subject_test <- read.table("./test/subject_test.txt")
x_train<-read.table("./train/X_train.txt",header=FALSE)
y_train<-read.table("./train/y_train.txt",header=FALSE)
subject_train <- read.table("./train/subject_train.txt")

colnames(activity_labels)<-c("activityID","activityType")
colnames(subject_test) <- "subjectID"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"


##1.Merges the training and the test sets to create one data set.
trainingdata<-cbind(y_train,subject_train,x_train)
testdata <- cbind(y_test,subject_test,x_test)
mergedData<-rbind(trainingdata,testdata)


##2.Extracts only the measurements on the mean and standard deviation
##for each measurement.
colNames <- colnames(mergedData)
datameanstd <-mergedData[,grepl("mean|std|subject|activityID",colnames(mergedData))]


##3.Uses descriptive activity names to name the activities in the data
##set
datameanstd <- join(datameanstd, activity_labels, by = "activityID", match = "first")

##4.Appropriately labels the data set with descriptive variable names.
names(datameanstd) <- gsub("\\(|\\)", " ", names(datameanstd), perl  = TRUE)
names(datameanstd) <- gsub("-", " ", names(datameanstd), perl  = TRUE)
names(datameanstd) <- gsub("tBody", "Body", names(datameanstd), perl  = TRUE)
names(datameanstd) <- gsub("fBody", "Body", names(datameanstd), perl  = TRUE)
names(datameanstd) <- gsub("BodyBody", "Body", names(datameanstd), perl  = TRUE)
names(datameanstd) <- gsub("tGravity", "Gravity", names(datameanstd), perl  = TRUE)

print(datameanstd)

##5.From the data set in step 4, creates a second, independent tidy 
##data set with the average of each variable for each activity and each
##subject.
tidydatamean<- ddply(datameanstd, c("subjectID","activityType"), numcolwise(mean))
write.table(tidydatamean,file="./tidydata.txt")

