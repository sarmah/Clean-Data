{
  library(data.table)
  library(plyr)
  library(dplyr)
  
  ## load column names
  labelData <- read.table("features.txt")

  ## load test and train data
  testData <- read.table("./test/X_test.txt", col.names=labelData[,2], check.names=FALSE)
  trainData <- read.table("./train/X_train.txt", col.names=labelData[,2], check.names=FALSE)
  
  ## load test and train subject IDs
  testSubj <- read.table("./test/subject_test.txt", col.names = "subject")
  trainSubj <- read.table("./train/subject_train.txt", col.names = "subject")
  
  ## load the activity codes
  testLabel <- read.table("./test/y_test.txt", col.names = "actCode")
  trainLabel <- read.table("./train/y_train.txt", col.names = "actCode")
  
  ## load activity labels
  actData <- read.table("activity_labels.txt", col.names = c("actCode", "activity"))
  
  ## merge Data, Subj, and Label into single dataset
  allTest <- cbind(testSubj, testLabel, testData)
  allTrain <- cbind(trainSubj, trainLabel, trainData)
  
  ## replace activity code with activity label
  allTest <- merge(allTest, actData)
  allTrain <- merge(allTrain, actData)
  
  ## merge test and train data
  allData <- rbind(allTest, allTrain)
  ##allData <- allTest

  ## filter the subject, activity, mean() and std() columns
  m <- grep("mean\\(\\)|std\\(\\)", labelData[,2], value=TRUE)
  m <- c("subject", "activity", m)
  filterData <- allData[,m]
  
  ## melt the data
  m1 <- melt(filterData, id = c("subject", "activity"))

  ## summarize teh data to get the mean
  s1 <- ddply(m1, c("subject", "activity", "variable"), summarize, mean=mean(value))

  write.table(s1, "tidy_data.txt", row.name=FALSE)
}