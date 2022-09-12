##############################################
####### Bootstrap t 检验：几种方法的比较 #######
##############################################
B = 399
DGP <- function(N){
  data = arima.sim(n = N, list(ar = 0.9)) + 10
  return(data)
}
#定义最小二乘回归函数
ols <- function(data){
  n = length(data)
  x = data[1:(n-1)]
  y = data[2:n]
  b = coef(lm(y~x))
  se = coef(summary(lm(y~x)))[, "Std. Error"][2]
  t = (b[2]-0.9)/se
  return(list(coef=b,std_error=se,test=t))
}
#基于学生t分布的p值计算
Student_t <- function(data){
  reg = ols(data) 
  t = reg$test
  p_t = 2*(1-pt(abs(t),(length(data)-1-2)))
  return(p_t)
}
#有约束回归的残差Bootstrap
library(tidyverse)
RR_bootstrap<-function(data){
  n = length(data)
  xx = data[1:(n-1)]
  y = data[2:n]
  b0 = mean(y - xx*0.9)
  e = y - b0 - xx*0.9
  u = sqrt((n-1)/(n-1-2))*e
  t_RR = lapply(
    1:B,
    function(x){
      u_star = sample(u,size=(n-1),replace=TRUE)
      da = arima.sim(n=n-1,list(ar = 0.9),n.start = 1,start.innov = xx[1],innov = u_star) + b0*10
      data_star = c(xx[1],da)
    } %>%
      ols(.) %>%
      .["test"]
    )
  t_RR = unlist(t_RR)
  t = ols(data)$test
  p_RR = sum(abs(t_RR)>abs(t))/B
  return(p_RR)
}
#无约束回归的残差Bootstrap
UR_bootstrap <- function(data){
  n = length(data)
  xx = data[1:(n-1)]
  y = data[2:n]
  reg = ols(data)
  b = reg$coef
  e = y - b[1] - xx*b[2]
  u = sqrt((n-1)/(n-1-2))*e
  data_star=rep(0,n)
  est = lapply(
    1:B,
    function(x){
      data_star[1] = xx[1]
      for (i in 2:n){
        data_star[i] = b[1] + b[2]*data_star[i-1] + sample(u,size=1,replace=TRUE)
      }
      data_star
    } %>%
      ols(.) %>%
      .[c("coef","std_error")]
  )
  t_UR = sapply(est,function(x){(x$coef[2]-b[2])/x$std_error})
  t = reg$test
  p_UR = sum(abs(t_UR)>abs(t))/B
  return(p_UR)
}
#成对抽样Bootstrap
pairs_bootstrap <- function(data){
  n = length(data)
  x = data[1:(n-1)]
  y = data[2:n]
  ss = cbind(x,y)
  reg = ols(data)
  b = reg$coef
  est = lapply(
    1:B,
    function(x){
      ind <- sample(1:(n-1),size=(n-1),replace=TRUE)
      data_star = ss[ind,]
      data_star = as.data.frame(data_star)
    } %>%
      lm(y~x,.)
  )
  t_pairs = sapply(est,function(x){(coef(summary(x))[, "Estimate"][2]-b[2])/coef(summary(x))[, "Std. Error"][2]})
  t = reg$test
  p_pairs=sum(abs(t_pairs)>abs(t))/B
  return(p_pairs)
}
#有约束的Wild Bootstrap
wild_bootstrap <- function(data){
  n = length(data)
  xx = data[1:(n-1)]
  y = data[2:n]
  b0 = mean(y - xx*0.9)
  e = y - b0 - xx*0.9
  hatm = lm.influence(lm(y~xx))$hat
  twopoints = c(1,-1)
  data_star = rep(0,n)
  t_pairs = lapply(
    1:B,
    function(x){
      data_star[1] = xx[1]
      for (i in 2:n){
        data_star[i]=b0+0.9*data_star[i-1]+(e[i]/sqrt(1-hatm[(i-1)]))*sample(twopoints,size=1,replace=TRUE,prob=c(0.5,0.5))
      }
      data_star
    } %>%
      ols(.) %>%
      .["test"]
  )
  t_pairs = unlist(t_pairs)
  t = ols(data)$test
  p_wild=sum(abs(t_pairs)>abs(t))/B
  return(p_wild)
}
#开启并行运算
library(parallel)
clnum<-detectCores() 
cl <- makeCluster(getOption("cl.cores", clnum))

reject_fre <- function(N){
  data = replicate(10000,DGP(N)) 
  p = parApply(cl,data,2,function(x) {
    c(p_t = Student_t(x),p_RR = RR_bootstrap(x),p_UR = UR_bootstrap(x),p_pairs=pairs_bootstrap(x),p_wild=wild_bootstrap(x))
    }
   )
  comp_p = p < 0.05
  return(parApply(cl,comp_p,1,mean))
}

clusterExport(cl, c("B","reject_fre","ols","Student_t","RR_bootstrap","%>%","UR_bootstrap","pairs_bootstrap","wild_bootstrap"))
sample_size <-c(10,14,20,28,40,56,80,113,160,226,320,452,640,905,1280)
rej_fre=sapply(sample_size,reject_fre)
