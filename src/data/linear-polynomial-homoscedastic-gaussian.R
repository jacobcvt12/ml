set.seed(1)

k <- 10 # number of covariates
degree <- 5 # number of polynomial degrees
sigma <- 1 # gaussian standard deviation
n <- 10000 # number of observations

b <- runif(1 + (k-1) * degree, -5, 5) # coefficients

X <- matrix(rnorm((k-1) * n, 0, 5), n, k-1) # covariates
X_tmp <- do.call(cbind, lapply(1:degree, function(y) X ^ y))
y <- rnorm(n, cbind(1, X_tmp) %*% b, sigma) # observations

# save data to hdf5 format
library(h5)
colnames(X) <- paste0("X", 1:(k-1))
data <- cbind(y, X)
script.dir <- dirname(sys.frame(1)$ofile)
file <- h5file(file.path(script.dir, "..", "..", "data", 
                         "linear-polynomial-homoscedastic-gaussain.h5"))
file["data"] <- data
h5close(file)