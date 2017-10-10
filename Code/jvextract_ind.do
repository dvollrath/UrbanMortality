***********************************************************
* Select individual countries for use in calibration
***********************************************************
	clear
	
	capture file close f_result
	file open f_result using "./work/jvextract_individual.m", write replace
	
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
		di "number `i'"
		file write f_result "Setup.Size = [" %9.4f (`base_urbrate'*.5) ";" %9.4f (`base_urbrate'*.5) ";" %9.4f (1-`base_urbrate') "];" _n
		file write f_result "T = {'UrbPerc'" %9.4f (`comp_urbrate') " 55; 'InfUrbPerc' " %9.4f (`comp_slum') " 55};" _n
		file write f_result `"name = '`j''; "' _n
		file write f_result "count = 1;" _n
		file write f_result "E = mcrobusti(Setup,time,T,name,f,count,n);" _n
		file write f_result "Eps(n-1,1) = E(1);" _n
		file write f_result "Eps(n-1,2) = E(2);" _n
		file write f_result "n = n+1;" _n
		local i = `i' + 1
		}
		
	} // end foreach loop
	
	file close f_result
	
