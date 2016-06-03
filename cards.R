transFun <- function(contacts, S, N, det=TRUE){
	if(contacts==0) return(0)
	if(contacts>N) return(N)
	if (det) return(contacts*S/N)
	## Pick contacts from population, and see how many are in the first S
	return(sum(sample(N, contacts)<=S))
}

sim <- function(R0, N=26, numSteps=10, I_0=1, det=TRUE){
	Ivec <- I <- I_0
	Svec <- S <- N-I_0
	Ivec <- Svec <- numeric(0)
	for (j in 1:numSteps){
		trans <- transFun(R0*I, S, N, det)
		I <- trans
		S <- S-trans
		Ivec[[j]] <- I
		Svec[[j]] <- S
	}
	return(data.frame(
		time=1:numSteps
		, I=Ivec
		, S=Svec
	))
}

stepFrame <- function(f){
	newf <- f[-nrow(f), ]
	newf$Inext <- f$I[-1]
	return(newf)
}

seed <- 23
reps <- 4
N <- 26

set.seed(seed)

for (R0 in 2:4){
	for (r in 1:reps){
		s <- sim(R0=R0, N=N, det=FALSE)
		sf <- stepFrame(s)
		sf$trial <- r
		sf$R0 <- R0
		if (r==1)
			dat <- sf
		else 
			dat <- rbind(dat, sf)
	}
}

dat <- subset(dat, (I>0) & (S>0))
dat$R0 <- as.factor(dat$R0)

print(dat)

quit()

library(lme4)

gfit <- glmer(Inext ~ R0-1 + offset(log(I) + log(S) -log(N)) + (1|trial:R0) 
	, family="poisson"
	, data=dat
)

print(summary(gfit))
print(gfit)

quit()


## We can't estimate R0 when the infecteds get down to 0 because no transmission is 
## taking place, so let's select the subset of the data for which we have real
## values only

df.R0.fit <- subset(df.R0.fit, log_new_infecteds!=-Inf)

## And now we want to estimate a new R0 value. We'll first feed our lmfit a "guess" value
## of what we think R0 is and make it the length of our full dataset. If we wanted to 
## create a time-varying value for R0, we could list different "guesses" here, but for now,
## we'll assume that R0 is constant across each trial. Let's guess that it is 2.
R0 <- rep(2, length(df.R0.fit$timestep))

## Then, we can go ahead and fit this model. We use the 'lmer' function in
## the R package 'lme4' to allow us to fit many trials of data, with trial 
## as a random effect.
## lmfit <- lmer(logInew ~ -1+as.factor(R0)+offset(logIold+logSold) + (1|trial)) 

require(lme4)
require(arm)

lmfit <- lmer(log_new_infecteds ~ -1 + R0 + offset(log_old_infecteds + log_old_susceptibles - log(N)) + (1|trial), data = df.R0.fit)

## We can look at the lmfit to see our new guess for R0. Remember our inputs are in log-form,
## so we need to exponentiate our new R0 estimate.
R0 <- exp(coef(lmfit)$trial[1,2])

## Is the new estimate bigger or smaller than our guess for R0 = 2?

## We can also extract standard errors on these fits to get 95% confidence intervals
## for our estimates
SE <- se.coef(lmfit)$fixef
lcl <- exp(coef(lmfit)$trial[1,2] - 1.96*SE)
ucl <- exp(coef(lmfit)$trial[1,2] + 1.96*SE)


## We can plot this R0 and corresponding confidence intervals and compare this
## trajectory with R0 = 2 that we adopted for our model.
plot(1, ylab="R0",  type= "n", xlim=c(0,3),ylim=c(0,2.5), xlab="", xaxt="n") #gives you beta across the time series (which in this case is also R0)
points(1,R0, col="red")
arrows(x0=1,y0=R0, x1=1, y1=ucl, code=2, angle=90, lty=1, col="red", length=.1)
arrows(x0=1,y0=R0, x1=1, y1=lcl, code=2, angle=90, lty=1, col="red", length=.1)
points(x=1.5,y=2, col="blue")
legend("topright", legend=c("fitted R0", "initial R0"), col = c("red", "blue"), pch="o")


## Now, let's add our fitted R0 to our model in place of R0 = 2 where we used it before
## First, we make two new empty vectors for I and S, then seed them with starting values.

model.I.new <- rep(NA, length(time))
model.S.new <- rep(NA, length(time))
model.I.new[1] <- 1
model.S.new[1] <- 25

## And then we iterate forward in time, except now we know that R0 = our optimized R0
## instead of previously when it was just 2. 
for (j in 2:length(time)){
  model.I.new[j] <- model.S.new[j-1]*model.I.new[j-1]/N*R0
  model.S.new[j] <- model.S.new[j-1]-model.S.new[j-1]*model.I.new[j-1]/N*R0
}

## And plot with the data and the old model. Does the 'fitted' model better match
## the data than the unfitted? Why or why not?

plot(model.I, type="l", col="red", ylab="proportion", xlab="time", ylim=c(0,26))
lines(model.S, col="green")
for (i in 1:length(unique(df.R0$trial))){
  lines(df.R0$time[df.R0$trial==i], df.R0$infecteds[df.R0$trial==i],  col = "red", lty=2, lwd=.5) 
}
#and do the same for susceptibles
for (i in 1:length(unique(df.R0$trial))){
  lines(df.R0$time[df.R0$trial==i], df.R0$susceptibles[df.R0$trial==i],  col = "green", lty=2, lwd=.5) 
}
lines(model.I.new, col="red", lwd = 3)
lines(model.S.new, col="green", lwd = 3)
legend("topright", legend=c("unfitted model: susceptible", "unfitted model: infected", "data: susceptible", "data: infected", "fitted model: susceptible", "fitted model: infected"), col= c("green", "red", "green", "red", "green", "red"), lty=c(1,1,2,2, 1, 1), lwd=c(1,1,.5,.5, 3, 3), cex=.5)


######################################################################
##Section 4: Exploring a time-varying R0

## Sometimes, disease ecologists experiment with models that allow transmission to vary
## for each timestep (so, in this case, R0 could change with each timestep). We have no
## biological reason to think this might happen here, but it is very common to find 
## seasonally-varying transmission rates in disease dynamics across an annual time series.
## Can you think of a reason that transmission might vary seasonally?

## Try repeating the above, now allowing for an R0 value that varies with each timestep.

## This time, we need to be even more selective in our data and only 'fit' time-varying R0
## values to the timesteps for which you have data in every trial (some trials end earlier
## than others). First, we select those parts of the dataset.

## First, find your shortest trial
trial.length <- list()
for (i in 1:length(unique(df.R0.fit$trial))){
  trial.length[[i]] <- max(df.R0.fit$timestep[df.R0.fit$trial==i])
}
short <- min(c(unlist(trial.length)))

#then select the subset of the data up to that timestep
df.R0.fit.tvar <- subset(df.R0.fit, timestep<=short)

## Now remember that your "guess" R0 needs to have different values that repeat the 
## length of the dataset.
R0 <- rep(unique(df.R0.fit.tvar$timestep), times=length(unique(df.R0.fit.tvar$trial)))


## And then you have to make R0 a factor. Otherwise, all is the same!
lmfit <- lmer(log_new_infecteds ~ -1 + as.factor(R0) + offset(log_old_infecteds + log_old_susceptibles - log(N)) + (1|trial), data = df.R0.fit.tvar)

## This time R0 is a vector across the time series.
R0 <- as.numeric(exp(coef(lmfit)$trial[1,2:length(coef(lmfit)$trial)]))

## Is the new estimate bigger or smaller than our guess for R0 = 2?

## We can also extract standard errors on these fits to get 95% confidence intervals
## for our estimates
SE <- se.coef(lmfit)$fixef
lcl <- as.numeric(exp(coef(lmfit)$trial[1,2:length(coef(lmfit)$trial)] - 1.96*SE))
ucl <- as.numeric(exp(coef(lmfit)$trial[1,2:length(coef(lmfit)$trial)] + 1.96*SE))


## This time, we can plot R0 as it changes across the time series.
plot(x=seq(1.5,(length(R0)+1),1), R0, ylab="R0",  type= "b", xlim=c(1,10),ylim=c(0,3), xlab="time", col="red") #gives you beta across the time series (which in this case is also R0)
arrows(x0=seq(1.5,(length(R0)+1),1),y0=R0, x1=seq(1.5,(length(R0)+1),1), y1=ucl, code=2, angle=90, lty=1, col="red", length=.1)
arrows(x0=seq(1.5,(length(R0)+1),1),y0=R0, x1=seq(1.5,(length(R0)+1),1), y1=lcl, code=2, angle=90, lty=1, col="red", length=.1)
abline(h=2, col="blue", lty=2)
legend("topright", legend=c("fitted R0", "initial R0"), col = c("red", "blue"), lty=c(1,2), cex=.5)

## Now, we add our new time-varying, fitted R0 to our model. Again, we make two new empty
## vectors for I and S and seed them with starting values. 
model.I.tvar <- rep(NA, length(time))
model.S.tvar <- rep(NA, length(time))
model.I.tvar[1] <- 1
model.S.tvar[1] <- 25

##This time, we need R0 to be a vector of length equivalent to S and I, and it is 
## currently shorter because we cut out those timesteps where I = -Inf. It doesn't 
## really matter what value we give it in these later timesteps, since it will
## always be multiplied by I=0, so we'll just fill those extra spaces with 2.

R0 <- c(R0, rep(2,(length(model.I.tvar)-length(R0))))

## And then we iterate forward in time just like before, except now R0 is also a vector.

for (j in 2:length(time)){
  model.I.tvar[j] <- model.S.tvar[j-1]*model.I.tvar[j-1]/N*R0[j-1]
  model.S.tvar[j] <- model.S.tvar[j-1]-model.S.tvar[j-1]*model.I.tvar[j-1]/N*R0[j-1]
}

## And now we replace our single R0 fitted model with our time-varying fitted model on our
## plot. Which does a better job recapturing the data? Why might this be?

plot(model.I, type="l", col="red", ylab="proportion", xlab="time", ylim=c(0,26))
lines(model.S, col="green")
for (i in 1:length(unique(df.R0$trial))){
  lines(df.R0$time[df.R0$trial==i], df.R0$infecteds[df.R0$trial==i],  col = "red", lty=2, lwd=.5) 
}
#and do the same for susceptibles
for (i in 1:length(unique(df.R0$trial))){
  lines(df.R0$time[df.R0$trial==i], df.R0$susceptibles[df.R0$trial==i],  col = "green", lty=2, lwd=.5) 
}
lines(model.I.tvar, col="red", lwd = 3)
lines(model.S.tvar, col="green", lwd = 3)
legend("topright", legend=c("unfitted model: susceptible", "unfitted model: infected", "data: susceptible", "data: infected", "fitted model (t-var R0): susceptible", "fitted model(t-var R0): infected"), col= c("green", "red", "green", "red", "green", "red"), lty=c(1,1,2,2, 1, 1), lwd=c(1,1,.5,.5, 3, 3), cex=.5)

## Do we think that a time-varying R0 is legitimate in this case, or could we be 'over-fitting?' Why or why not?
