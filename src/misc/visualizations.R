# libraries
library(dplyr)
library(tidyr)
library(ggplot2)

# read in MSE results
script.dir <- dirname(sys.frame(1)$ofile)
file <- h5file(file.path(script.dir, "..", "..", "data", "results.h5"))

models <- list.groups(file)
d <- setNames(vector("list", length(models)), sub("/", "", models))

for (model in models) {
    data <- file[paste0(model, "/data")][]
    train <- file[paste0(model, "/train")][]
    test <- file[paste0(model, "/test")][]
    
    tmp <- data_frame(dataset=data,
                      train=train,
                      test=test)
    d[[sub("/", "", model)]] <- tmp
}

h5close(file)

dict1 <- list("test"="Test",
              "train"="Train")

dict2 <- list("lhg"="Simple Linear",
              "lphg"="Nonlinear Polynomial",
              "lshg"="Spurious Linear")

dict3 <- list("lasso"="Lasso",
              "lm"="Linear Model",
              "rf"="Random Forest")

d <- bind_rows(d, .id="model") %>% 
    gather(key, value, train:test) %>% 
    mutate(key=unlist(dict1[key]),
           dataset=unlist(dict2[dataset]),
           model=unlist(dict3[model]))

ggplot(d, aes(x=model, y=value)) +
    geom_point(aes(colour=model)) +
    xlab("Model") +
    ylab("MSE") +
    guides(colour=FALSE) +
    scale_y_log10() + 
    facet_grid(dataset ~ key, scales = "free_y")
