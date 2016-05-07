ssh <- function(x, s){
	if (s==0) return(x)
	return(sinh(s*x)/s)
}

ssh(4, 0)
ssh(4, 0.01)
ssh(4, 1)

wt <- function(v){
	return((v[[3]]-v[[2]])/(v[[2]]-v[[1]]))
}

jsqwt <- function(q, phi){
	return(wt(ssh(q-phi, phi)))
}

q <- c(0.25, 0.5, 0.75)
qq <- qnorm(q)

for (phi in -5:5){
	print(log(jsqwt(qq, phi)))
}

