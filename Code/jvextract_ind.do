***********************************************************
* Select individual countries for use in calibration
***********************************************************
	clear
	
	capture file close f_result
	file open f_result using "./work/jvextract_individual.txt", write replace
	
	use "./work/jv_data_fit_sample.dta" // contains all the countries
	
	replace country = subinstr(country,"'","",.)
	
	local i = 1
	
	levelsof country // get all id numbers
	foreach j in `r(levels)' { // loop through all values
		// Urbanization rates
		qui summ urbrate if year==1950 & country=="`j'"
		local base_urbrate = r(mean)/100
		qui summ urbrate if year==2005 & country=="`j'"
		local comp_urbrate = r(mean)/100
		qui summ slum if year==2005 & country=="`j'"
		local comp_slum = r(mean)/100
		
		if `comp_urbrate'~=. & `comp_slum'~=. {
			file write f_result "`j',1," %9.4f (`comp_urbrate') "," %9.4f (`comp_slum') "," %9.4f (.5*`base_urbrate') "," %9.4f (.5*`base_urbrate') ///
						"," %9.4f (1-`base_urbrate') _n
			local i = `i' + 1
		}
	} // end foreach loop
	
	file close f_result
	
