import excel "/Users/xuqiuhua/Desktop/cs-gdp-pop.xlsx", sheet("Sheet1") firstrow clear
gen lgdp = log(GDP)
gen lpop = log(Pop)
reg lgdp lpop
