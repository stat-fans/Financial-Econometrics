mydata <- readxl::read_xlsx("~/贵州茅台.xlsx")
date <- as.Date(mydata$Date,"%Y%m%d")
gzmt <- xts::xts(mydata$close,date)
library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')
plot(gzmt,main="贵州茅台日收盘价")

mydata2 <- readxl::read_xlsx("~/全社会用电量.xlsx")
date <- as.Date(mydata2$date,"%Y%m%d")
pp <- xts::xts(mydata2$power,date)
pps <- pp["2018/2021"]/10000
library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')
plot(pps,main="全社会用电量（单位：亿千瓦时）",type="o",ylim = c(4000,9000))