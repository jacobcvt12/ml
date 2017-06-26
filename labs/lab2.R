# install libraries
install.packages("tree")
install.packages("ISLR")

# load libraries
library(tree) # libary for fitting CART
library(ISLR) # library containing datasets
library(MASS) # another library for a dataset

# classification tree example
head(Carseats) # inspect datasets
help(Carseats) # view documentation on dataset

# create binary variable based on sales (in thousands)
Carseats$High <- as.factor(ifelse(Carseats$Sales <= 8, "No", "Yes"))

# drop the Sales variables
Carseats <- subset(Carseats, select=-Sales)
head(Carseats) # inspect dataset again

# split dataset into training and test
set.seed(1)
train <- sample(1:nrow(Carseats), 200)
test <- Carseats[-train, ]

# fit a logistic regression to all variables
logit <- glm(High ~ ., family=binomial, data=Carseats, subset=train)
summary(logit) # view model summary

# fit a classification tree to all variables
class <- tree(High ~ ., data=Carseats, subset=train)
summary(class) # view summary of tree
plot(class) # plot tree
text(class) # add text to tree

# perform cross validation to prune tree
cv.class <- cv.tree(class, FUN=prune.misclass)
plot(cv.class$size, cv.class$dev)
data.frame(size=cv.class$size,
           deviance=cv.class$dev)

prune.class <- prune.misclass(class, best=20) # change this number!!

# check predictions on testing data
table(predict(class, test, type="class"), test$High)
table(predict(prune.class, test, type="class"), test$High)

logit.prob <- predict(logit, test, type="response")
logit.pred <- ifelse(logit.prob < 0.5, "No", "Yes")
table(logit.pred, test$High)

# now let's overfit a classification tree
# see confusion matrix for previous model
table(predict(class, type="class"), Carseats[train, ]$High)
# fit tree that grows until perfect fit on training data
class <- tree(High ~ ., data=Carseats, subset=train, 
              control=tree.control(200, minsize=2, mindev=0))
# see "perfect" training data confusion matrix
table(predict(class, type="class"), Carseats[train, ]$High)
plot(class)
text(class)
table(predict(class, test, type="class"), test$High)
cv.class <- cv.tree(class, FUN=prune.misclass)
plot(cv.class$size, cv.class$dev)
data.frame(size=cv.class$size,
           deviance=cv.class$dev)
prune.class <- prune.misclass(class, best=20) # change this number!!
plot(prune.class)
text(prune.class)
table(predict(prune.class, test, type="class"), test$High)

# fit a regression tree
head(Boston) # inspect dataset
help(Boston) # get dataset documentation

# split dataset into training and test
train <- sample(1:nrow(Boston), nrow(Boston) / 2)
test <- Boston[-train, ]

# fit linear regression using all covariates
lin <- lm(medv ~ ., Boston, subset=train)
summary(lin) # view model

# fit a regression tree to all variables
regress <- tree(medv ~ ., Boston, subset=train)
summary(regress) # view summary of tree
plot(regress) # plot tree
text(regress) # add text to tree

# perform cross validation to prune tree
cv.regress <- cv.tree(regress)
plot(cv.regress$size, cv.regress$dev)
data.frame(size=cv.regress$size,
           deviance=cv.regress$dev)

prune.regress <- prune.tree(regress, best=7) # change this number!!

# check mean squared error of three models
yhat.tree <- predict(regress, test)
yhat.prune <- predict(prune.regress, test)
yhat.lin <- predict(lin, test)

mean((yhat.tree - test$medv) ^ 2)
mean((yhat.prune - test$medv) ^ 2)
mean((yhat.lin - test$medv) ^ 2)

