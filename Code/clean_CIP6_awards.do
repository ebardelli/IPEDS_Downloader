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

replace p_black_m = cbkaam / ctotalm
replace p_black_w = cbkaaw / ctotalw
replace p_native_m = caianm / ctotalm
replace p_native_w = caianw / ctotalw
replace p_asian_m = casiam / ctotalm
replace p_asian_w = casiaw / ctotalw
replace p_hispanic_m = chispm / ctotalm
replace p_hispanic_w = chispw / ctotalw
replace p_white_m = cwhitm / ctotalm
replace p_white_w = cwhitw / ctotalw

replace p_black = cbkaat / ctotalt
replace p_native = caiant / ctotalt
replace p_asian = casiat / ctotalt
replace p_hispanic = chispt / ctotalt
replace p_white = cwhitt / ctotalt

** Generage CIP2 variable
gen cip2 = floor(cipcode / 10000)

label values cip2 label_cip2

gzsave "Data/Awards_2000_2020", replace
