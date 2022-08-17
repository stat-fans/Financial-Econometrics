shindex <- read.table("~/上证指数收益率.csv",sep = ",",header = TRUE)
library(forecast)
Return <- shindex$rtn
ggAcf(Return,10)
Box.test(Return,lag=40,type='Ljung-Box')
