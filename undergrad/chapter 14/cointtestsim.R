set.seed(20230303)
eps <- rnorm(1000,0,1)
eta <- rnorm(1000,0,2)
x <-  eps
y <-  eta
for(i in 2:1000) {
  x[i] <- x[i-1] + eps[i]
  y[i] <- y[i-1] + eta[i]
}
reg_data <- data.frame(x,y)
fit <- lm(y~x, data = reg_data)
fUnitRoots::adfTest(fit$residuals, lags = 21, type = "ct")
tseries::po.test(reg_data[,2:1])
