*****************************************************************
* Calculate averages for different samples for use in calibration
*****************************************************************
	
*****************************************************************
* Declare program to calculate appropriate averages for a given
* sample. This will be called repeatedly below.
*****************************************************************
capture program drop calc_pop
program calc_pop
	syntax [if] [, name(string) initinf(real 0.5) ind(int 0)]
	preserve
	quietly {
		keep `if' // keep based on given conditions
		keep if !missing(urbrate2005)
		keep if !missing(slum2005)
		keep if !missing(urbrate1950)
		
		summ urbrate2005
		local c_urb = r(mean)/100 // save mean urban rate 2005
		summ slum2005
		local c_inf = r(mean)/100 // save mean informal rate 2005
		summ urbrate1950
		local i_for = (1-`initinf')*r(mean)/100 // set initial formal rate 1950
		local i_inf = `initinf'*r(mean)/100 // set initial informal rate 1950
		local i_rur = 1 - r(mean)/100 // set initial rural rate 1950
	
		gen rurbpop2005 = pop2005*urbrate2005/(pop1950*urbrate1950) // relative urban pop
		ameans rurbpop2005
		local r_urb = r(mean_g) // get geometric mean of relative urban pop
		gen rinfpop2005 = pop2005*urbrate2005*slum2005/(pop1950*urbrate1950*`initinf'*100) // relative informal pop
		ameans rinfpop2005
		local r_inf = r(mean_g) // get geometric mean of relative informal pop
		gen rrurpop2005 = pop2005*(1-urbrate2005/100)/(pop1950*(1-urbrate1950/100)) // relative rural pop
		ameans rrurpop2005
		local r_rur = r(mean_g) // get geometric mean of relative rural pop

		count
		local c = r(N) // get count of countries included
		
		// Save country level data if asked
		if `ind'==1 {
			save "./work/jv_data_fit_sample.dta", replace
		}
		
		// Reshape to long and calculate fertility parameters
		reshape long urbrate slum slum2 crni crni2 cbr cdr pop improv_sani improv_water, i(country_id) j(year)
		bysort year: egen crnimean = mean(crni) // get mean CRNI by year
		gen t = year - 1950 // rebase time
		gen tsq = t^2
		reg crnimean t tsq // regress CRNI on time and time-squared to get quadratic coefficients
		local tau1 = _b[t] // save coefficients
		local tau2 = _b[tsq]
		
		// Write saved results to output file for use in Matlab
		file write f_text "`name', `c', " %9.4f (`c_urb') "," %9.4f (`c_inf') "," %9.4f (`i_for') "," %9.4f (`i_inf') ///
			"," %9.4f (`i_rur') "," %9.4f (`r_urb') "," %9.4f (`r_inf') "," %9.4f (`r_rur') "," %9.4f (`tau1') "," %9.4f (`tau2') _n
	}
	restore
end


*****************************************************************
* Open output file for summary stats used by Matlab
*****************************************************************
capture file close f_text
file open f_text using "./work/jvextract_redo.txt", write replace

*****************************************************************
* Calculate stats for baseline samples and variations
* - These use the slum variable directly
*****************************************************************
clear
use "./work/jv_data_fit_redo.dta" // contains full set of data

calc_pop if urbrate1950<20, name("Baseline") ind(1) // Baseline sample saves
calc_pop if slummax>30 & urbrate1950<20, name("Slum max $\geq$ 30\% Urb $\leq$ 20\%")
calc_pop if slummax>20 & urbrate1950<20, name("Slum max $\geq$ 20\% Urb $\leq$ 20\%")
calc_pop if slummax>10 & urbrate1950<20, name("Slum max $\geq$ 10\% Urb $\leq$ 20\%")
calc_pop if slummax>0 & urbrate1950<30, name("Slum max $\geq$ 0\% Urb rate $\leq$ 30\%")
calc_pop if slummax>0 & urbrate1950<40, name("Slum max $\geq$ 0\% Urb rate $\leq$ 40\%")
calc_pop if slummax>0 & urbrate1950<50, name("Slum max $\geq$ 0\% Urb rate $\leq$ 50\%")
calc_pop if slummax>30 & urbrate1950<30, name("Slum max $\geq$ 30\% Urb $\leq$ 30\%")
calc_pop if slummax>30 & urbrate1950<40, name("Slum max $\geq$ 30\% Urb $\leq$ 40\%")
calc_pop if cdr1980-cdr1950<=-7 & oecd==0, name("$\Delta CDR_{50-80} \leq -7$")
calc_pop if cdr1980-cdr1950<=-12 & oecd==0, name("$\Delta CDR_{50-80} \leq -12$")
calc_pop if cdr1980-cdr1950<=-16 & oecd==0, name("$\Delta CDR_{50-80} \leq -16$")
calc_pop if urbrate1950<20 & country~="China" & country~="India", name("ex-China and India")
calc_pop if urbrate1950<20 & communist==0, name("ex-Communist")

*****************************************************************
* Calculate stats using expanded slum information
* - Use slum2 in place of missing slum data
*****************************************************************
clear
use "./work/jv_data_fit_redo.dta" // contains full set of data

replace slum2005 = slum22005 if slum2005==. // replace with slum2 for missing slum obs
calc_pop if urbrate1950<20, name("Using slum2 for miss Urb $\leq$ 20\%")
calc_pop if urbrate1950<30, name("Using slum2 for miss Urb $\leq$ 30\%")
calc_pop if urbrate1950<40, name("Using slum2 for miss Urb $\leq$ 40\%")

*****************************************************************
* Calculate stats using only slum2 information
* - Use slum2 ONLY
*****************************************************************
clear
use "./work/jv_data_fit_redo.dta" // contains full set of data

replace slum2005 = slum22005 // replace with slum2 for everyone
calc_pop if urbrate1950<20, name("Using slum2 for all Urb $\leq$ 20\%")
calc_pop if urbrate1950<30, name("Using slum2 for all Urb $\leq$ 30\%")
calc_pop if urbrate1950<40, name("Using slum2 for all Urb $\leq$ 40\%")


capture file close f_text
