***********************************************************
* Control script for replicating Jedwab and Vollrath
***********************************************************

**** This should be changed to your master folder ****
cd /users/dietz/dropbox/project/megacity/UrbanMortality

do "./code/jvextract_prepare.do" // merge datasets and make adjustments
do "./code/jvextract_robust.do" // write summary stats for different samples
do "./code/jvextract_ind.do" // get stats for ind. countries
