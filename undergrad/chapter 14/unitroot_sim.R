set.seed(20230227)
e <- rnorm(1000)
x <- e
for(i in 2:1000) x[i] <- 0.1+x[i-1]+e[i]
mydata = data.frame(c(1:1000),x)
names(mydata) <- c("time","y")
library(tidyverse)
p1 <- mydata %>%
  ggplot() + geom_line(aes(x = time, y = y)) +
  xlab("Time") + ylab("Simulated Data")
p2<-forecast::ggAcf(mydata$y,20,main="ACF Plot")
ggpubr::ggarrange(p1, p2,ncol = 2, nrow = 1)