# coursera
# getting and cleaning data week 4
# weekly project

#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl,destfile="./Dataset.zip")

# Unzip dataSet to /data directory
#unzip(zipfile="Dataset.zip",exdir=".")

# Read train tables:
x_trn <- read.table("./train/X_train.txt")
y_trn <- read.table("./train/y_train.txt")
subj_trn <- read.table("./train/subject_train.txt")

# Read test tables:
x_tst <- read.table("./test/X_test.txt")
y_tst <- read.table("./test/y_test.txt")
subj_tst <- read.table("./test/subject_test.txt")

# Read feature vector:
features <- read.table('./features.txt')

# Reading activity labels:
activities = read.table('./activity_labels.txt')

#add the labels to the columns 
colnames(x_trn) <- features[,2] 
colnames(y_trn) <-"activityNo"
colnames(subj_trn) <- "subjectNo"
colnames(x_tst) <- features[,2] 
colnames(y_tst) <- "activityNo"
colnames(subj_tst) <- "subjectNo"
colnames(activities) <- c('activityNo','activityType')

#PART 1:  merge all the files together into one
train <- cbind(y_trn, subj_trn, x_trn)
test <- cbind(y_tst, subj_tst, x_tst)
everything <- rbind(train, test)

#PART 2: here we need to extract column that represent the mean or 
#standard deviation of an observation types
#start by putting all the column names in the variable header
header<-colnames(everything)
#now look for those names that contain "mean()" or "std()"
#pipe the greps together to simplify the code; 
#meanFreq(), the mean 
#of the frequency of certain observations, is o.k. as it satisfies
#the loose guidelines of the question

mean_std<-grepl("activityNo",header) | grepl("subjectNo" , header) |
          grepl("mean()" , header) | grepl("std()" , header) 

#now extract the columns that we identified above
dfmeanstd<-everything[,mean_std==TRUE]

#Part 3 and 4:  Uses descriptive activity names to name the activities in the data set
#we can do this using the merge() command where the column merged on is
#the activityNo column
dfmeanstdwlables<-merge(dfmeanstd,activities,by='activityNo')

#output the column names to use in the code book
header2<-colnames(dfmeanstdwlables)
write.table(header2,file ="headers")

#Part 5:  Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
tidy <- aggregate(. ~subjectNo + activityNo, dfmeanstdwlables, mean)
write.table(tidy, "tidy.txt", row.name=FALSE)
