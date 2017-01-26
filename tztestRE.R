library(lme4)

## Some data with a structural NA
## Religion not collected from country 3; we added a dummy level ("4")
## depends on functions in redundancy.R

set.seed(1971)
l <- 40

y <- rnorm(l)
x <- rnorm(l)
religion <- sample(1:3, l, prob=1:3, replace=TRUE)
country <- sample(1:3, l, prob=1:3, replace=TRUE)
village <- sample(1:2, l, prob=1:2, replace=TRUE)

religion[country==3] <- 4

dat <- data.frame(x=x, y=y
                  , religion=as.factor(religion)
                  , country=as.factor(country)
                  , village=as.factor(village)
)

## Naive lm works, but not so clear what it does
formula <- y~x+country+religion+(1|village)
summary(lmer(formula, data=dat))

## Now set the NAs to really be NAs
dat <- droplevels(within(dat, {
  religion[country==3] <- NA
}))

## Set NAs to base level; this matches the default behaviour (but without the dummy level, so better)
summary(lmFill(y~x+country+religion, dat, NArows = dat$country==3, fillvar="religion", method="base"))

## Set NAs to model center, or variable mean, or whatever we should call it
## Seems better
## Interestingly (but sensibly), this changes only the value estimated for the effect of the country with missing data
summary(lmFill(y~x+country+religion, dat, NArows = dat$country==3, fillvar="religion"))

