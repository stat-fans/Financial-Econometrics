use http://www.stata.com/data/jwooldridge/eacsap/jtrain2.dta, clear
gen d = train     
gen y = re78      
global xvars re74 re75 age agesq nodegree married black hisp

//协变量匹配
teffects nnmatch (y $xvars)(d)
estimates store m1
tebalance summarize
teffects nnmatch (y $xvars)(d), biasadj(re75)
estimates store m2
teffects nnmatch (y $xvars)(d), nneighbor(3) ematch(married black)
estimates store m3

esttab m1 m2 m3 using Mymatchreg.tex, replace ///
star( * 0.10 ** 0.05 *** 0.01 ) nogaps compress b(%20.3f) se(%7.2f)  ///
obslast ///
mtitles("m1" "m2" "m3") ///
title(Covariates Matching) booktabs  page width(\hsize)

//倾向得分匹配
teffects psmatch (y) (d $xvars, logit), nn(1)
teffects psmatch (y) (d $xvars), atet nn(1) generate(n) 
teffects overlap
tebalance box 
tebalance density      
tebalance summarize
