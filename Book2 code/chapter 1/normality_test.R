mydata <- readxl::read_xlsx("/Users/xuqiuhua/Documents/GitHub/Financial-Econometrics/data/chapter 2/上证指数.xlsx")
date <- as.Date(mydata$时间,"%Y%m%d")
shindex <- xts::xts(mydata$上证指数,date)
names(shindex) <- "wprice"
rtn <- quantmod::periodReturn(shindex,period='weekly',type='log')
rtn <- rtn[-1]

#JB test
library(fBasics)
normalTest(rtn,method='jb')

#Shapiro-Wilk test
rtn = as.numeric(rtn)
shapiro.test(rtn)

#Anderson-Darling test
nortest::ad.test(rtn)

#Cramer-von Mises test
nortest::cvm.test(rtn)

#Kolmogorov-Smirnov test
nortest::lillie.test(rtn)
