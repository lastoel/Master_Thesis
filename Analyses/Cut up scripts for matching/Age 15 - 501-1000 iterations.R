#Age 15 - 501-1000 iterations

set.seed(123)

#load in data
load("~/GitHub/Master_Thesis/Analyses/Workspaces/step1_dat.Rdata")
load("~/GitHub/Master_Thesis/Analyses/Workspaces/prop_scores_15.Rdata")

#Libraries
require(devtools)
remotes::install_github("markmfredrickson/optmatch")
library(optmatch) #for optimal full matching algorithm used in MatchIt package
library(MatchIt)
library(doSNOW) #for parallel computation
library(haven) #still necessary for working with step1_dat format


# a. Match sub-samples based on each of m.iter sets of propensity scores - USING FULLMATCH

## ON AGE =< 15
gc() #clean out unused memory
nclust <- parallel::detectCores() - 1
cl <- makeCluster(nclust)
registerDoSNOW(cl)

#add progress bar
pb <- txtProgressBar(min = 0, max = 500, style = 3)
opts <- list(progress = function(n) setTxtProgressBar(pb,n))

#export objects to newly created R seshs
clusterExport(cl, c('step1_dat'))
clusterEvalQ(cl, {(library("optmatch"))})
clusterEvalQ(cl, {(library("MatchIt"))})

start_time <- Sys.time()

fullmatches_p15_1000 <-
  foreach(i = 501:1000,
          .options.snow = opts,
          .packages = c("MatchIt", "optmatch") #export necessary packages to clusters
  ) %dopar% {
    
    matchit(
      group15 ~ as.factor(Gender) + AGE + GRADE + ISCEDL + ESCS + as.factor(Language),
      distance = prop_scores_15[i, ], #input propensity scores here
      method = "full", #fullmatch method
      estimand = "ATE", #use Average Treatment Effect
      include.obj = TRUE, #include output of the call to optmatch::fullmatch in output
      data = step1_dat, 
    )
  }

end_time <- Sys.time()

stopCluster(cl)

#Outcome and computation time - AGE 15
comptime_fullmatch_p15_1000 <- end_time - start_time  
obj.size_fullmatch_p15_1000 <- object.size(fullmatches_p15_1000)

#create dataset age =< 15
fullmatchdat_p15_1000 <- lapply(fullmatches_p15_1000, function(x) {match.data(x, group = "all", distance = "prop.score", data = step1_dat, drop.unmatched = T)})

#save dataset age =< 15
save(fullmatchdat_p15_1000, file = "Workspaces/fullmatchdat_p15_1000.Rdata")
