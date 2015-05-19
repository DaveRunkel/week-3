##Getting and Cleaning Data Course ASSignmnet Code Book
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following. 
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Data Names and purposes
- feat is the imported features from the dataset
- ext is the mean and standartd deviation of the features
- xtest is the imported and processed X_test data
- ytest is the imported and processed y_test data
- subtest is the subject list from subject_test 
- xtrain is the imported and processed X_train data
- ytrain is the imported and processed y_train data
- subtrain is the subject list from subject_train
- xray/yray/subject are the r bound data sets from the combination of their ASSociated test and train files
- avg is the average of the variable for each subject

#Getting AND CLEANING DATA ASSignment

##Cleans up Environment
rm(list=ls())

##Adds in required Libraries

library(data.table)
library(dplyr)

#read in features as a table

feat<- read.table("./UCI HAR DATASET/features.txt")

##pulls in both test and train datasets and rbinds them into a single set- xray

xtest<-read.table("./UCI HAR DATASET/test/X_test.txt",col.names=feat[,2])

xtrain<-read.table("./UCI HAR DATASET/train/X_train.txt", col.names=feat[,2])

xray<-rbind(xtest,xtrain)

##read out only data on X and std dev

ext <- feat[grep("(mean|std)\\(",feat[,2]),]

meanstd<-xray[,ext[,1]]

##Pulls in ytest and ytrain data and Rbindrs them into single dataset yray

ytest<-read.table("./UCI HAR DATASET/test/y_test.txt", col.names=c('activity'))

 ytrain<-read.table("./UCI HAR DATASET/train/Y_train.txt",col.names=c('activity'))
 
yray<-rbind(ytest,ytrain)

 labels<-read.table("./UCI HAR DATASET/activity_labels.txt")
 
##adds in the appropriate activity label to the yray dataset

 testcount<-nrow(yray)
 
for(i in 1:testcount){

  if (yray[i,1] =="1"){
  
  yray[i,2] <- "WALKING"
  
  }
  
  if (yray [i,1]=="2"){
  
    yray[i,2] <- "WALKING_UPSTAIRS"
    
  }
  
  if (yray [i,1]=="3"){
  
    yray[i,2] <- "WALKING_DOWNSTAIRS"
    
  }
  
  if (yray [i,1]=="4"){
  
    yray[i,2] <- "SITTING"
    
  }
  

  if (yray [i,1]=="5"){
  
    yray[i,2] <- "STANDING"
    
  }
  
  if (yray [i,1]=="6"){
  
    yray[i,2] <- "LAYING"
    
  }
  
}

##binds the labels together

 xlab<-cbind(yray,xray)
 
 meanstdlabel<-cbind(yray,meanstd)
 
##pulls in and binds the subject teast and train data

subtest <-read.table("./UCI HAR DATASET/test/subject_test.txt", col.names=c("subject"))

subtrain <-read.table("./UCI HAR DATASET/train/subject_train.txt",col.names=c("subject"))

subject <-rbind(subtest,subtrain)

##averages the data

 avg <- aggregate(xray,by =list(activity=yray[,1],subject=subject[,1]),mean)
 
##Writes ou t the tidycats data into a text file

write.table(avg, file="./tidy_data.txt", row.names=FALSE)