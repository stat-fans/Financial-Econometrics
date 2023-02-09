set.seed(20230201)
mydata = arima.sim(n=500, list(ma=c(0.7, -0.4)))+2
forecast::ggAcf(mydata,20,main="MA(2) Process")
library(tidyverse)
mydata %>%
  ggplot() +
  geom_line(aes(x = x, y = mydata)) +
  xlab("Time")
  
