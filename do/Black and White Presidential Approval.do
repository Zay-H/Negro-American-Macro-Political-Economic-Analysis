cd "C:\Users\Xhump\OneDrive\Documents\RBSI Project"

use RBSI_dataset_v2.dta, clear

tsset year

newey approvalblack L.approvalblack blk_wht_ratio_unemployment percentchange_cpi kia_per_1000 rally_flag avg_decade_afro_imgr_per_1000 pres_party year, lag (1)

newey approvalblack L.approvalblack blk_wht_ratio_unemployment percentchange_cpi kia_per_1000 rally_flag pres_party year, lag (1)

newey approvalwhite L.approvalwhite blk_wht_ratio_unemployment percentchange_cpi kia_per_1000 rally_flag pres_party year, lag (1)

newey approvalblack L.approvalblack blk_wht_ratio_unemployment L.blk_wht_ratio_unemployment percentchange_cpi l.percentchange_cpi kia_per_1000 rally_flag avg_decade_afro_imgr_per_1000 pres_party year, lag (1)

newey approvalwhite L.approvalwhite blk_wht_ratio_unemployment L.blk_wht_ratio_unemployment percentchange_cpi L.percentchange_cpi kia_per_1000 rally_flag pres_party year, lag (1)
