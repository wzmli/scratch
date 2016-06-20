library(lme4)

# What about Poisson fits
ffit <- glm(Inext~ R0-1 + offset(log(S) + log(I/N))
	, family=poisson(link=log)
	, data=dat
)

print(exp(coef(ffit)))

rfit <- glmer(Inext~ R0-1 + offset(log(S) + log(I/N)) + (1|R0:tr)
	, family=poisson(link=log)
	, data=dat
)

print(exp(fixef(rfit)))
