######################################
###本文件包括附录D5.数据可视化的代码内容
######################################
### Uses package tidyverse, carData
#########################################

library(tidyverse)
###图 D.6: 花萼长与花萼宽的散点图及平滑曲线图
iris %>%
  ggplot(aes(x=Sepal.Length, y=Sepal.Width))  +
  geom_point(aes(color = Species),# 使用ggplot()中的x,y映射，故略去。
             shape = 2,position = "jitter") + 
  #在aes()外的shape为几何对象的图形属性，2代表散点为三角形; 
  #参数position调整几何对象的位置，jitter为每个数据点添加微小随机扰动，避免重叠
  geom_smooth(aes(color = Species),
              method = lm, # 设置拟合方式为线性回归
              se = FALSE,  # 不显示置信区间
              linetype= 2) # 设置线条为虚线


###图 D.7: 美国个人储蓄率的日期折线图
# date为日期数据，psavert为个人储蓄率
economics[1:60,] %>%
  ggplot(aes(x=date, y=psavert/100)) +
  geom_line() +
  scale_x_date(name="日期",date_breaks = "8 months", date_labels = "%Y-%m") +
  # 刻度间隔为8个月，日期形式为四位数年份-两位数月份
  scale_y_continuous(name="个人储蓄率",labels = scales::percent)
# 使用scales包的percent函数将数据由小数转化为百分数格式


###图 D.8: 花萼长度与品种的堆叠直方图
#绘制Sepal.Length的直方图，并将离散变量Species映射到fill属性上，形成分块
iris %>%
  ggplot(aes(x = Sepal.Length, fill = Species)) +
  geom_histogram() +
  scale_fill_discrete(values = c("orange", "pink", "lightgreen")) +
                      # 自定义Species对应的颜色
 labs(x="花萼长度",y="数量",fill="品种") # 更改坐标轴和图例名称


###图 D.9: 花萼宽度与花瓣宽度的散点图
iris %>%
  ggplot(aes(x = Sepal.Width, y=Petal.Width,color = Sepal.Length)) +
  geom_point() +
  scale_color_gradient(name="花萼长度",low="blue", high="yellow",breaks=seq(4,8,by=0.7)) +
  scale_x_continuous(name="花萼宽度") +
  scale_y_continuous(name="花瓣宽度")


###图 D.11: 工资的经验累积分布函数
install.packages("carData") #如无carData包，则进行安装
library(carData)

#计算salary变量的经验累积概率分布并绘图
Salaries %>%
  ggplot(aes(salary)) +
  stat_ecdf() +
  xlab("工资") + # 使用xlab()，ylab()更改坐标轴名称
  ylab("经验累积概率")

### 图 D.12: 工龄与工资关于性别的分面散点图
#以sex(性别)为分面变量,绘制yrs.service(工龄)与salary(工资)的散点图
Salaries %>%
  ggplot() +
  geom_point(mapping = aes(x = yrs.service, y = salary)) +
  facet_wrap(~ sex, ncol = 2) 


###图 D.13: 工龄与工资关于性别和等级的分面散点图
#以rank(教授等级)和sex(性别)为分面变量
Salaries %>%
  ggplot() +
  geom_point(mapping = aes(x = yrs.service, y = salary)) +
  facet_grid(rank ~ sex)


