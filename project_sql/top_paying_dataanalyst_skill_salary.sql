-- 4. What is the top paying data analyst skills based on salary?

SELECT s.skills AS skill, ROUND(AVG(j.salary_year_avg),0) AS salary FROM skills_job_dim sj
INNER JOIN job_postings_fact j USING(job_id)
INNER JOIN skills_dim s USING(skill_id)
WHERE J.job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY skill
ORDER BY salary DESC;