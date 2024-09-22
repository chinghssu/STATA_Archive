set more off
cd "D:\hsiemf\20170322"


foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {
forv m=1/2 {
use h`i'_`m',clear

egen t_c1=total(temp1),by(tripid)
egen t_c2a=total(temp2a),by(tripid)
egen t_c2b=total(temp2b),by(tripid)
egen t_c3a=total(temp3a),by(tripid)
egen t_c3b=total(temp3b),by(tripid)
egen t_c4=total(temp4),by(tripid)
egen t_c5=total(temp5),by(tripid)
egen t_c6=total(temp6),by(tripid)
egen t_c7=total(temp7),by(tripid)
egen t_c8=total(temp8),by(tripid)
egen t_c9=total(temp9),by(tripid)
egen t_c10=total(temp10),by(tripid)
egen t_c11=total(temp11),by(tripid)
egen t_c12 = total(dollarspaid*low_fat), by(tripid)
egen t_c13 = total(dollarspaid*(1-low_fat)),by(hhid)
egen t_c14 = total(dollarspaid*low_salt), by(tripid)
egen t_c15 = total(dollarspaid*(1-low_salt)),by(tripid)

keep hhid tripid halfyr t_c1 t_c2a t_c2b t_c3a t_c3b t_c4 t_c5 t_c6 t_c7 t_c8 t_c9 t_c10 t_c11 t_c12 t_c13 t_c14 t_c15
duplicates drop
save ototal`i'_`m',replace

}
}
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {
forv m=1/2 {
use ototal`i'_`m',clear
/*duplicatesfirst and then egen means */
egen m_c1=mean(t_c1),by(hhid halfyr)
egen m_c2a=mean(t_c2a),by(hhid halfyr)
egen m_c2b=mean(t_c2b),by(hhid halfyr)
egen m_c3a=mean(t_c3a),by(hhid halfyr)
egen m_c3b=mean(t_c3b),by(hhid halfyr)
egen m_c4=mean(t_c4),by(hhid halfyr)
egen m_c5=mean(t_c5),by(hhid halfyr)
egen m_c6=mean(t_c6),by(hhid halfyr)
egen m_c7=mean(t_c7),by(hhid halfyr)
egen m_c8=mean(t_c8),by(hhid halfyr)
egen m_c9=mean(t_c9),by(hhid halfyr)
egen m_c10=mean(t_c10),by(hhid halfyr)
egen m_c11=mean(t_c11),by(hhid halfyr)
egen m_c12=mean(t_c12),by(hhid halfyr)
egen m_c13=mean(t_c13),by(hhid halfyr)
egen m_c14=mean(t_c14),by(hhid halfyr)
egen m_c15=mean(t_c15),by(hhid halfyr)
keep hhid halfyr m_c1 m_c2a m_c2b m_c3a m_c3b m_c4 m_c5 m_c6 m_c7 m_c8 m_c9 m_c10 m_c11 m_c12 m_c13 m_c14 m_c15 
save omean`i'_`m',replace
}
}
/*egen m_c1=mean(temp1),by(hhid)
keep m_c1 hhid
save m_c1_`m'_`k',replace*/
*--------------------------------
*-------------------organic1-----
*--------------------------------

foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {
forv m=1/2 {
use h`i'_`m',clear

egen t_c1_org1=total(organic1*temp1),by(tripid)
egen t_c2a_org1=total(organic1*temp2a),by(tripid)
egen t_c2b_org1=total(organic1*temp2b),by(tripid)
egen t_c3a_org1=total(organic1*temp3a),by(tripid)
egen t_c3b_org1=total(organic1*temp3b),by(tripid)
egen t_c4_org1=total(organic1*temp4),by(tripid)
egen t_c5_org1=total(organic1*temp5),by(tripid)
egen t_c6_org1=total(organic1*temp6),by(tripid)
egen t_c7_org1=total(organic1*temp7),by(tripid)
egen t_c8_org1=total(organic1*temp8),by(tripid)
egen t_c9_org1=total(organic1*temp9),by(tripid)
egen t_c10_org1=total(organic1*temp10),by(tripid)
egen t_c11_org1=total(organic1*temp11),by(tripid)
egen t_c12_org1 = total(organic1*dollarspaid*low_fat), by(tripid)
egen t_c13_org1 = total(organic1*dollarspaid*(1-low_fat)),by(hhid)
egen t_c14_org1 = total(organic1*dollarspaid*low_salt), by(tripid)
egen t_c15_org1 = total(organic1*dollarspaid*(1-low_salt)),by(tripid)

keep tripid halfyr hhid t_c1_org1 t_c2a_org1 t_c2b_org1 t_c3a_org1 t_c3b_org1 t_c4_org1 t_c5_org1 t_c6_org1 t_c7_org1 t_c8_org1 t_c9_org1 t_c10_org1 t_c11_org1 t_c12_org1 t_c13_org1  t_c14_org1 t_c15_org1 

duplicates drop
save org1total`i'_`m',replace
}
}

foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {
forv m=1/2 {
use org1total`i'_`m',clear

egen m_c1_org1=mean(t_c1_org1),by(hhid halfyr)
egen m_c2a_org1=mean(t_c2a_org1),by(hhid halfyr)
egen m_c2b_org1=mean(t_c2b_org1),by(hhid halfyr)
egen m_c3a_org1=mean(t_c3a_org1),by(hhid halfyr)
egen m_c3b_org1=mean(t_c3b_org1),by(hhid halfyr)
egen m_c4_org1=mean(t_c4_org1),by(hhid halfyr)
egen m_c5_org1=mean(t_c5_org1),by(hhid halfyr)
egen m_c6_org1=mean(t_c6_org1),by(hhid halfyr)
egen m_c7_org1=mean(t_c7_org1),by(hhid halfyr)
egen m_c8_org1=mean(t_c8_org1),by(hhid halfyr)
egen m_c9_org1=mean(t_c9_org1),by(hhid halfyr)
egen m_c10_org1=mean(t_c10_org1),by(hhid halfyr)
egen m_c11_org1=mean(t_c11_org1),by(hhid halfyr)
egen m_c12_org1=mean(t_c12_org1),by(hhid halfyr)
egen m_c13_org1=mean(t_c13_org1),by(hhid halfyr)
egen m_c14_org1=mean(t_c14_org1),by(hhid halfyr)
egen m_c15_org1=mean(t_c15_org1),by(hhid halfyr)
keep tripid halfyr hhid m_c1_org1 m_c2a_org1 m_c2b_org1 m_c3a_org1 m_c3b_org1 m_c4_org1 m_c5_org1 m_c6_org1 m_c7_org1 m_c8_org1 m_c9_org1 m_c10_org1 m_c11_org1 m_c12_org1 m_c13_org1 m_c14_org1 m_c15_org1

save org1mean`i'_`m',replace
}
}



*---------------organic2-----------
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {
forv m=1/2 {
use h`i'_`m',clear

egen t_c1_org2=total(organic2*temp1),by(tripid)
egen t_c2a_org2=total(organic2*temp2a),by(tripid)
egen t_c2b_org2=total(organic2*temp2b),by(tripid)
egen t_c3a_org2=total(organic2*temp3a),by(tripid)
egen t_c3b_org2=total(organic2*temp3b),by(tripid)
egen t_c4_org2=total(organic2*temp4),by(tripid)
egen t_c5_org2=total(organic2*temp5),by(tripid)
egen t_c6_org2=total(organic2*temp6),by(tripid)
egen t_c7_org2=total(organic2*temp7),by(tripid)
egen t_c8_org2=total(organic2*temp8),by(tripid)
egen t_c9_org2=total(organic2*temp9),by(tripid)
egen t_c10_org2=total(organic2*temp10),by(tripid)
egen t_c11_org2=total(organic2*temp11),by(tripid)
egen t_c12_org2 = total(organic2*dollarspaid*low_fat), by(tripid)
egen t_c13_org2 = total(organic2*dollarspaid*(1-low_fat)),by(hhid)
egen t_c14_org2 = total(organic2*dollarspaid*low_salt), by(tripid)
egen t_c15_org2 = total(organic2*dollarspaid*(1-low_salt)),by(tripid)

keep tripid halfyr hhid t_c1_org2 t_c2a_org2 t_c2b_org2 t_c3a_org2 t_c3b_org2 t_c4_org2 t_c5_org2 t_c6_org2 t_c7_org2 t_c8_org2 t_c9_org2 t_c10_org2 t_c11_org2 t_c12_org2 t_c13_org2 t_c14_org2 t_c15_org2
duplicates drop
save org2total`i'_`m',replace
}
}

foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {
forv m=1/2 {
use org2total`i'_`m',clear

egen m_c1_org2=mean(t_c1_org2),by(hhid halfyr)
egen m_c2a_org2=mean(t_c2a_org2),by(hhid halfyr)
egen m_c2b_org2=mean(t_c2b_org2),by(hhid halfyr)
egen m_c3a_org2=mean(t_c3a_org2),by(hhid halfyr)
egen m_c3b_org2=mean(t_c3b_org2),by(hhid halfyr)
egen m_c4_org2=mean(t_c4_org2),by(hhid halfyr)
egen m_c5_org2=mean(t_c5_org2),by(hhid halfyr)
egen m_c6_org2=mean(t_c6_org2),by(hhid halfyr)
egen m_c7_org2=mean(t_c7_org2),by(hhid halfyr)
egen m_c8_org2=mean(t_c8_org2),by(hhid halfyr)
egen m_c9_org2=mean(t_c9_org2),by(hhid halfyr)
egen m_c10_org2=mean(t_c10_org2),by(hhid halfyr)
egen m_c11_org2=mean(t_c11_org2),by(hhid halfyr)
egen m_c12_org2=mean(t_c12_org2),by(hhid halfyr)
egen m_c13_org2=mean(t_c13_org2),by(hhid halfyr)
egen m_c14_org2=mean(t_c14_org2),by(hhid halfyr)
egen m_c15_org2=mean(t_c14_org2),by(hhid halfyr)
keep tripid halfyr hhid m_c1_org2 m_c2a_org2 m_c2b_org2 m_c3a_org2 m_c3b_org2 m_c4_org2 m_c5_org2 m_c6_org2 m_c7_org2 m_c8_org2 m_c9_org2 m_c10_org2 m_c11_org2 m_c12_org2 m_c13_org2 m_c14_org2 m_c15_org2  

duplicates drop
save org2mean`i'_`m',replace
}
}

*------------append all markets
*1.origin
clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using ototal`i'_1
}
drop hhid
save alltotal_1,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using ototal`i'_2
}
drop hhid
save alltotal_2,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using omean`i'_1
}
save allmean_1,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using omean`i'_2
}
save allmean_2,replace

*2. organic 1


clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org1total`i'_1
}
drop hhid
save allorg1total_1,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org1total`i'_2
}
drop hhid
save allorg1total_2,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org1mean`i'_1
}
save allorg1mean_1,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org1mean`i'_2
}
save allorg1mean_2,replace


*3. organic 2


clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org2total`i'_1
}
drop hhid
save allorg2total_1,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org2total`i'_2
}
drop hhid
save allorg2total_2,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org2mean`i'_1
}
save allorg2mean_1,replace

clear
foreach i of numlist 1/3 7 8 12/14 17/20 22 24 28 29 32 38 41 42 44 50 51 {

append using org2mean`i'_2
}
save allorg2mean_2,replace

/* temps
forv m=1(1)2 {
forv k=1(1)2 {
use u`m'_`k',clear
g temp1=dollarspaid if deptid==1
egen t_c1=total(temp1),by(tripid)
keep t_c1 tripid hhid
save tc1,replace
egen m_c1=mean(temp1),by(hhid)
keep m_c1 hhid
save v`m'_`k',replace
}
}

local m=`m'+1
*------organic
g o1temp1=dollarspaid*organic1 if deptid=1
egen egen t_c1=total(o1temp1),by(tripid)
egen m_c1=mean(o1temp1),by(hhid)

keep 
duplicates drop
