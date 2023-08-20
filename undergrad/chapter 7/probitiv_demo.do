use fertil2.dta, clear
set more off
global xvars age agesq evermarr urban electric tv
global xvarsh age agesq evermarr urban
qui reg children educ7, r
estimates store DIM
qui ivtreatreg children educ7 $xvars, model(direct-2sls) hetero($xvarsh) iv(frsthalf) graphic vce(robust)
estimates store Direct
qui ivtreatreg children educ7 $xvars, model(probit-ols) hetero($xvarsh) iv(frsthalf) graphic vce(robust)
estimates store ProOLS
qui ivtreatreg children educ7 $xvars, model(probit-2sls) hetero($xvarsh) iv(frsthalf) graphic vce(robust)
estimates store Pro2SLS

esttab DIM Direct ProOLS Pro2SLS using Myrareg.tex, replace ///
star( * 0.10 ** 0.05 *** 0.01 ) nogaps compress b(%20.3f) se(%7.2f) r2(%9.3f) ar2 ///
obslast scalars(F) ///
mtitles("DIM" "Direct-2SLS" "Probit-OLS" "Probit-2SLS") ///
title(IV Causal Inference) booktabs  page width(\hsize)
