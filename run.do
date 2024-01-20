* set path: uncomment the following line and set the filepath for the folder containing this run.do file
*global root "[location of replication archive]"
global data "$root/data"
global code "$root/code"
global tables "$root/output/tables"
global figures "$root/output/figures"
global atwood_data "$data/Replication_Files/raw_data"

* Stata version control
version 15

* configure library environment
do "$code/_config.do"

*** clean the data
* disease data
do "$code/rates.do"

* 1960 census
do "$code/census_cleaning_false.do"

* ACS data
do "$code/acs_cleaning.do"

*** results
do "$code/table2_mw.do"

do "$code/eventstudy.do"