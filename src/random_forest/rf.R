# read in datasets
script.dir <- dirname(sys.frame(1)$ofile)
source(file.path(script.dir, "..", "misc", "read-in.R"))

# vector to collect MSE for all datasets
mse.test <- numeric(3)
mse.train <- numeric(3)

# fit random forests to training data
library(randomForest)
set.seed(1)

# notes:
# increasing the number of botstrap samples `ntree` reduces the variance/
# improves the fit, but only up to a point
# this function defaults to 500, I've increased to 1,000
# so these models will be a little slow
# additionally, random forests consider p/3 covariates
# for each bootstrap sample, whereas bagging considers all 
# covariates. This is a parameter that can be tuned, but often isn't
# using p/3 instead of p covariates allows decorrelation of 
# each tree and improves fit, so I'll stick with p/3
model1 <- randomForest(y ~ ., lhg[ind == 1, ], ntree=1000)
model2 <- randomForest(y ~ ., lphg[ind == 1, ], ntree=1000)
model3 <- randomForest(y ~ ., lshg[ind == 1, ], ntree=1000)

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
file["rf/data"] <- c("lhg", "lphg", "lshg")
file["rf/train"] <- mse.train
file["rf/test"] <- mse.test
h5close(file)
