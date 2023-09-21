use "/Users/xuqiuhua/Downloads/mus2/mus208psid.dta",clear
xtabond lwage, lags(2) vce(robust)
xtabond2 lwage L.lwage L2.lwage, gmmstyle(L.lwage) noleveleq robust

xtabond lwage occ south smsa ind, lags(2) maxldep(3) ///
        pre(wks,lag(1,2)) endogenous(ms,lag(0,2)) ///
		endogenous(union,lag(0,2)) twostep vce(robust)

	 
xtabond2 lwage L.lwage L2.lwage occ south smsa ind wks L.wks ms union, gmmstyle(lwage,lag(2 4)) gmmstyle(wks ms union,lag(2 3)) ivstyle(occ south smsa ind) noleveleq twostep robust
