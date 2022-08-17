import delimite "上证指数收益率.csv", clear

gen time = _n

tsset time

gen rtn_lag  = L.rtn

reg rtn rtn_lag

estat bgodfrey, lags(10)



