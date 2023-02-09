import excel "/Users/xuqiuhua/q-GDP-UKCAUS.xlsx", sheet("Sheet1") firstrow clear
gen time = _n
tsset time
foreach var in USA CANADA UK{
	gen lag_`var'=`var'[_n-1]
	gen gr_`var' = (log(`var') - log(lag_`var'))*100
}
varsoc gr_USA gr_CANADA gr_UK
var gr_USA gr_CANADA gr_UK,lags(1)
varlmar,mlag(4) 
varstable, graph
varwle
vargranger
irf creat impres, set(gdp) replace
irf graph oirf, i(gr_CANADA) yline(0)

gen year = year(DATE)
var gr_USA gr_CANADA gr_UK if year <= 2017, lags(1)
fcast compute pred_, step(8)
fcast graph pred_gr_UK, observed lp(dash)
irf table fevd,i(gr_USA) r(gr_USA gr_CANADA gr_UK) noci
