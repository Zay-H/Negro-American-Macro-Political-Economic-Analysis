cd "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata"
cap log close
log using logfiles/finalscrapedroper.txt, text replace
import delimited using "CSVs\IROPER Scraping Pres Approval\roper_scraped_final.xls", clear
keep roperid quarter start_date
rename roperid RoperID
tostring RoperID, replace
save rawdata/roper_pres_approval_quarters.dta, replace
use "rawdata\US Partisanship and Presidential Approval.dta", clear
merge m:1 RoperID using rawdata/roper_pres_approval_quarters.dta
save rawdata/US_Partisan_and_Pres_Approv_quaterly.dta, replace

* Create a new dataset with all year-quarter combinations
clear
set obs 325   // Number of quarters from 1948q1 to 2028q4 is (2028 - 1948 + 1) * 4 = 325

gen qnum = _n - 1
gen yq = yq(1948, 1) + qnum
format yq %tq

drop qnum
list yq if _n <= 10  // Preview first 10 rows

save createddata/full_yq_1948_to_2028.dta , replace

use "rawdata\US_Partisan_and_Pres_Approv_quaterly.dta", clear

/// Change string variable into numerical
gen quarter_num = .
replace quarter_num = 1 if quarter == "Q1"
replace quarter_num = 2 if quarter == "Q2"
replace quarter_num = 3 if quarter == "Q3"
replace quarter_num = 4 if quarter == "Q4"

/// Generate the yq variable
gen yq = yq(year, quarter_num)
format yq %tq

/// Giving an ID to each observation
gen participantid = _n

drop _merge
save rawdata/US_Partisan_and_Pres_Approv_numquaterly.dta, replace

/// Finding missing time periods
collapse (count) observations=participantid, by(yq)
merge 1:1 yq using "createddata\full_yq_1948_to_2028.dta"

sort yq
list yq if _merge == 2
keep if _merge == 2
save createddata/roper_pres_approval_missing_quarters.dta, replace
export delimited using "figures/roper_pres_approval_missing_quartersme.csv", replace
