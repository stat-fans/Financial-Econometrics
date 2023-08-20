webuse sysdsn1, clear
mlogit insure nonwhite, r
est store m1
mlogit insure nonwhite, base(2) r
est store m2
mlogit insure age male nonwhite i.site, r
est store m3
esttab m1 m2 m3 using Myfilereg.tex,                   ///
	replace star( * 0.10 ** 0.05 *** 0.01 )              ///
	nogaps compress b(%20.3f) se(%7.2f) ///
	obslast mtitles("m1" "m2" "m3")    ///
	title(mlogit results) booktabs  page width(\hsize)
