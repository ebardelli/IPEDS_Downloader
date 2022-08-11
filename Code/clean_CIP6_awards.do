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

** Line up counts across data collections
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

gen nonres_men = crace01
gen nonres_wom = crace02
gen black_men = crace03
gen black_wom = crace04
gen native_men = crace05
gen native_wom = crace06
gen aapi_men = crace07
gen aapi_wom = crace08
gen hispanic_men = crace09
gen hispanic_wom = crace10
gen white_men = crace11
gen white_wom = crace12
gen unknown_men = crace13
gen unknown_wom = crace14
gen men_tot = crace15
gen wom_tot = crace16
gen nonres_tot = crace17
gen black_tot = crace18
gen native_tot = crace19
gen aapi_tot = crace20
gen hispanic_tot = crace21
gen white_tot = crace22
gen unknown_tot = crace23
gen tot = crace24

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

replace nonres_men = cnralm if missing(nonres_men)
replace nonres_wom = cnralw if missing(nonres_wom)
replace black_men = cbkaam if missing(black_men)
replace black_wom = cbkaaw if missing(black_wom)
replace native_men = caianm if missing(native_men)
replace native_wom = caianw if missing(native_wom)
replace aapi_men = casiam if missing(aapi_men)
replace aapi_wom = casiaw if missing(aapi_wom)
replace hispanic_men = chispm if missing(hispanic_men)
replace hispanic_wom = chispw if missing(hispanic_wom)
replace white_men = cwhitm if missing(white_men)
replace white_wom = cwhitw if missing(white_wom)
replace unknown_men = cunknm if missing(unknown_men)
replace unknown_wom = cunknw if missing(unknown_wom)
replace men_tot = ctotalm if missing(men_tot)
replace wom_tot = ctotalw if missing(wom_tot)
replace nonres_tot = cnralt if missing(nonres_tot)
replace black_tot = cbkaat if missing(black_tot)
replace native_tot = caiant if missing(native_tot)
replace aapi_tot = casiat if missing(aapi_tot)
replace hispanic_tot = chispt if missing(hispanic_tot)
replace white_tot = cwhitt if missing(white_tot)
replace unknown_tot = cunknt if missing(unknown_tot)
replace tot = ctotalt if missing(tot)

foreach group in nonres black native aapi hispanic white unknown {
	gen p_`group'_men = `group'_men / men_tot
	gen p_`group'_wom = `group'_wom / wom_tot

	gen p_`group' = `group'_tot / tot
}

** Generate CIP2 variable
gen cip2 = floor(cipcode / 10000)
** Gen CIP4 variable
gen cip4 = floor(cipcode / 100)

label values cip2 label_cip2

gzsave "Data/Awards_2000_2020", replace
