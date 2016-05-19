qpfun <- function(P){
	return(c(P/2, 1/2, 1-P/2))
}

ssh <- function(x, s){
	if (s==0) return(x)
	return(sinh(s*x)/s)
}

wtfun <- function(v){
	if(length(v) != 3){
		stop(paste("v is supposed to have length 3 in wtfun", length(v)))
	}
	return((v[[3]]-v[[2]])/(v[[2]]-v[[1]]))
}

## Weight of a Johnson function with scale=offset=phi, given a vector of values
jsqwt <- function(phi, q, root=0){
	return(wtfun(ssh(q-phi, phi))-root)
}

jsqphi <- function(wt, P=0.1, phiRange=c(-10, 10)){
	qp <- qpfun(P)
	qq <- qnorm(qp)
	return(uniroot(jsqwt, phiRange, q=qq, root=wt)$root)
}

## Transform a normal deviate to a Johnson deviate
jsqfun <- function(q, phi, mu=0, sig=1){
	return(ssh((q-phi), phi)*sig+mu)
}

## A wrapper for jsqfun that allows a list of parameters)
jsqpfun <- function(q, pars){
	with(pars, return(jsqfun(q, phi, mu, sig)))
}

jsqpar <- function(q, P=0.1, phiRange=c(-10, 10)){
	wt <- wtfun(q)
	qp <- qpfun(P)
	z <- qnorm(qp)
	phi <- jsqphi(wt, P, phiRange)
	q0 <- jsqfun(z, phi)
	sig <- sd(q)/sd(q0)
	mu <- mean(q)-sig*mean(q0)
	return(list(mu=mu, sig=sig, phi=phi))
}

pars <- jsqpar(q=c(1, 2, 5))

print(jsqpfun(qnorm(qpfun(0.1)), pars))
