n <-20
set.seed(2123)

lmnew <- function(formula){
	mf <- model.frame(formula)
	mt <- attr(mf, "terms")
	mm <- model.matrix(mt, mf)
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

lm(z~poly(x, 2))
lmnew(z~poly(x, degree=2))

