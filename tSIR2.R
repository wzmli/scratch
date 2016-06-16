
library(lme4)

ffit <- glm(Inew/S ~ R0-1 + offset(log(I/N))
	, family=binomial(link=cloglog)
	, data=dat
        , weight=S
)

print(exp(coef(ffit)))

subset(dat,R0==1)

dat2 <- droplevels(subset(dat,R0!="1"))
s <- rep(0,3)
rfit <- try(glmer(Inew/S ~ R0-1 + offset(log(I/N)) + (1|R0:trial) 
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
	, control=glmerControl(optimizer="bobyqa",
                               nAGQ0initStep=FALSE)
	, start = list(fixef=s,theta=1)
))

print(rfit)
exp(fixef(rfit))
with(subset(dat,R0=="1"),table(Inew))
