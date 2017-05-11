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

set.seed(1)
ind <- sample(2, nrow(lhg), TRUE, prob=c(0.7, 0.3))
