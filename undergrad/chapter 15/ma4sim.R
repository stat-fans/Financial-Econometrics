set.seed(20230203)
mydata = arima.sim(n=500, list(ma=c(0.7, -0.4, 0.6, 0.8))) 
forecast::ggAcf(mydata,20,main="MA(4) Process")