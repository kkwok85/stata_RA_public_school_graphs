* change this to your directory
cd "D:\Dropbox\Professor Walker\graphs"



import excel using "SED 2000-2012.xlsx", clear firstrow




* drop if AcademicInstitutionstandardiz == "Not Available" | AcademicInstitutionstandardiz == ". Unknown Institutions"


encode AcademicInstitutionstandardiz, gen(AcademicInstitutionstandardiz1)
encode State, gen(State1)
destring NumberofDoctorateRecipientsb, replace 
rename AcademicDisciplineDetaileds discipline

sum  NumberofDoctorateRecipientsb  if  discipline == "Economics" 
sum  NumberofDoctorateRecipientsb  if  discipline == "Political Science and Public Administration" 
sum  NumberofDoctorateRecipientsb  if  discipline == "Sociology" 
sum  NumberofDoctorateRecipientsb  if  discipline == "Social Service Professions"
sum  NumberofDoctorateRecipientsb  if  discipline == "Other Social Sciences"




bysort discipline: egen sum_all_discipline = total(NumberofDoctorateRecipientsb) // aggregate all graduates in all years within different disciplines
bysort Year: egen sum_all_discipline_all_year = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year




graph hbar (sum) NumberofDoctorateRecipientsb , over(discipline)    // graph of PhD grad in different disciplines in all years
graph save Graph g1, replace

graph hbar (sum) NumberofDoctorateRecipientsb ,  over(Year)   // graph of PhD grad in different disciplines in all years
graph save Graph g2, replace







set more off

* The following is subsampling the data 
*****************************************************************************************************************************

foreach dis in Political_Science_Public_Admin Economics Social_Service Sociology  {


	import excel using "SED 2000-2012.xlsx", clear firstrow


/* 
change "Political Science and Public Administration" to  any of the following discipline if you want to check other discipline
Economics
Other Social Sciences
Social Service Professions
Sociology
*/

	encode AcademicInstitutionstandardiz, gen(AcademicInstitutionstandardiz1)
	encode State, gen(State1)
	destring NumberofDoctorateRecipientsb, replace 
	rename AcademicDisciplineDetaileds discipline


	gen discipline_replicate =.

	tostring discipline_replicate , replace

	replace discipline_replicate = "Political_Science_Public_Admin" if discipline == "Political Science and Public Administration"

	replace discipline_replicate = "Economics" if discipline == "Economics"

	replace discipline_replicate = "Other_Social_Sci" if discipline == "Other Social Sciences"

	replace discipline_replicate = "Social_Service" if discipline == "Social Service Professions"

	replace discipline_replicate = "Sociology" if discipline == "Sociology"




*	drop if AcademicInstitutionstandardiz == "Not Available" | AcademicInstitutionstandardiz == ". Unknown Institutions"



	
	

	bysort Year: egen sum_all_discipline_all_year = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year 
	bysort Year discipline: egen sum_all_year_by_discipline = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year 
	
	 
	keep if discipline_replicate == "Economics" | discipline_replicate == "Political_Science_Public_Admin" | discipline_replicate == "Sociology" | discipline_replicate == "Social_Service"
	bysort Year: egen sub_policy_discipline = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year 
	
	
	
	gen all_minus_policy_discipline = sum_all_discipline_all_year - sub_policy_discipline

	
	
	

	keep if discipline_replicate == "`dis'"







	bysort AcademicInstitutionstandardiz1: egen sum_all_years_by_school = total(NumberofDoctorateRecipientsb)   // aggregate all graduates in all years within Political Science and Public Administration
	bysort State: egen sum_all_state = total(NumberofDoctorateRecipientsb) // aggregate all graduates in all years within each state
	bysort Year: egen sum_all_year = total(NumberofDoctorateRecipientsb)  // aggregate all graduates in all states in each year



	duplicates drop Year, force

	
	
	gen change_all_minus_policy = ((all_minus_policy_discipline[_n] - all_minus_policy_discipline[_n-1])/all_minus_policy_discipline[_n-1])*100

	gen change_sum_all_year = ((sum_all_year[_n] - sum_all_year[_n-1])/sum_all_year[_n-1])*100



	graph twoway (bar change_all_minus_policy Year, fcolor(none) lcolor(green)) (bar change_sum_all_year Year, fcolor(none) lcolor(red)), ///
	legend(label(1 "Total PhD in all but policy related") label(2 "Total PhD in `dis'")) ///
	title(PhD graduates total minus policy related and by field) ///
	ytitle("percentage change of PhD graduates")
	

	
	
	graph save Graph sum_all_but_policy_and_`dis'_percentage_bar, replace

	
	/* you can play around with the numbers. But there will be too many graphs printed out if the number is too small
	xtline NumberofDoctorateRecipientsb if sum_all_years_by_school >= 200
	graph save Graph g3, replace


	xtline NumberofDoctorateRecipientsb if sum_all_years_by_school >= 200, overlay
	graph save Graph g4, replace




	graph hbar (sum) NumberofDoctorateRecipientsb if sum_all_state > 500, over(State)    // graph of aggregating all graduates in all years within each state
	graph save Graph g5, replace

	*/

	


/*
	graph twoway (line all_minus_policy_discipline Year) (line sum_all_year Year), legend(label(1 "Total PhD in all but policy related") label(2 "Total PhD in `dis'")) title(PhD graduates total minus policy related and by field) 
	graph save Graph sum_all_but_policy_and_`dis', replace



	graph twoway (line all_minus_policy_discipline Year) (line sum_all_year Year), legend(label(1 "Total PhD in all but policy related") label(2 "Total PhD in `dis'")) title(PhD graduates total minus policy related and by field (log scale)) yscale(log)
	graph save Graph sum_all_but_policy_and_`dis'_log_scale, replace
*/


	
	
/*

***** graph of PhD graduates by schools *****
	sort AcademicInstitutionstandardiz1 Year

	egen newid = group(AcademicInstitutionstandardiz1)

	
	
	



	replace NumberofDoctorateRecipientsb = 0 if NumberofDoctorateRecipientsb == .
	
	sum newid
	local total = r(max)	
	
	
	capture	forvalues i = 0(50) `total' {

			xtline NumberofDoctorateRecipientsb if sum_all_years_by_school != 0 & newid >= 1 + `i'  & newid < 50 + 1 + `i', yline(0)
			graph save Graph `dis'_by_school`i', replace

			}

*/
	
}




















	import excel using "SED 2000-2012.xlsx", clear firstrow


/* 
change "Political Science and Public Administration" to  any of the following discipline if you want to check other discipline
Economics
Other Social Sciences
Social Service Professions
Sociology
*/

	encode AcademicInstitutionstandardiz, gen(AcademicInstitutionstandardiz1)
	encode State, gen(State1)
	destring NumberofDoctorateRecipientsb, replace 
	rename AcademicDisciplineDetaileds discipline


	gen discipline_replicate =.

	tostring discipline_replicate , replace

	replace discipline_replicate = "Political_Science_Public_Admin" if discipline == "Political Science and Public Administration"

	replace discipline_replicate = "Economics" if discipline == "Economics"

	replace discipline_replicate = "Other_Social_Sci" if discipline == "Other Social Sciences"

	replace discipline_replicate = "Social_Service" if discipline == "Social Service Professions"

	replace discipline_replicate = "Sociology" if discipline == "Sociology"




*	drop if AcademicInstitutionstandardiz == "Not Available" | AcademicInstitutionstandardiz == ". Unknown Institutions"



	
	

	bysort Year: egen sum_all_discipline_all_year = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year 
	bysort Year discipline: egen sum_all_year_by_discipline = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year 
	
	 
	keep if discipline_replicate == "Economics" | discipline_replicate == "Political_Science_Public_Admin" | discipline_replicate == "Sociology" | discipline_replicate == "Social_Service"
	bysort Year: egen sub_policy_discipline = total(NumberofDoctorateRecipientsb) // aggregate all disciplines in each year 
	
	
	
	gen all_minus_policy_discipline = sum_all_discipline_all_year - sub_policy_discipline

	
	
	

	keep if discipline_replicate == "Economics"







	bysort AcademicInstitutionstandardiz1: egen sum_all_years_by_school = total(NumberofDoctorateRecipientsb)   // aggregate all graduates in all years within Political Science and Public Administration
	bysort State: egen sum_all_state = total(NumberofDoctorateRecipientsb) // aggregate all graduates in all years within each state
	bysort Year: egen sum_all_year = total(NumberofDoctorateRecipientsb)  // aggregate all graduates in all states in each year

	
	duplicates drop Year, force

	
	
gen change_all_minus_policy = ((all_minus_policy_discipline[_n] - all_minus_policy_discipline[_n-1])/all_minus_policy_discipline[_n-1])*100

gen change_sum_all_year = ((sum_all_year[_n] - sum_all_year[_n-1])/sum_all_year[_n-1])*100



	graph twoway (bar change_all_minus_policy Year, fcolor(none) lcolor(green)) (bar change_sum_all_year Year, fcolor(none) lcolor(red)), ///
	legend(label(1 "Total PhD in all but policy related") label(2 "Total PhD in Economics")) ///
	title(PhD graduates total minus policy related and by field) ///
	ytitle("percentage change of PhD graduates") 
