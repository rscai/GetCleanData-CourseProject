CodeBook
========================================================

Variables
-------------------------------------------------------
**features** data frame of features.txt

**X_train** data frame of X_train.txt

**y_train** data frame of y_train.txt

**subject_train** data frame of subject_train.txt

**train** megered data frame of **X_train**, **y_train** and **subject_train** with **features**

**X_test** data frame of X_test.txt

**y_test** data frame of y_test.txt

**subject_test** data frame of subject_test.txt

**test** megered data frame of **X_test**, **y_test** and **subject_test** with **features**

**datset** merged data frame of **train** and **test**

**activityLabels** data frame of activity_labels.txt

**extractData** data frame which takes all mean and std measurements, with activity labels

**tidyData**  tidy data set with the average of each variable for each activity and each subject

Transform
-------------------
1.merge X_train,y_train and subject_train, remove rowname column
```{r}
train<-merge(y_train,X_train,by=0)
train<-merge(subject_train,train,by=0)
train<-train[,c(2,4:565)]
```

2.merge X_test,y_test and subject_test, remove rownmaes column
```{r}
test<-merge(y_test,X_test,by=0)
test<-merge(subject_test,test,by=0)
test<-test[,c(2,4:565)]
```

3.merge train data and test data
```{r}
dataset<-rbind(train,test)
```

4.extract only the measurements on the mean and standard deviation for each measurement
```{r}
colnames(dataset)[c(1,2)]<-c("subject","activityCode")
extractCols<-grepl("mean|std",colnames(dataset))
extractCols[1]<-TRUE
extractCols[2]<-TRUE
extractData<-dataset[,extractCols]
```

5.merge activity labels
```[r]
activityLabels<-read.csv("activity_labels.txt",header=FALSE,sep="")
colnames(activityLabels)<-c("activityCode","label")


# merge label and extract data
x<-merge(activityLabels,extractData,by=c("activityCode"))

# remove column activityCode
extractData<-x[,!grepl("activityCode",colnames(x))]
```

6.calculate the average of each variable for each activity and each subject
```{r}
tidyData<-aggregate(extractData[,c(3:ncol(extractData))],by=list(subject=extractData$subject,label=extractData$label),mean)
```