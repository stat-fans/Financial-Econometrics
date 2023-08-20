library(DiceKriging)
library(tidyverse)

x <- seq(-5, 5, length = 200)
a <- 3

lambda <- 1
scad <- SCAD(x, lambda)
abs <- abs(x)
x <- matrix(x, 200, 1)
scad <- matrix(scad, 200, 1)
abs <- matrix(abs, 200, 1)
xx <- rbind(x, x)
yy <- rbind(abs, scad)
group <- c(rep("L1", 200), rep("SCAD", 200))
df <- data.frame(xx, yy, group)

ggplot(df, aes(x = xx, y = yy, group = group)) +
  geom_line(aes(color = group, linetype = group)) +
  scale_color_manual(values = c("L1" = "indianred1", "SCAD" = "darkturquoise"), name = "Penalty") +
  scale_linetype_manual(values = c("L1" = "dashed", "SCAD" = "solid"), name = "Penalty") +
  labs(
    title = "SCAD and L1 Penalty",
    x = "x",
    y = "Value"
  )
