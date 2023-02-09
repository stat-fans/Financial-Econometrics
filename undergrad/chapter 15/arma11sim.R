set.seed(20230204)
mydata <- arima.sim(n = 500, list(ar = c(0.8), ma = c(-0.5)))
forecast::ggAcf(mydata,20,main="ARMA(1,1) Process")
forecast::ggPacf(mydata,20,main="ARMA(1,1) Process")

