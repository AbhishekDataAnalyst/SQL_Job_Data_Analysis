-- 2. What skills are required for top paying data analyst jobs?

WITH top_paying_jobs AS (
    SELECT j.job_id, j.job_title, j.job_title_short, c.name AS company, j.job_location, j.job_country, 
            ROUND(j.salary_year_avg,0) AS salary
    FROM job_postings_fact j
    LEFT JOIN company_dim c USING(company_id)
    WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    ORDER BY salary DESC 
    LIMIT 10
)
SELECT t.*,s.skill_id,s.skills,COUNT(*) AS count FROM top_paying_jobs t
INNER JOIN skills_job_dim sj USING(job_id)
INNER JOIN skills_dim s ON sj.skill_id=s.skill_id;