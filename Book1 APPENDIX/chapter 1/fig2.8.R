library(MASS)
set.seed(9)
mu    = c(0, 0)
Sig   = matrix(c(1 ,0, 0, 0.1), 2, 2)
n     = 200
biv1  = mvrnorm(n, mu, Sig)
colnames(biv1) = c("x1","x2")
biv1 = as.data.frame(biv1)
library(tidyverse)

biv1 %>%
  ggplot(aes(x=x1,y=x2)) + 
  geom_point(colour="red",alpha = 0.4)+
  #labs(x = TeX("$x_{1}$"),y= TeX("$x_{2}$"))+
  labs(x = expression(x[1]),y= expression(x[2]))+
  ylim(-2,2)+
  geom_point(aes(x=0, y=0), colour="blue",shape=3)+
  geom_point(aes(x=0.5, y=0.5), colour="blue",shape=8)+
  annotate("text", x = 0.42, y = 0.6, label = "P",fontface = "italic",colour="blue")

