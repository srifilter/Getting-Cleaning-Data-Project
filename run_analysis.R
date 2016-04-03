
file<- "getdata_dataset.zip"
if (!file.exists(file)){
       Url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(Url1, file)
}  

if (!file.exists("UCI HAR Dataset")) { 
        unzip(file)
}

getDataSet <- function() {
        subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
        subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
        merged_subject <- rbind(subject_train, subject_test)
        names(merged_subject) <- "subject"
        merged_subject
}

X_dataset <- function() {
        X_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
        X_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
        X_merged  <- rbind(X_train, X_test)
}

Y_dataset <- function() {
        Y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
        Y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
        Y_merged  <- rbind(Y_train, Y_test)
}

subject_dataset <- getDataSet()
X_data <- X_dataset()
Y_data <- Y_dataset()

features_data<-read.table('./UCI HAR Dataset/features.txt', header= FALSE, col.names=c('id','names'))
mainfeatures<-grep(".*mean.*|.*std.*",features_data[,2])
dataset <- X_data[, mainfeatures]
names(dataset) <- features_data[features_data$id %in% mainfeatures, 2]

activityLabels<-read.table('./UCI HAR Dataset/activity_labels.txt', header= FALSE, col.names=c('id','names'))

Y_data[,1]<-activityLabels[Y_data[,1],2]
names(Y_data)<- "activity"
names(X_data)<- "subject"

allData<-cbind(X_data, Y_data, dataset)

write.csv("./output/whole_dataset_with_descriptive_activity_names.csv")

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)


