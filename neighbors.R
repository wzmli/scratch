neighbors <- c(1:4)
migrants <- rbinom(n=1, size=cases, migrateProb)
places <- sample(neighbors, migrants, replace=TRUE)
print(places)
