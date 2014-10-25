* change this to your directory
cd "C:\Users\Julian.Julian-PC\Dropbox\J file\temp_RA"



import excel using "SED subsample.xlsx", clear firstrow

drop if AcademicInstitutionstandardiz == "Not Available" | AcademicInstitutionstandardiz == ". Unknown Institutions"


encode AcademicInstitutionstandardiz, gen(AcademicInstitutionstandardiz1)
encode State, gen(State1)
destring NumberofDoctorateRecipientsb, replace 


bysort discipline: egen sum_all_discipline = total(NumberofDoctorateRecipientsb) // aggregate all graduates in all years within different disciplines
bysort Year: egen sum_all_discipline_all_year = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year



graph hbar (sum) NumberofDoctorateRecipientsb , over(discipline)    // graph of PhD grad in different disciplines in all years
graph save Graph g1, replace

graph hbar (sum) NumberofDoctorateRecipientsb ,  over(Year)   // graph of PhD grad in different disciplines in all years
graph save Graph g2, replace







set more off

* The following is subsampling the data and focus on political science and public administration
*****************************************************************************************************************************

foreach dis in Political_Science_Public_Admin Economics Other_Social_Sci Social_Service Sociology  {


import excel using "SED subsample.xlsx", clear firstrow


/* 
change "Political Science and Public Administration" to  any of the following discipline if you want to check other discipline
Economics
Other Social Sciences
Social Service Professions
Sociology
*/


gen discipline_replicate =.

tostring discipline_replicate , replace

replace discipline_replicate = "Political_Science_Public_Admin" if discipline == "Political Science and Public Administration"

replace discipline_replicate = "Economics" if discipline == "Economics"

replace discipline_replicate = "Other_Social_Sci" if discipline == "Other Social Sciences"

replace discipline_replicate = "Social_Service" if discipline == "Social Service Professions"

replace discipline_replicate = "Sociology" if discipline == "Sociology"



drop if AcademicInstitutionstandardiz == "Not Available" | AcademicInstitutionstandardiz == ". Unknown Institutions"


encode AcademicInstitutionstandardiz, gen(AcademicInstitutionstandardiz1)
encode State, gen(State1)
destring NumberofDoctorateRecipientsb, replace 



 


keep if discipline_replicate == "`dis'"




xtset AcademicInstitutionstandardiz1 Year



bysort AcademicInstitutionstandardiz1: egen sum_all_years_by_school = total(NumberofDoctorateRecipientsb)   // aggregate all graduates in all years within Political Science and Public Administration
bysort State: egen sum_all_state = total(NumberofDoctorateRecipientsb) // aggregate all graduates in all years within each state
bysort Year: egen sum_all_year = total(NumberofDoctorateRecipientsb)  // aggregate all graduates in all states in each year



/* you can play around with the numbers. But there will be too many graphs printed out if the number is too small
xtline NumberofDoctorateRecipientsb if sum_all_years_by_school >= 200
graph save Graph g3, replace


xtline NumberofDoctorateRecipientsb if sum_all_years_by_school >= 200, overlay
graph save Graph g4, replace




graph hbar (sum) NumberofDoctorateRecipientsb if sum_all_state > 500, over(State)    // graph of aggregating all graduates in all years within each state
graph save Graph g5, replace

*/

	graph twoway line sum_all_year Year  // graph of aggregating all graduates in all states in each year
	graph save Graph sum_all_year_`dis', replace




***** graph of PhD graduates by schools *****
	sort AcademicInstitutionstandardiz1 Year

	egen newid = group(AcademicInstitutionstandardiz1)





	replace NumberofDoctorateRecipientsb = 0 if NumberofDoctorateRecipientsb == .
	
	sum newid
	local total = r(max)-50	
	
	
	forvalues i = 0(50) `total' {

		xtline NumberofDoctorateRecipientsb if sum_all_years_by_school != 0 & newid >= 1 + `i'  & newid < 50 + 1 + `i', yline(0)
		graph save Graph `dis'_by_school`i', replace

	}

	
}










