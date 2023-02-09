import excel "/Users/xuqiuhua/Documents/GitHub/Financial-Econometrics/undergrad/chapter 15/GZMT.xlsx", sheet("1") firstrow clear
destring 收盘价元, replace force
rename 收盘价元 price
gen price_lag = price[_n-1]
gen logrtn = log(price)-log(price_lag)
gen time = _n
tsset time
wntestq logrtn, lags(12)
