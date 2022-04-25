#Age 12 - 1-1000 iterations

set.seed(123)

#load in data
load("~/GitHub/Master_Thesis/Analyses/Workspaces/step1_dat.Rdata")
load("~/GitHub/Master_Thesis/Analyses/Workspaces/prop_scores_12.Rdata")

#Libraries
require(devtools)
remotes::install_github("markmfredrickson/optmatch")
library(optmatch) #for optimal full matching algorithm used in MatchIt package
library(MatchIt)
library(doSNOW) #for parallel computation
library(haven) #still necessary for working with step1_dat format


# a. Match sub-samples based on each of m.iter sets of propensity scores - USING FULLMATCH

## ON AGE =< 12
gc() #clean out unused memory
nclust <- parallel::detectCores() - 1
cl <- makeCluster(nclust)
registerDoSNOW(cl)

#add progress bar
pb <- txtProgressBar(min = 0, max = 1000, style = 3)
opts <- list(progress = function(n) setTxtProgressBar(pb,n))

#export objects to newly created R seshs
clusterExport(cl, c('step1_dat'))
clusterEvalQ(cl, {(library("optmatch"))})
clusterEvalQ(cl, {(library("MatchIt"))})

start_time <- Sys.time()

fullmatches_p12 <-
  foreach(i = 1:1000,
          .options.snow = opts,
          .packages = c("MatchIt", "optmatch") #export necessary packages to clusters
  ) %dopar% {
    
    matchit(
      group12 ~ as.factor(Gender) + AGE + GRADE + ISCEDL + ESCS + as.factor(Language),
      distance = prop_scores_12[i, ], #input propensity scores here
      method = "full", #fullmatch method
      estimand = "ATE", #use Average Treatment Effect
      include.obj = TRUE, #include output of the call to optmatch::fullmatch in output
      data = step1_dat, 
    )
  }

end_time <- Sys.time()

stopCluster(cl)

#Outcome and computation time - AGE 12
comptime_fullmatch_p12 <- end_time - start_time  
obj.size_fullmatch_p12 <- object.size(fullmatches_p12) 

#create dataset age =< 12
fullmatchdat_p12 <- lapply(fullmatches_p12, function(x) {match.data(x, group = "all", distance = "prop.score", data = step1_dat, drop.unmatched = T)})

#save dataset age =< 12
save(fullmatchdat_p12, file = "Workspaces/fullmatchdat_p12.Rdata")