library(DynTxRegime)
# function to create bmiDataOne based on bmiData

createBmiDataOne <- function(x, y){
  #----------------------------------------------------#
  # load bmiData
  #----------------------------------------------------#
  data(bmiData) #load
  
  #----------------------------------------------------#
  # drop second stage variables
  #----------------------------------------------------#
  drops <- c("month12BMI", "A2")
  bmiDataOne <- bmiData[, !(names(bmiData) %in% drops)]
  
  #----------------------------------------------------#
  # Recast treatment variables to (0,1), MR = 1, CD=0
  # L is very important for integer
  #----------------------------------------------------#
  bmiDataOne$A1[which(bmiDataOne$A=="MR")] <- 1L
  bmiDataOne$A1[which(bmiDataOne$A=="CD")] <- 0L
  bmiDataOne$A1 <- as.integer(bmiDataOne$A)
  
  #----------------------------------------------------#
  # define response y to be the negative 4 month
  # change in BMI from baseline 
  #----------------------------------------------------#
  bmiDataOne$y <- -100*(bmiDataOne$month4BMI - bmiDataOne$baselineBMI)/bmiDataOne$baselineBMI
  return(bmiDataOne)
}