CREATE DATABASE job_listings;
USE job_listings;

CREATE TABLE job_data (
    work_year INT NOT NULL,                        -- Year of work
    job_title VARCHAR(255) NOT NULL,               -- Job title
    job_category VARCHAR(255),                     -- Job category (nullable)
    salary_currency VARCHAR(10),                   -- Currency of salary (nullable)
    salary INT NOT NULL,                           -- Salary
    salary_in_usd INT NOT NULL,                    -- Salary converted to USD
    employee_residence VARCHAR(100) NOT NULL,      -- Employee's residence
    experience_level VARCHAR(50),                  -- Experience level (nullable)
    employment_type VARCHAR(50) NOT NULL,          -- Employment type (e.g., full-time, part-time)
    work_setting VARCHAR(50) NOT NULL,             -- Work setting (e.g., remote, on-site)
    company_location VARCHAR(100) NOT NULL,        -- Company location
    company_size VARCHAR(10)                       -- Company size (nullable)
);



#show table
select * from job_data;
#table details
DESCRIBE job_data;
#number of rows
SELECT COUNT(*) AS total_rows FROM job_data;
#check null count or empty cell
SELECT 
    count(*) as total_row,
    SUM(CASE WHEN work_year IS NULL THEN 1 ELSE 0 END) AS work_year_nulls,
    SUM(CASE WHEN job_title IS NULL OR TRIM(job_title) = '' THEN 1 ELSE 0 END) AS job_title_nulls,
    SUM(CASE WHEN job_category IS NULL OR TRIM(job_category) = '' THEN 1 ELSE 0 END) AS job_category_nulls,
    SUM(CASE WHEN salary_currency IS NULL OR TRIM(salary_currency) = '' THEN 1 ELSE 0 END) AS salary_currency_nulls,
    SUM(CASE WHEN salary IS NULL THEN 1 ELSE 0 END) AS salary_nulls,
    SUM(CASE WHEN salary_in_usd IS NULL THEN 1 ELSE 0 END) AS salary_in_usd_nulls,
    SUM(CASE WHEN employee_residence IS NULL OR TRIM(employee_residence) = '' THEN 1 ELSE 0 END) AS employee_residence_nulls,
    SUM(CASE WHEN experience_level IS NULL OR TRIM(experience_level) = '' THEN 1 ELSE 0 END) AS experience_level_nulls,
    SUM(CASE WHEN employment_type IS NULL OR TRIM(employment_type) = '' THEN 1 ELSE 0 END) AS employment_type_nulls,
    SUM(CASE WHEN work_setting IS NULL OR TRIM(work_setting) = '' THEN 1 ELSE 0 END) AS work_setting_nulls,
    SUM(CASE WHEN company_location IS NULL OR TRIM(company_location) = '' THEN 1 ELSE 0 END) AS company_location_nulls,
    SUM(CASE WHEN company_size IS NULL OR TRIM(company_size) = '' THEN 1 ELSE 0 END) AS company_size_nulls
FROM job_data;

UPDATE job_data
SET job_title = REPLACE(REPLACE(job_title, 'Remote', ''), 'in office', '')
WHERE job_title LIKE '%Remote%' OR job_title LIKE '%in office%';

UPDATE job_data
SET job_title = REPLACE(REPLACE(job_title, '(', ''), ')', '')
WHERE job_title LIKE '%(%' OR job_title LIKE '%)%';

#convert all empty cell to null 
SET sql_safe_updates = 0;

UPDATE job_data
SET 
    job_category = NULL
WHERE TRIM(job_category) = '' OR job_category IS NULL;

UPDATE job_data
SET 
    salary_currency = NULL
WHERE TRIM(salary_currency) = '' OR salary_currency IS NULL;

UPDATE job_data
SET 
    experience_level = NULL
WHERE TRIM(experience_level) = '' OR experience_level IS NULL;

UPDATE job_data
SET 
    company_size = NULL
WHERE TRIM(company_size) = '' OR company_size IS NULL;

#data cleaning
#delet all null value cell
DELETE FROM job_data
WHERE work_year IS NULL 
   OR job_title IS NULL
   OR job_category IS NULL
   OR salary_currency IS NULL
   OR salary IS NULL
   OR salary_in_usd IS NULL
   OR employee_residence IS NULL
   OR experience_level IS NULL
   OR employment_type IS NULL
   OR work_setting IS NULL
   OR company_location IS NULL
   OR company_size IS NULL;
   
ALTER TABLE job_data
DROP COLUMN salary_currency,
DROP COLUMN salary;
   
#total row count after the cleaning
SELECT COUNT(*) AS total_rows FROM job_data;


#EDA
#all unique value in catogotical coulmn
SELECT DISTINCT job_title
FROM job_data;

SELECT DISTINCT job_category
FROM job_data;

SELECT DISTINCT salary_currency
FROM job_data;
#change short form to full form
SELECT DISTINCT employee_residence
FROM job_data;
UPDATE job_data
SET employee_residence = CASE
    WHEN employee_residence = 'US' THEN 'United States'
    WHEN employee_residence = 'JP' THEN 'Japan'
    WHEN employee_residence = 'UK' THEN 'United Kingdom'
    WHEN employee_residence = 'DE' THEN 'Germany'
    WHEN employee_residence = 'CN' THEN 'China'
    WHEN employee_residence = 'MX' THEN 'Mexico'
    WHEN employee_residence = 'IN' THEN 'India'
    ELSE employee_residence
END;

SELECT DISTINCT experience_level
FROM job_data;
UPDATE job_data
SET experience_level = CASE
    WHEN experience_level = 'EN' THEN 'Entry Level'
    WHEN experience_level = 'EX' THEN 'Expert'
    WHEN experience_level = 'MI' THEN 'Mid Level'
    WHEN experience_level = 'SE' THEN 'Senior'
    ELSE experience_level
END;

SELECT DISTINCT employment_type
FROM job_data;
UPDATE job_data
SET employment_type = CASE
    WHEN employment_type = 'CT' THEN 'Contract'
    WHEN employment_type = 'FL' THEN 'Freelance'
    WHEN employment_type = 'FT' THEN 'Full-Time'
    WHEN employment_type = 'PT' THEN 'Part-Time'
    ELSE employment_type
END;

SELECT DISTINCT company_location
FROM job_data;
UPDATE job_data
SET company_location = CASE
    WHEN company_location = 'DE' THEN 'Germany'
    WHEN company_location = 'IN' THEN 'India'
    WHEN company_location = 'CN' THEN 'China'
    WHEN company_location = 'MX' THEN 'Mexico'
    WHEN company_location = 'UK' THEN 'United Kingdom'
    WHEN company_location = 'JP' THEN 'Japan'
    WHEN company_location = 'US' THEN 'United States'
    ELSE company_location
END;

SELECT DISTINCT company_size
FROM job_data;


#EDA
#shape
SELECT COUNT(*) AS total_rows, 
       (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'job_data') AS total_columns
FROM job_data;
#salary max and min
SELECT 
    MIN(salary_in_usd) AS min_salary_usd,
    MAX(salary_in_usd) AS max_salary_usd,
    AVG(salary_in_usd) AS avg_salary_usd
    FROM job_data;
    
    #TOP SALARY WITH JOB TITLE
    
SELECT jd.job_title,jd.job_category,jd.employee_residence,jd.company_location,jd.salary_in_usd,jd.employment_type
FROM job_data jd
JOIN (
    SELECT salary_in_usd
    FROM job_data
    ORDER BY salary_in_usd DESC
    LIMIT 10
) AS top_salaries
ON jd.salary_in_usd = top_salaries.salary_in_usd ORDER BY salary_in_usd DESC;


#EMPLOYEE WITH JOB IN SAME COUNTRY
SELECT count(*) FROM job_data WHERE employee_residence=company_location;

#frequenct of catogory table
SELECT job_title, COUNT(*) AS count
FROM job_data
GROUP BY job_title
ORDER BY count DESC;
SELECT job_category, COUNT(*) AS count
FROM job_data
GROUP BY job_category
ORDER BY count DESC;
SELECT salary_currency, COUNT(*) AS count
FROM job_data
GROUP BY salary_currency
ORDER BY count DESC;
SELECT employee_residence, COUNT(*) AS count
FROM job_data
GROUP BY employee_residence
ORDER BY count DESC;
SELECT experience_level, COUNT(*) AS count
FROM job_data
GROUP BY experience_level
ORDER BY count DESC;
SELECT employment_type, COUNT(*) AS count
FROM job_data
GROUP BY employment_type
ORDER BY count DESC;
SELECT work_setting, COUNT(*) AS count
FROM job_data
GROUP BY work_setting
ORDER BY count DESC;
SELECT company_location, COUNT(*) AS count
FROM job_data
GROUP BY company_location
ORDER BY count DESC;
SELECT company_size, COUNT(*) AS count
FROM job_data
GROUP BY company_size
ORDER BY count DESC;

 
#corelation
SELECT job_title, AVG(salary_in_usd) AS avg_salary
FROM job_data
GROUP BY job_title
ORDER BY avg_salary DESC;

SELECT company_location, AVG(salary_in_usd) AS avg_salary
FROM job_data
GROUP BY company_location
ORDER BY avg_salary DESC;

SELECT job_category, AVG(salary_in_usd) AS avg_salary
FROM job_data
GROUP BY job_category
ORDER BY avg_salary DESC;

SELECT employee_residence, AVG(salary_in_usd) AS avg_salary
FROM job_data
GROUP BY employee_residence
ORDER BY avg_salary DESC;

SELECT company_size, AVG(salary_in_usd) AS avg_salary
FROM job_data
GROUP BY company_size
ORDER BY avg_salary DESC;



#common job title in 2020 and 2021
SELECT 
    job_title,
    COUNT(*) AS job_title_count,
    work_year
FROM 
    job_data
GROUP BY 
    job_title, work_year
ORDER BY 
     job_title_count DESC;

#evolction of job cahange 2020 to 2021
SELECT 
    job_title,
    SUM(CASE WHEN work_year = 2020 THEN 1 ELSE 0 END) AS count_2020,
    SUM(CASE WHEN work_year = 2021 THEN 1 ELSE 0 END) AS count_2021,
    SUM(CASE WHEN work_year = 2022 THEN 1 ELSE 0 END) AS count_2022,
    SUM(CASE WHEN work_year = 2021 THEN 1 ELSE 0 END) - SUM(CASE WHEN work_year = 2020 THEN 1 ELSE 0 END) AS change_in_count_2020_to_2021,
    SUM(CASE WHEN work_year = 2022 THEN 1 ELSE 0 END) - SUM(CASE WHEN work_year = 2021 THEN 1 ELSE 0 END) AS change_in_count_2021_to_2022
    FROM 
    job_data
GROUP BY 
    job_title
ORDER BY 
    change_in_count_2021_to_2022 DESC;
#employee residennce and salary range
SELECT 
    job_title,
    employee_residence,
    MIN(salary_in_usd) AS min_salary,
    MAX(salary_in_usd) AS max_salary,
    AVG(salary_in_usd) AS avg_salary
FROM 
    job_data
GROUP BY 
    job_title, employee_residence
ORDER BY 
    job_title, employee_residence;

#company size and avg salary
SELECT 
    company_size,
    AVG(salary) AS avg_salary
FROM 
    job_data
WHERE 
    job_title IS NOT NULL
    AND salary IS NOT NULL
    AND company_size IS NOT NULL
GROUP BY 
    company_size
ORDER BY 
    company_size;

#worksetting and job count
SELECT 
    work_setting,
    COUNT(*) AS job_count
FROM 
    job_data
GROUP BY 
    work_setting
ORDER BY 
    job_count DESC;

#experince level
SELECT 
    experience_level,
    COUNT(*) AS job_count,
    AVG(salary_in_usd) AS avg_salary,
    MIN(salary_in_usd) AS min_salary,
    MAX(salary_in_usd) AS max_salary
FROM 
    job_data
GROUP BY 
    experience_level
ORDER BY 
    job_count DESC;
#employee_residence
SELECT 
    employee_residence,
    COUNT(*) AS job_count
FROM 
    job_data
WHERE 
    employee_residence IS NOT NULL
GROUP BY 
    employee_residence
ORDER BY 
    job_count DESC;
