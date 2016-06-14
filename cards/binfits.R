
library(lme4)


ffit <- glm(Inew/S ~ R0-1 + offset(log(I/N))
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
)

print(exp(coef(ffit)))

rfit <- try(glmer(Inew/S ~ R0-1 + offset(log(I/N)) + (1|R0:trial) 
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
	, control=glmerControl(optimizer="bobyqa")
	, start = list(fixef=c(0.7,1.1,1.4),theta=1)
))

print(rfit)

