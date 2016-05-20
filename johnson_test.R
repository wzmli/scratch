P <- 0.1
CI <- c(25, 400)
qlim <- c(10, 1000)
boxes <- 500
steps <- 6

## Medians
lCI <- log(CI)
medlist <- exp(seq(from=min(lCI), to=max(lCI), length.out=steps+1))
medlist <- medlist[-c(1, steps+1)]

## Points of the distribution (and their differences)
j <- seq(min(qlim), max(qlim), length.out=boxes+1)
del <- (j[-1] - j[-length(j)])
j <- (j[-1] + j[-length(j)])/2

for (med in medlist){
	dens <- jsqdens(j, q=c(CI[[1]], med, CI[[2]]), P=P, logq=TRUE)
	# plot(j, dens, type="l")
}


### Linear style
medlist <- seq(from=min(CI), to=max(CI), length.out=steps+1)
medlist <- medlist[-c(1, steps+1)]

qlim <- c(-50, 500)
## Points of the distribution (and their differences)
j <- seq(min(qlim), max(qlim), length.out=boxes+1)
del <- (j[-1] - j[-length(j)])
j <- (j[-1] + j[-length(j)])/2

for (med in medlist){
	print(jsqpar(q=c(CI[[1]], med, CI[[2]]), P=P))
	dens <- jsqdens(j, q=c(CI[[1]], med, CI[[2]]), P=P)
	plot(j, dens, type="l")
}
