c_f <- 20
c_0 <- 4
t0 <- 0
Tc <- 5

t <- 0:10
c = c_f + (c_0-c_f)*exp((t0-t)/Tc)

plot(t, c)

