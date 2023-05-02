set.seed(20230304)
eps <- rnorm(1000,0,1)
eta <- rnorm(1000,0,2)
x <-  eps
y <-  eta
tt <- c(1:1000)
for(i in 2:1000) {
  x[i] <- x[i-1] + eps[i]
  y[i] <- y[i-1] + eta[i]
}
reg_data <- data.frame(x,y,tt)
fit <- lm(y~x,data = reg_data)
summary(fit)

fit2 <- lm(y~x+tt, data = reg_data)
summary(fit2)
