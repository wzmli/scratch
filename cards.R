seed <- 94
rep <- 4000
N <- 1000
init <- 10
Rvec <- 2:4
trials <- 3

library(dplyr)

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

library(ggplot2); theme_set(theme_bw())
ggplot(dat,aes(factor(trial),Inew/S-log(I/N)))+
    geom_boxplot()+facet_wrap(~R)

ggplot(dat,aes(S,Inew))+
    geom_point()+facet_wrap(~R)+
    geom_smooth()

