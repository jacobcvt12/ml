# read in datasets
script.dir <- dirname(sys.frame(1)$ofile)
source(file.path(script.dir, "..", "misc", "read-in.R"))

# vector to collect MSE for all datasets
mse.test <- numeric(3)
mse.train <- numeric(3)

# perform lasso regularized regression on training datasets
library(glmnet)

# grid of lambda regularizers to choose from
grid <- 10 ^ seq(10, -2, length=100)

# fit models
X1 <- as.matrix(lhg[ind == 1, 2:ncol(lhg)])
y1 <- lhg[ind == 1, "y"]
model1 <- glmnet(X1, y1, alpha=1, lambda=grid)

X2 <- as.matrix(lphg[ind == 1, 2:ncol(lphg)])
y2 <- lphg[ind == 1, "y"]
model2 <- glmnet(X2, y2, alpha=1, lambda=grid)

X3 <- as.matrix(lshg[ind == 1, 2:ncol(lshg)])
y3 <- lshg[ind == 1, "y"]
model3 <- glmnet(X3, y3, alpha=1, lambda=grid)

# perform cross validation to choose best lambda value from grid
set.seed(1)

cv1 <- cv.glmnet(X1, y1, alpha=1, lambda=grid)
lambda1 <- cv1$lambda.min

cv2 <- cv.glmnet(X2, y2, alpha=1, lambda=grid)
lambda2 <- cv2$lambda.min

cv3 <- cv.glmnet(X3, y3, alpha=1, lambda=grid)
lambda3 <- cv3$lambda.min
# for spruious data, examine coefficients
# the simulated data did not use covariates X10-X19
predict(model3, type="coefficients", s=lambda3)

# now calculate training MSEs
mse.train[1] <- mean((predict(model1, s=lambda1, newx=X1) - y1)^2)
mse.train[2] <- mean((predict(model2, s=lambda2, newx=X2) - y2)^2)
mse.train[3] <- mean((predict(model3, s=lambda3, newx=X3) - y3)^2)

# now calculate testing MSEs
X1 <- as.matrix(lhg[ind == 2, 2:ncol(lhg)])
y1 <- lhg[ind == 2, "y"]

X2 <- as.matrix(lphg[ind == 2, 2:ncol(lphg)])
y2 <- lphg[ind == 2, "y"]

X3 <- as.matrix(lshg[ind == 2, 2:ncol(lshg)])
y3 <- lshg[ind == 2, "y"]

mse.test[1] <- mean((predict(model1, s=lambda1, newx=X1) - y1)^2)
mse.test[2] <- mean((predict(model2, s=lambda2, newx=X2) - y2)^2)
mse.test[3] <- mean((predict(model3, s=lambda3, newx=X3) - y3)^2)

# collect all MSEs and save
file <- h5file(file.path(script.dir, "..", "..", "data", "results.h5"))
file["lasso/data"] <- c("lhg", "lphg", "lshg")
file["lasso/train"] <- mse.train
file["lasso/test"] <- mse.test
h5close(file)
