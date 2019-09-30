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
### Data cleaning:  
Using the linear relationship between density and bodyfat, cook's distance to find out outliers. Then delete the possible outliers. Scale the variables.  
Here are the outliers we dropped：
39 has too large weight  
42 is way too short  
48,76,96 does not match the relationship between bodyfat and density  
182 has bodyfat 0, it is a mistake.  

### Model building:   
Do variable selection using the stepwise selection(AIC,BIC), Mallow's cp, and lasso.   
AIC backward: BODYFAT ~ AGE + ADIPOSITY + NECK + CHEST + ABDOMEN + HIP + BICEPS + 
    WRIST  
AIC forward/both sides: BODYFAT ~ ABDOMEN + WEIGHT + WRIST + BICEPS  
BIC backwards: BODYFAT ~ ABDOMEN + WEIGHT + WRIST  
BIC forward: BODYFAT ~ AGE + ABDOMEN + WRIST  
BIC both sides: BODYFAT ~ ABDOMEN + WRIST + HEIGHT  
Mallow's cp: BODYFAT ~ AGE + HEIGHT + CHEST + ABDOMEN + BICEPS + WRIST  
Lasso: BODYFAT ~ AGE + HEIGHT + ABDOMEN + WRIST   



NEXT need to be done:drawbacks and advantages of each method.   
...........
### model BIC_forward
Call:
lm(formula = BODYFAT ~ ABDOMEN + WEIGHT + WRIST, data = data_clean)

Residuals:
    Min      1Q  Median      3Q     Max 
-9.0083 -2.9089 -0.4031  3.0037  9.2038 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) -23.62403    6.26031  -3.774 0.000202 ***
ABDOMEN       0.88190    0.05130  17.190  < 2e-16 ***
WEIGHT       -0.08457    0.02243  -3.770 0.000205 ***
WRIST        -1.30939    0.40579  -3.227 0.001425 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.976 on 242 degrees of freedom
Multiple R-squared:  0.7302,	Adjusted R-squared:  0.7268 
F-statistic: 218.3 on 3 and 242 DF,  p-value: < 2.2e-16



