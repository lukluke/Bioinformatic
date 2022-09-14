install.packages("SASxport") 
install.packages("ggplot2")
install.packages("dplyr")

library("SASxport")
library("dplyr")
library("ggplot2")

## Problem 1.1
setwd("/Users/luk/Downloads/EE3211_project") 
getwd()

#Diabetes <-read.xport("DIQ_J.XPT")
#Blood_Pressure_Cholesterol<-read.xport("BPQ_J.XPT")
#Body_Measures<-read.xport("BMX_J.XPT")
#Alcohol_Use <-read.xport("ALQ_J.XPT")

DIQ = read.xport("DIQ_J.XPT") 
BMX = read.xport("BMX_J.XPT") 
BPQ = read.xport("BPQ_J.XPT") 
ALQ = read.xport("ALQ_J.XPT") 

DIQ = DIQ[,c("SEQN","DIQ010")] 
BMX = BMX[,c("SEQN","BMXWT","BMXHT","BMXBMI","BMXWAIST","BMXHIP")] 
BPQ = BPQ[,c("SEQN","BPQ020","BPQ080")] 
ALQ = ALQ[,c("SEQN","ALQ290","ALQ130")] 


## Problem 1.2
CombineData = merge(DIQ, BMX, by="SEQN") 
CombineData2 = merge(BPQ, ALQ, by="SEQN") 
Matrix = merge(CombineData, CombineData2, by="SEQN") 
Matrix =na.omit(Matrix) 
summary(Matrix) 


## Problem 2,1
Matrix[,2]<-ifelse(Matrix [,2]=="1",1,ifelse(Matrix [,2]=="2",0,ifelse(Matrix [,2]=="3",NA,ifelse(Matrix [,2]=="7",NA,ifelse(Matrix [,2]=="9",NA,NA)))))

#Remove NA values
Matrix<-Matrix[!(is.na(Matrix$DIQ010)),]



## Problem 2.2
Matrix$overweight = ifelse(Matrix$BMXBMI >30, "1", "0") 
Matrix$BMXHT = Matrix$BMXHT/100 
model = lm(Matrix$BMXBMI~Matrix$BMXWT/(Matrix$BMXHT^2)) 
summary(model) 
model = cor.test(Matrix$BMXBMI,Matrix$BMXHT) 
model

#hbmi<-cor.test(omit_missing_value$BMXHT,omit_missing_value$BMXBMI,method="pearson")
#hbmi

## Problem 2.3



Matrix$DIQ010 = factor(Matrix$DIQ010)
Matrix$overweight = factor(Matrix$overweight)

class(Matrix$DIQ010)
class(Matrix$overweight)
## Problem 2.4
summary(Matrix)

## Problem 3.1
logistic<-glm(DIQ010~BMXHT+BMXWAIST+BPQ020,data=Matrix,family="binomial")
summary(logistic)

## Problem 3.2
model = glm(formula = DIQ010~overweight+BPQ080+ALQ130, data = Matrix, family = binomial(link=logit)) 
summary(model)

## Problem 3.3
boxplot(BMXBMI~DIQ010,main="Result of Regression Test", ylab="bmi", xlab= "diabetes", col="yellow",data = Matrix)

## Problem 3.4
#3.4	Select the samples with diabetes
ggplot(na.omit(Matrix),aes(na.omit(Matrix)$BMXWT))+geom_density()+labs(title="Distribution of body weight",x="weight in kg")

ggplot(data=na.omit(Matrix),aes(na.omit(Matrix)$BMXBMI))+geom_histogram(breaks=seq(14, 65, by = 2),col="blue",fill="yellow", alpha = .2) + labs(title="Histogram for bmi") +labs(x="bmi", y="value")

