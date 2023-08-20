library(tidyverse)
set.seed(20230812)
x <- runif(50, 0, 1)
epsilon <- rnorm(50, mean = 0, sd = 0.4)
y <- sin(2 * pi * x) + epsilon
data_df <- data.frame(x = x, y = y)
ggplot(data_df, aes(x = x, y = y)) +
  geom_point(shape = 1, size = 4, color = "red", fill = "white") +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "darkgoldenrod4",linetype = "solid") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3),se = FALSE, color = "deepskyblue1",linetype = "dashed") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 20),se = FALSE, color = "chartreuse3",linetype = "dotdash") +
  geom_line(data = data.frame(x = seq(0, 1, 0.01)), aes(x = x, y = sin(2 * pi * x)), color = "black") +
  labs(x = "X", y = "Y")

test <- runif(50, 0, 1)
test_label <- sin(2 * pi * test) + rnorm(50, mean = 0, sd = 0.4)
m1 <- lm(y~x, data = data_df)
mse1_in <- mean((y-predict(m1))^2)
pred1 <- predict(m1, data.frame(x = test))
mse1_out <- mean((test_label - pred1)^2)

m2 <- lm(y~poly(x, 3), data = data_df)
mse2_in <- mean((y-predict(m2))^2)
pred2 <- predict(m2,data.frame(x = test))
mse2_out <- mean((test_label - pred2)^2)

m3 <- lm(y~poly(x, 20), data = data_df)
mse3_in <- mean((y-predict(m3))^2)
pred3 <- predict(m3,data.frame(x = test))
mse3_out <- mean((test_label - pred3)^2)
mse_in <- c(mse1_in,mse2_in,mse3_in)
mse_out <- c(mse1_out,mse2_out,mse3_out)
comp_mse <- data.frame(x=c(1,3,20),mse_in,mse_out,Group = c("Group 1", "Group 2", "Group 3"))
ggplot(comp_mse, aes(x = x, shape = Group)) +
  geom_line(aes(y = mse_in, group = 1), size = 1, color = "darkgrey") +  # Connect Y1 data points across groups with blue line
  geom_line(aes(y = mse_out, group = 1,color = Group), size = 1,color = "lightpink1") +
  geom_point(aes(y = mse_in, color = Group), size = 4) +
  geom_point(aes(y = mse_out, color = Group), size = 4) +
  labs(x = "Degree of Polynomial", y = "Mean Squared Error") +
  scale_color_manual(values = c("Group 1" = "darkgoldenrod4", "Group 2" = "deepskyblue1", "Group 3" = "chartreuse3")) +
  scale_shape_manual(values = c("Group 1" = 16, "Group 2" = 17, "Group 3" = 18)) +
  theme(legend.position = "none")  