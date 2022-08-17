use mroz.dta, replace
keep if inlf == 1 
quietly reg lwage educ exper
estat hettest
estat hettest, iid
estat imtest, white
estat hettest educ exper c.educ#c.educ ///
c.exper#c.exper c.educ#c.exper, iid

