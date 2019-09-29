library(leaps)
library(faraway)
# read the data
data = read.csv("BodyFat.csv", row.names = 1)

# detect points which bodyfat does not have a linear relationship of 1 / density
plot(data$BODYFAT,data$DENSITY)
B = 495*(1/data$DENSITY)-450
plot(B-data$BODYFAT,xlab = 'observations', ylab = 'B-BODYFAT(%)', main = "siri's equation",type="p",cex=0.7)
text(1:length(data[,1]), B-data$BODYFAT, 1:length(data[,1]),cex=0.8)
#we should get rid of the density 
data_new = data[, -2]
model1<- lm(BODYFAT ~ AGE + WEIGHT + HEIGHT + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data)
plot(model1, which = 4)
model2<- lm(BODYFAT ~ AGE + WEIGHT + HEIGHT + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data[-42,])
plot(model2, which = 4)
model3<- lm(BODYFAT ~ AGE + WEIGHT + HEIGHT + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data[-c(39,42),])
# layout(matrix(1:3, nrow = 1, byrow = TRUE))
plot(model3, which = 4)


data_clean = data_new[c(-39, -42, -48, -96, -76, -182), ]#remove some potential outliers

# cook's distance
model = lm(BODYFAT ~ ., data = data_clean)
layout(1)
plot(model, which = 4)
# outlier test
outlierTest(model)

## methods: Mallow's Cp, Adj-R^2, AIC, and BIC 
#aic bic
# stepwise 
full = lm(BODYFAT ~ ., data = data_clean)
base = lm(BODYFAT ~ 1, data = data_clean)
# AIC 
# backward
model_AIC_b = step(full, direction = "backward", trace = 0)
print(model_AIC_b)

# forward
model_AIC_f = step(base, direction = "forward", trace = 0, 
                   scope = list(lower = base, upper = full))
print(model_AIC_f)


# BIC
# backward
n = dim(data)[1]
model_BIC_b = step(full, direction = "backward", trace = 0, k = log(n))
print(model_BIC_b)

# forward
model_BIC_f = step(base, direction = "forward", trace = 0, 
                   scope = list(lower = base, upper = full), 
                   k = log(n))
print(model_BIC_f )





#mallow's cp

X = data_clean[, -1]
Y = data_clean$BODYFAT
g = leaps(X, Y, nbest = 1)
Cpplot(g)
print(colnames(data_clean)[c(1, 3, 6, 7, 12, 14) + 1])
model_cp = BODYFAT ~ AGE + HEIGHT + CHEST + ABDOMEN +  BICEPS + WRIST



cp_model = BODYFAT ~ AGE + HEIGHT + CHEST + ABDOMEN +  BICEPS + WRIST
cp_lm = lm(cp_model, data_clean)


#adjusted R square
g_ad = leaps(X, Y, nbest = 1,method="adjr2")
plot(g_ad$adjr2)
(g_ad$which)[which(g_ad$adjr2==max(g_ad$adjr2)),]
