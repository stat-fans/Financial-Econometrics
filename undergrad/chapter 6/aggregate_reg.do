use "/Users/xuqiuhua/Stata Data Code/CHIP2002/CHIP2002.dta", clear
rename P113 edu
rename P201 wage
gen lwage = log(wage)
//keep edu lwage
//drop if lwage == .
reg lwage edu, r
collapse (count) n = lwage (mean) mlwage=lwage, by(edu)
reg mlwage edu [aw = n], r
