# Transmission function, for a given number of contacts in a particular model world. det=TRUE returns the deterministic version; cards=TRUE a stochastic version based on the detailed model; cards=FALSE a binomial approximation to the "true" stochastic version. They should be very similar, and produce qualitatively similar results
transFun <- function(contacts, S, N, det=TRUE, cards=TRUE){
	if(contacts==0) return(0)
	if(contacts>=N) return(S)
	if (det) return(contacts*S/N)
	## Pick contacts from population, and see how many are in the first S
	if (!cards) return(rbinom(1, size=S, prob=contacts/N))
	return(sum(sample(N, contacts)<=S))
}

# Simulate a stochastic epidemic, using the transFun above for the transmission step
sim <- function(R0, N=26, numSteps=10, I_0=1, det=TRUE, cards=TRUE){
	Ivec <- I <- I_0
	Svec <- S <- N-I_0
	for (j in 2:numSteps){
		trans <- transFun(R0*I, S, N, det, cards)
		I <- trans
		S <- S-trans
		if (S<0) print(c(R0*I, S, N, det, cards, trans))
		Ivec[[j]] <- I
		Svec[[j]] <- S
	}
	return(data.frame(
		time=1:numSteps
		, I=Ivec
		, S=Svec
	))
}

# Make a data frame with Inext on the same row, in an apparently correct way.
stepFrame <- function(f){
	newf <- f[-nrow(f), ]
	newf$Inext <- f$I[-1]
	return(newf)
}

## Do a bunch of sims with reps for varying values of R0
seed <- 41
reps <- 10
N <- 1000
Rstart <- 1
Rstop <- 4
Rstep <- 1
cards <- TRUE

set.seed(seed)

Rseq <- seq(from=Rstart, to=Rstop, by=Rstep)
for (R0 in Rseq){
	for (r in 1:reps){
		s <- sim(R0=R0, N=N, det=FALSE, cards=cards)
		sf <- stepFrame(s)
		sf$trial <- r
		sf$R0 <- R0
		if (!exists("dat"))
			dat <- sf
		else 
			dat <- rbind(dat, sf)
	}
}

dat <- subset(dat, (I>0) & (S>0))
dat$R0 <- as.factor(dat$R0)
print(dat)

