fac <- function(x, l=NULL){
	if (x==1) return(l)
	f <- 1+min(which(x%%(2:x)==0))
	return(fac(x/f, c(l, f)))
}

fac(3811^2)
