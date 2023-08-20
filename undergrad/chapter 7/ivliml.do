use mus207mepspresdrugs.dta, clear
global controlvar totchr age female blhisp linc
ivregress 2sls ldrugexp (hi_empunion = ssiratio lowincome firmsz multlc) $controlvar, r
est store IV
ivregress liml ldrugexp (hi_empunion = ssiratio lowincome firmsz multlc) $controlvar, r
est store LIML

esttab IV LIML using Myfilereg.tex,                   ///
	replace star( * 0.10 ** 0.05 *** 0.01 )              ///
	nogaps compress order(hi_empunion)      ///
	b(%20.3f) se(%7.2f) r2(%9.3f) ar2 aic bic            ///
	obslast        ///
	mtitles("IV" "LIML")                     ///
	title(esttab_Table: regression result) booktabs  page width(\hsize)
