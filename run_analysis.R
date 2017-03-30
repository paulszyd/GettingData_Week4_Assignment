# The createTidyData() function can be used to load raw data files into R and produce the required tidy dataset,
# provided the raw dataset as identified in README.md has been downloaded and unzipped into the user's working directory.
createTidyData <- function(){
# Read tables into R
# Look for each file in the original folder in which it existed in the unzipped raw data folder
# as a subdirectory of the working directory. If it is not there, then look in the working working
# directory itself. Once found, assign it to a descriptive object name
if(file.exists("./UCI HAR Dataset/activity_labels.txt")) {
        activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
}else {
        activity_labels <- read.table("activity_labels.txt", header=FALSE)
}
if(file.exists("./UCI HAR Dataset/features.txt")) {
        features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
}else {
        features <- read.table("features.txt", header=FALSE)
}
if(file.exists("./UCI HAR Dataset/test/subject_test.txt")) {
        subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
}else {
        subject_test <- read.table("subject_test.txt", header=FALSE)
}
if(file.exists("./UCI HAR Dataset/test/X_test.txt")) {
        x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
}else {
        x_test <- read.table(X_test.txt, header=FALSE)
}
if(file.exists("./UCI HAR Dataset/test/y_test.txt")) {
        y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
}else {
        y_test <- read.table("y_test.txt", header=FALSE)
}
if(file.exists("./UCI HAR Dataset/train/subject_train.txt")) {
        subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
}else {
        subject_train <- read.table("subject_train.txt", header=FALSE)
}
if(file.exists("./UCI HAR Dataset/train/X_train.txt")) {
        x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
}else {
        x_train <- read.table("X_train.txt", header=FALSE)
}
if(file.exists("./UCI HAR Dataset/train/y_train.txt")) {
        y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
}else {
        y_train <- read.table("y_train.txt", header=FALSE)
}

#Add the column names in "features" to x_test and x_train:
        colnames(x_test) <- features[[2]]
        colnames(x_train) <- features[[2]]

# Add column name "activity" to y_train and and y_test, which contain the activity ID variable, 
# to conform to tidy data standards by giving a descriptive name to the variable:
        colnames(y_test) <- "activity"
        colnames(y_train) <- "activity"

# Add column name "subject" to subject_test and subject_train to conform to tidy data 
# standards by giving a descriptive name to the variable:
        colnames(subject_test) <- "subject"
        colnames(subject_train) <- "subject"        

# Add "subjecttype" column with "test" or "train" flag to identify subjects as test or train 
# subjects so they can be properly identified in the combined data set. This must be done 
# before the datasets are combined and can be done using the mutate() function:
        subject_test <- mutate(subject_test, subjecttype="test")
        subject_train <- mutate(subject_train, subjecttype="train")

# Bind subject_test and subject_train columns to y_test and y_train so that the subject 
#and the activity (walking, sitting, etc) are matched for each row of observations
        y_test <- cbind(subject_test, y_test)
        y_train <- cbind(subject_train, y_train)

# Bind columns in x_test and x_train data to y_test and y_train combine subject, 
# subjecttype, activity and data results
        test_data <- cbind(y_test, x_test)
        train_data <- cbind(y_train, x_train)

# Combine test and train data into single dataset using rbind(). 
        comb_data <- rbind(train_data, test_data)

# Change activitycode to activity description;
# mapvalues is a function that updates a value based upon the existing
# value, with the ability to update a numeric to a character value.
# In this case, 1="WALKING", 2="WALKING_UPSTAIRS"...6="LAYING"
        comb_data$activity <- mapvalues(comb_data$activity,                   
                c(1, 2, 3, 4, 5, 6),
                c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# Create a vector of column names to be used to subset the full data set to desired data
# consisting only of mean and standard deviation values
# Note: only variables with lower case "mean" are being extracted
# because examination of the data show they are results that are a mean value.
# Those with an uppercase "Mean" are results that use a mean value to calculate
# another value (e.g., an angle based upon a mean) and thus, are not true means (see Markdown.md)
        cols<-c("subject","subjecttype","activity",
                grep("mean", names(comb_data), value = TRUE), 
                grep("std", names(comb_data), value = TRUE))

# Use the cols vector created above to subset the desired data based upon the column names in "cols"
        comb_data <- comb_data[,cols]

# Reset the "cols" vector to include only the columns that will be used for calculating
# the mean values in the final data set
        cols<-c(grep("mean", names(comb_data), value = TRUE), 
                grep("std", names(comb_data), value = TRUE))

# Melt comb_data so that subject and activity are a unique ID that data can be grouped by 
# to calculate means. Subject type (test or train) can be included in the id that data will 
# be grouped upon without affecting calculation of means since all subjects belong to only 
# one group (test or train).
        data_melt <- melt(comb_data, id=c("subject", "activity", "subjecttype"), measure.vars=cols)

# Create the final dataset with the mean of each variable for each activity 
# by each subject given in wide format table of 180 objects of 82 variables 
        subject_means <- dcast(data_melt, subject + activity + subjecttype ~ variable,mean)

# print(str(subject_means))
        write.table(subject_means,"./subject_means.txt", row.names = FALSE)
}
