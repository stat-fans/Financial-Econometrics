import excel "贵州茅台.xlsx", sheet("Sheet1") firstrow clear
gen time = _n
tsset time
dfuller close, lags(14) trend
