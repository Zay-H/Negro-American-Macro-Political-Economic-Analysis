use "US Partisanship and Presidential Approval.dta", clear

keep if !missing(RoperDOI)
keep RoperID RoperDOI

duplicates drop RoperDOI, force

export delimited using "unique_roper_links.csv", replace
