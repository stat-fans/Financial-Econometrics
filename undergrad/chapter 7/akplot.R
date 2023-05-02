#https://jrnold.github.io/masteringmetrics/
library("AER")
library("sandwich")
library("lmtest")
library("tidyverse")
library("broom")
data("ak91", package = "masteringmetrics")
ak91 <- mutate(ak91,
               qob_fct = factor(qob),
               q4 = as.integer(qob == "4"),
               yob_fct = factor(yob))
ak91_age <- ak91 %>%
  group_by(qob, yob) %>%
  summarise(lnw = mean(lnw), s = mean(s)) %>%
  mutate(q4 = (qob == 4))
library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc')
ggplot(ak91_age, aes(x = yob + (qob - 1) / 4, y = s)) +
  geom_line() +
  geom_label(mapping = aes(label = qob, color = q4)) +
  theme(legend.position = "none") +
  scale_x_continuous("出生年份", breaks = 1930:1940) +
  scale_y_continuous("受教育时间（年）", breaks = seq(12.2, 13.2, by = 0.2),
                     limits = c(12.2, 13.2))
ggplot(ak91_age, aes(x = yob + (qob - 1) / 4, y = lnw)) +
  geom_line() +
  geom_label(mapping = aes(label = qob, color = q4)) +
  scale_x_continuous("出生年份", breaks = 1930:1940) +
  scale_y_continuous("周对数工资") +
  theme(legend.position = "none")