set.seed(20230206) 
mydata = arima.sim(n=100, list(ar=c(0.5,0.24,0.2,-0.8))) 
forecast::ggPacf(mydata,20,main="AR(4) Process")