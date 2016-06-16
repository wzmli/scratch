
# Transmission function, for a given number of contacts in a particular model world. det=TRUE returns the deterministic version; cards=TRUE a stochastic version based on the detailed model; cards=FALSE a binomial approximation to the "true" stochastic version. They should be very similar, and produce qualitatively similar results
transFun <- function(contacts, S, N, det=TRUE, cards=TRUE){
    if(contacts==0) return(0)
    if (det) return(contacts*S/N)
    ## Pick contacts from population, and see how many are in the first S
    if (!cards) return(rbinom(1, size=S, prob=contacts/N))
    if (contacts>N) return(S)
    if (cards) return(sum(sample(N, contacts)<=S))
}

# Simulate a stochastic epidemic, using the transFun above for the transmission step
sim <- function(R0, N=26, numSteps=10, I_0=1, det=TRUE, cards=TRUE){
    Ivec <- I <- I_0
    Svec <- S <- N-I_0
    for (j in 2:numSteps){
        trans <- transFun(R0*I, S, N, det, cards)
        if (is.na(trans)) browser()
        I <- trans
        S <- S-trans
        if (S<0) browser()
        Ivec[[j]] <- I
        Svec[[j]] <- S
    }
    return(data.frame(
        time=1:numSteps
      , I=Ivec
      , S=Svec
    ))
}

## testing/messing around:
if (FALSE) {
    set.seed(101)
    ss <-  sim(R0=2,N=25)  ## deterministic
    matplot(ss[,1],ss[,-1],type="l")
    ## incidence = R0*S*I/N
    with(ss,plot(tail(S*I/25,-1),I[-1],type="b"))
    with(ss2,lines(tail(S*I/25,-1),I[-1],type="b",col=2))
    abline(a=0,b=2)
}

# Make a data frame with Inext on the same row, in an apparently correct way.
stepFrame <- function(f){
    newf <- f[-nrow(f), ]  ## all but last row of f
    newf$Inext <- f$I[-1]  ## 
    return(newf)
}

## Do a bunch of sims with reps for varying values of R0
seed <- 44
reps <- 20
N <- 100
Rstart <- 1
Rstop <- 4
Rstep <- 1/2

set.seed(seed)

rm(dat)
for (R0 in seq(from=Rstart, to=Rstop, by=Rstep)){
    for (r in 1:reps){
        s <- sim(R0=R0, N=N, det=FALSE, cards=TRUE)
        sf <- stepFrame(s)
        sf$trial <- r
        sf$R0 <- R0
        if (!exists("dat"))
            dat <- sf
        else 
            dat <- rbind(dat, sf)
    }
}

## print(dat)
dat <- subset(dat, (I>0) & (S>0))
dat$R0 <- as.factor(dat$R0)

library(lme4)

## Try to infer R0 for each set of sims based on the data (and an assumed perfect knowledge of susceptibles (tSIR-like)
## I(next) = (R0-1)*S*I/N
gfit <- glmer(Inext ~ R0-1 + offset(log(I) + log(S) -log(N)) + (1|R0/trial) 
	, family="poisson"
	, data=dat
)


### BMB stuff: more systematic diagnoses

library(plyr)

## reps 
simfun2 <- function(R0,N,nrep=10) {                     
    rdply(nrep,sim(R0=R0,N=N,det=FALSE,card=TRUE))
}
simfun2(5,100)
simfun3 <- function(N,Rstart=1,Rstop=4,Rstep=0.5) {
    R0vec <- seq(from=Rstart, to=Rstop, by=Rstep)
    ldply(setNames(R0vec,R0vec),simfun2,N=N,.id="R0")
}
head(simfun3(100))
Nvec <- round(exp(seq(from=log(20),to=log(1000),length=8)))
names(Nvec) <- Nvec
set.seed(101)
simres1 <- ldply(Nvec,simfun3,Rstop=8,.id="N")
simres2 <- ddply(simres1,c("N","R0",".n"),
                 mutate,
                 Inext=c(I[2:length(I)],NA))
library(ggplot2); theme_set(theme_bw())
zmargin <- theme(panel.margin=grid::unit(0,"lines"))
ggplot(simres2,aes(time,I,group=interaction(.n,R0,N)))+geom_line()+
    facet_grid(R0~N)+scale_y_log10()+zmargin

fitfun <- function(d,family=poisson,
                   form = Inext ~ offset(log(I) + log(S) -log(N))) {
    d <- subset(mutate(d,N=as.numeric(as.character(N))),Inext>0)
    mod <- try(glm(form, family=family, data=na.omit(d)))
    if (is(mod,"try-error")) {
        return(data.frame(est=NA,lwr=NA,upr=NA))
    }
    ci <- suppressMessages(exp(confint(mod)))
    return(data.frame(est=exp(coef(mod)),lwr=ci[1],upr=ci[2]))
}

s0 <- subset(simres2,N=="20" & R0=="4" & .n==1)
fitfun(s0)
simvals <- ddply(simres2,c("N","R0",".n"),fitfun)

tdat <- data.frame(R0=as.numeric(levels(simvals$R0)))
ggplot(simvals,aes(.n,est,ymin=lwr,ymax=upr))+
    facet_grid(R0~N)+geom_pointrange()+
    geom_hline(data=tdat,aes(yintercept=R0),col="red")+
    zmargin
ggplot(simvals,aes(as.numeric(as.character(R0)),est,ymin=lwr,ymax=upr))+
    facet_wrap(~N)+geom_pointrange()+
    zmargin+geom_abline(intercept=0,slope=1,lty=2)


