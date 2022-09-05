*-------------------------------------*
*             Stata结果输出           *
*-------------------------------------*


******** 描述统计结果输出 ********
sysuse nlsw88, clear
local varlist "wage age race married grade collgrad south union occupation"
* asdoc：不支持中文，字符型变量会报错
asdoc sum `varlist',                           ///
    save(Myfile1.doc) replace                    ///
	stat(N mean sd min p50 max)  dec(3)          /// dec(3)：保留小数点后三位
	title(asdoc_Table: Descriptive statistics)

* sum2docx：支持中文，字符型变量会报错，能设置每个统计量的小数位数
sum2docx `varlist' using Myfile2.docx, replace  ///
	stats(N mean(%9.2f) sd(%9.3f) min(%9.2f)          ///
	median(%9.2f) max(%9.2f))                         ///
	title(sum2docx_Table: Descriptive statistics)

* outreg2：不支持中文，字符型变量在输出结果中自动剔除
outreg2 using Myfile3, sum(detail) replace word ///
    eqkeep(N mean sd min p50 max)     ///
	fmt(f) keep(`varlist')            ///fmt(f)：使用固定长度的字符串
	sortvar(wage age grade)           ///变量排序
	title(outreg2_Table: Descriptive statistics)

* esttab：不支持中文，有字符型变量会直接运行并输出空白结果，能设置小数位数
estpost summarize `varlist', detail
esttab using Myfile4.rtf, ///
	cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) p50(fmt(2)) max(fmt(2))") ///
	noobs compress replace title(esttab_Table: Descriptive statistics)
// 输出.tex文件
esttab using Myfile4.tex,  ///
	cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) p50(fmt(2)) max(fmt(2))") ///
	noobs compress replace     ///
	title(esttab_Table: Descriptive statistics) ///
	booktabs  page(array, makecell) alignment(cccccc) width(\hsize)

	
******** 两样本t检验结果输出 ********
sysuse nlsw88, clear
local varlist "wage age race married grade collgrad union"
* t2docx命令的使用：
t2docx `varlist' using Myfilet1.docx, replace ///
	 not by(south) title(t2docx_Table: T_test by group) 

* esttab命令的使用：
estpost ttest `varlist', by(south)
esttab using Myfilet2.rtf,                         ///
	cells("N_1 mu_1(fmt(3)) N_2 mu_2(fmt(3)) b(star fmt(3))") ///
	starlevels(* 0.10 ** 0.05 *** 0.01)              ///
	noobs compress replace title(esttab_Table: T_test by group)
// 输出.tex文件
esttab using Myfilet2.tex,                         ///
	cells("N_1 mu_1(fmt(3)) N_2 mu_2(fmt(3)) b(star fmt(3))") ///
	starlevels(* 0.10 ** 0.05 *** 0.01)              ///
	noobs compress append title(esttab_Table: T_test by group)///
	booktabs  page width(\hsize)
	
	
******** 相关系数矩阵的输出 ********
sysuse nlsw88, clear
local varlist "wage age race married grade collgrad"
* corr2docx：可汇报Pearson相关系数，不报告p值，但是可标注显著性的星号
corr2docx `varlist' using Myfilecorr1.docx, replace    ///
    spearman(ignore) pearson(pw) star                       ///
    title(corr2docx_Table: correlation coefficient matrix)
	
* esttab：能报告p值，可以设置标注显著性星号的临界值
estpost correlate `varlist', matrix
esttab using Myfilecorr2.rtf,                     ///
	unstack not noobs compress nogaps replace       ///
	star(* 0.1 ** 0.05 *** 0.01)                    ///
	b(%8.3f) p(%8.3f)                               ///
	title(esttab_Table: correlation coefficient matrix)
// 输出.tex文件
esttab using Myfilecorr2.tex,                     ///
	unstack not noobs compress nogaps append        ///
	star(* 0.1 ** 0.05 *** 0.01)                    ///
	b(%8.3f) p(%8.3f)                               ///
	title(esttab_Table: correlation coefficient matrix) ///
	booktabs  page width(\hsize)	
	
	
******** 回归结果的输出 ********
sysuse nlsw88.dta, clear
tabulate race, gen(race_num)  //生成类别变量race对应的虚拟变量
drop race_num1
gen lwage = log(wage)
qui reg lwage age married occupation
est store m1                    //保存回归结果到m1
qui reg lwage age married collgrad occupation
est store m2
qui reg lwage age married collgrad occupation race_num*
est store m3
esttab m1 m2 m3 using Myfilereg.rtf,                   ///
	replace star( * 0.10 ** 0.05 *** 0.01 )              ///
	nogaps compress order(married) drop(occupation)   ///
	b(%20.3f) se(%7.2f) r2(%9.3f) ar2 aic bic            ///
	obslast scalars(F) indicate("race=race_num*")        ///
	mtitles("OLS-1" "OLS-2" "OLS-3")                     ///
	title(esttab_Table: regression result)
// 输出.tex文件
esttab m1 m2 m3 using Myfilereg.tex,                   ///
	replace star( * 0.10 ** 0.05 *** 0.01 )              ///
	nogaps compress order(married) drop(occupation)      ///
	b(%20.3f) se(%7.2f) r2(%9.3f) ar2 aic bic            ///
	obslast scalars(F) indicate("race=race_num*")        ///
	mtitles("OLS-1" "OLS-2" "OLS-3")                     ///
	title(esttab_Table: regression result) booktabs  page width(\hsize)	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	