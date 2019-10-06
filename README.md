# 628module2
GUANQI LU, YI-HSUAN TSAI, HAOXIANG Wei, QIAOCHU YU  

## Goal 
We try to build an easy, robust and accurate model to  predict the bodyfat.   



## Raw Data  
The BodyFat.csv contains 252 observations of male and 16 variables,we treat the fist column(IDNO) as rownames,because it is the number of observations.   
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
The R code and jupyter notebook temporary code files are in the code folder.   
### Data cleaning:  
Using the linear relationship between density and bodyfat, cook's distance to find out outliers. Then delete the possible outliers. Scale the variables.  
Here are the outliers we dropped：
39 has too large weight  
42 is way too short  
48,76,96 does not match the relationship between bodyfat and density  
182 has bodyfat 0, it is a mistake.  
We choose to just drop these outliers.  
### Model building:   
Do variable selection using the stepwise selection(AIC,BIC), Mallow's cp, ajdusted R square and lasso.   
AIC backward: BODYFAT ~ AGE + WEIGHT + HEIGHT + ADIPOSITY + NECK + 
    ABDOMEN + HIP + THIGH + FOREARM + WRIST
AIC forward/both sides:  BODYFAT ~ ABDOMEN + WEIGHT + WRIST + BICEPS
BIC forwards: BODYFAT ~ ABDOMEN + WEIGHT + WRIST  
BIC backward: BODYFAT ~ WEIGHT + ABDOMEN + WRIST 
BIC both sides: BODYFAT ~ ABDOMEN + WRIST + HEIGHT  
Mallow's cp: BODYFAT ~ AGE + HEIGHT + CHEST + ABDOMEN + BICEPS + WRIST   
Adjusted R sq: BODYFAT ~ AGE + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + BICEPS + FOREARM + WRIST  
Lasso: BODYFAT ~ AGE + HEIGHT + ABDOMEN + WRIST   
 


### model BIC_forward  is the best considering the F statistics and adjusted R square.   
 If we only use 2 variables:  
 The model is BODYFAT = 0.73*ABDOMEN  -2.03* WRIST - 11.2 
 Then we try to use just 1 independent variables.  
 The final model should be BODYFAT = 0.617*ABDOMEN  - 38  


# Shiny App (code in code folder)
https://manu200921.shinyapps.io/BodyFatCalculator/  



