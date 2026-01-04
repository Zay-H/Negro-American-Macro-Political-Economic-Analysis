cd "C:\Users\Xhump\OneDrive\Documents\RBSI Project"

use RBSI_dataset_v3.dta, clear

gen midterm = inlist(year, 1986, 1990, 1994, 1998, 2002, 2006, 2010, 2014, 2018, 2022)
label define midterm_lbl 0 "Presidential year" 1 "Midterm election"
label values midterm midterm_lbl

reg nhb_turnout pres_race covid midterm blk_unemployment percentchange_cpi, robust

reg nhw_turnout pres_race covid midterm wht_unemployment percentchange_cpi, robust

correlate nhb_turnout nhw_turnout

gen turnout_gap = nhw_turnout - nhb_turnout
summarize turnout_gap, detail

reg turnout_gap pres_race covid midterm percentchange_cpi, robust

sureg (nhb_turnout = pres_race covid midterm blk_unemployment percentchange_cpi) ///
                        (nhw_turnout = pres_race covid midterm wht_unemployment percentchange_cpi), ///
                        vce(robust)


test [nhb_turnout]_b[pres_race] = [nhw_turnout]_b[pres_race]
test [nhb_turnout]_b[midterm] = [nhw_turnout]_b[midterm]
