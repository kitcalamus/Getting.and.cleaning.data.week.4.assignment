##Load, merge and rename test columns
Xtest<- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest<- read.table("./UCI HAR Dataset/test/y_test.txt")
Subject<- read.table("./UCI HAR Dataset/test/subject_test.txt")
feature<- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)
featureV<- feature[,2]
test<- cbind(Subject,Ytest,Xtest)
colnames(test)<- c("Subject","Activity",featureV)

##load, merge and rename training columns
Xtrain<- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain<- read.table("./UCI HAR Dataset/train/y_train.txt")
Subject<- read.table("./UCI HAR Dataset/train/subject_train.txt")
feature<- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)
featureV<- feature[,2]
train<- cbind(Subject,Ytrain,Xtrain)
colnames(train)<- c("Subject","Activity",featureV)

set<- rbind(test,train) ##merged test and training dataset

interested.variables<- set[,grepl("mean\\(\\)|std\\(\\)|Activity|Subject",colnames(set))] ##Extract Activity, Subject, mean and std. only.


activity_labels<- read.table("./UCI HAR Dataset/activity_labels.txt")

interested.variables$Activity <- factor(interested.variables$Activity,levels = activity_labels[,1],labels = activity_labels[,2]) ##apply the activities name to activities

##rename the variables to a much descriptive names
names(interested.variables)<- gsub("[\\(\\)-]", "", names(interested.variables))
names(interested.variables)<- gsub("mean", "Mean", names(interested.variables))
names(interested.variables)<- gsub("Freq", "Frequency", names(interested.variables))
names(interested.variables)<- gsub("std", "StandardDeviation", names(interested.variables))
##create a new dataset, that calculates mean for each activity and subject
tidydata<- aggregate(interested.variables[,3:68], list(interested.variables$Subject, interested.variables$Activity), mean)
colnames(tidydata)[1] <- "Subject" #Rename column name to Subject
colnames(tidydata)[2] <- "Activity" #Rename column name to Activity
write.table(tidydata, file = "tidydata.txt",col.names = TRUE) #Create independent dataset