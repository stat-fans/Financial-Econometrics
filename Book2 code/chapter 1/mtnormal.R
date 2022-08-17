mydata <- readxl::read_xlsx("~/GZMT.xlsx")
price <- xts::xts(as.numeric(mydata$`收盘价(元)`),mydata$日期)
names(price) <- "price"
dlogrt <- quantmod::periodReturn(price,period = 'daily',type = 'log')
library(fBasics)
s3 = skewness(dlogrt)
s3
samplesize = length(dlogrt) 
t3 = s3/sqrt(6/samplesize)
pp3 = 2*(pnorm(t3))
pp3

s4 = kurtosis(dlogrt, method = "excess")
s4
t4 = s4/sqrt(24/samplesize)
pp4 = 2*(1-pnorm(t4))
pp4

shapiro.test(as.numeric(dlogrt))

mu <- mean(dlogrt)
sd <- sd(dlogrt)
nrx <- seq(min(dlogrt),max(dlogrt),by=0.001)
nry <- dnorm(nrx,mu,sd)
normdata <- as.data.frame(cbind(nrx,nry))
library(tidyverse)
hist1 <- dlogrt %>%
  ggplot(aes(dlogrt)) + 
  geom_histogram(aes(y = ..density..),fill="yellow",colour="grey30")+
  labs(x = "贵州茅台对数收益率")+
  geom_line(mapping = aes(x=nrx,y=nry),data = normdata,colour="blue")

rtn <- as.numeric(unlist(dlogrt))
rtn <- as.data.frame(rtn)
qqplot2 <- ggplot(rtn, aes(sample=rtn)) +
  labs(x = "Normal quantile",y="Quantile of returns")+
  stat_qq(colour="blue") +
  stat_qq_line(colour="red")

ggpubr::ggarrange(hist1, qqplot2, ncol = 2, nrow = 1)
