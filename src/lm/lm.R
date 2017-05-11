# read in datasets
script.dir <- dirname(sys.frame(1)$ofile)
source(file.path(script.dir, "..", "misc", "read-in.R"))

# vector to collect MSE for all datasets
mse.test <- numeric(3)
mse.train <- numeric(3)

# perform linear regression on training datasets
model1 <- lm(y ~ ., lhg[ind == 1, ])
model2 <- lm(y ~ ., lphg[ind == 1, ])
model3 <- lm(y ~ ., lshg[ind == 1, ])

# now calculate training MSEs
mse.train[1] <- mean((predict(model1, lhg[ind == 1, ]) -
                      lhg[ind == 1, "y"])^2)
mse.train[2] <- mean((predict(model2, lphg[ind == 1, ]) -
                      lphg[ind == 1, "y"])^2)
mse.train[3] <- mean((predict(model3, lshg[ind == 1, ]) -
                      lshg[ind == 1, "y"])^2)

# now calculate testing MSEs
mse.test[1] <- mean((predict(model1, lhg[ind == 2, ]) -
                     lhg[ind == 2, "y"])^2)
mse.test[2] <- mean((predict(model2, lphg[ind == 2, ]) -
                     lphg[ind == 2, "y"])^2)
mse.test[3] <- mean((predict(model3, lshg[ind == 2, ]) -
                     lshg[ind == 2, "y"])^2)

# collect all MSEs and save
file <- h5file(file.path(script.dir, "..", "..", "data", "results.h5"))
file["lm/data"] <- c("lhg", "lphg", "lshg")
file["lm/train"] <- mse.train
file["lm/test"] <- mse.test
h5close(file)