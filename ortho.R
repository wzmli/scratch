n <-20
set.seed(2123)

qReduce <- function(m){
	QR <- qr(m)
	z <- QR$qr
	z <- z * (row(z) == col(z))
	return(qr.qy(QR, z))
}

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

lmnew(z~1)
om <- lmnew(z~x+y)
print(vcov(om))

# lmnew(z~x*y)

