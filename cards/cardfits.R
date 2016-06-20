# library(lme4)

# Fit the card sims the way that works for the simple sims
ffit <- glm(Inext/S ~ R0-1 + offset(log(I/N))
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
)

print(exp(coef(ffit)))

# Now attempt to correct for the inflation by projecting to low transmission
tr <- with(dat, I*S)
pfit <- glm(Inext/S ~ R0-1 + offset(log(I/N)) + R0:I
	, family=binomial(link=cloglog)
	, data=dat
	, weight=S
)

print(exp(coef(pfit)))

# glmer stuff dropped for now
