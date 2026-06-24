-- Task 1 
-- Find out the distribution of days spent in the hospital by number of patients.

-- Selecting time_in_hospital and counting the number of patients for each duration.
select time_in_hospital, 
       count(patient_nbr) as number_of_patients
from patient_data
-- Grouping the results by time_in_hospital to observe the distribution pattern.
group by time_in_hospital
-- Sorting the results in ascending order based on time_in_hospital for clarity.
order by time_in_hospital asc


-- Task 2
-- Analyzing % distribution of patients based on readmission status.

-- Selecting readmission status and calculating the percentage distribution.
select readmitted,
       round((count(*) * 100.0 / total), 2) as percentage
from patient_data
cross join (select count(*) as total
            from patient_data) as sub1
-- Grouping the results by readmission status and total count.
group by readmitted, total

  
-- Task 3
-- Finding the average time in the hospital for patients who experienced a change in medication and were readmitted within 30 days.

-- Selecting and rounding the average number of days in the hospital.
select round(avg(number_of_days), 2) as avg_length_of_stay
   -- Subquery: extracting relevant data for patients with medication change and readmission within 30 days.
from (select patient_nbr, time_in_hospital as number_of_days
      from patient_data
      where change = 'Ch' and readmitted = '<30')


-- Task 4
-- Analyzing the relationship between the frequency of lab procedures, procedures, medications and the patient's age.

-- Selecting age and rounding the averages for num_lab_procedures, num_procedures, and num_medications.
select age,
       round(avg(num_lab_procedures), 2) as avg_lab_procedures,
       round(avg(num_procedures), 2) as avg_procedures,
       round(avg(num_medications), 2) as avg_medications
from patient_data
-- Grouping the results by age to observe patterns across different age groups.
group by age
-- Sorting the results in ascending order based on age for better readability.
order by age asc


-- Task 5
-- Analyzing the co-relation between lab procedures and length of stay.

-- Selecting and rounding the average length of stay, categorizing lab procedure frequency.
select round(avg(time_in_hospital), 2) as avg_length_of_stay,
       case
           when num_lab_procedures >= 0 and num_lab_procedures <= 25 then 'Few'
           when num_lab_procedures > 25 and num_lab_procedures <= 50 then 'Average'
           when num_lab_procedures > 50 and num_lab_procedures <= 100 then 'Many'
           else 'Special Cases'
       end as lab_procedure_frequency
from patient_data
-- Grouping the results by lab procedure frequency to observe correlations.
group by lab_procedure_frequency
-- Sorting the results in ascending order based on average length of stay for better insights.
order by avg_length_of_stay asc


-- Task 6
-- Finding the hospital specialities that perform the highest average number of procedures.

-- Selecting medical_specialty, rounding the average number of procedures, and counting procedure occurrences.
select medical_specialty, 
       round(avg(num_procedures), 2) as avg_procedures, 
       count(*) as procedure_count
from patient_data
-- Grouping the results by medical_specialty.
group by medical_specialty
-- Filtering out unknown specialties and those with less than 50 occurrences.
having medical_specialty not like '?' and count(*) > 50
-- Sorting the results in descending order based on average procedures for insights.
order by avg_procedures desc


-- Task 7
-- Analyzing the distribution of the most common diabetes medication usage by all age groups. 

-- Subquery for Metformin medication state distribution by age.
with tblm as
(select age, medication_state, count(*) as metformin_num_patients
from (select age, metformin,
      case
      when metformin = 'No' and diabetesmed = 'Yes' then 'Not Using'
      when (metformin = 'Up' or metformin = 'Up' or metformin = 'Down' or metformin = 'Steady')and diabetesmed = 'Yes' then 'Using'
	  else 'Not on Diabetes Medication'
      end as medication_state
      from patient_data) as medication_states
group by age, medication_state
having medication_state not like 'Not on Diabetes Medication' and medication_state not like 'Not Using'),
-- Subquery for Insulin medication state distribution by age.
tbli as 
(select age, medication_state, count(*) as insulin_num_patients
from (select age, insulin,
      case
      when insulin = 'No' and diabetesmed = 'Yes' then 'Not Using'
      when (insulin = 'Up' or insulin = 'Down' or insulin = 'Steady') and diabetesmed = 'Yes' then 'Using'
	  else 'Not on Diabetes Medication'
      end as medication_state
      from patient_data) as medication_states
group by age, medication_state
having medication_state not like 'Not on Diabetes Medication' and medication_state not like 'Not Using'),
-- Subquery for Glipizide medication state distribution by age.
tblglip as 
(select age, medication_state, count(*) as glipizide_num_patients
from (select age, glipizide,
      case
      when glipizide = 'No' and diabetesmed = 'Yes' then 'Not Using'
      when (glipizide = 'Up' or glipizide = 'Down' or glipizide = 'Steady') and diabetesmed = 'Yes' then 'Using'
	  else 'Not on Diabetes Medication'
      end as medication_state
      from patient_data) as medication_states
group by age, medication_state
having medication_state not like 'Not on Diabetes Medication' and medication_state not like 'Not Using'),
-- Subquery for Glimepiride medication state distribution by age.
tblglim as 
(select age, medication_state, count(*) as glimepiride_num_patients
from (select age, glimepiride,
      case
      when glimepiride = 'No' and diabetesmed = 'Yes' then 'Not Using'
      when (glimepiride = 'Up' or glimepiride = 'Down' or glimepiride = 'Steady') and diabetesmed = 'Yes' then 'Using'
	  else 'Not on Diabetes Medication'
      end as medication_state
      from patient_data) as medication_states
group by age, medication_state
having medication_state not like 'Not on Diabetes Medication' and medication_state not like 'Not Using'),
-- Subquery for Glyburide medication state distribution by age.
tblglyb as 
(select age, medication_state, count(*) as glyburide_num_patients
from (select age, glyburide,
      case
      when glyburide = 'No' and diabetesmed = 'Yes' then 'Not Using'
      when (glyburide = 'Up' or glyburide = 'Down' or glyburide = 'Steady') and diabetesmed = 'Yes' then 'Using'
	  else 'Not on Diabetes Medication'
      end as medication_state
      from patient_data) as medication_states
group by age, medication_state
having medication_state not like 'Not on Diabetes Medication' and medication_state not like 'Not Using'),
-- Subquery for Pioglitazone medication state distribution by age.
tblpio as 
(select age, medication_state, count(*) as pioglitazone_num_patients
from (select age, pioglitazone,
      case
      when pioglitazone = 'No' and diabetesmed = 'Yes' then 'Not Using'
      when (pioglitazone = 'Up' or pioglitazone = 'Down' or pioglitazone = 'Steady') and diabetesmed = 'Yes' then 'Using'
	  else 'Not on Diabetes Medication'
      end as medication_state
      from patient_data) as medication_states
group by age, medication_state
having medication_state not like 'Not on Diabetes Medication' and medication_state not like 'Not Using')
-- Final query to select results from all medication state distributions.
select tbli.age, tbli.medication_state, 
       insulin_num_patients, 
       metformin_num_patients, 
       glipizide_num_patients,
       glyburide_num_patients,
       pioglitazone_num_patients,
       glimepiride_num_patients
from tbli
full outer join tblm on tbli.age = tblm.age
full outer join tblglip on tbli.age = tblglip.age
full outer join tblglyb on tbli.age = tblglyb.age
full outer join tblglim on tbli.age = tblglim.age
full outer join tblpio on tbli.age = tblpio.age

-- Task 8
-- Find out the list of patients who were re-admitted to the hospital more than once. 

-- Selecting patient numbers and counting the times they were admitted.
select patient_nbr, count(*) as times_admitted
from patient_data
-- Grouping the results by patient number.
group by patient_nbr
-- Filtering out patients with more than two admissions. (which means more than one re-admissions since first admission is not a readmission)
having count(*) > 2
-- Sorting the results in ascending order based on patient number.
order by patient_nbr asc


-- Task 9
-- Analyzing racial disparities by calculating the average number of lab procedures for distinct racial groups. 

-- Selecting race and rounding the average number of lab procedures.
select race, round(avg(num_lab_procedures), 2) as avg_num_lab_procedures
from patient_data
-- Filtering out unknown race values.
where race not like '?'
-- Grouping the results by race to observe disparities.
group by race
-- Sorting the results in descending order based on average number of lab procedures.
order by avg_num_lab_procedures desc


-- Task 10
-- Providing a one line summary for each patient, including their race, lab procedures, medications, readmission etc.

-- Selecting concatenated patient summaries based on various patient information.
select concat('patient ', patient_nbr, ' was ', race, ' and ', 
			         (case 
			          when readmitted = 'no' then ' was not readmitted. they had '
			          else ' was readmitted. they had '
			          end),
			          num_medications, ' medication(s) and ', num_lab_procedures, ' lab procedures.') as patient_summary
from patient_data




