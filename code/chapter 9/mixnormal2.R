library(tidyverse)
set.seed(123)
xx <- seq(-3, 3, by = 0.01)
y_mix1 <- 0.2*dnorm(xx)+0.2*dnorm(xx,0.5,2/3)+0.6*dnorm(xx,13/12,5/9)
y_mix2 <- 0.75*dnorm(xx)+0.25*dnorm(xx,3/2,1/3)
y_mix3 <- (9/20)*dnorm(xx,-6/5,3/5)+(9/20)*dnorm(xx,6/5,3/5)+0.1*dnorm(xx,0,1/4)

dens_plot <- data.frame( "obs" = xx,
                         "Mix1" = y_mix1,
                         "Mix2" = y_mix2,
                         "Mix3" = y_mix3) %>%
  gather(Distribution, dens, -obs)

library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')

dens_plot %>%
  ggplot(aes(obs, dens)) +
  geom_line(aes(colour=Distribution,linetype=Distribution)) +
  scale_linetype_discrete(labels=c("单峰有偏","双峰有偏","三峰")) +
  scale_color_discrete(labels=c("单峰有偏","双峰有偏","三峰")) +
  labs(x = " ", y=" ") +
  theme(legend.position = "top") 