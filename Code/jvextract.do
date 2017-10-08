***********************************************************
* Select sample data and set values for use in calibration
***********************************************************
	clear
	
	local rich = 0 // flag to do rich (1) or poor (0) countries
	local base = 1950
	local comp = 2005
	local slum_limit = 30 // slum percent must reach higher than this to be included
	local pop_limit = 1000 // population (000's) must be higher than this
	local urb_limit = 20 // urbanization must be below this in base period for poor countries
	local urb_min = 50 // urbanization must be above this in base period for rich countries
	
	local slum_miss = 5 // assumed value of slums when missing for rich countries

// Load dataset
	use "./data/jv_data_fit.dta" // contains full set of data

// Create summary data to compare baseline calibration against
	sort country year
	egen country_id = group(country) // get numeric id for country
	xtset country_id year, delta(5) // for using lag and difference operators

// Limit sample of countries
	if `rich'== 1 { // rich countries
		by country_id: egen pop_min = min(pop)
		keep if pop_min>`pop_limit' // only countries with minimum of 1mil population
		by country_id: egen urbrate_min = min(urbrate)
		keep if urbrate_min>`urb_min' // only countries that were very un-urbanized to start with
		replace slum = `slum_miss' if slum==.
		local inf_initial = 0.25 // assumed initial informal share
		local name="rich"
	}
	else { // poor countries
		by country_id: egen slum_max = max(slum)
		keep if slum_max>`slum_limit' // only countries with slum percent that reached at least 30% at some point
		gen slum_mark = 1 if year==`comp' & slum~=. // mark countries with 2005 obs on slums
		by country_id: egen slum_mark_tot = sum(slum_mark)
		keep if slum_mark_tot==1 // only keep countries with a 2005 obs on slum
		by country_id: egen pop_min = min(pop)
		keep if pop_min>`pop_limit' // only countries with minimum of 1mil population
		by country_id: egen urbrate_min = min(urbrate)
		keep if urbrate_min<`urb_limit' // only countries that were very un-urbanized to start with
		local inf_initial = 0.5 // assumed initial informal share
		local name = "poor"
		drop if country=="Bosnia and Herzegovina" // eliminate Euro-area countries
		drop if country=="Republic of Moldova"
	}
// Generate variables measuring relative size of urban population
	gen u = urbrate/100 // urbanization in decimal form
	gen s_inf = u*slum/100 // informal share of total population in decimal form
	gen inf_pop = s_inf*pop // total size of informal pop
	replace inf_pop = `inf_initial'*u*pop if year==`base' // get baseline informal population
	gen for_pop = u*pop - inf_pop // total size of formal pop
	gen rur_pop = (1-u)*pop // total size of rural pop

	gen inf_perc = s_inf/u
	
	gen rel_urb_pop =. // initialize variables
	gen rel_inf_pop =.
	gen rel_for_pop =.
	gen rel_rur_pop =.
	gen rel_pop = .

		replace rel_urb_pop = 1 if year==`base'
		replace rel_inf_pop = 1 if year==`base'
		replace rel_pop = 1 if year==`base'
		replace rel_for_pop = 1 if year==`base'
		replace rel_rur_pop = 1 if year==`base'
		
	forvalues i = 1(1)13 { // create relative populations using lags
		replace rel_urb_pop = u*pop/(L`i'.u*L`i'.pop) if year==`base'+5*`i'
		replace rel_inf_pop = inf_pop/L`i'.inf_pop if year==`base'+5*`i'
		replace rel_pop = pop/L`i'.pop if year==`base'+5*`i'
		replace rel_for_pop = for_pop/L`i'.for_pop if year==`base'+5*`i'
		replace rel_rur_pop = rur_pop/L`i'.rur_pop if year==`base'+5*`i'
	}
			
	capture file close f_result
	file open f_result using "./work/jvextract_`name'.txt", write replace
	
	summ u if year==`base'
	local i_inf = r(mean)*`inf_initial'
	local i_for = r(mean)*(1-`inf_initial')
	local i_rur = 1- r(mean)
	
	forvalues y = `base'(5)`comp' {
		file write f_result "`y'"
		
		qui ameans rel_for_pop if year==`y'
		local write = r(mean_g)*`i_for'
		if `write'==. {
			local write = 0
		}
		file write f_result "," %9.5f (`write')
		qui ameans rel_inf_pop if year==`y'
		local write = r(mean_g)*`i_inf'
		if `write'==. {
			local write = 0
		}
		file write f_result "," %9.5f (`write')
		qui ameans rel_rur_pop if year==`y'
		local write = r(mean_g)*`i_rur'
		if `write'==. {
			local write = 0
		}
		file write f_result "," %9.5f (`write')
		
		qui ameans crni if year==`y'
		local write = r(mean)
		if `write'==. {
			local write = 0
		}
		file write f_result "," %9.5f (`write')
		
		file write f_result _n
	}
	capture file close f_result
	
	save "./work/jv_data_fit_work.dta", replace
	
// End file
