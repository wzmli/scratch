seed <- 94
rep <- 4000
N <- 1000
init <- 10
Rvec <- 2:4
trials <- 3

library(dplyr)
library(lme4)


### Some simple data that I should be able to fit with cloglog or log
### (log should work because I start with a small FoI)
dat <- data.frame(
	S=sample(1:N, rep, replace=TRUE)
	, I=sample(1:init, rep, replace=TRUE)
	, N=N
	, R=sample(Rvec, rep, replace=TRUE)
	, trial=as.factor(sample(1:trials, rep, replace=TRUE))
)

dat <- (dat
	%>% mutate(
		Inext = rbinom(rep, size=S, prob=1-exp(-R*I/N))
		, R = as.factor(R)
	)
)

## Fit the desired model with glm
fixed <- glm(Inext/S ~ R-1 + offset(log(I/N))
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
)

exp(coef(fixed))

## Fit a log link (not ideal) with glmer
randomLog <- glmer(Inext/S ~ R-1 + offset(log(I/N)) + (1|R/trial)
	, family=binomial(link=log)
	, data=dat
	, weight=S
)
exp(fixef(randomLog))

## Fit the desired cloglog link with glmer
random <- try(glmer(Inext/S ~ R-1 + offset(log(I/N)) + (1|R/trial)
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
))
print(random)
