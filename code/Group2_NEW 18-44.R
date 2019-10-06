library(car)
library(leaps)
library(faraway)
library(glmnet)
library(ggplot2)
# read in the raw data
DATA = read.csv("BodyFat.csv", row.names = 1)
data = DATA
data$IDNO = 1:length(data$BODYFAT)
boxplot(data,main="boxplot of rawdata",cex.axis=0.4)      

# data cleaning 
# detect points which bodyfat does not have a linear relationship of 1 / density
#########?????????????????????????????????#########
plot(data$BODYFAT,data$DENSITY,xlab="bodayfat",ylab="density")
text(1:length(data[,1]), data$BODYFAT, 1:length(data[,1]),cex=0.5)
##########siri##########
####182,48,76,96#######
data$Bodyfat = 495*(1/data$DENSITY)-450
data$sirilabel = ifelse(abs(data$Bodyfat-data$BODYFAT)>abs(data$Bodyfat-data$BODYFAT)[5],data$IDNO,"")
plot.siri = ggplot(data = data, aes(x =IDNO,y = Bodyfat-BODYFAT, colour = factor(sirilabel)))+ geom_point()+geom_text(data = data,aes(x = IDNO,y = Bodyfat-BODYFAT,label = sirilabel))
##########BMI##########
####163???221???42#####
data$BMI=703*(data$WEIGHT/(data$HEIGHT)^2)
data$bmilabel = ifelse(abs(data$BMI-data$ADIPOSITY)>abs(data$BMI-data$ADIPOSITY)[4],data$IDNO,"")
plot.bmi = ggplot(data = data, aes(x =IDNO,y = BMI-ADIPOSITY, colour = factor(bmilabel)))+ geom_point()+geom_text(data = data,aes(x = IDNO,y = BMI-ADIPOSITY,label = bmilabel))
#we should get rid of the density 
DATA_new = DATA[, -2]
DATA_new = DATA_new[-c(182,48,76,96,163,221,42),]
########## Before removing the data points with large cook's distance##########
model0 = lm(BODYFAT ~ .,data = DATA_new)
data$cook = cooks.distance(model0)
data$cooklabel = ifelse(data$cook>0.02,data$IDNO,"")
plot.cook = ggplot(data = data, aes(x = IDNO, y = cook, colour = factor(cooklabel)))+ geom_point()+geom_text(data = data,aes(x = IDNO,y = cook,label = cooklabel))
#check the cook's distance one by one
#########cook###################     
k = 14 ###### number of variables
n = length(DATA$BODYFAT)
index = 1:n
index = index[-c(182,48,76,96,163,221,42)]
while(TRUE){
  a = qf(0.5,k,n-k)
  model1<- lm(BODYFAT ~ ., data = DATA_new)
  cook = cooks.distance(model1)
  if(sum(cook>0.5)>0){
    DATA_new = DATA_new[-which.max(cook),]
    index = index[-which.max(cook)]
    n = n-1
  }else{break}
}
out = setdiff(1:length(data$BODYFAT),index)
######cook.distance > F_0.5(k,n-k)####### 
 
#plot(model1, which = 4)
#delete the possible outliers
data[c(39, 42, 48, 96, 76, 163,182,221),]
#39 has too large weight
#42 is way too short
#48,76,96 does not match the relationship between bodyfat and density
#182 has bodyfat 0, it is a mistake.
#221,163,42 don't obey the BMI equation
data_clean = data_new[c(-39, -42, -48, -96, -76, -163,-182,-221), ]#remove some potential outliers
data_clean<-data.frame(scale(data_clean))#scale the data
write.csv(data_clean,"bodyfat_clean.csv",row.names = F)
#check the cook's distance again
model = lm(BODYFAT ~ ., data = data_clean)
#plot(model, which = 4)

#outlier test
 outlierTest(model)

# methods: Mallow's Cp, Adj-R^2, AIC, and BIC, lasso 
# AIC&BIC
full = lm(BODYFAT ~ ., data = data_clean)
base = lm(BODYFAT ~ 1, data = data_clean)
# AIC 
# backward
model_AIC_b = step(full, direction = "backward", trace = 0)
print(model_AIC_b)
summary(model_AIC_b)

# forward
model_AIC_f = step(base, direction = "forward", trace = 0,scope = list(lower = base, upper = full))
print(model_AIC_f)
#both sides
model_AIC_t = step(base, direction = "both", trace = 0, scope = list(lower = base, upper = full))
print(model_AIC_t)
# BIC
# backward
n = dim(data)[1]
model_BIC_b = step(full, direction = "backward", trace = 0, k = log(n))
print(model_BIC_b)
summary(model_BIC_b)
# forward
model_BIC_f = step(base, direction = "forward", trace = 0, scope = list(lower = base, upper = full), k = log(n))
print(model_BIC_f )

#both sides
model_BIC_t = step(full, direction = "both", trace = 0, k = log(n))
print(model_BIC_t)
summary(model_BIC_t)


# mallow's cp
X = data_clean[, -1]
Y = data_clean$BODYFAT
g = leaps(X, Y, nbest = 1)
Cpplot(g)
print(colnames(data_clean)[c(1, 3, 6, 7, 12, 14) + 1])
cp_model = BODYFAT ~ AGE + HEIGHT + CHEST + ABDOMEN +  BICEPS + WRIST
cp_lm = lm(cp_model, data=data_clean)
summary(cp_lm)
#adjusted R square
g_ad = leaps(X, Y, nbest = 1,method="adjr2")
plot(g_ad$adjr2)
(g_ad$which)[which(g_ad$adjr2==max(g_ad$adjr2)),]
Ad_r=BODYFAT~AGE+ADIPOSITY+NECK+CHEST+ABDOMEN+HIP+BICEPS+FOREARM+WRIST
adr_model<-lm(Ad_r,data=data_clean)
summary(adr_model)

#lasso
model_l <- glmnet(as.matrix(data_clean[,2:15]), data_clean$BODYFAT, family = "gaussian", nlambda = 50, alpha = 1,standardize = T)
print(model_l)
plot(model_l, xvar = "lambda", label = T)
cvfit <- cv.glmnet(as.matrix(data_clean[,2:15]), data_clean$BODYFAT, family = "gaussian", type.measure = "mse", nfolds = 10,alpha = 1)
plot(cvfit)
print(coef(cvfit, s = "lambda.1se" ))
model_lasso<- BODYFAT ~ AGE + HEIGHT  + ABDOMEN +  WRIST
model_l<-lm(BODYFAT ~ AGE + HEIGHT  + ABDOMEN +  WRIST,data=data_clean)


#check the possible multicolinearity betweeen abdomen and wrist,weight
cor(data_clean$WRIST,data_clean$ABDOMEN)
cor(data_clean$WEIGHT,data_clean$ABDOMEN)
cor(data_clean$WRIST,data_clean$WEIGHT)
vif(model_BIC_f)

#SUMMARY
print(model_AIC_b)
summary(model_AIC_b)
print(model_AIC_f)
summary(model_AIC_f)
print(model_AIC_t)
summary(model_AIC_t)

print(model_BIC_b)
summary(model_BIC_b)
print(model_BIC_f)
summary(model_BIC_f)
print(model_BIC_t)
summary(model_BIC_t)

summary(cp_lm)

summary(model_l)



#PLOTS
layout(matrix(1:4, byrow = TRUE, nrow = 2))
plot(model_AIC_b)
plot(model_AIC_f)
plot(model_AIC_t)
plot(model_BIC_b)
plot(model_BIC_f)
plot(model_BIC_t)
plot(model_l)
plot(cp_lm)
plot(model_BIC_f$residuals)
abline(h=0)
#anova 
anova(model_AIC_b,model_AIC_f,model_AIC_t,model_BIC_f,model_BIC_b,model_BIC_t,cp_lm,model_l,adr_model)
#try to use only two x.
#check the model results
data_clean = data_new[c(-39, -42, -48, -96, -76, -163,-182,-221), ]#?????????scale???
summary(lm(BODYFAT ~ ABDOMEN + WRIST, data = data_clean))
summary(lm(BODYFAT ~ ABDOMEN + WEIGHT, data = data_clean))
summary(lm(BODYFAT ~ ABDOMEN , data = data_clean))
vif(lm(BODYFAT ~ ABDOMEN + WEIGHT, data = data_clean))
vif(lm(BODYFAT ~ ABDOMEN + WRIST, data = data_clean))
#so our final model should be  BODYFAT ~ ABDOMEN +wrist

layout(1)
#plot(data_clean$ABDOMEN,data_clean$BODYFAT,xlab="Abdomen",ylab="Bodyfat",main="final model")
#abline(-38,0.617,col="red")
#plot(data_clean$BODYFAT-(0.62*data_clean$ABDOMEN-38))
final_model<-lm(BODYFAT ~ ABDOMEN + WRIST, data = data_clean)
plot(final_model,which=1)
plot(final_model,which=2)
plot(final_model,which=4)

