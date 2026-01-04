cd "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata"
cap log close
log using logfiles/UNE_GAP_REG.txt, text replace

/// Presidential Effect on Unemployment 
use rawdata/BLK_WHT_UNE.dta, clear
drop if nwhtsaune == .
arima nwhtsaune L1.nwhtsaune L3.president_democrate, ar(1/2)
gen unegap = nwhtsaune - whtsaune
arima unegap L1.unegap L4.president_democrate, ar(1)

/// Looking for significant changes in unemployment by date
reg nwhtsaune L1.nwhtsaune L3.president_democrate
estat sbsingle

use rawdata/BLK_WHT_UNE.dta, clear
drop if blksaune == .
arima blksaune L1.blksaune L3.president_democrate, ar(1/2)
gen unegap = blksaune - whtsaune
arima unegap L1.unegap L4.president_democrate, ar(1)

/// Looking for significant changes in signicance base on years

/// Cutting from more recent year
drop if year > 2000
arima unegap L1.unegap L4.president_democrate, ar(1)

drop if year > 1990
arima unegap L1.unegap L4.president_democrate, ar(1)

drop if year > 1980
arima unegap L1.unegap L4.president_democrate, ar(1)
---
/// Cutting from earlier years
use rawdata/BLK_WHT_UNE.dta, clear
drop if blksaune == .
gen unegap = blksaune - whtsaune

drop if year < 1980
arima unegap L1.unegap L4.president_democrate, ar(1)

drop if year < 1990
arima unegap L1.unegap L4.president_democrate, ar(1)

drop if year < 2000
arima unegap L1.unegap L4.president_democrate, ar(1)

---
////Remove and Add --- here depending on whether you want to look at interactions 

use rawdata/BLK_WHT_UNE.dta, clear
drop if whtsaune ==.
arima whtsaune L1.whtsaune L3.president_democrate, ar(1/2)

/// More than just the president
use rawdata/BLK_WHT_UNE.dta, clear
* Create the lagged variables
gen L3_president_democrate = L3.president_democrate
gen L3_senate_democrate = L3.senate_democrate
gen L3_house_democrate = L3.house_democrate

* Create all 2-way interactions
gen L3_pres_senate_democrate = L3_president_democrate * L3_senate_democrate
gen L3_pres_house_democrate = L3_president_democrate * L3_house_democrate
gen L3_senate_house_democrate = L3_senate_democrate * L3_house_democrate

* Create the 3-way interaction
gen L3_pres_sen_house_democrate = L3_president_democrate * L3_senate_democrate * L3_house_democrate

save rawdata/BLK_WHT_UNE_PWRCON.dta, replace

// NWHT SA UNE
drop if nwhtsaune == .
arima nwhtsaune L1.nwhtsaune L3_house_democrate L3_president_democrate L3_senate_democrate L3_senate_house_democrate L3_pres_house_democrate L3_pres_sen_house_democrate, ar(1/2)
gen unegap = nwhtsaune - whtsaune
arima unegap L1.unegap L3_house_democrate L3_president_democrate L3_senate_democrate L3_senate_house_democrate L3_pres_house_democrate L3_pres_sen_house_democrate, ar(1)

// BLK SA UNE
use rawdata/BLK_WHT_UNE_PWRCON.dta, clear
drop if blksaune == .
arima blksaune L1.blksaune L3_house_democrate L3_president_democrate L3_senate_democrate L3_senate_house_democrate L3_pres_house_democrate L3_pres_sen_house_democrate, ar(1/2)
gen unegap = blksaune - whtsaune
arima unegap L1.blksaune L3_house_democrate L3_president_democrate L3_senate_democrate L3_senate_house_democrate L3_pres_house_democrate L3_pres_sen_house_democrate, ar(1)

// WHT SA UNE
use rawdata/BLK_WHT_UNE_PWRCON.dta, clear
drop if whtsaune ==.
arima whtsaune L1.whtsaune L3_house_democrate L3_president_democrate L3_senate_democrate L3_senate_house_democrate L3_pres_house_democrate L3_pres_sen_house_democrate, ar(1/2)

 