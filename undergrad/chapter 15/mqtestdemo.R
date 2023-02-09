mydata <- readxl::read_xlsx("~/sh_index.xlsx")
logdata <- log(mydata[,2:4])
#计算三个指数的收益率并进行Ljung-Box检验  
rt_sh <- logdata[2:dim(logdata)[1],]-logdata[1:(dim(logdata)[1]-1),]
Box.test(rt_sh[,1],lag=12,type='Ljung-Box')
Box.test(rt_sh[,2],lag=12,type='Ljung-Box')
Box.test(rt_sh[,3],lag=12,type='Ljung-Box')
#多元Q检验
MTS::mq(rt_sh,20)
#MTS::ccm(rt_sh)
MTS::VARorder(rt_sh)


