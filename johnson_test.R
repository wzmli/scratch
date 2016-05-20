
## Parameters for a particular vector
P <- 0.1
v <- c(50, 80, 400)
plim <- 0.01
boxes <- 5000

pars <- jsqpar(q=v, P=P)

qlim <- (jsqfun(qnorm(qpfun(plim)), pars=pars))
qlim <- c(10, 500)

j <- seq(min(qlim), max(qlim), length.out=boxes+1)

del <- (j[-1] - j[-length(j)])
j <- (j[-1] + j[-length(j)])/2

dens <- jsqdens(j, q=v, P=P)
plot(j, dens, type="l")
dd <- (del*dens)
print(sum(dd))
print(plim/2+sum(dd[j<v[[1]]]))
print(plim/2+sum(dd[j<v[[2]]]))
print(plim/2+sum(dd[j<v[[3]]]))

dens <- jsqdens(j, q=v, P=P, logq=TRUE)
plot(j, dens, type="l")
dd <- (del*dens)
print(sum(dd))
print(plim/2+sum(dd[j<v[[1]]]))
print(plim/2+sum(dd[j<v[[2]]]))
print(plim/2+sum(dd[j<v[[3]]]))

