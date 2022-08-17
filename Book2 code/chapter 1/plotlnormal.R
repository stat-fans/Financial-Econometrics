library(tidyverse)
x_dlnorm <- seq(0, 3, by = 0.01)
y_dlnorm <- dlnorm(x_dlnorm) 
y_dlnorm2 <- dlnorm(x_dlnorm,sdlog = 0.5) 
y_dlnorm3 <- dlnorm(x_dlnorm,sdlog = 1/4) 
dens_plot <- data.frame( "obs" = x_dlnorm,
                         "sd1" = y_dlnorm,
                          "sd.5" = y_dlnorm2,
                          "sd.25" = y_dlnorm3 ) %>%
gather(Lognormal, dens, -obs)

library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')

dens_plot %>%
  ggplot(aes(obs, dens)) +
  geom_line(aes(colour=Lognormal,linetype=Lognormal)) + 
  scale_linetype_discrete(labels=c(expression(paste(sigma, " = 1/4")),expression(paste(sigma, " = 1/2")),expression(paste(sigma, " = 1"))))+
  scale_color_discrete(labels=c(expression(paste(sigma, " = 1/4")),expression(paste(sigma, " = 1/2")),expression(paste(sigma, " = 1"))))+
  labs(x = " ", y="对数正态密度") +
  theme(legend.position = "top") 

  # guides(color=guide_legend(title = "Lognoraml"))+
  # guides(linetype=guide_legend(title = "Lognoraml"))

  
  
  