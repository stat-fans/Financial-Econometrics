library(tidyverse)
library(forecast)
set.seed(20220719)
e <- rnorm(300)
x <- e
for(i in 2:300) x[i] <- x[i-1]+e[i]
x <- as.data.frame(cbind(c(1:300),x))
names(x) <- c("time","position")
rwplot <- x %>%
  ggplot(aes(time,position)) +
  geom_line() 
rwacf <- ggAcf(x$position,50,main="")

ggpubr::ggarrange(rwplot,rwacf, ncol = 2, nrow = 1)