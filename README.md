# Getting Data Week 4 Assignment

## Sections

* Assignment Overview
* Raw Data Overview
* Steps to Complete Assignment
* Downloading, Organizing and Understanding the Raw Data
* Assembling the Datasets

## Assignment Overview 

The purpose of this assignement was to download data from the Human Activity Recognition Using Smartphones Dataset and successfully perform the following taks:

1) Merge the training and the test sets to create one data set.
2) Extract only the measurements on the mean and standard deviation for each measurement.
3) Use descriptive activity names to name the activities in the data set
4) Appropriately label the data set with descriptive variable names.
5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

The script to perform all the data manilupation and creation of the final tidy dataset can be performed with the function createTideData() located within the file run_analysis.R. Furthermore, in the submission instructions, we were told that the script should be written so that the final tidy dataset in item #5 above could be produced given that the original datafiles were located within the reviewer's working directory. I have added an optional function loadRawData() in the separate scriptt file "run_analysis_(files_download).R" that the reviewer can choose to run if the files are not in the working directory. I chose not to include this in the primary script  (run_analysis.R) because I did not want to automate the potential download and manipulation of files on another person's system and because downloading the original data was not part of the assignment requirements for the script.

## Raw Data Overview

The original compressed data used for the assignment can be found here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

<strong>About the Raw Data</strong>

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

The data for this project comes from the Human Activity Recognition Using Smartphones Dataset that is subject to the following license:
License:

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

We know from the README.txt file that accompanied the source data that the dataset includes the following files:

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features. These will become the source for variable names in the final dataset.

- 'activity_labels.txt': This identifies the specific activity (e.g., WALKING, SITTING, STANDING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS, LAYING) with the integer IDs used in the y_train.txt and t_test.txt files.

- 'train/X_train.txt': Training set that has the data for each observation window for the given subject and activity.

- 'train/y_train.txt': Training labels that identify the subject's activity by activity ID for that observation window. These will need to be converted to descriptive labels ((WALKING, SITTING, etc.) in the final dataset.

- 'test/X_test.txt': Test set that has the data for each observation window for the given subject and activity.

- 'test/y_test.txt': Test labels that identify the subject's activity by activity ID for that observation window. These will need to be converted to descriptive labels ((WALKING, SITTING, etc.) in the final dataset.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt' and 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. This data will need to be combined with the respective y_test and y_train data so that the subject and activity are known for each observation window. Furthermore, an identifying variable will need to be added so that "test" and "train" subjects can be identified in the final dataset.

The following raw data files were not used to complete the assignment:

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## Steps to Complete Assignment

### Downloading, Organizing and Understanding the Raw Data

Download, unzip and move data files into current working directory. I chose to keep the directory structure that placed the data in "/UCI HAR Dataset", with subdirectories "/test" and "/train". However, my script is written to search for the required files in both the directory structure above and in the parent working directory. The steps I used included the following:

* store the tempfile name in "temp" before downloading data
* download the .zip file containing the raw data to temp
* unzip the compressed files to "data"
* print "data" to confirm the file names and locations
		
The files were read into the following objects:

	activity_labels <- "activity_labels.txt"
	features <- "features.txt"
	subject_test <- "subject_test.txt"
	x_test <- X_test.txt
	y_test <- "y_test.txt"
	subject_train <- "subject_train.txt"
	x_train <- "X_train.txt"
	y_train <- "y_train.txt"

Reading the tables into R and using the dim() function to understand the basic structure, gives the following results:

	> print(dim(activity_labels))
	[1] 6 2
	> print(dim(features))
	[1] 561   2
	> print(dim(subject_test))
	[1] 2947    1
	> print(dim(x_test))
	[1] 2947  561
	> print(dim(y_test))
	[1] 2947    1
	> print(dim(subject_train))
	[1] 7352    1
	> print(dim(x_train))
	[1] 7352  561
	> print(dim(y_train))
	[1] 7352    1
		
We know from the features.txt and features_info.txt files that these are the 561 variables that were measured for each observation. These will thus become variable (or column) names in our tidy datasets. 

str(x_test) and str(x_train) show that both are data.frames with 561 variables, which will use the values in features.txt as column names

We know that the 30 subjects were split into test and train groups (70% train, 30% test or 21 train, 9 test) and that they are identified for each observations in subject_test.txt and subject_train.txt (from the original README.txt file accompanying the raw data). We can test that these files contain the correct number of unique subjects in the following manner:

	> length(unique(subject_train)[[1]])
	[1] 21
	> length(unique(subject_test)[[1]])
	[1] 9 
	
We see by this that both subject_train and subject_test	hold the correct number of unique subjects. 

Likewise, we can test y_test and y_train, which shows they include 6 uniques activities each, which will be a variable in the final data set using descriptive labels.

	> length(unique(y_test)[[1]])
	[1] 6
	> length(unique(y_train)[[1]])
	[1] 6

We can now start to assemble our combined datasets. We will first assemble two separate datasets, one for test and one for train, that will be identical in structure and will contain all the data for each respective dataset.

The column structure will be:

	"subject", "subjecttype", "activity", "feature1", "feature2",..."feature561"
	
Where:
	
  * subject = the individual subject being monitored
  * subjecttype = test or train subject group
  * activity = what the subject was doing at the time of observation (walking, sitting, standing, laying, walking upstair, walking downstairs)
 * feature1, feature2...feature 561 = the observation measurement variables
 
	
Once the separate datasets are assembled, we will:

* combine the two into a combined test/train dataset
* extract only those values representing mean and standard deviation into a tidy dataset
* create a new tidy dataset onsisting of the means of the results from the previous tidy dataset for each subject and activity.
	
### Assembling the Datasets

The R script "run_analysis.R" includes the function createTidyData(), which will read the raw data into R, assemble the intermediate and final tidy datasets and write the final dataset to "subject_means.txt" in the users working directory. An optional function, loadRawData() is located in a separate script file, run_analysis_(files_download).R is provided in the event the user wishes to automate download of the raw data into the working directory. It is provided strictly as a convenience for the user, but is unncessary if the raw data files exist in the user's working directory.

1) Add the column names in "features" to x_test and x_train:
<pre>
	colnames(x_test) <- features[[2]]
	colnames(x_train) <- features[[2]]

	The observation data now includes descriptive variable names
</pre>		
2)  Add column name "activity" to y_train and and y_test, which contain the activity ID variable, to conform to tidy data standards by giving a descriptive name to the variable:
<pre>
	colnames(y_test) <- "activity"
	colnames(y_train) <- "activity"
		
	The activity column now has a descriptive variable name
</pre>	
3) Add column name "subject" to subject_test and subject_train to conform to tidy data standards by giving a descriptive name to the variable:
<pre>	
	colnames(subject_test) <- "subject"
	colnames(subject_train) <- "subject" 
	
	The column identifying the subjects now has a descriptive variable name		
</pre>		
4) Add "subjecttype" column with "test" or "train" flag to identify subjects as test or train subjects so they can be properly identified in the combined data set. This must be done before the datasets are combined and can be done using the mutate() function:
<pre>
	subject_test <- mutate(subject_test, subjecttype="test")
	subject_train <- mutate(subject_train, subjecttype="train")
	
	The subject objects now include a column to identify which group the subject 
	was in (test or train) and the column includes a descriptive variable name ("subjecttype")
</pre>
5)  Bind subject_test and subject_train columns to y_test and y_train so that the subject and the activity (walking, sitting, etc) are matched for each row of observations
<pre>
	y_test <- cbind(subject_test, y_test)
	y_train <- cbind(subject_train, y_train)
	
	Each acivity objects (y_train, y_test) objects now include subject data. 
	The columns in these objects are ""subject", "subjecttype", "activity"
</pre>	
6)  Bind columns in x_test and x_train data to y_test and y_train combine subject, subjecttype, activity and data results
<pre>		
	test_data <- cbind(y_test, x_test)
	train_data <- cbind(y_train, x_train)
	
	The test_data and train_data objects are data.frames with the following column structures: 
	"subject", "subjecttype", "activity", "feature1", "feature2",..."feature561"
</pre>
7)  Combine test and train data into single dataset using rbind(). 
<pre>	
	comb_data <- rbind(train_data, test_data)
</pre>

8)  Now that all the data is in a single dataset we can change activity from an integer ID to an activity description. We did not do this earlier because changing the activity as a standalone variable could have affected the order of the data, leading to incorrect matching as objects were combined. We will use the mapvalues() function that updates a value based upon the existing value, with the ability to update a numeric to a character value. In this case, 1="WALKING", 2="WALKING_UPSTAIRS"...6="LAYING"
<pre>
	comb_data$activity <- mapvalues(comb_data$activity,                   
				c(1, 2, 3, 4, 5, 6),
				c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
</pre>
9)  Create a vector of column names to be used to subset the full data set to desired data consisting only of mean and standard deviation values.
	Note: only variables with lower case "mean" are being extracted because examination of the data and features descriptions show they are results that are a mean() value. Those with an uppercase "Mean" are results that use a mean value to calculate another value (e.g., an angle based upon a mean) and thus, are not true means. We have chosen to include meanFreq() because it is a measure of a mean value. It is easier for the end user of the data to disregard this value if not needed than it is to use it if it is not included, therefore the ambiguity of the request suggests it is better to include it. We create an object ("cols") that will be used to subset the data as desired:
<pre>	
	cols<-c("subject","subjecttype","activity",
		grep("mean", names(comb_data), value = TRUE), 
		grep("std", names(comb_data), value = TRUE))
				
		length(cols) == 82, which is how many variables should be extracted for our final dataset
</pre>
10) Use the cols vector created above to subset the desired data based upon the column names in "cols"
	comb_data <- comb_data[,cols]
		
	This produces a tidy dataset of the desired combined data
<pre>	
	> str(comb_data)
	'data.frame':	10299 obs. of  82 variables:
	 $ subject                        : int  1 1 1 1 1 1 1 1 1 1 ...
	 $ subjecttype                    : chr  "train" "train" "train" "train" ...
	 $ activity                       : chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
	 $ tBodyAcc-mean()-X              : num  0.289 0.278 0.28 0.279 0.277 ...
	 $ tBodyAcc-mean()-Y              : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
	 $ tBodyAcc-mean()-Z              : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
		 ...
	 $ feature79 ....
</pre>		 
	This dataset includes 82 variables, which include "subject", "subjecttype", "activity" and 
	the 79 variables, which is what we expected using "cols"
	
11) We now need to group the data by subject and activity, while maintaining the ability to
identify a subject as test or train (this was not specified in the instructions, but we will 
do so in case the end user wishes to have that information available. Including it does not 
impact the resulting data.

	Reset the "cols" vector to include only the columns that will be used for calculating the mean values in the final data set

		cols<-c(grep("mean", names(comb_data), value = TRUE), 
			grep("std", names(comb_data), value = TRUE))
	
	Melt comb_data so that subject and activity are a unique ID that data can be grouped by 
	to calculate means. Subject type (test or train) can be included in the id that data will 
	be grouped upon without affecting calculation of means since each subject belongs to only 
	one group (test or train).
	
		data_melt <- melt(comb_data, id=c("subject", "activity", "subjecttype"), measure.vars=cols)

	Create the final dataset with the mean of each variable for each activity by each subject 
	given in wide format with 180 objects of 82 variables that include subject, activity, 
	subjecttype (test or train) and the means of 79 measured variables):

	
		subject_means <- dcast(data_melt, subject + activity + subjecttype ~ variable,mean)
			
		dim(subject_means) should result in a table of 180 objects of 82 variables 
		(30 subjects x 6 acitivities each = 180 observations):
		> dim(subject_means)
		[1] 180  82`
		

	Check to see if the data is tidy. The dataset includes descriptive variable names, 
	descriptive row lables ("LAYING", "SITTING" and "test", "train") and includes a single type 
	of observation per variable.
	
		
		str(subject_means)
		
		 data.frame':	180 obs. of  82 variables:  
		 $ subject                        : int  1 1 1 1 1 1 2 2 2 2 ...  
		 $ activity                       : chr  "LAYING" "SITTING" "STANDING" "WALKING" ...  
		 $ subjecttype                    : chr  "train" "train" "train" "train" ...  
		 $ tBodyAcc-mean()-X              : num  0.222 0.261 0.279 0.277 0.289 ...  
		 $ tBodyAcc-mean()-Y              : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...  
	
12) Finally, we write the resulting dataset to the file "subject_means.txt"
	
	`write.table(subject_means,"./subject_means.txt", row.names = FALSE)`
	
Reviewing the requirements for this assignment, we can confirm whether they have been successfully fulfilled:

1) Merge the training and the test sets to create one data set. 
2) Extract only the measurements on the mean and standard deviation for each measurement.
3) Use descriptive activity names to name the activities in the data set
4) Appropriately label the data set with descriptive variable names.
5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.		
	
