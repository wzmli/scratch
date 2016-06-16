
library(dplyr)
library(lme4)

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
