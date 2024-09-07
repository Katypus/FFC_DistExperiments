##
## Imputation stage
## 
## we use Amelia to imputa variables


## ***************************************************** ##
## please manually set the working directory to 
## ~/.../.../Replication
##
## ***************************************************** ##

# load package
require(Amelia)

# set.seed
set.seed(2018)

# --------------------------------- #
# load data to be imputed
# --------------------------------- #
load('new_d3.RData')

# --------------------------------- #
# carry out imputation
# check arguments!!
# --------------------------------- #
a.out.more <- amelia(new_d3, m = 1, idvars = "challengeID", empri = 01*nrow(new_d3),
                      parallel = "multicore", ncpus = 7)

# --------------------------------- #
# save outcomes
# --------------------------------- #
save(a.out.more, file = "imputed.RData")

# View(a.out.more$imputations$imp3)
