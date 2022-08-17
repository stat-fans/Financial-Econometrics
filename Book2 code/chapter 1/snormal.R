library(tidyverse)
xx <- seq(-3, 3, by = 0.01)
y_norm <- dnorm(xx)
y_snorm1 <- sn::dsn(xx, xi=0, omega=1,alpha=1)
y_snorm2 <- sn::dsn(xx, xi=0, omega=1,alpha=3)
y_snorm3 <- sn::dsn(xx, xi=0, omega=1,alpha=-3)

dens_plot <- data.frame( "obs" = xx,
                         "Normal" = y_norm,
                         "SNormal1" = y_snorm1,
                         "SNormal2" = y_snorm2,
                         "SNormal3" = y_snorm3) %>%
gather(Distribution, dens, -obs)

library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')

dens_plot %>%
  ggplot(aes(obs, dens)) +
  geom_line(aes(colour=Distribution,linetype=Distribution)) + 
  scale_linetype_discrete(labels=c("Normal (0,1)","SNormal (0,1,1)","SNormal (0,1,3)","SNormal (0,1,-3)")) +
  scale_color_discrete(labels=c("Normal (0,1)","SNormal (0,1,1)","SNormal (0,1,3)","SNormal (0,1,-3)")) +
  labs(x = " ", y=" ") +
  theme(legend.position = "top") 