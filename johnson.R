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

djsq <- function(j,  phi, eps=0, lam=1, pars=NULL){
	if (!is.null(pars)) return(djsq(j, pars$phi, pars$eps, pars$lam))
	j0 <- (j-eps)/lam
	z <- assh(j0, phi)
	zdens <- dnorm(z-phi)
	return(zdens/(lam*cosh(phi*z)))
}

## Parameters for a particular vector
P <- 0.1
v <- c(10, 25, 100)
plim <- 0.01
boxes <- 5000

pars <- jsqpar(q=v, P=P)

qlim <- (jsqfun(qnorm(qpfun(plim)), pars=pars))
j <- seq(min(qlim), max(qlim), length.out=boxes+1)
del <- (max(j) - min(j))/boxes
j <- (j[-1] + j[-length(j)])/2

dens <- djsq(j, pars=pars)
plot(j, dens, type="l")
print(del*sum(dens))
print(plim/2+del*sum(dens[j<v[[1]]]))
print(plim/2+del*sum(dens[j<v[[2]]]))
print(plim/2+del*sum(dens[j<v[[3]]]))
