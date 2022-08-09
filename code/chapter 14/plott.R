library(tidyverse)
xx <- seq(-3, 3, by = 0.01)
y_norm <- dnorm(xx) 
y_t5 <- dt(xx,5) 
y_t2 <- dt(xx,2)
y_t1 <- dt(xx,1)
dens_plot <- data.frame( "obs" = xx,
                         "Normal" = y_norm,
                         "t5" = y_t5,
                         "t2" = y_t2,
                         "t1" = y_t1) %>%
  gather(Distribution, dens, -obs)

library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')

dens_plot %>%
  ggplot(aes(obs, dens)) +
  geom_line(aes(colour=Distribution,linetype=Distribution)) + 
  scale_linetype_discrete(labels=c("Normal (0,1)",expression(t[1]),expression(t[2]),expression(t[5]))) +
  scale_color_discrete(labels=c("Normal (0,1)",expression(t[1]),expression(t[2]),expression(t[5]))) +
  labs(x = " ", y=" ") +
  theme(legend.position = "top") 