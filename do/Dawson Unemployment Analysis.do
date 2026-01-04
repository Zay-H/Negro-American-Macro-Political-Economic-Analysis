cd "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata"
cap log close
log using logfiles/UNE_GAP_REG_DAW.txt, text replace

/// Presidential Effect on Unemployment Dawson's Years
use rawdata/BLK_WHT_UNE.dta, clear
drop if nwhtsaune == .
drop if tm >= tm(1985q4)
arima nwhtsaune L1.nwhtsaune L3.president_democrate, ar(1/2)

gen unegap = nwhtsaune - whtsaune
arima unegap L1.unegap L4.president_democrate, ar(1)

use rawdata/BLK_WHT_UNE.dta, clear
drop if blksaune == .
drop if tm >= tm(1985q4)
arima blksaune L1.blksaune L3.president_democrate, ar(1/2)

gen unegap = blksaune - whtsaune
arima unegap L1.unegap L4.president_democrate, ar(1)

use rawdata/BLK_WHT_UNE.dta, clear
drop if whtsaune ==.
drop if tm >= tm(1985q4)
arima whtsaune L1.whtsaune L3.president_democrate, ar(1/2)