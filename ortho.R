n <-20
set.seed(2123)

lmnew <- function(formula){
	mf <- model.frame(formula)
	mm <- model.matrix(mf)
	mr <- model.response(mf)
	mfit <- lm.fit(mm, mr)
	mfit$call <- match.call()
	class(mfit) <- "lm"
	mfit$terms <- terms(mf)
	return(mfit)
}

x <- rnorm(n)
y <- rnorm(n)
z <- rnorm(n)

lm(z~x*y)
lmnew(z~x*y)

