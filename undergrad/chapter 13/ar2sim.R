set.seed(20230203) #设置随机种子
mydata = arima.sim(n=1000, list(ar=c(0.6, -0.4))) 
forecast::ggAcf(mydata,20,main="AR(2) Process")
library(tidyverse)
mydata %>%
  ggplot() +
  geom_line(aes(x = x, y = mydata)) +
  xlab("Time")
library(UnitCircle)
uc.check(pol_ = c(1,-0.6,0.4), plot_output = TRUE)


