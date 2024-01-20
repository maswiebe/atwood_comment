*** cohort event study
* interact measles_pc with birthyr, omit 1948 as last cohort with vaccine exposure=0
* want 16 years before and after 1948-64
    * 32-48, 64-80

* close chrome to save memory

use year sex age birthyr black bpl female cpi_incwage cpi_incwage_no0 ln_cpi_income poverty100 employed hrs_worked avg_12yr_measles_rate bpl_region9 if inrange(birthyr,1932,1980) & missing(avg_12yr_measles_rate)==0 using "$data/acs_cleaned.dta", clear

gen measles_pc = avg_12yr_measles_rate/100000

forvalues i = 1932/1980 {
    gen d`i' = (birthyr==`i')
    gen int_`i' = d`i'*measles_pc
    lab var int_`i' " "
    drop d`i'
}
* label ticks on graph
foreach i in 1940 1950 1960 1970 1980 {
    lab var int_`i' "`i'"
}

* loop to construct list by appending
    * put 1948 last, as omitted year
local interactions ""
forval y = 1932/1980 {
    if `y' != 1948 {
        local interactions "`interactions' int_`y'"
    }
}
local interactions "`interactions' int_1948"

local int_ordered ""
forval y = 1932/1980 {
    local int_ordered "`int_ordered' int_`y'"
}

local robust_fes year age#black#female bpl#black#female bpl_region9#birthyr

set scheme plotplainblind

foreach x in cpi_incwage cpi_incwage_no0 ln_cpi_income poverty100 employed hrs_worked {
    
    reghdfe `x' `interactions', ab(`robust_fes') vce(cluster bpl#birthyr)

    coefplot, drop(_cons) vert order(`int_ordered') omitted xline(17.5, lcolor(reddish)) xline(33.5, lcolor(reddish)) yline(0, lcolor(black)) xtitle("Birth year")
    graph export "$figures/es_robust_`x'.png", replace
    graph export "$figures/es_robust_`x'.pdf", replace
    graph close
}