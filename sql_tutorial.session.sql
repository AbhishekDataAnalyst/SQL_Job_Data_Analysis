CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);


/* insert data into job_applied table */
INSERT INTO job_applied (job_id, application_sent_date, custom_resume, resume_file_name, 
cover_letter_sent, cover_letter_file_name, status)
VALUES (1, '2023-01-01', TRUE, 'resume1.pdf', TRUE, 'cover_letter1.pdf', 'applied'),
        (2, '2023-01-02', FALSE, 'resume2.pdf', FALSE, NULL, 'rejected');

-- View all entries
SELECT * FROM job_applied;

-- Alter table by adding contact_info column
ALTER TABLE job_applied
ADD contact_info VARCHAR(255);

-- add values to contact_info column
UPDATE job_applied
SET contact_info = 'Abhishek'
WHERE job_id = 1; 

UPDATE job_applied
SET contact_info = 'Akhilesh'
WHERE job_id = 2; 

-- rename contact_info columns to contact_name
ALTER TABLE job_applied
RENAME COLUMN contact_info TO contact_name;

-- delete job_applied table
DROP TABLE job_applied;
DROP DATABASE sql_course;


---------------------------------------
-- DATE/TIME FUNCTIONS
---------------------------------------

-- change job_posted_date to date type
SELECT job_title_short AS title, job_location AS location, job_posted_date::DATE AS posted_date 
FROM job_postings_fact;

-- time zone conversion
SELECT job_title_short AS title, job_location AS location, 
    job_posted_date AT TIME ZONE 'UTC' AS posted_date_utc
FROM job_postings_fact;


-- extract year, month, day from job_posted_date
SELECT job_title_short AS title, job_location AS location,
    EXTRACT(YEAR FROM job_posted_date) AS year,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    EXTRACT(DAY FROM job_posted_date) AS day
FROM job_postings_fact;

-- extract hour, minute, second from job_posted_date
SELECT job_title_short AS title, job_location AS location,
    EXTRACT(HOUR FROM job_posted_date) AS hour,
    EXTRACT(MINUTE FROM job_posted_date) AS minute,
    EXTRACT(SECOND FROM job_posted_date) AS second
FROM job_postings_fact;

-- extract name of the month
SELECT job_title_short AS title, job_location AS location,
    TO_CHAR(job_posted_date, 'Month') AS month_name
FROM job_postings_fact;

-- extract day of the week
SELECT job_title_short AS title, job_location AS location,
    TO_CHAR(job_posted_date, 'Day') AS day_name
FROM job_postings_fact; 

-- no of job post per month
SELECT TO_CHAR(job_posted_date, 'Month') AS month,
       COUNT(*) AS job_count
FROM job_postings_fact
GROUP BY month
ORDER BY job_count DESC;


------------------------------
-- PRACTICE -----
------------------------------

-- 1.CREATE 3 TABLES OF JAN, FEB, MAR 2023 JOBS
CREATE TABLE JAN_2023_JOBS AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(YEAR FROM JOB_POSTED_DATE) = 2023
AND EXTRACT(MONTH FROM JOB_POSTED_DATE) = 1;

CREATE TABLE FEB_2023_JOBS AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(YEAR FROM JOB_POSTED_DATE) = 2023
AND EXTRACT(MONTH FROM JOB_POSTED_DATE) = 2;

CREATE TABLE MAR_2023_JOBS AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(YEAR FROM JOB_POSTED_DATE) = 2023
AND EXTRACT(MONTH FROM JOB_POSTED_DATE) = 3;



----------------------------
-- CASE STATEMENTS
----------------------------

/* label new column 'job_location_category' based on job_location
    - 'Anywhere' for 'Remote'
    - 'New York' for 'Local_jobs'
    - 'Onsite' for any other location */

SELECT job_title_short AS title, job_location AS location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'local_jobs'
        WHEN job_location NOT IN ('Anywhere','New York, NY') THEN 'Onsite'
        END AS job_location_category
FROM job_postings_fact;

-- count the no.of job types based on job_location_category
SELECT COUNT(*) AS job_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'local_jobs'
        WHEN job_location NOT IN ('Anywhere','New York, NY') THEN 'Onsite'
        END AS job_location_category
FROM job_postings_fact
GROUP BY job_location_category ORDER BY job_count DESC; 

-------------------------
-- SUBQUERIES AND CTEs
-------------------------

-- Jan 2023 JOBS (CTE)
WITH JAN_2023_JOBS AS (
    SELECT * FROM JOB_POSTINGS_FACT
    WHERE EXTRACT(MONTH FROM JOB_POSTED_DATE) = 1
    AND EXTRACT(YEAR FROM JOB_POSTED_DATE) = 2023
)
SELECT job_title_short AS title, job_location AS location, job_posted_date AS posted_date
FROM JAN_2023_JOBS;

-- USING SUBQUERY
SELECT job_title_short AS title, job_location AS location, job_posted_date AS posted_date
FROM (
    SELECT job_title_short, job_location, job_posted_date
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    AND EXTRACT(YEAR FROM job_posted_date) = 2023
) AS JAN_2023_JOBS;


----------------------
-- PRACTICE QUESTIONS
----------------------

/* find the count of number of remote jobs postings per skill
    - display the top 5 skills by their demand in remote jobs
    - include skill ID, name, and count of postings requiring the skill 
    - using cte and subquery */

WITH REMOTE_SKILLS AS (
    SELECT SJD.SKILL_ID, COUNT(*) AS SKILL_COUNT 
    FROM SKILLS_JOB_DIM SJD
    JOIN JOB_POSTINGS_FACT JPF USING(JOB_ID)
    WHERE JPF.JOB_WORK_FROM_HOME = TRUE
    GROUP BY SJD.SKILL_ID
)
SELECT SKILL_ID, SD.SKILLS AS SKILL, SKILL_COUNT
FROM REMOTE_SKILLS
JOIN SKILLS_DIM SD USING(SKILL_ID)
ORDER BY SKILL_COUNT DESC LIMIT 5;


-----------------------------
--- UNION --------
-----------------------------

-- union job_id, job_title_short of 3 tables JAN_2023_JOBS, FEB_2023_JOBS, MAR_2023_JOBS
SELECT job_id, job_title_short FROM JAN_2023_JOBS
UNION
SELECT job_id, job_title_short FROM FEB_2023_JOBS
UNION
SELECT job_id, job_title_short FROM MAR_2023_JOBS;

-- union all 
SELECT job_id, job_title_short FROM JAN_2023_JOBS
UNION ALL
SELECT job_id, job_title_short FROM FEB_2023_JOBS
UNION ALL
SELECT job_id, job_title_short FROM MAR_2023_JOBS;



-----------------------
--- practice problem ---
-----------------------

-- find job postings from the first quarter that have a higher salary than $70k
SELECT JOB_ID, JOB_TITLE_SHORT, JOB_LOCATION, SALARY_YEAR_AVG AS SALARY
FROM (
    SELECT * FROM JAN_2023_JOBS
    UNION ALL
    SELECT * FROM FEB_2023_JOBS
    UNION ALL
    SELECT * FROM MAR_2023_JOBS
) AS Q1_JOBS
WHERE SALARY_YEAR_AVG > 70000
ORDER BY SALARY DESC;