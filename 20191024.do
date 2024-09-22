set more off
cd "C:\gcloud5\Work\AIECON\postdoc\data"

use 20190820_numerical.dta, clear
tsset period, monthly
log using 20191024, replace

describe
sum
*UKXR WPI USXR SLVstock NYSP LNDSP IR
foreach i of varlist WPI USXR SLVstock NYSP IR {

di "`i'" in smcl as result
dfuller `i'
dfuller D.`i'
}
* "By the Augmented Dickey-Fuller test, we obtain the eLon and i are I(0) variables, and the others are I(1) variables"
* "Hence, by the definition of cointegration, there are no cointegration in these variables."
varsoc D.WPI D.USXR D.SLVstock IR
* By BIC criterion test, we choose lag 1
var D.WPI D.USXR D.SLVstock D.NYSP IR, lags(1)

*The Granger cauality test are as follows:
*For example:
*Null hypothesis: eLON(Equation) is not granger cause D.WPI(Excluded)
*The p-value is 0.820 which means that the null hypothesis is not rejected.
*Hence eLON is not a cause of WPI.    
vargranger


qui var D.WPI D.USXR D.SLVstock D.NYSP IR, lags(1)

irf create irf1, step(10) set(irf1) replace

foreach i of varlist D.WPI D.USXR D.SLVstock D.NYSP IR IR {

  foreach j of varlist D.WPI D.USXR D.SLVstock D.NYSP IR IR {

  irf graph irf, impulse(`i') response(`j') byopts(note("") legend(off))

  graph save Graph "C:\gcloud5\Work\AIECON\postdoc\data\pic\a_`i'_`j'.gph", replace


  }
}

cd "C:\gcloud5\Work\AIECON\postdoc\data\pic"
fs *.gph
graph combine `r(files)'
graph save Graph "C:\gcloud5\Work\AIECON\postdoc\data\IRF0820.gph", replace
*/

log close
cd "C:\gcloud5\Work\AIECON\postdoc\data"
translate 20190820.smcl 20191024.pdf,replace
