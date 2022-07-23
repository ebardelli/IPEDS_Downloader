/*
	Clean CIP6 Awards
	=================

	This do file creates a single data file with all CIP6 award data

 */

clear all

forval year = 2002/2020 {
	append using "Data/Raw/Institutions_`year'.dta", force
	cap gen year = .
	replace year = `year' if missing(year)
}

save "Data/Institutions_2002_2022", replace
