use mroz.dta, replace
keep if inlf == 1 
reg lwage educ exper, vce(hc3)
reg lwage educ exper, vce(jackknife,nodots)
jackknife: reg lwage educ exper
