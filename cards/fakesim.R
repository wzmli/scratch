library(dplyr)

dat <- (dat 
	%>% mutate(
		R = as.numeric(as.character(R0))
		, tr = as.numeric(as.character(trial))
		, Inew = rbinom(nrow(dat), size=S, prob=1-exp(-R*I/N))
	)
)

summary(dat)
