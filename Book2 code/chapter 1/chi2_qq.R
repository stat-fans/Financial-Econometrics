library(MASS)
mu    = c(0,1)
Sig   = matrix(c(1, 0.6, 0.6, 1), 2, 2)
n     = 5000
set.seed(1234)
biv   = MASS::mvrnorm(n, mu, Sig)
Sbiv  = cov(biv)
D2    = mahalanobis(biv, colMeans(biv), Sbiv)

D2 <- as.data.frame(D2)


ggplot(D2, aes(sample=D2)) +
  labs(x = "Theoretical quantile",y="Quantile of Distance")+
  stat_qq(distribution = stats::qchisq,dparams=2,colour="blue") +
  stat_qq_line(distribution = stats::qchisq,dparams=2,colour="red")

