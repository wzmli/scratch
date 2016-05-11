library(dplyr)

a <- (1:10)
b <- (1:10)
c <- (1:10)
d1 <- 10
d2 <- 0.1

test = function(a,b,c){
	return(rbinom(a*b*c, size=d1, prob=d2))
}

test(3, 3, 3)


binf <- (data.frame(a, b, c)
	%>% rowwise()
	%>% mutate(rb <- test(a, b, c))
)


