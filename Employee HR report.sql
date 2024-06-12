CREATE database resource;
USE resource;

SELECT*
FROM hr;
 
 #check data types
 DESCRIBE hr;
  

  #change date types to dates
  
 ALTER TABLE hr
 MODIFY COLUMN birthdate DATE;
 
 ALTER TABLE hr
 MODIFY COLUMN hire_date DATE;
 
 UPDATE hr
 SET termdate=date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
 WHERE termdate IS NOT NULL AND termdate!='';
 
 
  ALTER TABLE hr
 MODIFY COLUMN termdate DATE;
 
 # Add another column employee_age
 
 ALTER TABLE hr
 ADD COLUMN employee_age INT;
 
 UPDATE hr
 SET employee_age=timestampdiff(YEAR,birthdate,CURDATE());
 
 SELECT birthdate, employee_age
 from hr
 where employee_age;
 
 #1. Gender breakdown
 SELECT gender, count(gender)
 FROM hr
 WHERE termdate IS NULL
 group by gender;
 
 #2.race/ethnicity breakdown
SELECT race, count(race)
FROM hr
WHERE termdate IS NULL
GROUP BY RACE
ORDER BY COUNT(race) DESC;

#3.Age distribution
SELECT 
min(employee_age) AS youngest,
max(employee_age) AS oldest
FROM hr
WHERE termdate IS NULL;

SELECT
CASE
WHEN employee_age>=21 AND employee_age<=24 THEN '18-24'
WHEN employee_age>=25 AND employee_age<=34 THEN '25-34'
WHEN employee_age>=35 AND employee_age<=44 THEN '35-44'
WHEN employee_age>=45 AND employee_age<=54 THEN '45-54'
WHEN employee_age>=55 AND employee_age<=60 THEN '55-60'
ELSE 'NOT STAFF'
END AS age_group,
count(employee_age) AS total
FROM hr
WHERE termdate IS NULL
GROUP BY age_group
ORDER BY age_group;

#gender distribution across age_groups
SELECT
CASE
WHEN employee_age>=21 AND employee_age<=24 THEN '18-24'
WHEN employee_age>=25 AND employee_age<=34 THEN '25-34'
WHEN employee_age>=35 AND employee_age<=44 THEN '35-44'
WHEN employee_age>=45 AND employee_age<=54 THEN '45-54'
WHEN employee_age>=55 AND employee_age<=60 THEN '55-60'
ELSE 'NOT STAFF'
END AS age_group,
gender,
count(employee_age) AS total
FROM hr
WHERE termdate IS NULL
GROUP BY age_group,gender
ORDER BY age_group,gender;

#Employees locations hq vs. remote
SELECT location, count(location) AS COUNT
FROM hr
WHERE termdate IS NULL
GROUP BY location;

#Average Employment duration
SELECT 
avg(datediff(termdate,hire_date))/365 AS Average_employment_duration
FROM hr
WHERE termdate IS NOT NULL;
#Gender distribution across departments

SELECT gender, department,COUNT(*) AS count
FROM hr
WHERE termdate IS NULL
GROUP BY gender, department
ORDER BY department;

#Distribution of job titles
SELECT jobtitle, count(*)
FROM hr
WHERE termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

  #Termination rate per department
  SELECT department,
  SUM(total_count),
  SUM(terminated_count),
  SUM(terminated_count)/SUM(total_count) as termination_rate
FROM(
SELECT department,
  count(*) as total_count,
  sum(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count
 FROM hr
 GROUP BY department) as S1
 GROUP BY department
 ORDER BY termination_rate DESC;
 
 #Distribution across states
 
 SELECT location_state, count(*) as count
 from hr
 WHERE termdate IS NULL
 GROUP BY location_state
 ORDER BY count DESC;
 
 #employee countchange based on hire and term dates
 SELECT 
 year,
 hires,
 terminations,
 hires-terminations AS net_change,
 ((hires-terminations)/hires)*100 as net_chang_percent
 
 FROM (
 SELECT YEAR(hire_date) AS year,
 count(*) AS hires,
 SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminations
 FROM hr 
 GROUP BY YEAR(hire_date)
 ) AS S2
 
ORDER BY year ASC;

#Tenure distribution across departments
SELECT department, round(avg (datediff(termdate, hire_date)/365),2) AS avg_tenure
 FROM hr
 where termdate IS NOT NULL
 GROUP BY department;
 
 
 
 
 
 

 