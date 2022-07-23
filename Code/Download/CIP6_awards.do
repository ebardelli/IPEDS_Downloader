/*
	IPEDS Downloader
	================

	This do file downloads data files (awards/degrees conferred by CIP-6 codes)

	Download URLs:
	 - Data: https://nces.ed.gov/ipeds/datacenter/data/C2020_A_Data_Stata.zip
	 - Code: https://nces.ed.gov/ipeds/datacenter/data/C2020_A_Stata.zip
	 - Dict: https://nces.ed.gov/ipeds/datacenter/data/C2020_A_Dict.zip
 */

cap mkdir "Data"
cap mkdir "Code"
cap mkdir "Documentation"
cap mkdir "Data/Raw"
cap mkdir "Data/Zip"
cap mkdir "Data/Temp"
cap mkdir "Code/IPEDS"
cap mkdir "Documentation/IPEDS"

forval year = 2000/2020 {
	cap mkdir "Data/Zip/`year'/"

	** Download files
	copy https://nces.ed.gov/ipeds/datacenter/data/C`year'_A_Data_Stata.zip Data/Zip/`year'/C_A_Data_Stata.zip, replace
	copy https://nces.ed.gov/ipeds/datacenter/data/C`year'_A_Stata.zip Data/Zip/`year'/C_A_Code_Stata.zip, replace
	copy https://nces.ed.gov/ipeds/datacenter/data/C`year'_A_Dict.zip Data/Zip/`year'/C_A_Dict.zip, replace

	** Unzip files
	unzipfile Data/Zip/`year'/C_A_Data_Stata.zip
	unzipfile Data/Zip/`year'/C_A_Code_Stata.zip
	unzipfile Data/Zip/`year'/C_A_Dict.zip

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
	local files : dir "`c(pwd)'" files "*_a.do"
	foreach file in `files' {
		copy `file' Code/IPEDS/, replace
		erase `file'
	}
	local files : dir "`c(pwd)'" files "*_A.do"
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
}
