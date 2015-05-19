#Getting AND CLEANING DATA ASSignment

##Cleans up Environment
 rm(list=ls())
##Adds in required Libraries
library(data.table)
library(dplyr)
#read in features as a table
feat<- read.table("./UCI HAR DATASET/features.txt")
##pull/process in x &y data
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
##binds the labels todgether
 xlab<-cbind(yray,xray)
 meanstdlabel<-cbind(yray,meanstd)
##pulls ina nd binds the subject teast and train data
subtest <-read.table("./UCI HAR DATASET/test/subject_test.txt", col.names=c("subject"))
subtrain <-read.table("./UCI HAR DATASET/train/subject_train.txt",col.names=c("subject"))
subject <-rbind(subtest,subtrain)
##averages the data
 avg <- aggregate(xray,by =list(activity=yray[,1],subject=subject[,1]),mean)
##Writes ou the tidycats data into a text file
write.table(avg, file="./tidy_data.txt", row.names=FALSE)