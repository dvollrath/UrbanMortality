*****************************************************************
* Prepare sample data and make adjustments to slum shares
*****************************************************************
	clear
	
	// Merge main data with demographics and flags for type of country
	use "./data/jv_data_fit.dta" // contains full set of data
	qui merge 1:1 country year using "./data/cbdcdrcrni.dta"
	drop _merge
	qui merge m:1 country using "./data/jv_flags.dta"
	drop _merge
	
	// Drop unneed variables
	capture drop pop50
	capture drop pop1950
	capture drop gr
	// Create country ID
	egen country_id = group(country)
	
	// Set baseline slum shares for rich countries so they can be included
	replace slum = 1 if slum==. & oecd==1 & year==2005 // 1% slum shares for oecd
	replace slum = 95 if country=="Sierra Leone" & year==2005 // replace 100%
	
	// Calculate changes in CDR over time for each country
	foreach X in 50 75 80 {
		qui gen cdr`X' = cdr if year == 19`X'
		qui bysort country: egen cdr19`X' = max(cdr`X')
		qui drop cdr`X'
	}
	qui gen cdr5075 = cdr1975-cdr1950
	qui gen cdr5080 = cdr1980-cdr1950
	
	// Calculate maximum slum share
	bysort country: egen slummax = max(slum)
	
	// Reshape to include only 1950 and 2005 relevant data
	keep if inlist(year,1950,2005)
	reshape wide urbrate slum slum2 crni crni2 cbr cdr pop improv_sani improv_water, i(country_id) j(year)
	
	// Drop if small population - this condition has not changed - so make permanent
	keep if pop1950>1000
	save "./work/jv_data_fit_redo.dta", replace
