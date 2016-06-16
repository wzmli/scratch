library(lme4)

ffit <- glm(Inext/S ~ R0-1 + offset(log(I/N))
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
)

print(exp(coef(ffit)))

s <- rep(0,length(Rseq))
rfit <- try(glmer(Inext/S ~ R0-1 + offset(log(I/N)) + (1|R0:trial) 
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
	, control=glmerControl(optimizer="bobyqa", nAGQ0initStep=FALSE)
	, start = list(fixef=s,theta=1)
))

print(exp(fixef(rfit)))

