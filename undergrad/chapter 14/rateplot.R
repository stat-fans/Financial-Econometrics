mydata <- readxl::read_xlsx("~/BondRate.xlsx")
mydata <- mydata[which(mydata$Y10Rate>0),]
library(tidyverse)

ggplot(mydata, aes(x = Time)) + 
  geom_line(aes(y = Y10Rate, color = "Y10Rate")) +
  geom_line(aes(y = Y1Rate, color = "Y1Rate")) +
  scale_color_manual(name = "", 
                     values = c("Y10Rate" = "red", "Y1Rate" = "blue")) +
  labs(title = "国债收益率", x = "Time", y = "Rate")+
  theme(legend.position = c(0.9, 0.9),
        legend.background = element_rect(fill = "transparent", size = 0.5))

