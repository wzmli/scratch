formula <- with(dat, y~x+country+religion)

## Straightforward lm; we think it treats the redundant religion as the baseline religion
m <- lm(formula)
print(summary(m))

# make a version with NAs, so we can get a model.frame of the right shape

dat <- droplevels(within(dat, {
	religion[country==3] <- NA
}))
formula <- with(dat, y~x+country+religion)

## Confirm what we're doing with redundant religion
mf <- model.frame(formula, na.action=NULL)
mt <- attr(mf, "terms")
mm <- model.matrix(mt, mf)
ma <- attr(mm, "assign")

str(mf)
str(mm)

### <allow horrible code>
### Confirm that lm result matches tz -> religion1
tzrows <- dat$country==3
mm[tzrows, "religion2"] <- 0
mm[tzrows, "religion3"] <- 0

### Put in the coding we want (mean)
### We want to redo all of this with the assign vector and be 

mr <- model.response(mf)
print(mr)
mfit <- lm.fit(mm, mr)
mfit$call <- match.call()
class(mfit) <- "lm"
mfit$terms <- terms(mf)

summary(mfit)
