import delimited ~/F-F_Research_Data_Factors_daily.CSV, rowrange(5:) varnames(5) clear
describe
gen time = date(v1, "YMD")
gen requiretime = (time > date("196001","YM")) & (time < date("202004","YM"))
save ~/threefactor, replace

import delimited ~/25_Portfolios_5x5_Daily.CSV, rowrange(19:24724) varnames(19) clear
describe
tostring v1, replace

merge 1:1 v1 using ~/threefactor
save ~/Fama-French_Data, replace

keep smalllobm mktrf rf smb hml requiretime
keep if requiretime==1
drop requiretime

save ~/Fama-French_Data, replace
