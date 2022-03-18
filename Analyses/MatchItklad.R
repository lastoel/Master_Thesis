#MatchIt trial

library(MatchIt)
??MatchIt

library("MatchIt")
data("lalonde")

head(lalonde)

# No matching; constructing a pre-match matchit object
m.out0 <- matchit(treat ~ age + educ + race + married + 
                    nodegree + re74 + re75, data = lalonde,
                  method = NULL, distance = "glm")
# Checking balance prior to matching
summary(m.out0)

# 1:1 NN PS matching w/o replacement
m.out1 <- matchit(treat ~ age + educ + race + married + 
                    nodegree + re74 + re75, data = lalonde,
                  method = "nearest", distance = "glm")
m.out1
# Checking balance after NN matching
summary(m.out1, un = FALSE)
plot(m.out1, type = "jitter", interactive = FALSE)
plot(m.out1, type = "qq", interactive = FALSE,
     which.xs = c("age", "married", "re75"))

# Full matching on a probit PS
m.out2 <- matchit(treat ~ age + educ + race + married + 
                    nodegree + re74 + re75, data = lalonde,
                  method = "full", distance = "glm", link = "probit")
m.out2

# Checking balance after full matching
summary(m.out2, un = FALSE)

plot(summary(m.out2))
