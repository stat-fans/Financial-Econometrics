shindex <- read.table("~/上证指数收益率.csv",sep = ",",header = TRUE)
library(forecast)
Return <- shindex$rtn
absReturn <- abs(Return) 
Return2 <- Return^2

acf1 <- ggAcf(Return,20,main="上证指数收益率")
acf2 <- ggAcf(absReturn,20,main="上证指数收益率绝对值")
acf3 <- ggAcf(Return2,20,main="上证指数收益率平方")

ggpubr::ggarrange(acf1,acf2,acf3, ncol = 3, nrow = 1)