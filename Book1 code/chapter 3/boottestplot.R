library(tidyverse)
library(readxl)
data = read_excel("/Users/xuqiuhua/Documents/GitHub/Financial-Econometrics/Book1 code/chapter 3/Bootstrap_result.xlsx")
data = tibble(
  sample_size = as.factor(c(10,14,20,28,40,56,80,113,160,226,320,452,640,905,1280)),
  data
)
names(data) <- c("sample_size","t","RR", "UR","Pairs","Wild")
library(showtext)
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')
plottitle <- expression(paste("五种 ", italic('t')," 检验小样本性质的比较"))
data %>%
  ggplot(aes(x=sample_size)) +
  geom_point(aes(y=t,group=1,color="t"),shape=15,size=2,show.legend = TRUE)+
  geom_line(aes(y=RR,group=1,color="RR"),linetype = "dotted",size=1,show.legend = TRUE)+
  geom_line(aes(y=UR,group=1,color="UR"),linetype = "dashed",size=1,show.legend = TRUE)+
  geom_point(aes(y=Pairs,group=1,color="Pairs"),shape=20,size=2,show.legend = TRUE)+
  geom_line(aes(y=Wild,group=1,color="Wild"),linetype = "longdash",size=1,show.legend = TRUE)+
  scale_x_discrete("Sample Size", data$sample_size[c(1,3,5,7,9,11,13,15)])+
  scale_y_continuous("Rejection Frequency",seq(0.02,0.18,0.01))+
  theme(legend.position = c(0.9, 0.9),legend.justification = c(0.9, 0.9))+
  labs(title = plottitle)+
  #labs(color  = " ")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(
    legend.title = element_blank(),
    legend.background = element_rect(fill='transparent'), #transparent legend bg
    legend.box.background = element_rect(fill='transparent') #transparent legend panel
  )
  
  
  