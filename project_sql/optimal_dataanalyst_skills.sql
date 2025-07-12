-- 5. What is the most optimal skills for data analyst? (High paying and high demanding)

-- Hint:- Combine 3. and 4. code 

WITH skill_demand AS(
    SELECT s.skill_id AS skill_id, s.skills AS skill, COUNT(*) AS count FROM skills_job_dim sj
    INNER JOIN job_postings_fact j USING(job_id)
    INNER JOIN skills_dim s USING(skill_id)
    WHERE J.job_title_short = 'Data Analyst'
    GROUP BY s.skill_id,skill
), skill_salary AS (
    SELECT s.skill_id AS skill_id, s.skills AS skill, ROUND(AVG(j.salary_year_avg),0) AS avg_salary FROM skills_job_dim sj
    INNER JOIN job_postings_fact j USING(job_id)
    INNER JOIN skills_dim s USING(skill_id)
    WHERE J.job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY s.skill_id,skill
)
SELECT sd.skill, sd.count, ss.avg_salary
FROM skill_demand sd
JOIN skill_salary ss ON sd.skill_id = ss.skill_id
ORDER BY sd.count DESC, ss.avg_salary DESC
LIMIT 10;