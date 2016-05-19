qpfun <- function(P){
	return(c(P/2, 1/2, 1-P/2))
}

# Scaled sinh function is meant to be smooth as scale goes through 0
ssh <- function(x, s){
	if (s==0) return(x)
	return(sinh(s*x)/s)
}

assh <- function(x, s){
	if (s==0) return(x)
	return(asinh(s*x)/s)
}

## A weight function takes a vector of three quantiles and computes the ratio between the two sides
wtfun <- function(v){
	if(length(v) != 3){
		stop(paste("v is supposed to have length 3 in wtfun", length(v)))
	}

## The weight of a scaled Johnson function constrained so that mu_N*sig_N=1
## given quantile values
jsqwt <- function(phi, q, root=0){
	return(wtfun(ssh(q-phi, phi))-root)
}

## Find the parameter for the desired weight of a constrained Johnson function
## given quantile probabilities
jsqphi <- function(wt, P=0.1, phiRange=c(-10, 10)){
	qp <- qpfun(P)
	qq <- qnorm(qp)
	return(uniroot(jsqwt, phiRange, q=qq, root=wt)$root)
}

## Transform a normal deviate to a Johnson deviate
jsqfun <- function(q, phi, eps=0, lam=1){
	return(ssh(q-phi, phi)*lam+eps)
}

## A wrapper for jsqfun that allows a list of parameters)
jsqpfun <- function(q, pars){
	with(pars, return(jsqfun(q, phi, eps, lam)))
}

## Transform a Johnson to a normal deviate 
ajsqfun <- function(q, phi, eps=0, lam=1){
	return(assh((q-eps)/lam, phi)+phi)
}
ajsqpfun <- function(q, pars){
	with(pars, return(ajsqfun(q, phi, eps, lam)))
}

jsqpar <- function(q, P=0.1, phiRange=c(-10, 10)){
	wt <- wtfun(q)
	qp <- qpfun(P)
	z <- qnorm(qp)
	phi <- jsqphi(wt, P, phiRange)
	q0 <- jsqfun(z, phi)
	lam <- sd(q)/sd(q0)
	eps <- mean(q)-lam*mean(q0)
	return(list(eps=eps, lam=lam, phi=phi))
}

pars <- jsqpar(q=c(1, 2, 5))

print(jsqpfun(qnorm(qpfun(0.1)), pars))

ajsqpfun(c(1, 2, 5), pars)
