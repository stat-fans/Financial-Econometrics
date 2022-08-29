######################################
###本文件包括附录D.4 数据处理的代码内容
######################################
### Uses package tidyverse
#########################################

library(tidyverse)
fit_test <- read_csv('~/fit_test.csv')

###D.4.1 行操作
##删除重复行或有缺失的行
#删除完全重复的行
fit_test %>%
  distinct()

#删除在某些变量上重复的行
fit_test %>%
  distinct(stu_ID, .keep_all = TRUE) 
#.keep_all = TRUE 返回所有列,否则返回指定列

#删除所有含缺失值的行
fit_test %>%
  drop_na()

#删除在某些变量上有缺失值的行
fit_test %>%
  drop_na(stu_ID:sex)# 作用范围由stu_ID到sex


##过滤行
#选出age为19或20，sprint在[8，9]之间，
#且rope_skipping>190的，并保留缺失值
fit_test %>%
  filter(age %in% c(19,20) & between(sprint, 8, 9) &
           (is.na(rope_skipping) | rope_skipping>190)
         )


##调整行序
#先按age升序排列，再在此基础上按sit_up升序排列
fit_test %>%
  arrange(age,sit_up)

#按sprint降序排列，且缺失值在最前
fit_test %>%
  arrange(desc(is.na(sprint)),desc(sprint)) #两个desc()语句顺序不可换


###D.4.2 列操作
##选择列
fit_test %>%
  select(sex, sit_up) # 或select(3, 6)

#选择唯一值的数量小于5的列
# 函数n_distinct()计算变量唯一值的个数
fit_test %>%
  select(where(~n_distinct(.) < 5)) 

##调整列序
#将sex移到第一列
fit_test %>%
  select(sex, everything())

#将字符型变量移动至最后
fit_test %>%
  relocate(where(is.character), .after =last_col())

##对列重命名
#将stu_ID更名为学号
fit_test %>%
  rename(学号=stu_ID)

#为所有列重新命名
fit_test %>%
  set_names("学号","年龄","性别","短跑","跳绳","仰卧起坐")


##创建新列
x <- c(1,-6,2,0,5)
cumsum(x) # 累计和
cummax(x) # 累计最大值

#将sprint的名次(男女分开排序)作为新变量rank
fit_test %>%
  group_by(sex) %>% # 男女分开排序
    mutate(rank = min_rank(sprint))


###D.4.3 统计描述
#根据age,sex分组，并统计除stu_ID外其余变量的平均值与中位数
fit_test %>%
  group_by(age,sex) %>%
    summarize(across(-stu_ID, list(Mean=mean,Median=median), na.rm = TRUE))



