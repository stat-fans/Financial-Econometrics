set.seed(20230204)
x <- arima.sim(n=1000,list(ar=c(0.5, -0.25, 0.4), ma=c(0.5, -0.3))) 
final.bic <- Inf
final.order <- c(0,0,0)
for (i in 0:4) for (j in 0:4) {
  current.bic <- BIC(arima(x, order=c(i, 0, j))) 
  if (current.bic < final.bic) {
    final.bic <- current.bic
    final.order <- c(i, 0, j)
    final.arma <- arima(x, order=final.order)
  } }
final.order

forecast::auto.arima(x,max.p = 4,max.q = 4,ic = "bic")