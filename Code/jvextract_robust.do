*****************************************************************
* Prepare sample data and calculate data averages for calibration
*****************************************************************
	clear
	
	// Merge main data with demographics and flags for type of country
	use "./data/jv_data_fit.dta" // contains full set of data
	qui merge 1:1 country year using "./data/cbdcdrcrni.dta"
	drop _merge
	qui merge m:1 country using "./data/jv_flags.dta"
	drop _merge
	
	// Set baseline slum shares for rich countries so they can be included
	replace slum = 5 if slum==. & oecd==1 & year==2005
	
	save "./work/jv_data_fit_work.dta", replace
	
	// Open output file to write Matlab commands to perform calibrations
	capture file close f_result
	file open f_result using "./work/jvextract_robust.m", write replace

*****************************************************************
* Declare program to calculate appropriate averages for a given
* sample. This will be called repeatedly below.
*****************************************************************
capture program drop calc_pop
program calc_pop 
	syntax [, name(string) base(integer 1950) comp(integer 2005) slumlimit(real 30) poplimit(real 1000) urblimit(real 50) infinit(real 0.5) drop5075(real 999) drop5080(real 999) exclude(string) comm(int 99) apart(int 99)]
	
	// Load dataset
	clear
	use "./work/jv_data_fit_work.dta" // contains full set of data
	
	foreach X in 50 75 80 {
		qui gen cdr`X' = cdr if year == 19`X'
		qui bysort country: egen cdr19`X' = max(cdr`X')
		qui drop cdr`X'
	}
	qui gen cdr5075 = cdr1975-cdr1950
	qui gen cdr5080 = cdr1980-cdr1950

	// Create summary data to compare baseline calibration against
	sort country year
	qui egen country_id = group(country) // get numeric id for country
	qui xtset country_id year, delta(5) // for using lag and difference operators

	// Limit sample of countries
	quietly {
		by country_id: egen slum_max = max(slum)
		keep if slum_max>`slumlimit' // only countries with slum percent that reached at least 30% at some point
		gen slum_mark = 1 if year==`comp' & slum~=. // mark countries with 2005 obs on slums
		by country_id: egen slum_mark_tot = sum(slum_mark)
		keep if slum_mark_tot==1 // only keep countries with a 2005 obs on slum
		by country_id: egen pop_min = min(pop)
		keep if pop_min>`poplimit' // only countries with minimum of 1mil population
		by country_id: egen urbrate_min = min(urbrate)
		keep if urbrate_min<`urblimit' // only countries that were very un-urbanized to start with
		
		if `drop5075'<999 {
			keep if cdr5075<=`drop5075'
		}
		if `drop5080'<999 {		
			keep if cdr5080<=`drop5080'
		}
		
		drop if communist==`comm'
		drop if apart==`apart'
		
		foreach c of local exclude {
			drop if country=="`c'"
		}
		
		drop if country=="Bosnia and Herzegovina" // eliminate Euro-area countries
		drop if country=="Republic of Moldova"
	}
	
	// Generate variables measuring relative size of urban population
	quietly {
		gen u = urbrate/100 // urbanization in decimal form
		gen s_inf = u*slum/100 // informal share of total population in decimal form
		gen inf_pop = s_inf*pop // total size of informal pop
		replace inf_pop = `infinit'*u*pop if year==`base' // get baseline informal population
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
			
		summ u if year==`base'
		local c = r(N)
		local i_inf = r(mean)*`infinit'
		local i_for = r(mean)*(1-`infinit')
		local i_rur = 1- r(mean)
		
		qui ameans rel_for_pop if year==`base'
		local c_for = r(mean_g)*`i_for'
		qui ameans rel_inf_pop if year==`base'
		local c_inf = r(mean_g)*`i_inf'
		qui ameans rel_rur_pop if year==`base'
		local c_rur = r(mean_g)*`i_rur'
		
		file write f_result "Setup.Size = [" %9.4f (`c_for') ";" %9.4f (`c_inf') ";" %9.4f (`c_rur') "];" _n
		
		qui ameans rel_for_pop if year==`comp'
		local c_for = r(mean_g)*`i_for'
		qui ameans rel_inf_pop if year==`comp'
		local c_inf = r(mean_g)*`i_inf'
		qui ameans rel_rur_pop if year==`comp'
		local c_rur = r(mean_g)*`i_rur'
		local c_tot = `c_for' + `c_inf' + `c_rur'
		local c_urb = `c_for' + `c_inf'

		summ u if year==`comp'
		local c_urb = r(mean)
		summ inf_perc if year==`comp'
		local c_inf = r(mean)
		file write f_result "T = {'UrbPerc'" %9.4f (`c_urb') " 55; 'InfUrbPerc' " %9.4f (`c_inf') " 55};" _n
		file write f_result `"name = '`name''; "' _n
		file write f_result "count = `c';" _n
		file write f_result "mcrobusti(Setup,time,T,name,f,count,n);" _n
		file write f_result "n = n+1;" _n
	}
	file write f_result _n
end // end program to calculate values	
	
////////////////////////////////
// Calls to calculate for different parameters
///////////////////////////////
calc_pop, base(1950) comp(2005) slumlimit(30) poplimit(1000) urblimit(20) infinit(0.5) name(Baseline)
save "./work/jv_data_fit_sample.dta", replace // save this baseline set of countries

calc_pop, base(1950) comp(2005) slumlimit(30) poplimit(1000) urblimit(30) infinit(0.5) name(1950 Urbanization $\leq$ 30\%)
calc_pop, base(1950) comp(2005) slumlimit(30) poplimit(1000) urblimit(40) infinit(0.5) name(1950 Urbanization $\leq$ 40\%)

calc_pop, base(1950) comp(2005) slumlimit(20) poplimit(1000) urblimit(20) infinit(0.5) name(Max. slum share $\geq$ 20\%, urb share $\leq$ 20\%)
calc_pop, base(1950) comp(2005) slumlimit(20) poplimit(1000) urblimit(30) infinit(0.5) name(Max. slum share $\geq$ 20\%, urb share $\leq$ 30\%)
calc_pop, base(1950) comp(2005) slumlimit(20) poplimit(1000) urblimit(40) infinit(0.5) name(Max. slum share $\geq$ 20\%, urb share $\leq$ 40\%)
calc_pop, base(1950) comp(2005) slumlimit(20) poplimit(1000) urblimit(50) infinit(0.5) name(Max. slum share $\geq$ 20\%, urb share $\leq$ 50\%)
calc_pop, base(1950) comp(2005) slumlimit(20) poplimit(1000) urblimit(60) infinit(0.5) name(Max. slum share $\geq$ 20\%, urb share $\leq$ 60\%)

calc_pop, base(1950) comp(2005) slumlimit(10) poplimit(1000) urblimit(20) infinit(0.5) name(Max. slum share $\geq$ 10\%, urb share $\leq$ 20\%)
calc_pop, base(1950) comp(2005) slumlimit(10) poplimit(1000) urblimit(30) infinit(0.5) name(Max. slum share $\geq$ 10\%, urb share $\leq$ 30\%)
calc_pop, base(1950) comp(2005) slumlimit(10) poplimit(1000) urblimit(40) infinit(0.5) name(Max. slum share $\geq$ 10\%, urb share $\leq$ 40\%)
calc_pop, base(1950) comp(2005) slumlimit(10) poplimit(1000) urblimit(50) infinit(0.5) name(Max. slum share $\geq$ 10\%, urb share $\leq$ 50\%)
calc_pop, base(1950) comp(2005) slumlimit(10) poplimit(1000) urblimit(60) infinit(0.5) name(Max. slum share $\geq$ 10\%, urb share $\leq$ 60\%)

calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(20) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 20\%)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(30) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 30\%)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(40) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 40\%)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(50) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 50\%)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(60) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 60\%)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(70) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 70\%)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(80) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 80\%)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(90) infinit(0.5) name(Max. slum share $\geq$ 0\%, urb share $\leq$ 90\%)

calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(100) infinit(0.5) drop5080(-7) name($\Delta CDR_{50,80} \leq -7$)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(100) infinit(0.5) drop5080(-12) name($\Delta CDR_{50,80} \leq -12$)
calc_pop, base(1950) comp(2005) slumlimit(0) poplimit(1000) urblimit(100) infinit(0.5) drop5080(-16) name($\Delta CDR_{50,80} \leq -16$)

calc_pop, base(1950) comp(2005) slumlimit(30) poplimit(1000) urblimit(20) infinit(0.5) name(ex-China and India) exclude(China India)
calc_pop, base(1950) comp(2005) slumlimit(30) poplimit(1000) urblimit(20) infinit(0.5) comm(1) name(ex-Communist)

capture file close f_result
