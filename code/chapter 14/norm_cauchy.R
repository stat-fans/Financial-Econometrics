library(tidyverse)
xx <- seq(-3, 3, by = 0.01)
y_norm <- dnorm(xx) 
y_cauchy <- dcauchy(xx,location=0,scale = 1) 
dens_plot <- data.frame( "obs" = xx,
                         "Normal" = y_norm,
                         "Cauchy" = y_cauchy) %>%
gather(Distribution, dens, -obs)

library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')

dens_plot %>%
  ggplot(aes(obs, dens)) +
  geom_line(aes(colour=Distribution,linetype=Distribution)) + 
  scale_linetype_discrete(labels=c("Cauchy (0,1)","Normal (0,1)")) +
  scale_color_discrete(labels=c("Cauchy (0,1)","Normal (0,1)")) +
  labs(x = " ", y=" ") +
  theme(legend.position = "top") 