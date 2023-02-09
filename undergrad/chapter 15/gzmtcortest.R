mydata <- readxl::read_xlsx("~/GZMT.xlsx")
library(xts)
price <- xts(as.numeric(mydata$`收盘价(元)`),mydata$日期)
names(price) <- "price"
dlogrt <- quantmod::periodReturn(price,period = 'daily',type = 'log')
Box.test(dlogrt[-1],lag=12,type='Ljung-Box')

