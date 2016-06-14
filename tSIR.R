seed <- 94
rep <- 4000
N <- 1000
init <- 10
Rvec <- 2:4
trials <- 3

library(dplyr)
library(lme4)

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

rfit <- glmer(Inext/S ~ R-1 + offset(log(I/N)) + (1|trial) 
	, family=binomial(link=log)
	, data=dat
	, weight=S
)

exp(fixef(rfit))
summary(rfit)
