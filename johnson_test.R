
### Linear fits and plots
seqPlot <- function(
	CI, qlim, boxes, steps, logq=FALSE, P=0.1, plotlim=NULL, medlist=NULL
){
	# List of medians
	if (is.null(medlist)){
		medlim <- CI
		if (logq) medlim <- log(medlim)
		medlist <- seq(from=min(medlim), to=max(medlim), length.out=steps+1)
		medlist <- medlist[-c(1, steps+1)]
		if (logq) medlist <- exp(medlist)
	}

	## Points of the distribution (and their differences)
	j <- seq(min(qlim), max(qlim), length.out=boxes+1)
	del <- (j[-1] - j[-length(j)])
	j <- (j[-1] + j[-length(j)])/2

	dlist <- sapply(medlist, function(med){
		d <- jsqdens(j, q=c(CI[[1]], med, CI[[2]]), P=P, logq=logq)
		dd <- del*d
		print(c(
			tot = sum(dd)
			, down = sum(dd[j<=max(CI)])
			, up = sum(dd[j>=min(CI)])
		))
		return(d)
	})

	matplot(j, dlist, type="l", lwd="3", lty=1, xlim=plotlim)
	abline(v=CI, lty=3, lwd=1.5)
	for (i in 1:length(medlist)){
		abline(v=medlist[[i]], col=i, lty=2, lwd=1.5)
	}
}

CI <- c(25, 400)
P <- 0.1

steps <- 6
boxes <- 10000

seqPlot (CI = CI
	, qlim = c(-100, 500)
	, boxes = boxes
	, steps = steps
	, P=P
)

seqPlot (CI = CI
	, qlim = c(10, 600)
	, boxes = boxes
	, steps = steps
	, P=P
	, logq=TRUE
)

## Arbitrary example from the .rmd
seqPlot(CI=c(7, 122), medlist=40, boxes=10000, qlim=c(1, 200))
