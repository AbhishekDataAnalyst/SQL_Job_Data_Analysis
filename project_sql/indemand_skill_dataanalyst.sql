-- 3. What is the most in-demand skill for data analyst?

SELECT s.skills AS skill, COUNT(*) AS count FROM skills_job_dim sj
INNER JOIN job_postings_fact j USING(job_id)
INNER JOIN skills_dim s USING(skill_id)
WHERE J.job_title_short = 'Data Analyst'
GROUP BY skill
ORDER BY count DESC LIMIT 5;