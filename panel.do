clear all
set more off
local texpath "C:\Working\trade_network\data\"

* Load data
import delimited "C:\Working\trade_network\data\panel.csv"

xtset num_id date, yearly
xi i.date

xtreg x_ch L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2008-_Idate_2015, fe
xtreg x_ch L1.x_def L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2008-_Idate_2015, fe

xtdpd x_ch L1.x_ch L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2008-_Idate_2015, ///
	dgmmiv(L1.x_ch) dgmmiv(L1.q_ch) div(_Idate_2008-_Idate_2015) nocons hascons 

xtabond2 x_ch L1.x_ch L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2009-_Idate_2015, gmm((L.x_ch)) iv(L1.q_ch _Idate_*) twostep nolevel robust 

clear all
set more off
local texpath "C:\Working\trade_network\data\"

* Load data
import delimited "C:\Working\trade_network\data\panel_oil.csv"

* Create numerical index
sort iso2
by iso2 : gen first = _n == 1
gen num_id = sum(first)
drop first


gen date2=date(date,"YMD")
generate date1= mofd(date2)
format  date1 %tm


xtset num_id date1, monthly
xi i.date1

gen d_p = p - L1.p
gen c_ecm = d_p * ecm
gen c_ecx = d_p * ecx


xtreg x_ch L1.x_def L1.q_ch L1.c_ecm, fe
*xtreg x_ch L1.x_def L1.q_ch L1.c_ecm i.date1, fe
xtreg x_ch L1.x_def L1.q_ch L1.d_p, fe
xtreg x_ch L1.x_def L1.q_ch L1.d_p L1.ecm, fe

xtdpd x_ch L1.x_ch L1.q_ch L1.c_ecm, ///
	dgmmiv(L1.x_ch, lagrange(0 1)) nocons hascons

xtdpd x_ch L1.x_ch L1.q_ch L1.d_p L1.ecm, ///
	dgmmiv(L1.x_ch, lagrange(0 1)) nocons hascons
*estat sargan

*xtdpd x_ch L1.x_ch q_ch cs_def ns_def cn_def i.date
/*
* Create numerical index
sort iso2
by iso2 : gen first = _n == 1
gen num_id = sum(first)
drop first

* Declare data to be panel 



save "C:\Working\trade_network\data\panel.dta", replace
*/
*export delimited "C:\Working\trade_network\panel.csv", replace

/*
foreach v of varlist x_def q cs_def ns_def cn_def{
bysort num_id: egen mean_`v'=mean(`v')
g demeaned_`v'=`v'-mean_`v'
drop mean_`v'
}


gen y = D1.x_def
gen FE1 = D1.x_def
gen FE2 = D1.x_def
gen GMM1 = D1.x_def
gen GMM2 = D1.x_def
gen x1 = L1.D1.x_def
gen x1b = L1.x_def
gen x2 = L1.q_ch
gen x3 = L1.cs_def
gen x4 = L1.ns_def
gen x5 = L1.cn_def
gen x6 = L1.nn_def
gen m_sum = x3 + x4 + x5 + x6
gen x3b = x3 / m_sum
gen x4b = x4 / m_sum
gen x5b = x5 / m_sum


xtreg FE1 L1.x_def L1.q_ch L1.cs_def L1.ns_def L1.cn_def i.date, fe 
est2vec table, e(r2_a F chi2 sig2) vars(L1.x_def L1.D1.x_def L1.q_ch L1.cs_def L1.ns_def L1.cn_def)

xtreg FE2 L1.D1.x_def L1.q_ch L1.cs_def L1.ns_def L1.cn_def i.date, fe 
est2vec table, addto(table)

xtabond2 GMM1 L1.x_def L1.q_ch L1.cs_def L1.ns_def L1.cn_def i.date, gmm(x1b) nocons
est2vec table, addto(table)

xtabond2 GMM2 L1.D1.x_def L1.q_ch L1.cs_def L1.ns_def L1.cn_def i.date, gmm(x1b) nocons
est2vec table, addto(table)
est2tex table, preserve path(`texpath') levels(90 95 99) mark(stars) thousep fancy leadzero replace

* Load csv file with data
import delimited "C:\Working\trade_network\data\panel_oil.csv"

gen ddate = daily(date, "YMD")

gen mdate = mofd(ddate)

format mdate %tm

* Create numerical index
sort iso2
by iso2 : gen first = _n == 1
gen num_id = sum(first)
drop first

* Declare data to be panel
xtset num_id mdate, monthly

gen c_ecm = D1.p * ecm
gen c_ecx = D1.p * ecx

*xtgls D1.x_def L1.D1.x_def L1.q_ch c_ecm, pan(correlate hetero) corr(ar1) 

xtreg D1.x_def L1.x_def q_ch c_ecm L1.D1.p i.mdate, fe 

gen FE2 = D1.x_def
gen FE1 = D1.x_def

xtreg FE1 L1.x_def L1.q_ch c_ecm L1.D1.p  i.mdate, fe 
est2vec table, e(r2_a F) vars(L1.x_def L1.q_ch c_ecm ecm D1.p L1.D1.p)

xtreg FE2 L1.x_def L1.q_ch c_ecm, fe 
est2vec table, addto(table)

gen FE3 = D1.x_def
xtreg FE3 L1.x_def L1.q_ch ecm D1.p i.mdate, fe 
est2vec table, addto(table)

est2tex table, preserve path(`texpath') levels(90 95 99) mark(stars) thousep fancy leadzero replace


*/


*xtreg D1.x_def L1.x_def L1.q_ch ecx D1.p i.mdate, fe 

*xtreg D1.x_def L1.x_def L1.q_ch c_ecm, fe 

*xtreg D1.x_def L1.x_def L1.q_ch c_ecx, fe 

*xtgls D1.x_def L1.x_def L1.q_ch ecx D1.p i.mdate, pan(correlate hetero) corr(ar1) 

* Estimate results

*xtreg x_ch L1.x_ch q_ch ecx p_ch, fe /* as listed above */
* xtabond x_ch q_ch ecx p_ch, vce(robust) 
*xtabond x_ch q_ch c, vce(robust)     /* Arellano-Bond GMM */
* xtabond x_ch q_ch ecm p_ch, vce(robust) 
*xtabond x_ch q_ch c, vce(robust)     /* Arellano-Bond GMM */

*xtabond2 x_ch L1.x_ch q_ch c, gmm((L1.x_ch)) twostep
*xtreg x_ch L1.x_def q_ch c, fe
*outtex, detail level below title(Dep = `e(depvar)') legend 
