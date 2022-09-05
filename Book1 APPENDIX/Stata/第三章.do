*-------------------------------------*
*              Stata绘图              *
*-------------------------------------*


******** 双坐标绘图 ********
use effort.dta, clear
* 散点图：Y：生育率变化（change）；X：社会环境（setting）
graph twoway scatter change setting

* 散点图和回归拟合线：使用命令lfit可以进行回归并绘制样本回归线
graph twoway (scatter setting effort)  (lfit setting effort)

* 样本回归线添加置信带：使用命令lfitci
* ytitle()：为y轴指定标签；legend(off)：隐藏图例
graph twoway (lfitci setting effort) (scatter setting effort), ///
   ytitle("Fertility Decline") legend(off)
 
* 使用mlabel添加点标签
graph twoway (lfitci change setting)     ///
             (scatter change setting, mlabel(country))
* 处理点标签重叠情况
gen pos = 3                                            //默认3点钟方向
replace pos = 11 if country == "TrinidadTobago"        //移动到11点
replace pos = 9 if country == "CostaRica"              //移动到9点
replace pos = 2                                        ///移动到2点
          if country == "Panama" | country == "Nicaragua"  
graph twoway (lfitci change setting)      ///
             (scatter change setting, mlabel(country) mlabv(pos) )

* 进一步调整：加title、修改坐标轴标签、修改图例位置等
graph twoway (lfitci change setting)                                 ///
       (scatter change setting, mlabel(country) mlabv(pos) ),        ///
       title("Fertility Decline by Social Setting")                  ///
       ytitle("Fertility Decline")                                   ///
       legend(ring(0) pos(5) order(2 "linear fit" 1 "95% CI")) 
graph export fig1.pdf, replace  


******** 线图绘制 ********
sysuse sp500, clear
* 简单线图：开盘价（open）、收盘价（close）对观测序号做线图
gen n =_n                                         //n为当前观测的序号               
graph twoway line open close n in 1/50            //只画前50天的走势

* 添加标题和图例，并将图例移动到绘图区域7点钟位置
graph twoway line open close n in 1/50, sort clpattern(- l)           ///
    title("SP500 Stock Price") subtitle("January 2 to March 14")        ///
    xtitle("Date")  ytitle("Price")                                     ///
    legend( order(1 "open" 2 "close") ring(0) pos(7))

* 更改线条颜色和粗细
graph twoway (line open close n in 1/50, sort clpattern(- l)          /// 
    clcolor(blue red) clwidth(0.9 0.9)),                                ///
    title("SP500 Stock Price") subtitle("January 2 to March 14")        ///
    xtitle("Date") ytitle("Price")                                      ///
    legend( order(1 "open" 2 "close") ring(0) pos(7))

* 利用scheme改变图形风格，使用命令help scheme查看帮助文档
graph display, scheme(economist)                //使用经济学人杂志绘图风格
graph export fig2.pdf, replace


******** 直方图绘制 ********
use "stockltd.dta", clear
drop if roa==. | year < 2019       //剔除缺失值并保留2019年上市公司roa数据
ssc install winsor2, replace
winsor2 roa, replace cut(1 99)     //进行1%和99%的缩尾处理
sum(roa)                           //查看描述性统计，确定横轴范围
* 绘制直方图
histogram roa, fraction normal                           ///
    title ("2019年上市公司资产收益率直方图")               ///
    start(-0.5) xlabel (-0.5 (0.1) 0.2) xmtick(##2)        ///
    xtitle("上市公司资产收益率")  ytitle("所占比重")
graph export bar1.pdf, replace


******** 箱线图绘制 ********
use "stockltd.dta", clear
drop if bm ==. 
winsor2 bm, replace cut(1 99) 
* 绘制箱线图
graph box bm, over(year, label(angle(45)))                       ///
    box(1, color("51 102 204")) ylabel(0(0.2)1.2) nooutside        ///
    title("上市公司账面市值比箱线图") ymtick(##2) ytitle("账面市值比") 
graph export box1.pdf, replace




























