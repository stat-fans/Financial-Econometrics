######################################
###本文件包括附录D.2 数据结构的代码内容
######################################
### Uses package tidyverse, lubridate
#########################################

library(tidyverse)

###D.2.1 向量、矩阵与数组
##创建向量
a <- c(1,3,7) #创建双精度型向量
b <- c(1L,3L,7L) #创建整型向量
c <- c("adc","mgn","kk") 
d <- c(TRUE,TRUE,FALSE,TRUE,FALSE)
e <- 1:10 %% 3==1 #通过比较运算符创建逻辑型向量 

#变量d,e接上例
typeof(d)
length(e)

#对向量命名
c(x=-1,y=0,z=1)
purrr::set_names(1:3,c("A","B","C"))

##向量取子集
#使用数值向量取子集
X <- c("red", "black", "white", "green", "blue")
X[c(1,5,3,3)]
X[c(-2,-4,-5)]

#使用逻辑向量取子集
Y <- c(-3, NA, 1, 7, NA)
Y[!is.na(Y)]#取出Y的所有非缺失值

#使用字符向量取子集
Z <- c(ad = -3, eee = 0, W1 = 2)
Z[c("W1", "eee")]

##矩阵与数组
#创建矩阵
cel <- c(11,6,2,8,-9,22) 
row_names <- c("R1", "R2","R3") 
col_names <- c("C1", "C2")
mat <- matrix(cel, nrow=3, ncol=2, byrow=TRUE,dimnames=list(row_names, col_names))
#byrow=TRUE代表按行填充
mat


###D.2.2 数据框
##创建数据框
tibble(
  x = c(2,-1,3),
  y = 1, #自动重复该输入
  z = x^2 + y, #使用刚刚创建的变量
  ch = LETTERS[1:3]
)

tribble(
  ~stu,~num,~score,
  "Bob","001",89,
  "Lily","024",95
)

as_tibble(rock)  #将rock石头形态数据集转换为tibble类型

##数据框的简单操作
tb=tibble(
  x = 1:3,
  y = 3:1,
)
add_column(tb,z = 0,.after = 1) # 插入一列常数向量至倒数第2列
add_row(tb, x = 7, y = 7, .before = 0) #插入一行数据到第1行

#变量tb接上例
##取tibble某列
#按名称取
tb$x
tb[["x"]]
#按位置取
tb[[1]]
tb[,1]

##取tibble某行，需用逗号作分隔符
tb[1,]


###D.2.3 列表
##创建列表
set.seed(123) #设置随机种子
l = list(rnorm(1),letters[1:3], rnorm(4)>0)
names(l)=c('n',"chr","lo")
l
names(l)=NULL #移除名称
names(l)=c("N","CHR","LO") #修改列表成分名

##列表取子集
str(l[1]) #通过str()函数查看数据结构
str(l[[2]])
str(l$LO)

##列表的转换
as.list(c(3,1))
str(unlist(l))


###D.2.4 字符串
##创建字符串
ch1="What is Econometrics?"
ch1

ch2 = c("ab","TTT","Q-R")
str_length(ch2)
str_pad(ch2, 4, pad="-") #pad参数指定填充符

x <- "This string is moderately long"
str_trunc(x, 10, ellipsis = "...") 
#注：截断长度不能短于省略号参数ellipsis的长度

#注意间隔符参数sep和collapse的作用处
str_c(c("x","y","z"),c("A","B","C"),sep=".") 
#str_c将对应的字符串两两相连，中间用.分割
str_c(c("x","y","z"),c("A","B","C"), sep=".",collapse="-") 
#str_c先根据sep的设置将对应的字符串两两相连，中间用.分割，
#再根据collapse的设置将所得字符串再次连接，中间用-分割，最终得到一个字符串。

str_split("q-eeF-WCAR",pattern="-") # pattern为指定的分隔符

#变量ch2接上例
str_sort(ch2, decreasing = TRUE, locale = "en")
#降序排列，语言为英文 

##字符串取子集
ch3=c("long","short","big","small","thick") 
str_sub(ch3,start=2, end=4)
#若字符串长度不足，则取到最后。如"big"，取子集为"ig"

# 变量ch3接上例
str_detect(ch3, "h")
str_which(ch3, "h")
str_count(ch3, "l")
str_starts(ch3, "l")
str_ends(ch3, "g")


###D.2.5 日期和时间
##创建日期时间
library(lubridate) # 加载lubridate
ymd("2020,08,11")
dmy("15th,January,2018")
dmy_hm("12-10-2022 21:34")
mdy_hms("12/30/2021 10:00:30")

make_date(2022,6,10)
make_datetime(2022,6,10,8,30,10)

###D.2.6 因子
##创建因子
ch=c("Thur.","Wed.","Thur.","Fri.","Tue.","Mon")
f=factor(ch)
f
#修改因子水平
levels(f) = c("周五","周一","周四","周二","周三")
f

##处理因子数据
fct_count(f) #统计因子数据频数

#将频数小于2的归为“其他”
fct_lump_min(f,2, other_level = "其他") %>% table()

#修改某个因子水平
fct_recode(f, 礼拜四="周四")
