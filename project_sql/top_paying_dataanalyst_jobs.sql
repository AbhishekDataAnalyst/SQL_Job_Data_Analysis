-- 1. What are the top paying data analyst jobs?

SELECT j.job_title, c.name AS company, j.job_via AS platform, j.job_location, j.job_country, 
        ROUND(j.salary_year_avg,0) AS salary
FROM job_postings_fact j
LEFT JOIN company_dim c USING(company_id)
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY salary DESC LIMIT 10;