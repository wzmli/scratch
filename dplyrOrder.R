library(dplyr)

options(stringsAsFactors=FALSE)  

set.seed=101
x <- rnorm(10)
y <- rnorm(10)
z <- rnorm(10)
a <- rnorm(10)

df <- data.frame(x,y,z,a)

se <- function(dframe){
  tempdat <- data.frame(variable=c("y","a","x","z"))
  print(tempdat)
  tempdat2 <- tempdat %>% rowwise() %>% mutate(dplyrSD=sd(dframe[,variable]))
  return(tempdat2)
}

dplyrSE <- se(df)
cbind(dplyrSE
      , SD=c(sd(y),sd(a),sd(x),sd(z))
      , what_I_want_dplyr_to_do=c(sd(df[,"y"]),sd(df[,"a"]),sd(df[,"x"]),sd(df[,"z"]))
)

