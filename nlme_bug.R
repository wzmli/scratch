####### Some fake data
n <- 2000
set.seed(2113)
noise_factor <- 0.01

id <- as.factor(1:n)
x <- runif(n)
y <- rnorm(n)
noise <- rnorm(n)
orig <- data.frame(id=id, x=x, y=y)

#### Make a data frame with redundant data and a desired amount of noise
make_frame <- function(id, x, y, noise){
	return(data.frame(id = c(id, id)
		, x = c(x, x)
		, y = c(y, y+noise)
	))
}

### What are the correct T statistics?
print(coef(summary(
	lm(data = orig, y~x)
)))

library(nlme)

# Try lme on redundant data with decreasing amount of noise

t_noise <- function(id, x, y, noise, nf){
	nframe <- make_frame(id, x, y, noise*nf)
	return(summary(lme(
		data=nframe, fixed = y~x, random = ~1 | id
		, method = "REML"
	))$tTab[["x", "t-value"]])
}

for (nf in 0.1^(1:17))
	print(c(nf, t_noise(id, x, y, noise, nf)))
