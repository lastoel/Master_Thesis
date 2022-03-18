#optmatch documentation trial

data(nuclearplants)
match_on.examples <- list()
### Propensity score distances.
### Recommended approach:
(aGlm <- glm(pr~.-(pr+cost), family=binomial(), data=nuclearplants))
match_on.examples$ps1 <- match_on(aGlm)

### A second approach: first extract propensity scores, then separately
### create a distance from them.  (Useful when importing propensity
### scores from an external program.)
plantsPS <- predict(aGlm, type = "response")
match_on.examples$ps2 <- match_on(pr~plantsPS, data=nuclearplants)

str(match_on.examples$ps2)

### Full matching on the propensity score.
fm1 <- fullmatch(match_on.examples$ps1, data = nuclearplants)
fm2 <- fullmatch(match_on.examples$ps2, data = nuclearplants)
### Because match_on.glm uses robust estimates of spread,
### the results differ in detail -- but they are close enough
### to yield similar optimal matches.
all(fm1 == fm2) # The same

print(fm2, paired = T)
nuke.matched <- cbind(nuclearplants, matches = fm2)


# on my data:
iter1 <- prop_scores[1,]
str(iter1)
str(plantsPS)


matchobj <- match_on(group ~ iter1, data = step1_dat)
options("optmatch_max_problem_size" = Inf)
optfullmatch <- fullmatch(matchobj, data = step1_dat)


### code from github ### https://github.com/markmfredrickson/optmatch

set.seed(20120111) # set this to get the exact same answers as I do
n <- 26 # chosen so we can divide the alphabet in half
W <- data.frame(w1 = rbeta(n, 4, 2), w2 = rbinom(n, 1, p = .33))

# nature assigns to treatment
tmp <- numeric(n)
tmp[sample(1:n, prob = W$w1^(1 + W$w2), size = n/2)] <- 1
W$z <- tmp

# for convenience, let's give the treated units capital letter names
tmp <- character(n)
tmp[W$z == 1] <- LETTERS[1:(n/2)]
tmp[W$z == 0] <- letters[(26 - n/2 + 1):26]
rownames(W) <- tmp

#illustrate imbalance on covariates: 
table(W$w2, W$z)
library(lattice) ; densityplot(W$w1, groups = W$z)

#Let's begin with a simple EUCLIDEAN distance on the space defined by W:
distances <- list()
distances$euclid <- match_on(z ~ w1 + w2, data = W, method = "euclidean")
str(distances$euclid)

#The default method extends the simple Euclidean distance by rescaling the distances by the covariance of the variables, the MAHALANOBIS distance:
distances$mahal <- match_on(z ~ w1 + w2, data = W)

#To create distances, we could also try regressing the treatment indicator on the covariates and computing the difference distance for each treated and control pair. PROPSENSITY SCORES
propensity.model <- glm(z ~ w1 + w2, data = W, family = binomial())
distances$propensity <- match_on(propensity.model)

#combine all 3 methods into 1 distance estimate. We can combine these distances into single metric using standard arithmetic functions:
distances$all <- with(distances, euclid + mahal + propensity)

#SOMETHING ABOUT CALIPERS, MIGHT BE HANDY IF MY PROBLEM IS TOO LARGE, NOT NOW.

#Generating the match
matched <- lapply(distances, function(x) { fullmatch(x, data = W) })

#The result of the matching process is a named factor, where the names correspond to the units (both treated and control) and the levels of the factors are the matched groups. Including the data argument is highly recommended. This argument will make sure that the result of fullmatch will be in the same order as the original data.frame that was used to build the distance specification. This will make appending the results of fullmatch on to the original data.frame much more convenient.

#Once one has generated a match, you may wish to view the results. The results of calls to fullmatch or pairmatch produce optmatch objects (specialized factors). This object has a special option to the print method which groups the units by factor level:
mahal.match <- pairmatch(distances$mahal, data = W)
print(mahal.match, grouped = T)
print(matched, grouped = T)

#If you wish to join the match factor back to the original data.frame:
W.matched <- cbind(W, matched = mahal.match)
