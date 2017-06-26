# load libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(tree)
theme_set(theme_classic(base_size=20))

# neural network

# generate data
set.seed(1)

n <- 2000 # number of observations
k <- 10
#X <- matrix(rnorm(n * k, 0, 2), ncol=k) # simulate random input data
X <- matrix(runif(n * k, -5, 5), ncol=k) # simulate random input data

sigmoid <- function(z) {
    return(1 / (1 + exp(-z)))
}

std <- 1.1

sizes <- c(k, 1000, 1000, 1)
num.layers <- length(sizes)
biases <- lapply(sizes[2:length(sizes)], rnorm, sd=std)
weights <- apply(cbind(sizes[1:(num.layers-1)], sizes[2:num.layers]), 1,
                 function(x) matrix(rnorm(x[2] * x[1], sd=std), x[2], x[1]))

feedforward <- function(a, biases, weights) {
    for (layer in mapply(list, biases, weights, SIMPLIFY=FALSE)) {
        b <- layer[[1]]
        w <- layer[[2]]
        
        a <- sigmoid(w %*% a + b)
    }
    
    return(a)
}

f <- apply(X, 1, feedforward, biases, weights)
f <- log(f / (1 - f))
y <- rnorm(n, f, 5)

mod.lm <- lm(y ~ X)
pred.lm <- predict(mod.lm)

mod.tree <- tree(y ~ X)#, control=tree.control(n, mindev=1e-5))
cv.mod <- cv.tree(mod.tree)
plot(cv.mod$size, cv.mod$dev)
pred.tree <- predict(mod.tree)

plot(pred.lm, f)
plot(pred.tree, f)

mean((pred.lm - f) ^ 2)
mean((pred.tree - f) ^ 2)

# 2d nonlinear function
set.seed(1)

n <- 2000 # number of observations
k <- 2
#X <- matrix(rnorm(n * k, 0, 2), ncol=k) # simulate random input data
X <- matrix(runif(n * k, -5, 5), ncol=k) # simulate random input data

f <- sin(X[, 2] / ((X[, 1])^2 + 1e-5))
y <- rnorm(n, f, 0.1)

mod.lm <- lm(y ~ X)
pred.lm <- predict(mod.lm)

mod.tree <- tree(y ~ X)
cv <- cv.tree(mod.tree)
plot(cv)
pred.tree <- predict(mod.tree)

mean((pred.lm - y)^2)
mean((pred.tree - y)^2)
