set.seed(1)

k <- 10 # number of covariates
k_obs <- 20 # number of observed covariates
sigma <- 1 # gaussian standard deviation
n <- 10000 # number of observations

b <- runif(k, -5, 5) # coefficients

X <- matrix(rnorm((k_obs-1) * n, 0, 5), n, k_obs-1) # covariates
y <- rnorm(n, cbind(1, X[, 1:(k-1)]) %*% b, sigma) # observations

# save data to hdf5 format
library(h5)
colnames(X) <- paste0("X", 1:(k_obs-1))
data <- cbind(y, X)
script.dir <- dirname(sys.frame(1)$ofile)
file <- h5file(file.path(script.dir, "..", "..", "data", 
                         "linear-spurious-homoscedastic-gaussain.h5"))
file["data"] <- data
h5close(file)