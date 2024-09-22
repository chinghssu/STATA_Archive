clear
set more off
cd "H:\hsiemf\20170410"
log using format_price, replace

* ================================================================
* Store format, base basket selection & price index
* 1. define store formats
* 2. define base basket
* 3. generate price indexes
*
* data source: data`l'_`j', store_info_`l'
*                   l=1(2005-06), 2(2007-08), j=market id
* outputs: basket_`j', data`l'b_`j', pi`l'_`j', orgpi`l'_`j'
*
* use the same basket definition for both 2005-06 and 2007-08
* generate price indexes (monthly)
* ================================================================

* ======#####========


* === j: market id ===

/*foreach j of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51{
forv l=1/2{
use `j'_`l',clear

save data`l'_`j',replace
}
}*/

* ===================

* ---------------------------------------------------------------
*
* 1. define "store formats" - stformat
*
* ---------------------------------------------------------------

* === l: 1 for 2005-06, 2 for 2007-08 ===
foreach j of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51{
local l = 1

while (`l' <= 2) {
use data`l'_`j'

destring store* pm pg channelid deptid organicclaim usdaorganic, replace

* a. products with USDA organic seals
g organic1=0 if usdaorganic~=.
replace organic1=1 if usdaorganic==4

* b. products with organic claim
g organic2=0 if organicclaim~=.
replace organic2=1 if organicclaim==3 | (organicclaim>4 & organicclaim~=.)
replace organic2=0 if organicclaim==32 | organicclaim==50

g storeid = storename*10^5 + storezip
form storeid %12.0g
sort storeid
merge m:m storeid using store_info_`l'
drop if _merge==2
drop _merge

* ========================= define formats ==============================

* Condition 1. orgstore:  % organics in total sales & total items
g r_org1sales = sales_org1 / sales
g r_org2sales = sales_org2 / sales
g r_org1items = items_org1 / items
g r_org2items = items_org2 / items

egen r_org = rowtotal(r_org1sales r_org2sales r_org1items r_org2items)

g orgstore = 0
replace orgstore = 1 if r_org ~=. & r_org >= .5

* Condition 2. freshstore:  % fresh produce in total sales & total items
g exp_fresh = dollarspaid if deptid == 6
egen sales_fresh = total(exp_fresh), by(storeid)
g r_freshsales = sales_fresh / sales

g n_fresh = 1 if deptid == 6
egen items_fresh = total(n_fresh), by(storeid)
g r_freshitems = items_fresh / items

egen r_fresh = rowmean(r_freshsales r_freshitems)

g freshstore = 0
replace freshstore = 1 if r_fresh ~=. & r_fresh >= .5

* --- store formats ---
*   1. supercenters
*   2. grocery stores
*   3. organic stores
*   4. fresh stores
* ---------------------
g 		stformat=1	if channelid==4
replace stformat=2 	if channelid~=4 & orgstore == 0 & freshstore==0
replace stformat=3 	if channelid~=4 & orgstore == 1 & freshstore==0
replace stformat=4 	if channelid~=4 & orgstore == 0 & freshstore==1
* =======================================================================

table stformat, c(mean sales mean items mean r_org mean r_fresh)
table stformat, c(mean pms mean upcs mean hhids mean mdist mean vdist)

save data`l'a_`j', replace
drop _all

local l = `l' + 1
}


}
* ---------------------------------------------------------------
*
* 2. define "base basket": 1)basketsm, 2)basketbg, 3)basketorg2
*
* ---------------------------------------------------------------
foreach j of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51{
use data1a_`j'

*
* ------ 2.1 regular baskets ------
*
table pm, by(stformat) c(mean pg n pg) f(%5.0f) replace
rename table1 pg
rename table2 n

* indicator for each format
g f1=n if stformat==1
g f2=n if stformat==2
g f3=n if stformat==3
g f4=n if stformat==4

* frequency for each format
egen freq1=total(f1), by(pm)
egen freq2=total(f2), by(pm)
egen freq3=total(f3), by(pm)
egen freq4=total(f4), by(pm)

*---drop f1 f2 f3 f4

keep pg pm freq*
duplicates drop
egen ftotal = rowtotal(freq*)
egen fmin  = rowmin(freq1 freq2 freq3 freq4)

g basketsm = 1 if fmin >= 50
g basketbg = 1 if fmin >= 10

egen rsm = rank(-ftotal) if basketsm==1
egen rbg = rank(-ftotal) if basketbg==1

gsort -ftotal
list pm pg ftotal r* if basketbg==1

sort pm pg
save basket1, replace
drop _all

*
* ------ 2.2 organic basket ------
* 
* (use organic2 as organic index)
*

use data1a_`j'

table pm if organic2==1 , by(stformat) c(mean pg n pg) f(%5.0f) replace
rename table1 pg
rename table2 n

* indicator for each format
g f1=n if stformat==1
g f2=n if stformat==2
g f3=n if stformat==3
g f4=n if stformat==4

* frequency for each format
egen forg1=total(f1), by(pm)
egen forg2=total(f2), by(pm)
egen forg3=total(f3), by(pm)
egen forg4=total(f4), by(pm)

drop f1 f2 f3 f4

keep pg pm forg*
duplicates drop
egen forgtot = rowtotal(forg*)
egen fminorg1 = rowmin(forg1 forg2 forg3 forg4)
egen fminorg2 = rowmin(forg2 forg3)

g basketorg1 = 1 if fminorg1 >= 5
g basketorg2 = 1 if fminorg2 >= 5

gsort -forgtot
egen rorg = rank(-forgtot) if basketorg2 == 1

sort pm pg
save basket2, replace

merge m:m pm pg using basket1
tab _merge
drop _merge

sort pm
merge m:m pm using prod_names
drop if _merge==2
drop _merge

sort pm
save basket_`j', replace 
* including 1) basketbg 2) basketsm and 3) basketorg2

gsort -ftotal
list pm pmname pg pgname if basketbg==1 | basketsm==1 | basketorg2==1
list pm ftotal forgtot r* if basketbg==1 | basketsm==1 | basketorg2==1

/*erase basket1.dta
erase basket2.dta*/

drop _all
}

log close

log using def_priceindexes, replace
* ---------------------------------------------------------------
*
* 3. define "price indexes"
*
* ---------------------------------------------------------------
* /*ignore mkt=12 41 because cannot produce share*/
* ---------------------------------------------------------------


foreach j of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51{
local l = 1

while (`l'<=2) {

use data`l'a_`j'

destring purmo puryr, replace

* --- period 0: initiation period; period 1: estimation period ----
g period = 1
replace period = 0 if (puryr == 2005 | puryr == 2007) & purmo <= 6
* -----------------------------------------------------------------

g unitdollars = dollarspaid / quantity

sort pm
merge m:m pm using basket_`j'
drop if _merge==2
drop _merge
sort pm
save temp`l'_`j', replace
local l=`l'+1
}
}
* === 3.1 price index for small basket by formats ===

* >> pm market share (whole market) <<
foreach j of numlist 1/3 7 8 13 14 17/20 22 24 28 29 32 38 41 42 44 50 51{
local l = 1 /*ignore mkt=12 because cannot produce share*/

while (`l'<=2) {

use data`l'a_`j'
sort pm
merge m:m pm using basket_`j'
drop if _merge==2
drop _merge
sort pm
* --- period 0: initiation period; period 1: estimation period ----
g period = 1
destring purmo puryr,replace
replace period = 0 if (puryr == 2005 | puryr == 2007) & purmo <= 6
* -----------------------------------------------------------------
/*有問題的先不用跑*/
table pm if basketsm==1 & period==0, c(n dollarspaid) replace
rename table1 freq
egen totfreq = total(freq)
g share = freq/totfreq
sort pm
save smshare`l'_`j', replace
drop _all

* >> pm unit price by format <<
use temp`l'_`j'
keep if basketsm==1
egen unitprice = mean(unitdollars), by(pm purmo puryr stformat)
sort pm

*>> merge & calculate index <<
merge m:m pm using smshare`l'_`j'
drop _merge
g ps = unitprice*share
keep pm purmo puryr stformat unitprice share ps
duplicates drop

egen pi = mean(ps), by(stformat purmo puryr)

sort stformat purmo puryr
save smpi`l'_`j', replace

* -------- table of mean monthly price index -------
table purmo stformat, c(mean pi) by(puryr) replace
rename table1 price
g market = `j'
sort stformat puryr purmo
save pi`l'_`j', replace
* --------------------------------------------------

drop _all

* === 3.2 price index for small "organic" basket by format ===

* >> pm market share (whole market) <<
use temp`l'_`j'
table pm if basketorg1==1 & period==0, c(n dollarspaid) replace
rename table1 freq
egen totfreq = total(freq)
g share = freq/totfreq
sort pm
save org1share`l'_`j', replace

* >> pm unit price by format <<
use temp`l'_`j'
keep if basketorg1==1
egen org1price = mean(unitdollars), by(pm purmo puryr stformat)
sort pm

*>> merge & calculate index <<
merge m:m pm using org1share`l'_`j'
drop _merge
g org1ps = org1price*share
keep pm purmo puryr stformat org1price share org1ps
duplicates drop

egen org1pi = mean(org1ps), by(stformat purmo puryr)

sort stformat purmo puryr
save org1pi`l'_`j', replace

* ----- table of mean monthly organic price index -----
table purmo stformat, c(mean org1pi) by(puryr) replace
rename table1 orgprice
g market = `j'
sort stformat puryr purmo
save orgpi`l'_`j', replace
* -----------------------------------------------------

drop _all

* ==== merge & erase files ====
use temp`l'_`j'

sort stformat purmo puryr
merge m:m stformat purmo puryr using smpi`l'_`j'
tab _merge
drop _merge

sort stformat purmo puryr
merge m:m stformat purmo puryr using org1pi`l'_`j'
tab _merge
drop _merge

* ---- generate format-price-index ----
g f1=1 if stformat==1
g f2=1 if stformat==2
g f3=1 if stformat==3
g f4=1 if stformat==4

g pi1=f1*pi
g pi2=f2*pi
g pi3=f3*pi
g pi4=f4*pi

egen p1=mean(pi1), by(purmo puryr)
egen p2=mean(pi2), by(purmo puryr)
egen p3=mean(pi3), by(purmo puryr)
egen p4=mean(pi4), by(purmo puryr)

g p12 = p1/p2
g p32 = p3/p2
g p42 = p4/p2
g p1_2 = p1-p2
g p3_2 = p3-p2
g p4_2 = p4-p2

drop f1 f2 f3 f4 pi1 pi2 pi3 pi4

*compress
save data`l'b_`j', replace

drop _all

/*erase temp`l'_`j'.dta
erase data`l'a_`j'.dta
erase smshare`l'_`j'.dta
erase smpi`l'_`j'.dta
erase org1share`l'_`j'.dta
erase org1pi`l'_`j'.dta*/
 
local l = `l' + 1
}




}

log close
