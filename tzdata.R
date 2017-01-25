set.seed(1971)
l <- 40

y <- rnorm(l)
x <- rnorm(l)
religion <- sample(1:3, l, prob=1:3, replace=TRUE)
country <- sample(1:3, l, prob=1:3, replace=TRUE)

religion[country==3] <- 4

dat <- data.frame(x=x, y=y
	, religion=as.factor(religion)
	, country=as.factor(country)
)

# rdsave(dat)
