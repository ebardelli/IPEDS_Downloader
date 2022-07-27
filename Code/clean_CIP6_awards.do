/*
	Clean CIP6 Awards
	=================

	This do file creates a single data file with all CIP6 award data

 */

clear all

forval year = 2000/2003 {
	append using "Data/Raw/Awards_`year'.dta"
	cap gen year = .
	replace year = `year' if missing(year)
	drop xcrace*
}

forval year = 2004/2019 {
	append using "Data/Raw/Awards_`year'_rv.dta"
	replace year = `year' if missing(year)
}

forval year = 2020/2020 {
	append using "Data/Raw/Awards_`year'.dta"
	replace year = `year' if missing(year)
}

** Generate percentage
/*
crace01         int     %8.0g                 Nonresident alien men
crace02         int     %8.0g                 Nonresident alien women
crace03         int     %8.0g                 Black non-Hispanic men
crace04         int     %8.0g                 Black non-Hispanic women
crace05         int     %8.0g                 American Indian or Alaskan Native men
crace06         int     %8.0g                 American Indian or Alaskan Native women
crace07         int     %8.0g                 Asian or Pacific Islander men
crace08         int     %8.0g                 Asian or Pacific Islander women
crace09         int     %8.0g                 Hispanic men
crace10         int     %8.0g                 Hispanic women
crace11         int     %8.0g                 White non-Hispanic men
crace12         int     %8.0g                 White non-Hispanic women
crace13         int     %8.0g                 Race/ethnicity unknown men
crace14         int     %8.0g                 Race/ethnicity unknown women
crace15         int     %8.0g                 Grand total men
crace16         int     %8.0g                 Grand total women
crace17         int     %8.0g                 Nonresident alien total
crace18         int     %8.0g                 Black non-Hispanic total
crace19         int     %8.0g                 American Indian/Alaska Native total
crace20         int     %8.0g                 Asian or Pacific Islander total
crace21         int     %8.0g                 Hispanic total
crace22         int     %8.0g                 White non-Hispanic total
crace23         int     %8.0g                 Race/ethnicity unknown total
crace24         int     %8.0g                 Grand total
*/

gen p_nonres_m = crace01 / crace15
gen p_nonres_w = crace02 / crace16
gen p_black_m = crace03 / crace15
gen p_black_w = crace04 / crace16
gen p_native_m = crace05 / crace15
gen p_native_w = crace06 / crace16
gen p_asian_m = crace07 / crace15
gen p_asian_w = crace08 / crace16
gen p_hispanic_m = crace09 / crace15
gen p_hispanic_w = crace10 / crace16
gen p_white_m = crace11 / crace15
gen p_white_w = crace12 / crace16
gen p_unknown_m = crace13 / crace15
gen p_unknown_w = crace14 / crace16

gen p_nonres = crace17 / crace24
gen p_black = crace18 / crace24
gen p_native = crace19 / crace24
gen p_asian = crace20 / crace24
gen p_hispanic = crace21 / crace24
gen p_white = crace22 / crace24
gen p_unknown = crace23 / crace24

** New counts
/*
cnralm          int     %8.0g                 Nonresident alien men
cnralw          int     %8.0g                 Nonresident alien women
cunknm          int     %8.0g                 Race/ethnicity unknown men
cunknw          int     %8.0g                 Race/ethnicity unknown women
ctotalm         int     %8.0g                 Grand total men
ctotalw         int     %8.0g                 Grand total women
cnralt          int     %8.0g                 Nonresident alien total
cunknt          int     %8.0g                 Race/ethnicity unknown total
ctotalt         long    %8.0g                 Grand total
chispm          int     %8.0g                 Hispanic or Latino men - new
chispw          int     %8.0g                 Hispanic or Latino women - new
caianm          int     %8.0g                 American Indian or Alaska Native men - new
caianw          int     %8.0g                 American Indian or Alaska Native women - new
casiam          int     %8.0g                 Asian men - new
casiaw          int     %8.0g                 Asian women - new
cbkaam          int     %8.0g                 Black or African American men - new
cbkaaw          int     %8.0g                 Black or African American women - new
cnhpim          int     %8.0g                 Native Hawaiian or Other Pacific Islander men - new
cnhpiw          int     %8.0g                 Native Hawaiian or Other Pacific Islander women - new
cwhitm          int     %8.0g                 White men - new
cwhitw          int     %8.0g                 White women - new
c2morm          int     %8.0g                 Two or more races men - new
c2morw          int     %8.0g                 Two or more races women - new
chispt          int     %8.0g                 Hispanic or Latino total - new
caiant          int     %8.0g                 American Indian or Alaska Native total - new
casiat          int     %8.0g                 Asian total - new
cbkaat          int     %8.0g                 Black or African American total - new
cnhpit          int     %8.0g                 Native Hawaiian or Other Pacific Islander total - new
cwhitt          int     %8.0g                 White total - new
c2mort          int     %8.0g                 Two or more races total - new
 */

replace p_black_m = cbkaam / ctotalm if missing(p_black_m)
replace p_black_w = cbkaaw / ctotalw if missing(p_black_w)
replace p_native_m = caianm / ctotalm if missing(p_native_m)
replace p_native_w = caianw / ctotalw if missing(p_native_w)
replace p_asian_m = casiam / ctotalm if missing(p_asian_m)
replace p_asian_w = casiaw / ctotalw if missing(p_asian_w)
replace p_hispanic_m = chispm / ctotalm if missing(p_hispanic_m)
replace p_hispanic_w = chispw / ctotalw if missing(p_hispanic_w)
replace p_white_m = cwhitm / ctotalm if missing(p_white_m)
replace p_white_w = cwhitw / ctotalw if missing(p_white_w)

replace p_black = cbkaat / ctotalt if missing(p_black)
replace p_native = caiant / ctotalt if missing(p_native)
replace p_asian = casiat / ctotalt if missing(p_asian)
replace p_hispanic = chispt / ctotalt if missing(p_hispanic)
replace p_white = cwhitt / ctotalt if missing(p_white)

** Generage CIP2 variable
gen cip2 = floor(cipcode / 10000)

label values cip2 label_cip2

gzsave "Data/Awards_2000_2020", replace
