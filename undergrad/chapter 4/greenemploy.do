use "/Users/xuqiuhua/Desktop/数据-城市横截面.dta",clear
global controlvar citywage pop pgdp rsc
gen treatvar = 0
replace treatvar=1 if policy <= 2011
keep if 年度 == 2011
qui reg citylabor treatvar
est store m1
qui reg citylabor treatvar pop
est store m2
qui reg citylabor treatvar pop citywage
est store m3
qui regress citylabor treatvar $controlvar
est store m4
esttab m1 m2 m3 m4 using Mygreenreg.tex, replace star( * 0.10 ** 0.05 *** 0.01 ) nogaps compress b(%20.3f) se(%7.2f) r2(%9.3f) ar2 aic bic obslast scalars(F) mtitles("OLS-1" "OLS-2" "OLS-3" "OLS-4") title(esttab_Table: regression result) booktabs  page width(\hsize)
test $controlvar
