mydata <- readxl::read_xlsx("~/Desktop/q-china-GDP.xlsx")
library(tidyverse)
library(forecast)
gdp <- ts(mydata$gdp, start=1992, frequency=4)/10000
preD <- matrix(1:8, ncol=1)
u <- preD
l <- preD
N = length(gdp)-8
for(i in 1:8) {
  optm = auto.arima(gdp[i:N])
  m.curr <- arima(gdp[i:N], order = c(optm$arma[1],optm$arma[6],optm$arma[2]), seasonal = list(order=c(optm$arma[3],optm$arma[7],optm$arma[4]),period=optm$arma[5]))
  m.pred <- forecast(m.curr, h=1)
  preD[i] <- m.pred$mean[1]
  u[i] <- m.pred$upper[1,2]
  l[i] <- m.pred$lower[1,2]
  N=N+1
}
save.res <- data.frame(x = mydata$time[(length(gdp)-7):length(gdp)],
           y1 = preD, y2 = gdp[(length(gdp)-7):length(gdp)], y3=l,y4=u)

save.res %>% 
  ggplot(aes(x)) + 
  geom_line(aes(y = y1, colour = "y1", linetype = "y1")) +
  geom_line(aes(y = y2, colour = "y2", linetype = "y2")) +
  geom_line(aes(y = y3, colour = "y3", linetype = "y3")) +
  geom_line(aes(y = y4, colour = "y4", linetype = "y4")) +
  geom_point(aes(y = y1, colour = "y1", shape = "y1"), size = 3) +
  geom_point(aes(y = y2, colour = "y2", shape = "y2"), size = 3) +
  geom_point(aes(y = y3, colour = "y3", shape = "y3"), size = 3) +
  geom_point(aes(y = y4, colour = "y4", shape = "y4"), size = 3) +
  scale_colour_manual(values = c("y1" = "red", "y2" = "blue", "y3" = "brown", "y4" = "brown")) +
  scale_linetype_manual(values = c("y1" = "dashed", "y2" = "solid", "y3" = "dotted", "y4" = "dotted")) +
  scale_shape_manual(values = c("y1" = 0, "y2" = 1)) +
  labs(title = "Rolling-window 1-step ahead forecast",
       x = "Time",
       y = "Quarterly GDP of China") +
  theme(legend.position = "none")
  
