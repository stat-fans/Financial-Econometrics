use "/Users/xuqiuhua/Downloads/mus2/mus208psid.dta"
xtabond lwage occ south smsa ind, lags(2) maxldep(3) ///
        pre(wks,lag(1,2)) endogenous(ms,lag(0,2)) ///
		endogenous(union,lag(0,2)) twostep vce(robust)
estat abond
xtdpdsys lwage occ south smsa ind, lags(2) maxldep(3) ///
     pre(wks, lag(1,2)) endogenous(ms, lag(0,2)) ///
     endogenous(union, lag(0,2)) twostep vce(robust)
estat abond
//estat sargan
xtdpd L(0/2).lwage L(0/1).wks occ south smsa ind ms union, ///
      div(occ south smsa ind) dgmmiv(lwage, lagrange(2 4)) ///
      dgmmiv(ms union, lagrange (2 3)) dgmmiv(L.wks, lagrange (1 2)) ///
      lgmmiv(lwage wks ms union) twostep vce(robust) 
estat abond
xtdpd L(0/2).lwage L(0/1).wks occ south smsa ind ms union, ///
      div(occ south smsa ind) dgmmiv(lwage, lagrange(3 4)) ///
      dgmmiv(ms union, lagrange (2 3)) dgmmiv(L.wks, lagrange (1 2)) ///
      lgmmiv(L.lwage wks ms union) twostep vce(robust) 
estat abond
