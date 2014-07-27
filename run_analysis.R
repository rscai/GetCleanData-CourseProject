# read feature list
features<-read.csv(file="features.txt",header=FALSE,sep=" ")
# read data of train
X_train<-read.csv(file="train/X_train.txt",header=FALSE,sep="")
# merge feature name
colnames(X_train)<-features[,2]
y_train<-read.csv(file="train/y_train.txt",header=FALSE,sep="")
subject_train<-read.csv(file="train/subject_train.txt",header=FALSE,sep="")

# merge train data
train<-merge(y_train,X_train,by=0)
train<-merge(subject_train,train,by=0)
train<-train[,c(2,4:565)]

# read data of test
X_test<-read.csv(file="test/X_test.txt",header=FALSE,sep="")
#merge feature name
colnames(X_test)<-features[,2]
y_test<-read.csv(file="test/y_test.txt",header=FALSE,sep="")
subject_test<-read.csv(file="test/subject_test.txt",header=FALSE,sep="")

# merge test data
test<-merge(y_test,X_test,by=0)
test<-merge(subject_test,test,by=0)
test<-test[,c(2,4:565)]

# merge data of train and test
dataset<-rbind(train,test)
# add column names for subject and activityCode
colnames(dataset)[c(1,2)]<-c("subject","activityCode")
extractCols<-grepl("mean|std",colnames(dataset))
extractCols[1]<-TRUE
extractCols[2]<-TRUE
extractData<-dataset[,extractCols]


activityLabels<-read.csv("activity_labels.txt",header=FALSE,sep="")
colnames(activityLabels)<-c("activityCode","label")


# merge label and extract data
x<-merge(activityLabels,extractData,by=c("activityCode"))

# remove column activityCode
extractData<-x[,!grepl("activityCode",colnames(x))]

# calculate average for all variables

tidyData<-aggregate(extractData[,c(3:ncol(extractData))],by=list(subject=extractData$subject,label=extractData$label),mean)

# write tidyDat to file
write.csv(tidyData,file="tidy.csv",row.names=FALSE)
