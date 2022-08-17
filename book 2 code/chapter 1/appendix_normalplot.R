mydata <- readxl::read_xlsx("/Users/xuqiuhua/Documents/GitHub/Financial-Econometrics/data/chapter 2/上证指数.xlsx")
date <- as.Date(mydata$时间,"%Y%m%d")
shindex <- xts::xts(mydata$上证指数,date)
names(shindex) <- "wprice"
rtn <- quantmod::periodReturn(shindex,period='weekly',type='log')
rtn <- rtn[-1]
mu <- mean(rtn)
sd <- sd(rtn)
nrx <- seq(min(rtn),max(rtn),by=0.001)
nry <- dnorm(nrx,mu,sd)
normdata <- as.data.frame(cbind(nrx,nry))
library(tidyverse)
rtn %>%
  ggplot(aes(rtn)) + 
  geom_histogram(aes(y = ..density..),fill="yellow",colour="grey30")+
  labs(x = "weekly returns")+
  geom_line(mapping = aes(x=nrx,y=nry),data = normdata,colour="blue")

rtn <- as.numeric(unlist(rtn))
rtn <- as.data.frame(rtn)
ggplot(rtn, aes(sample=rtn)) +
  labs(x = "Normal quantile",y="Quantile of returns")+
  stat_qq(colour="blue") +
  stat_qq_line(colour="red")


library(qqtest)
qqtest(rtn,main="Returns")

