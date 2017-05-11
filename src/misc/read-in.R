# read in datasets
library(h5)
script.dir <- dirname(sys.frame(1)$ofile)

file <- h5file(file.path(script.dir, "..", "..", "data", 
                         "linear-homoscedastic-gaussain.h5"))
lhg <- file["data"][]
h5close(file)

file <- h5file(file.path(script.dir, "..", "..", "data", 
                         "linear-polynomial-homoscedastic-gaussain.h5"))
lphg <- file["data"][]
h5close(file)

file <- h5file(file.path(script.dir, "..", "..", "data", 
                         "linear-spurious-homoscedastic-gaussain.h5"))
lshg <- file["data"][]
h5close(file)

colnames(lhg) <- c("y", paste0("X", 1:(ncol(lhg)-1)))
colnames(lphg) <- c("y", paste0("X", 1:(ncol(lphg)-1)))
colnames(lshg) <- c("y", paste0("X", 1:(ncol(lshg)-1)))

set.seed(1)
ind <- sample(2, nrow(lhg), TRUE, prob=c(0.7, 0.3))
