######################################
###本文件包括附录D.1 安装与配置的代码内容
######################################

###D.1.2 包的安装与使用
install.packages("tidyverse") #安装单个包
.libPaths() #查看库所在位置

rownames(installed.packages()) #查看当前已安装的包的名称

pkgs = c("xts","vars","rugarch")#批量安装多个包
lapplhelp(mutate)y(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x) # 若该包已被安装，则跳过该包
})

library("tidyverse") #加载tidyverse包
search() #查看当前已加载的包

help(package="tidyverse")
#查看mutate函数的帮助文档
help(mutate)
?mutate


###D.1.3 工作空间的管理
getwd() #查看当前工作路径
setwd("~/Documents/GitHub") #设置新工作路径
rm(list = ls(all = TRUE))#清除当前所有对象


