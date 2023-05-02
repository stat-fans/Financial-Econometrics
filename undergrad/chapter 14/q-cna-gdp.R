mydata <- readxl::read_xlsx("~/Desktop/q-china-GDP.xlsx")
library(tidyverse)
library(forecast)
gdp <- ts(mydata$gdp, start=1992, frequency=4)/10000
autoplot(gdp) + ylab("Quarterly GDP of China") + xlab("Year")
gdp %>% diff(lag = 4) %>% diff() %>% ggtsdisplay()
auto.arima(gdp)
fit <- gdp %>%
  Arima(order=c(1,1,1), seasonal=c(0,1,1)) 
autoplot(fit)
fit %>% forecast(h=12) %>% 
  autoplot(main="12-step ahead Forecast") + ylab("Quarterly GDP of China") + xlab("Year")
