cd "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata"
cap log close
log using logfiles/US_Pres_Approv_and_une_quaterly.txt, text replace
use "rawdata\US_Partisan_and_Pres_Approv_numquaterly.dta", clear
merge m:1 yq using rawdata/BLK_WHT_UNE_QUARTERLY.dta
drop _merge
save rawdata/US_Pres_Approv_and_une_quaterly.dta, replace
