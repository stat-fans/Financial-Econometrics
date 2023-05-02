set.seed(20230303)
eps <- rnorm(300)
eta <- rnorm(300)
x <- -0.1 + eps
y <- 0.2 + eta
tt <- 1:300
for(i in 2:300) {
  x[i] <- -0.1*tt[i] + 0.1*x[i-1] + eps[i]
  y[i] <- 0.2*tt[i] + 0.7*y[i-1] + eta[i]
}
reg_data <- data.frame(x,y,tt)
fit <- lm(y~x,data = reg_data)
summary(fit)

fit2 <- lm(y~x+tt, data = reg_data)
summary(fit2)
