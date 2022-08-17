import delimited "上证指数收益率.csv", clear
gen time = _n
tsset time
ac rtn, lags(10)
wntestq rtn
