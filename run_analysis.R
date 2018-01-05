library(reshape2)

File_Name <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(File_Name)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, File_Name, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(File_Name) 
}

# Load activity labels + Features
Activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
Activity_Labels[,2] <- as.character(Activity_Labels[,2])
Features <- read.table("UCI HAR Dataset/Features.txt")
Features[,2] <- as.character(Features[,2])

# Extract only the data on mean and standard deviation
Features_Wanted <- grep(".*mean.*|.*std.*", Features[,2])
Features_Wanted.names <- Features[Features_Wanted,2]
Features_Wanted.names = gsub('-mean', 'Mean', Features_Wanted.names)
Features_Wanted.names = gsub('-std', 'Std', Features_Wanted.names)
Features_Wanted.names <- gsub('[-()]', '', Features_Wanted.names)


# Load the datasets
Train <- read.table("UCI HAR Dataset/Train/X_Train.txt")[Features_Wanted]
Train_Activities <- read.table("UCI HAR Dataset/Train/Y_Train.txt")
TrainSubjects <- read.table("UCI HAR Dataset/Train/subject_Train.txt")
Train <- cbind(TrainSubjects, Train_Activities, Train)

Test <- read.table("UCI HAR Dataset/Test/X_Test.txt")[Features_Wanted]
Test_Activities <- read.table("UCI HAR Dataset/Test/Y_Test.txt")
TestSubjects <- read.table("UCI HAR Dataset/Test/subject_Test.txt")
Test <- cbind(TestSubjects, Test_Activities, Test)

# merge datasets and add labels
All_Data <- rbind(Train, Test)
colnames(All_Data) <- c("subject", "activity", Features_Wanted.names)

# turn activities & subjects into factors
All_Data$activity <- factor(All_Data$activity, levels = Activity_Labels[,1], labels = Activity_Labels[,2])
All_Data$subject <- as.factor(All_Data$subject)

All_Data.melted <- melt(All_Data, id = c("subject", "activity"))
All_Data.mean <- dcast(All_Data.melted, subject + activity ~ variable, mean)

write.table(All_Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)