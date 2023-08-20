use AK1991Y3.dta, clear
gen AGEQSQ= AGEQ*AGEQ
global controlvar RACE MARRIED SMSA AGEQ AGEQSQ
ivregress 2sls LWKLYWGE (EDUC = i.QOB) $controlvar, r
estat firststage, all forcenonrobust
weakivtest

preserve   //保存原始数据
set seed 202306
sample 30
ivreg2 LWKLYWGE (EDUC = i.QOB) $controlvar, r first
ivreg2 LWKLYWGE (EDUC = i.QOB#i.YOB) $controlvar, r first
ivregress 2sls LWKLYWGE (EDUC = i.QOB#i.YOB) $controlvar, r
weakivtest
