library(ISLR2)
library(tidyverse)
default_x <- Default %>%
  dplyr::mutate(cons = replicate(dim(Default)[1],1)) %>%
  dplyr::select(c(cons,balance,income))

default_y <- ifelse(as.character(Default[,"default"])=="Yes",1,0)

X = as.matrix(default_x)
Y = as.matrix(default_y)

logistic <- function(beta){
  return(1/(1+exp(-X%*%beta)))
}


llk <- function(beta){
  return(-sum(Y*log(logistic(beta))+(1-Y)*log(1-logistic(beta))))
}

opt = nlminb(c(0,0,0),llk,hessian = T)
library(numDeriv)
hatbeta = opt$par
names(hatbeta) = c("beta0","beta1","beta2")
hess = hessian(llk,hatbeta,method.args=list(d=0.025))
se = sqrt(diag(solve(hess)))
print(cbind(hatbeta,se))

summary(glm(default ~ balance + income, data = Default, family=binomial(link="logit")))
