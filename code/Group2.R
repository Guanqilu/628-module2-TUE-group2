library(car)
library(leaps)
library(faraway)
library(glmnet)
# read in the raw data
data = read.csv("BodyFat.csv", row.names = 1)
# data cleaning 
# detect points which bodyfat does not have a linear relationship of 1 / density
plot(data$BODYFAT,data$DENSITY)
B = 495*(1/data$DENSITY)-450
plot(B-data$BODYFAT,xlab = 'observations', ylab = 'B-BODYFAT(%)', main = "siri's equation",type="p",cex=0.7)
text(1:length(data[,1]), B-data$BODYFAT, 1:length(data[,1]),cex=0.8)
#we should get rid of the density 
data_new = data[, -2]
#check the cook's distance one by one
model1<- lm(BODYFAT ~ AGE + WEIGHT + HEIGHT + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data)
plot(model1, which = 4)
model2<- lm(BODYFAT ~ AGE + WEIGHT + HEIGHT + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data[-42,])
plot(model2, which = 4)
model3<- lm(BODYFAT ~ AGE + WEIGHT + HEIGHT + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data[-c(39,42),])
plot(model3, which = 4)
#delete the possible outliers
data_clean = data_new[c(-39, -42, -48, -96, -76, -182), ]#remove some potential outliers
data_clean<-data.frame(scale(data_clean))#scale the data
write.csv(data_clean,"bodyfat_clean.csv",row.names = F)
#check the cook's distance again
model = lm(BODYFAT ~ ., data = data_clean)
plot(model, which = 4)
#let's look at the 221 person
data_clean[221,]#nothing wierd
# outlier test
# outlierTest(model)

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
#check the model results
summary(model_BIC_f)
summary(lm(BODYFAT ~ ABDOMEN + WRIST, data = data_clean))
summary(lm(BODYFAT ~ ABDOMEN + WEIGHT, data = data_clean))
summary(lm(BODYFAT ~ ABDOMEN , data = data_clean))
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
cp_lm = lm(cp_model, data_clean)
summary(cp_lm)
#adjusted R square
g_ad = leaps(X, Y, nbest = 1,method="adjr2")
plot(g_ad$adjr2)
(g_ad$which)[which(g_ad$adjr2==max(g_ad$adjr2)),]


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
summary(model_AIC_f)
print(model_BIC_t)
summary(model_AIC_t)

summary(cp_lm)

summary(model_l)
