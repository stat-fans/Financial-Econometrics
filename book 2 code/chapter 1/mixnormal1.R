library(tidyverse)
set.seed(123)
xx <- seq(-10, 10, by = 0.01)
y_norm1 <- dnorm(xx) 
y_norm.25 <- dnorm(xx,0,0.5) 
y_norm25 <- dnorm(xx,0,5)
y_mix <- 0.5*dnorm(xx)+0.4*dnorm(xx,sd=0.5)+0.1*dnorm(xx,0,5)

dens_plot <- data.frame( "obs" = xx,
                         "Normal1" = y_norm1,
                         "Normal2" = y_norm.25,
                         "Normal3" = y_norm25,
                         "Mixture Normal" = y_mix) %>%
  gather(Distribution, dens, -obs)

dens_plot %>%
  ggplot(aes(obs, dens)) +
  geom_line(aes(colour=Distribution,linetype=Distribution)) +
  scale_linetype_discrete(labels=c("Mixture Normal","Normal (0,1)","Normal (0,0.25)","Normal (0,25)")) +
  scale_color_discrete(labels=c("Mixture Normal","Normal (0,1)","Normal (0,0.25)","Normal (0,25)")) +
  labs(x = " ", y=" ") +
  theme(legend.position = "top") 