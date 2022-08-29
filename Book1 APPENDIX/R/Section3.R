######################################
###本文件包括附录D.3 基本语法的代码内容
######################################
### Uses package tidyverse
#########################################

library(tidyverse)

###D.3.1 管道

sqrt(81) %>% log() %>%cos() %>% exp() %>% round(3)
#等价于
round(exp(cos(log(sqrt(81)))),3)

##管道占位符的使用 
#将数据传递给第一个参数
c(7,-4,5,NA) %>% 
mean(.,na.rm = TRUE)  
# .可省略      
c(7,-4,5,NA) %>% 
  mean(na.rm = TRUE)

iris %>% 
  plot(Sepal.Length~Petal.Length,data = .) #数据传递给第二个参数

#在管道中使用提取操作
set.seed(123)
df <- tibble(
  x = rnorm(4), #生成标准正态分布随机数
  y = runif(4)  #生成区间[0,1]内的均匀分布随机数
)

#提取列x
df %>% .$x
df %>% .[["x"]]


###D.3.2 控制流
##if语句
x <- 9L
if(!is.integer(x)) {
  print("X is not an integer")
} else {
  print(x^2)
}

#针对多元p值向量，标记其在0.05水平下的显著性
p <- c(.0014, .1021, .2478, .0003, .8216) 
test <- ifelse(p <.05, "Significant", "Not Significant") 
test

##for 结构
# 计算 mtcars 数据集每列的均值
mtcars_mean <- vector("double", ncol(mtcars)) # 为输出结果分配足够的空间
for (i in seq_along(mtcars)) { # 循环序列
  mtcars_mean[[i]] <- mean(mtcars[[i]]) # 循环体
}

##while 结构
#求出连续出现 3 次正面向上所需的投掷总次数
set.seed(123)
total <- 0 # 设置投掷总次数的初值
heads <- 0 # 设置连续正面向上的次数的初值
while (heads < 3) { # 正面向上次数小于3为循环条件
  if (sample(c("T", "H"), 1) == "H") { #sample()函数模拟随机掷硬币，“H”代表证明向上
    heads <- heads + 1 # 当正面向上，heads计数累加
  } else {
    heads <- 0 #当出现了反面向上，heads计数从零重新开始
  }
  total <- total + 1 
} # 每次循环，total计数加1
total

###D.3.3 purrr 包实现循环
##单参数迭代
#使用map_dbl()计算mtcars数据集每列的均值
mtcars_mean2 <- mtcars %>%
  map_dbl(mean) # 此处省略了.占位符,等价于map_dbl(.,mean)

#使用apply()计算mtcars数据集每列的均值
mtcars_mean3 <- apply(mtcars,2,mean)
# 第二个参数MARGIN代表维度
#对于数据框，维度为1表示对行进行运算，为2表示对列进行运算

##多参数迭代
#生成三组均值、标准差都不同的正态分布随机数
set.seed(123)
mu <- list(0,1,-1)
sigma <- list(1,2,3)
map2(mu, sigma, rnorm, n=4) %>% 
  str() # str()用来查看数据的内部结构

#生成三组的均值、方差和样本数量各不相同的正态分布随机数
# 变量mu,sigma接上例
set.seed(123)
num <- list(4,6,8)
# 为par各变量命名。函数rnorm(n,mean,sd)将依据变量名匹配参数。
par <- list(mean=mu, sd=sigma, n=num) 
# 若省略命名步骤，函数rnorm(n,mean,sd)将按照变量位置引入参数。此时，num,mu,sigma的位置与函数rnorm()的参数n,mean,sd位置必须对应。
par <- list(num, mu, sigma) 
par %>% 
  pmap(rnorm) %>%
  str()

#使用tribble()按行填充
par2 <- tribble(
  ~mean, ~sd, ~n,
  0, 1, 4,
  1, 2, 6,
  -1, 3, 8 
)

par2 %>%
  pmap(rnorm)

##调用不同函数的迭代
#生成一组正态分布随机数及两组参数不同的学生T分布随机数
set.seed(123)
f <- list(rnorm,rt,rt) # 定义函数列表
#也可为函数名称组成的字符向量 f <- c("rnorm","rt","rt")  
param <- list(
  list(mean=1, sd = 2), 
  list(df = 4),
  list(df = 10)
  )

invoke_map(f, param, n = 4) %>% 
  str()


###D.3.4 自定义函数
map(
  c(-3, -0.7, 2.1, 0.5), function(x){
  if(abs(x) <= 1){x^2}
    else{1}
 } # 此处定义的匿名函数作为map()的第二个参数
)

#purrr包的匿名函数
map(c(-3, -0.7, 2.1, 0.5),
    ~if(abs(.) <= 1){.^2} else{1} #此处用.指代参数
 )

set.seed(123)
par=list(rnorm(5),runif(5),rt(df=10,5))
pmap(par,~log(..1 + ..2 + ..3)) # 此处用..1和..2等指代参数

# 定义两种数据调整方式，将其中常用的一种设置为默认
adjust <- function(x, type=1){
  if(type==1) {
    new = (x-mean(x))/sd(x)
  } else {
    new = (x-mean(x))/(max(x)-min(x))
  }
  return(new)
}

#自定义函数，包含任意长度的参数
add_pos <- function(x, ...){
  args = list(...) # 通过list()获得所有参数
  x+unlist(args[args>0]) 
  # 将x与剩余正值参数相加，其中unlist()函数将列表转换为向量以进行数值运算
}
add_pos(x=3,-1,0,28,-7,3) #调用含有参数...的函数时，最好对其余参数命名

