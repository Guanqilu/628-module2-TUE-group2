# 628module2
GUANQI LU, YI-HSUAN TSAI, HAOXIANG Wei, QIAOCHU YU  

## Raw Data  
The BodyFat.csv contains 252 observations and 16 variables,we treat the fist column(IDNO) as rownames,because it is the number of observations. 
Age (years)
Weight (lbs)
Height (inches)
Adioposity (bmi)
Neck circumference (cm) 
Chest circumference (cm)
Abdomen 2 circumference (cm) 
Hip circumference (cm) 
Thigh circumference (cm)
Knee circumference (cm)
Ankle circumference (cm)
Biceps (extended) 
circumference (cm) 
Forearm circumference (cm)
Wrist circumference (cm)  

## Code folder
The R code files are in the code folder. 
In R code:
Data cleaning:using the linear relationship between density and bodyfat, cook's distance to find out outliers. Then delete the possible outliers. Scale the variables.

Model building:
Do variable selection using the stepwise selection(AIC,BIC), Mallow's cp, and lasso.

NEXT need to be done:drawbacks and advantages of each method.
...........




