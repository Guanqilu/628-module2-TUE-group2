# 628module2
GUANQI LU, YI-HSUAN TSAI, HAOXIANG Wei, QIAOCHU YU  

## Goal 
We try to build an easy, robust and accurate model to  predict the bodyfat.   



## Raw Data  
The BodyFat.csv contains 252 observations and 16 variables,we treat the fist column(IDNO) as rownames,because it is the number of observations.   
Density
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
### Data cleaning:  
Using the linear relationship between density and bodyfat, cook's distance to find out outliers. Then delete the possible outliers. Scale the variables.  
Here are the outliers we dropped：
39 has too large weight  
42 is way too short  
48,76,96 does not match the relationship between bodyfat and density  
182 has bodyfat 0, it is a mistake.  
We choose to just drop these outliers.  
### Model building:   
Do variable selection using the stepwise selection(AIC,BIC), Mallow's cp, and lasso.   
AIC backward: BODYFAT ~ AGE + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + BICEPS + 
    WRIST  
AIC forward/both sides: BODYFAT ~ ABDOMEN + WEIGHT + WRIST + BICEPS  
BIC forwards: BODYFAT ~ ABDOMEN + WEIGHT + WRIST  
BIC backward: BODYFAT ~ AGE + ABDOMEN + WRIST  
BIC both sides: BODYFAT ~ ABDOMEN + WRIST + HEIGHT  
Mallow's cp: BODYFAT ~ AGE + HEIGHT + CHEST + ABDOMEN + BICEPS + WRIST  
Lasso: BODYFAT ~ AGE + HEIGHT + ABDOMEN + WRIST   

NEED TO DO NEXT----PLOTS  


### model BIC_forward  is the best considering the F statistics and adjusted R square. 
 Then we try to use just 1 independent variables.
 The final model should be BODYFAT = 0.62*ABDOMEN  - 38





