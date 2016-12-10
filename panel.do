clear all
set more off
local texpath "C:\Working\trade_network\data\"

* Load data
import delimited "C:\Working\trade_network\data\panel.csv"

xtset num_id date, yearly
xi i.date

*** NATURAL DISASTER SHOCKS MODEL *** 

*reg x_ch L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2008-_Idate_2015, robust
gen FE1 = x_ch
gen FE2 = x_ch
gen GMM = x_ch

xtreg FE1 L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2008-_Idate_2015, fe
est2vec table, e(N N_g g_min arm1 arm2 r2_a sargan sig2) vars(L1.x_def L1.x_ch L1.q_ch L1.cs_def L1.ns_def L1.cn_def)

xtreg FE2 L1.x_def L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2008-_Idate_2015, fe
est2vec table, addto(table)

xtdpd GMM L1.x_ch L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2009-_Idate_2015, ///
	dgmmiv(L.x_ch) div(L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2009-_Idate_2015) nocons hascons vce(robust)
*est2vec table, addto(table)
	
xtabond2 GMM L.x_ch L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2009-_Idate_2015, ///
	gmm((L.x_ch), e(d)) iv(L1.q_ch L1.cs_def L1.ns_def L1.cn_def _Idate_2009-_Idate_2015, e(d)) nolevel robust
est2vec table, addto(table)
	
est2tex table, preserve path(`texpath') levels(90 95 99) mark(stars) thousep fancy leadzero replace


*** OIL SHOCKS MODEL ***

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
gen x_def_l = L1.x_def	
gen q_ch_l = L1.q_ch
gen c_ecm_l = L1.c_ecm
gen ecm_l = L1.ecm
gen d_p_l = L1.d_p

gen FE1 = x_ch
gen FE2 = x_ch
gen FE3 = x_ch
gen MG = x_ch
gen CCE = x_ch

xtreg FE1 x_def_l q_ch_l c_ecm_l, fe
est2vec table2, e(N g_min r2_a sig2 trend_sig) vars(x_def_l q_ch_l d_p_l ecm_l c_ecm_l)

xtreg FE2 x_def_l q_ch_l d_p_l, fe
est2vec table2, addto(table2)

xtreg FE3 x_def_l q_ch_l d_p_l ecm_l, fe
est2vec table2, addto(table2)

xtmg CCE x_def_l q_ch_l c_ecm_l, cce trend robust
est2vec table2, addto(table2)

est2tex table2, preserve path(`texpath') levels(90 95 99) mark(stars) thousep fancy leadzero replace


