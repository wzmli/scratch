ssh <- function(x, s){
	if (s==0) return(x)
	return(sinh(s*x)/s)
}

wt <- function(v){
	return((v[[3]]-v[[2]])/(v[[2]]-v[[1]]))
}

## Weight of a Johnson function with scale=offset=phi, given a vector of values
jsqwt <- function(phi, q, root=0){
	return(wt(ssh(q-phi, phi))-root)
}

jsqphi <- function(wt, P=0.1, phiRange=c(-10, 10)){
	qp <- c(P/2, 1/2, 1-P/2)
	qq <- qnorm(qp)
	return(uniroot(jsqwt, phiRange, q=qq, root=wt)$root)
}

print(jsqphi(1/2))
print(jsqphi(1))
print(jsqphi(2))
