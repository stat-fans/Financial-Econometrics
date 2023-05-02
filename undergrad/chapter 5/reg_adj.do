use http://www.stata.com/data/jwooldridge/eacsap/jtrain2.dta, clear
describe

gen y = re78
gen d = train

global xvars re74 re75 age agesq nodegree married black hisp
global xvarsh re74 re75 age agesq nodegree married black hisp

bysort d: tabstat y $xvars, columns(statistics) s(n mean sd min max)

qui reg y d, r
estimates store DIM

qui ivtreatreg y d $xvars , model(cf-ols) vce(robust)
estimates store RA1

qui ivtreatreg y d $xvars , hetero($xvarsh) model(cf-ols) vce(robust)
estimates store RA2

esttab DIM RA1 RA2 using Myrareg.tex, replace ///
star( * 0.10 ** 0.05 *** 0.01 ) nogaps compress b(%20.3f) se(%7.2f) r2(%9.3f) ar2 ///
obslast scalars(F) ///
mtitles("DIM" "RA1" "RA2") ///
title(Regression Adjustment) booktabs  page width(\hsize)

bootstrap atet=e(atet) atent=e(atent), rep(200): ///
ivtreatreg y d $xvars, hetero($xvarsh) model(cf-ols)

teffects ra (y $xvars, linear) (d)
teffects ra (y $xvars, linear) (d), atet
