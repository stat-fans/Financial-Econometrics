mydata <- readxl::read_xlsx("~/GZMT.xlsx")
library(xts)
price <- xts(as.numeric(mydata$`收盘价(元)`),mydata$日期)
names(price) <- "price"
drt <- quantmod::periodReturn(price,period = 'daily',type = 'arithmetic')
wrt <- quantmod::periodReturn(price,period = 'weekly',type = 'arithmetic')
mrt <- quantmod::periodReturn(price,period = 'monthly',type = 'arithmetic')
dlogrt <- quantmod::periodReturn(price,period = 'daily',type = 'log')
wlogrt <- quantmod::periodReturn(price,period = 'weekly',type = 'log')
mlogrt <- quantmod::periodReturn(price,period = 'monthly',type = 'log')
plot(price,main = "daily price")
plot(dlogrt,main = "daily log return")
drt <- as.numeric(drt)
wrt <- as.numeric(wrt)
mrt <- as.numeric(mrt)
dlogrt <- as.numeric(dlogrt)
wlogrt <- as.numeric(wlogrt)
mlogrt <- as.numeric(mlogrt)
dailydata <- cbind.data.frame(drt,dlogrt)
weeklydata <- cbind.data.frame(wrt,wlogrt)
monthlydata <- cbind.data.frame(mrt,mlogrt)

library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')

library(tidyverse)

dfigure <- dailydata %>% 
  ggplot(aes(drt, dlogrt)) +
  geom_point(colour="blue") +
  labs(x = "简单收益率",y="对数收益率",title = "贵州茅台日收益率") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(mapping = aes(x=dlogrt,y=dlogrt),colour="red")

wfigure <- weeklydata %>% 
  ggplot(aes(wrt, wlogrt)) +
  geom_point(colour="blue") +
  labs(x = "简单收益率",y="对数收益率",title = "贵州茅台周收益率") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(mapping = aes(x=wlogrt,y=wlogrt),colour="red")

mfigure <- monthlydata %>% 
  ggplot(aes(mrt, mlogrt)) +
  geom_point(colour="blue") +
  labs(x = "简单收益率",y="对数收益率",title = "贵州茅台月收益率") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_line(mapping = aes(x=mlogrt,y=mlogrt),colour="red")

ggpubr::ggarrange(dfigure, wfigure, mfigure,ncol = 3, nrow = 1)
