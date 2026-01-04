cd "C:\Users\Xhump\OneDrive\Documents\RBSI Project"
cap log close
log using RBSI.txt, text replace

use anes_combined.dta, clear

* Merge black unemployment
merge m:1 year using black_unemp.dta
rename _merge merge_black_unemp

* Merge white unemployment
merge m:1 year using white_unemp.dta
rename _merge merge_white_unemp

* Merge CPI
merge m:1 year using cpi.dta
rename _merge merge_cpi

* Merge KIAs
merge m:1 year using kias.dta
rename _merge merge_kias

* Merge rally flag events
merge m:1 year using rally.dta
rename _merge merge_rally

* Merge African immigration
merge m:1 year using african_immigration2.dta
rename _merge merge_immigration

* Save final dataset
save master_anes_with_context.dta, replace