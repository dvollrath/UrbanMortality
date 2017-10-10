***********************************************************
* Control script for replicating Jedwab and Vollrath
***********************************************************

**** This should be changed to your master folder ****
cd /users/dietz/dropbox/project/megacity/UrbanMortality

//do "./code/jvextract.do" // get main summary stats
do "./code/jvextract_robust.do" // get stats for sub-samples, write code to use
do "./code/jvextract_ind.do" // get stats for ind. countries, write code to use
