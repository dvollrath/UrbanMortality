*****************************************************************
* Prepare sample data and make adjustments to slum shares
*****************************************************************
	clear
	
	// Merge main data with demographics and flags for type of country
	use "./data/jv_data_fit.dta" // contains full set of data
	qui merge 1:1 country year using "./data/cbdcdrcrni.dta" // demographics
	drop _merge
	qui merge m:1 country using "./data/jv_flags.dta" // flags for sets of countries
	drop _merge
	
	// Drop unneeded variables
	capture drop pop50
	capture drop pop1950
	capture drop gr
	capture drop Countrycode // incomplete and redundant
	
	// Create country ID
	egen country_id = group(country)
	
	// Set baseline slum shares for rich countries so they can be included
	replace slum = 1 if slum==. & oecd==1 & year==2005 // 1% slum shares for oecd
	replace slum = 95 if country=="Sierra Leone" & year==2005 // replace 100%
		
	// Calculate maximum slum share
	bysort country: egen slummax = max(slum)
	
	// Reshape to wide
	reshape wide urbrate slum slum2 crni crni2 cbr cdr pop improv_sani improv_water, i(country_id) j(year)
	
	// Drop if small population - this condition has not changed - so make permanent
	keep if pop1950>1000
	save "./work/jv_data_fit_robust.dta", replace
