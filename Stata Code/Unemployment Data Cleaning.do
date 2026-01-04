cd "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata"
cap log close
log using logfiles/BLK_WHT_UNE, text replace
import delimited using "C:\Users\Xhump\OneDrive\Desktop\Macro Analysis Project\Stata\CSVs\United States Unemployment\Black_and_White_Unemployment_Edited.csv", clear
rename nwhtaf8nsaaf8unemployment nwhtnsaune
rename nwhtaf8saaf8unemployment nwhtsaune
rename blkaf8saaf8unemployment blksaune
rename blknwhtaf8unemployment blknwhtsauneratio
rename whtaf8saaf8unemployment whtsaune
replace blksaune = "." if blksaune == "NA"
replace nwhtsaune = "." if nwhtsaune == "NA"
replace nwhtnsaune = "." if nwhtnsaune == "NA"
replace whtsaune = "." if whtsaune == "NA"


destring monthnum, replace
destring nwhtnsaune, replace
destring nwhtsaune, replace
destring blksaune, replace
destring whtsaune, replace
destring blknwhtsauneratio, replace

/// Change string variable into numerical
gen quarter_num = .
replace quarter_num = 1 if quarter == "Q1"
replace quarter_num = 2 if quarter == "Q2"
replace quarter_num = 3 if quarter == "Q3"
replace quarter_num = 4 if quarter == "Q4"
* Generate monthly time variable
gen tm = ym(year, monthnum)
format tm %tm
tsset tm



* Party of the US President
gen str15 president_party = ""
replace president_party = "Republican"  if tm >= tm(1953m2) & tm <= tm(1961m1)
replace president_party = "Democratic"  if tm >= tm(1961m2) & tm <= tm(1963m11)
replace president_party = "Democratic"  if tm >= tm(1963m12) & tm <= tm(1969m1)
replace president_party = "Republican"  if tm >= tm(1969m2) & tm <= tm(1974m9)
replace president_party = "Republican"  if tm >= tm(1974m10) & tm <= tm(1977m1)
replace president_party = "Democratic"  if tm >= tm(1977m2) & tm <= tm(1981m1)
replace president_party = "Republican"  if tm >= tm(1981m2) & tm <= tm(1989m1)
replace president_party = "Republican"  if tm >= tm(1989m2) & tm <= tm(1993m1)
replace president_party = "Democratic"  if tm >= tm(1993m2) & tm <= tm(2001m1)
replace president_party = "Republican"  if tm >= tm(2001m2) & tm <= tm(2009m1)
replace president_party = "Democratic"  if tm >= tm(2009m2) & tm <= tm(2017m1)
replace president_party = "Republican"  if tm >= tm(2017m2) & tm <= tm(2021m1)
replace president_party = "Democratic"  if tm >= tm(2021m2) & tm <= tm(2025m1)
replace president_party = "Republican"  if tm >= tm(2025m2)

encode president_party, gen(president_party_cat) label(party_lbl)
tab president_party_cat
gen president_republican = (president_party_cat == 2)
gen president_democrate = (president_party_cat == 1)

*House Majority Party
gen str15 house_party = ""
replace house_party = "Democratic"  if tm >= tm(1953m1) & tm <= tm(1993m12)
replace house_party = "Republican"  if tm >= tm(1994m1) & tm <= tm(2005m12)
replace house_party = "Democratic"  if tm >= tm(2006m1) & tm <= tm(2009m12)
replace house_party = "Republican"  if tm >= tm(2010m1) & tm <= tm(2017m12)
replace house_party = "Democratic"  if tm >= tm(2018m1) & tm <= tm(2021m12)
replace house_party = "Republican"  if tm >= tm(2022m1)

encode house_party, gen(house_party_cat) label(party_lbl)
tab house_party_cat
gen house_republican = (house_party_cat == 2)
gen house_democrate = (house_party_cat == 1)

*Senate Majority Party
gen str15 senate_party = ""
replace senate_party = "Republican"  if tm >= tm(1953m1) & tm <= tm(1954m12)
replace senate_party = "Democratic"  if tm >= tm(1955m1) & tm <= tm(1980m12)
replace senate_party = "Republican"  if tm >= tm(1981m1) & tm <= tm(1986m12)
replace senate_party = "Democratic"  if tm >= tm(1987m1) & tm <= tm(1994m12)
replace senate_party = "Republican"  if tm >= tm(1995m1) & tm <= tm(2000m12)
replace senate_party = "Democratic"  if tm == tm(2001m1)
replace senate_party = "Republican"  if tm >= tm(2001m2) & tm <= tm(2001m5)
replace senate_party = "Democratic"  if tm >= tm(2001m6) & tm <= tm(2002m10)
replace senate_party = "Republican"  if tm >= tm(2002m11) & tm <= tm(2006m12)
replace senate_party = "Democratic"  if tm >= tm(2007m1) & tm <= tm(2014m12)
replace senate_party = "Republican"  if tm >= tm(2015m1) & tm <= tm(2020m12)
replace senate_party = "Democratic"  if tm >= tm(2021m1) & tm <= tm(2024m12)
replace senate_party = "Republican"  if tm >= tm(2025m1)

encode senate_party, gen(senate_party_cat) label(party_lbl)
tab senate_party_cat
gen senate_republican = (senate_party_cat == 2)
gen senate_democrate = (senate_party_cat == 1)

save rawdata/BLK_WHT_UNE.dta, replace

// Looking at Black and Non-White Unemploymnet Overlap to look at whether pre- 1972 NWHTUNE should be scaled

drop if blknwhtsauneratio == .
regress blksaune nwhtsaune year

regress blksaune nwhtsaune
summ blknwhtsauneratio
// Created time series
gen tq = yq(year, quarter_num)
format tq %tq
// Creating Categorical variable
encode quarter, gen(quarter_cat)

collapse (mean) blksaune nwhtsaune (first)"quarter_cat", by(tq)

tsset tq

regress blksaune nwhtsaune

regress blksaune c.nwhtsaune##i.quarter

use rawdata/BLK_WHT_UNE.dta, clear

gen tq = yq(year, quarter_num)
format tq %tq

collapse (mean) whtsaune blksaune  nwhtnsaune nwhtsaune blknwhtsauneratio, by(tq)
tsset tq
rename tq yq
save rawdata/BLK_WHT_UNE_QUARTERLY.dta, replace

