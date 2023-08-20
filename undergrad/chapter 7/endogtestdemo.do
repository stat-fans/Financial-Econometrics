use mus207mepspresdrugs.dta, clear
global controlvar totchr age female blhisp linc
//DWH检验
reg ldrugexp hi_empunion $controlvar
estimates store ols   //保存OLS估计的结果
ivregress 2sls ldrugexp (hi_empunion = ssiratio multlc) $controlvar
estimates store iv    //保存2SLS估计的结果
hausman iv ols, constant sigmamore
//异方差稳健检验
ivregress 2sls ldrugexp (hi_empunion = ssiratio multlc) $controlvar,r
estat endogenous
ivregress 2sls ldrugexp (hi_empunion = ssiratio multlc) $controlvar
estat endogenous
