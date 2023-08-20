library(tidyverse)
set.seed(20230802)
x <- runif(10, 0, 1)
epsilon <- rnorm(10, mean = 0, sd = 0.4)
y <- sin(2 * pi * x) + epsilon
data_df <- data.frame(x = x, y = y)
ggplot(data_df, aes(x = x, y = y)) +
  geom_point(shape = 1, size = 4, color = "red", fill = "white") +
  geom_smooth(method = "lm", formula = y ~ 1, se = FALSE, color = "blue",linetype = "dotted") +
  geom_line(data = data.frame(x = seq(0, 1, 0.01)), aes(x = x, y = sin(2 * pi * x)), color = "darkgreen") +
  labs(x = "X", y = "Y")

ggplot(data_df, aes(x = x, y = y)) +
  geom_point(shape = 1, size = 4, color = "red", fill = "white") +
  geom_smooth(method = "lm", se = FALSE, color = "blue",linetype = "dotted") +
  geom_line(data = data.frame(x = seq(0, 1, 0.01)), aes(x = x, y = sin(2 * pi * x)), color = "darkgreen") +
  labs(x = "X", y = "Y")

ggplot(data_df, aes(x = x, y = y)) +
  geom_point(shape = 1, size = 4, color = "red", fill = "white") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3),se = FALSE, color = "blue",linetype = "dotted") +
  geom_line(data = data.frame(x = seq(0, 1, 0.01)), aes(x = x, y = sin(2 * pi * x)), color = "darkgreen") +
  labs(x = "X", y = "Y")

ggplot(data_df, aes(x = x, y = y)) +
  geom_point(shape = 1, size = 4, color = "red", fill = "white") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 5),se = FALSE, color = "blue",linetype = "dotted") +
  geom_line(data = data.frame(x = seq(0, 1, 0.01)), aes(x = x, y = sin(2 * pi * x)), color = "darkgreen") +
  labs(x = "X", y = "Y")+
  ylim(-1.5, 1.5)

ggplot(data_df, aes(x = x, y = y)) +
  geom_point(shape = 1, size = 4, color = "red", fill = "white") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 8),se = FALSE, color = "blue",linetype = "dotted") +
  geom_line(data = data.frame(x = seq(0, 1, 0.01)), aes(x = x, y = sin(2 * pi * x)), color = "darkgreen") +
  labs(x = "X", y = "Y")+
  ylim(-1.5, 1.5)
