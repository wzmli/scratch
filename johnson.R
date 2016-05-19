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

## Take a vector of three quantiles and computes the "weight" – the ratio between the two sides
wtfun <- function(v){
	if(length(v) != 3){
		stop(paste("v is supposed to have length 3 in wtfun", length(v)))
	}
	return((v[[3]]-v[[2]])/(v[[2]]-v[[1]]))
}

## Weight of a constrained Johnson distribution (for calling by uniroot)
jsqwt <- function(phi, q, root=0){
	return(wtfun(ssh(q+phi, phi))-root)
}

jsqphi <- function(wt, P=0.1, phiRange=c(-10, 10)){
	qp <- qpfun(P)
	qq <- qnorm(qp)
	return(uniroot(jsqwt, phiRange, q=qq, root=wt)$root)
}

## Transform a normal deviate to a Johnson deviate
jsqfun <- function(z, phi, eps=0, lam=1, pars=NULL){
	if (!is.null(pars)) return(jsqfun(z, pars$phi, pars$eps, pars$lam))
	return(ssh(z+phi, phi)*lam+eps)
}

## Transform a Johnson to a normal deviate 
ajsqfun <- function(j, phi, eps=0, lam=1, pars=NULL){
	if (!is.null(pars)) return(ajsqfun(j, pars$phi, pars$eps, pars$lam))
	return(assh((j-eps)/lam, phi)-phi)
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

## Parameters for a particular vector
pars <- jsqpar(q=c(1, 2, 5), P=0.1)

print(jsqfun(qnorm(qpfun(0.1)), pars=pars))

ajsqfun(c(1, 2, 5), pars=pars)
