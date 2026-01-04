
cd "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata"
cap log close
log using logfiles/addingKIA.txt, text replace
import delimited using "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata\CSVs\Killed in Action Data\Final_KIA_by_year_quarter.xls", clear

// Remove all spaces
gen yq0 = trim(yearquarter)       // removes leading/trailing spaces

replace yq0 = subinstr(yq0, " ", "", .)  // removes any remaining internal spaces

// Convert the 'Q' in yq to lowercase
replace yq0 = lower(yq0)

// Realized I had made a mistake combining the year and quarter to soon making it so my combining my data would not work correctly rather than fixing all the python code I am just going to fix it with STATA
gen year = substr(yq, 1, 4)

gen quarter = substr(yq, 5, .)   // everything after position 5

destring year, replace

replace quarter = subinstr(quarter,"q","",.)

destring quarter, replace

gen yq = yq(year, quarter)

format yq %tq

drop yq0 yearquarter year quarter

duplicates list yq
// The spaced data didn't add together correct in python because of the spaces therefore I need to add them now since I removed the spaces
collapse (sum) kia, by(yq)

duplicates list yq


save rawdata/KIA_by_year_quarter.dta, replace

use "rawdata\US_Partisan_and_Pres_Approv_numquaterly.dta", clear

drop _merge

merge m:1 yq using rawdata/KIA_by_year_quarter.dta
drop _merge
replace kia = 0 if kia == .
 
save rawdata/KIA_Approv_quarterly.dta, replace