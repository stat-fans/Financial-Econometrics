use "/Users/xuqiuhua/Desktop/高等教育出版社《计量经济学》/实例/金融科技与企业创新/rtmrdpmh/数据/baseline.dta", clear
preserve
keep if year== 2012
reg Patent Fintech, r
est store m1
restore
preserve
keep if year== 2016
reg Patent Fintech, r
est store m2
esttab m1 m2 using Myfilereg.tex,                   ///
	replace star( * 0.10 ** 0.05 *** 0.01 )              ///
	nogaps compress       ///
	b(%20.3f) se(%7.2f) ar2  ///
	obslast scalars(F)        ///
	mtitles("2012" "2016")                     ///
	title(regression result) booktabs  page width(\hsize)
restore
drop if year < 2012 | (year > 2012 & year < 2016)
reg Patent Fintech, cluster(code)
est store m3
bys code: gen dPatent = Patent - Patent[_n-1]
bys code: gen dFintech = Fintech - Fintech[_n-1]
reg dPatent dFintech, r
est store m4
esttab m3 m4 using Myfilereg.tex,                   ///
	replace star( * 0.10 ** 0.05 *** 0.01 )              ///
	nogaps compress       ///
	b(%20.3f) se(%7.2f) ar2  ///
	obslast scalars(F)        ///
	mtitles("Pool" "Diff")                     ///
	title(regression result) booktabs  page width(\hsize)
