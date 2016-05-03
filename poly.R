set.seed(29111)
reps <- 20

x <- rnorm(reps)
y <- x^2

nsq <- function(n){
	return(n/sqrt(mean(n^2)))
}

xhat <- nsq(x - mean(x))

yhat <- nsq(y - mean(xhat*y)*xhat - mean(y))

print(sum(xhat*yhat))

print(data.frame(xhat/sqrt(reps), yhat/sqrt(reps)))
print(poly(x, 2))
