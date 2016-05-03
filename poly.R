set.seed(29111)
reps <- 20

x <- rnorm(reps)
y <- x^2

nsq <- function(n){
	return(n/sqrt(sum(n^2)))
}

xhat <- nsq(x - mean(x))

yhat <- nsq(y - sum(xhat*y)*xhat - mean(y))

print(sum(xhat*yhat))

print(data.frame(xhat, yhat))
print(poly(x, 2))
