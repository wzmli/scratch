
library(lme4)

ffit <- glm(Inew/S ~ R0-1 + offset(log(I/N))
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
)

print(exp(coef(ffit)))

s <- rep(0,length(Rseq))
rfit <- try(glmer(Inew/S ~ R0-1 + offset(log(I/N)) + (1|R0:tr) 
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
	, control=glmerControl(optimizer="bobyqa", nAGQ0initStep=FALSE)
	, start = list(fixef=s,theta=1)
))

print(exp(fixef(rfit)))

