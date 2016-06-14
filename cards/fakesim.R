library(dplyr)

dat <- (dat 
	%>% mutate(
		R = as.numeric(as.character(R0))
		, Inew = rbinom(nrow(dat), size=S, prob=1-exp(-R*I/N))
	)
)
