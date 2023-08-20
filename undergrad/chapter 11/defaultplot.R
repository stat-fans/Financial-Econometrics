library(ISLR2)
library(tidyverse)
data(Default)
Default$default <- ifelse(as.character(Default[,"default"])=="Yes",1,0)
ggplot(data = Default, aes(x = balance, y = default)) +
  geom_point(color = "blue") +
  geom_abline(intercept = -0.0751920, slope = 0.0001299, color = "blueviolet", linetype = "dashed")+
  labs(x = "Balance", y = "Default", title = "Scatter Plot with Linear Regression Line")