use FGLS_Eg.dta, replace
quietly reg crash IS wret wturn lev roa top conp
est sto OLS
estat hettest //Breusch–Pagan异方差检验

predict e, res //求残差，保存在e中
gen logesq=ln(e^2) 
predict haty //求拟合值，保存在haty中
gen haty2 = haty^2 //计算拟合值的平方
quietly reg logesq haty haty2 
//$\log(e_{i}^{2})$对拟合值和拟合值的平方进行回归
predict esqhat //求拟合值，保存在esqhat中
gen h=exp(esqhat) //计算$\hat{h}$
reg crash IS wret wturn lev roa top conp [aw= 1/h]
//重新回归，以$1/\hat{h}$作为权重
est sto AW
//***************************************************//
//自定义权重，对数据进行转换
gen w = 1/(h)^0.5 //注意用于转换数据的权重是$1/\sqrt{\hat{h}_{i}}$
foreach i in crash IS wret wturn lev roa top conp  {
	gen `i'w=`i'*w //数据转换
	}
reg crashw ISw wretw wturnw levw roaw topw conpw w, noc
  //因为常数项也要做数据转换，回归中加入的w对应转换前的常数项，
  //", noc"表示回归中没有常数项
est sto NOC
//***************************************************//
  //也可以利用第三方命令wls0或regwls
  //如果未安装wls0和regwls，使用findit wls0寻找下载地址
wls0 crash IS wret wturn lev roa top conp, wvar(haty haty2) type(loge2)
est sto WLS0
regwls crash IS wret wturn lev roa top conp, wvar(haty haty2) type(loge2)
est sto REGWLS

esttab OLS AW NOC WLS0 REGWLS ///
   using fefwls.tex, ///
   replace ///
   star(* 0.10 ** 0.05 *** 0.01) nogaps b(%20.3f) se(%7.3f) ///
   mtitle("OLS" "AW" "NOC" "WLS0" "REGWLS") ///
   r2(%9.3f) ar2 obslast scalars(F)
* nogaps: suppress vertical spacing
