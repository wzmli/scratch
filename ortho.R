lm.fit
lmnew <- function(formula){
	mf <- model.frame(formula)
	mm <- model.matrix(mf)
	mr <- model.response(mf)
	return(lm.fit(mm, mr))
}

n <- 20
set.seed(0234)

x <- rnorm(n)
y <- rnorm(n)
z <- rnorm(n)

lmnew(z~x*y)
