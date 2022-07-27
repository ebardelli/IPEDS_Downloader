/*
	IPEDS Downloader
	================

	This do file downloads data files (awards/degrees conferred by CIP-6 codes)

	Download URLs:
	 - Data: https://nces.ed.gov/ipeds/datacenter/data/HD2020_Data_Stata.zip
	 - Code: https://nces.ed.gov/ipeds/datacenter/data/HD2020_Stata.zip
	 - Dict: https://nces.ed.gov/ipeds/datacenter/data/HD2020_Dict.zip
 */

cap mkdir "Data"
cap mkdir "Code"
cap mkdir "Documentation"
cap mkdir "Data/Raw"
cap mkdir "Data/Zip"
cap mkdir "Data/Temp"
cap mkdir "Code/IPEDS"
cap mkdir "Documentation/IPEDS"

forval year = 2002/2020 {
	cap mkdir "Data/Zip/`year'/"

	** Download files
	copy https://nces.ed.gov/ipeds/datacenter/data/HD`year'_Data_Stata.zip Data/Zip/`year'/HD_Data_Stata.zip, replace
	copy https://nces.ed.gov/ipeds/datacenter/data/HD`year'_Stata.zip Data/Zip/`year'/HD_Code_Stata.zip, replace
	copy https://nces.ed.gov/ipeds/datacenter/data/HD`year'_Dict.zip Data/Zip/`year'/HD_Dict.zip, replace

	** Unzip files
	unzipfile Data/Zip/`year'/HD_Data_Stata.zip
	unzipfile Data/Zip/`year'/HD_Code_Stata.zip
	unzipfile Data/Zip/`year'/HD_Dict.zip

	** Organize unzipped files
	** Data files
	local files : dir "`c(pwd)'" files "*.csv"
	foreach file in `files' {
		copy `file' Data/Raw/, replace
		erase `file'
	}
	local files : dir "`c(pwd)'" files "*.xls"
	foreach file in `files' {
		copy `file' Data/Raw/, replace
		erase `file'
	}
	local files : dir "`c(pwd)'" files "*.xlsx"
	foreach file in `files' {
		copy `file' Data/Raw/, replace
		erase `file'
	}
	** Do files
	** Remove loading and saving of data. We do this separately.
	shell sed -i '/insheet/d' *.do
	shell sed -i '/save/d' *.do

	local files : dir "`c(pwd)'" files "*.do"
	foreach file in `files' {
		copy `file' Code/IPEDS/, replace
		erase `file'
	}
	** Dictionary
	local files : dir "`c(pwd)'" files "*.html"
	foreach file in `files' {
		copy `file' Documentation/IPEDS/, replace
		erase `file'
	}

	** Create dta files for each downloaded year
	local files : dir "Data/Raw/" files "hd`year'*.csv"
	foreach file in `files' {
		clear all

		** Some years have revised data. This adds a _rv flag to the saved dta file
		if regexm("`file'", "rv") {
			local rv = "_rv"
		}
		else {
			local rv = ""
		}
		insheet using "Data/Raw/`file'", comma clear

		local file : dir "Code/IPEDS/" files "hd`year'*.do"
		local do_file = "Code/IPEDS/" + `file'
		cap do "`do_file'"

		** Save data
		save "Data/Raw/Institutions_`year'`rv'", replace
	}
}
