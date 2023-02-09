set.seed(20230202) #设置随机种子
mydata = arima.sim(n=1000, list(ar=0.8)) 
forecast::ggAcf(mydata,20,main="AR(1) Process with positive parameter")
library(tidyverse)
mydata %>%
  ggplot() +
  geom_line(aes(x = x, y = mydata)) +
  xlab("Time")	

mydata2 = arima.sim(n=1000, list(ar=-0.8)) 
forecast::ggAcf(mydata2,20,main="AR(1) Process with negative parameter")
library(tidyverse)
mydata2 %>%
  ggplot() +
  geom_line(aes(x = x, y = mydata2)) +
  xlab("Time")