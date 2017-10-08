# Replication for Jedwab and Vollrath

## City-level data
TBD 

## Calibration and simulation
The calibration of the model in the paper requires some data work to produce the targets for various runs of the calibration, and then a Matlab program that performs the calibrations themselves.

### Folder structure
The code is set up to expect a folder structure that mimics this repository. That is, there should be folders "Drafts", "Data", "Work", and "Code" all contained within your master folder. 

### Data and code preparation
The Stata scripts pull summary information on urbanization and population size from a dataset of developing countries. The data files are:

1. jv_flags.dta: this is a set of indicators for which countries were ex-communist, etc.. that we use to control which countries belong in which sub-samples

2. cbdcdrcrni.dta: this contains country/year information on crude birth rates, crude death rates, and crude rates of natural increase

3. jv_data_fit.dta: this is a set of country/year information that includes urbanization rates, population size, and various measures of slum shares

These Stata scripts write Matlab code to new files, and that Matlab code is read by our main calibration routine to perform various robustness checks. 

To set up all the data and code necessary for the calibration, you should **edit "jvmaster.do" to have the correct path to your master folder** and then **run jvmaster.do**. This script calls the following:

1. jvextract_ind.do: this gets summary information for each country individually, and writes a Matlab command for each country that will be used to calibrate the model to that country's data

2. jvextract_robust.do: this gets summary information for different sample selection criteria, and writes a Matlab command for each sample that will be used to calibrate the model to that sample's data

3. jvextract.do: this gets summary information for the whole sample, and writes it to a single output file

The Matlab code that is written by these Stata scripts are all written to the "Work" folder, where the following Matlab code for the calibration will expect it to exist.

### Running the calibration
The master script for reproducing all results is "mcmaster.m". You should **edit this to point to your master folder** before running it. This sets the initial values of all parameters, and fits the model to find the calibrated values of the congestion elasticities in formal and informal areas. It then calls subroutines to write results to tables, and to perform various robustness checks. It should only be necessary to call "mcmaster.m" from Matlab to reproduce all the results. All output tables are written to the "Drafts" folder. 

The remaining Matlab code in the "Code" folder are the subroutines used by mcwork to calibrate and evaluate the model. Note that the code names (mctable2) do not match the tables in the paper (Table 3) because of changes in the text and code over time.

1. mceval.m: this calls the actual model in mcfix.m, and compares the results of the model to the targets, and passes back the (squared) distance. mcwork.m uses "fminsearch" on this until it finds the set of parameters that deliver the smallest squared distance.

2. mcfix.m: this takes in initial conditions and parameters, and calculates the outcome of the model in all time periods up to some given end date. This is the *actual* model from the paper.

3. mctable2.m: this writes the information in Table 3.

4. mctable3.m: this writes Table 4. It calls the model in mcfix.m repeatedly, passing it different iterations of parameters, for different scenarios

5. mctable4.m: this writes Table 6. It calls the model in mcfix.m repeatedly, passing it different iterations of parameters, for different scenarios

6. mctable5.m: this writes Table 7. It overrides the baseline parameters to start the simulations in 2005, and then calls the model in mcfix.m repeatedly, passing it different iterations of parameters, for different scenarios

7. mcindividual.m: this writes an appendix table that calibrates the values of formal and informal elasticities separately for each country using mcrobusti.m. 

8. mcrobust.m: this writes Table 5 on robustness checks. It calls mcrobusti.m repeatedly, which calibrates the values of formal and informal elasticities for different samples or initial conditions

9. mcrobusti.m: this is called by mcrobust.m and mcindividual.m, and it calls mceval.m to get the calibrated values of elasticities for the given scenario, then calls mcfix.m to produce the results of the model with those elasticities, and writes those results to a given file