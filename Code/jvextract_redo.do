*****************************************************************
* Calculate averages for different samples for use in calibration
*****************************************************************
	
*****************************************************************
* Declare program to calculate appropriate averages for a given
* sample. This will be called repeatedly below.
*****************************************************************
capture program drop calc_pop
program calc_pop
	syntax [if] [, name(string) initinf(real 0.5)]
	preserve
		keep `if'
		keep if !missing(urbrate2005)
		keep if !missing(slum2005)
		keep if !missing(urbrate1950)
		
		summ urbrate2005
		local c_urb = r(mean)/100
		summ slum2005
		local c_inf = r(mean)/100
		summ urbrate1950
		local i_for = (1-`initinf')*r(mean)/100
		local i_inf = `initinf'*r(mean)/100
		local i_rur = 1 - r(mean)/100
	
		tempvar rurbpop2005
		gen `rurbpop2005' = pop2005*urbrate2005/(pop1950*urbrate1950)
		ameans `rurbpop2005'
		local r_urb = r(mean_g)
		tempvar rinfpop2005
		gen `rinfpop2005' = pop2005*urbrate2005*slum2005/(pop1950*urbrate1950*`initinf'*100)
		ameans `rinfpop2005'
		local r_inf = r(mean_g)
		tempvar rrurpop2005
		gen `rrurpop2005' = pop2005*(1-urbrate2005/100)/(pop1950*(1-urbrate1950/100))
		ameans `rrurpop2005'
		local r_rur = r(mean_g)

		count
		local c = r(N)
		
		tabulate country
		
		file write f_text "`name', `c', " %9.4f (`c_urb') "," %9.4f (`c_inf') "," %9.4f (`i_for') "," %9.4f (`i_inf') ///
			"," %9.4f (`i_rur') "," %9.4f (`r_urb') "," %9.4f (`r_inf') "," %9.4f (`r_rur') _n
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

calc_pop if urbrate1950<20, name("Baseline")
calc_pop if slummax>30 & urbrate1950<20, name("Slum max $\geq$ 30\% Urb $\leq$ 20\%")
calc_pop if slummax>20 & urbrate1950<20, name("Slum max $\geq$ 20\% Urb $\leq$ 20\%")
calc_pop if slummax>10 & urbrate1950<20, name("Slum max $\geq$ 10\% Urb $\leq$ 20\%")
calc_pop if slummax>0 & urbrate1950<30, name("Slum max $\geq$ 0\% Urb rate $\leq$ 30\%")
calc_pop if slummax>0 & urbrate1950<40, name("Slum max $\geq$ 0\% Urb rate $\leq$ 40\%")
calc_pop if slummax>0 & urbrate1950<50, name("Slum max $\geq$ 0\% Urb rate $\leq$ 50\%")
calc_pop if slummax>30 & urbrate1950<30, name("Slum max $\geq$ 30\% Urb $\leq$ 30\%")
calc_pop if slummax>30 & urbrate1950<40, name("Slum max $\geq$ 30\% Urb $\leq$ 40\%")
calc_pop if cdr5080<=-7 & oecd==0, name("$\Delta CDR_{50-80} \leq -7$")
calc_pop if cdr5080<=-12 & oecd==0, name("$\Delta CDR_{50-80} \leq -12$")
calc_pop if cdr5080<=-16 & oecd==0, name("$\Delta CDR_{50-80} \leq -16$")
calc_pop if urbrate1950<20 & country~="China" & country~="India", name("ex-China and India")
calc_pop if urbrate1950<20 & communist==0, name("ex-Communist")



capture file close f_text
