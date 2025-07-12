# 🚀 Exploring the Data Analyst Job Market

## 📌 What This Project Is About
This project dives into the world of data analyst jobs—looking at which roles pay the most, what skills are in high demand, and which ones are worth learning to boost your career.

**Link for SQL queries :-** [project_sql folder](/project_sql/)

## 🧰 My Goals
I wanted to answer these key questions using SQL:

1. What are the top paying data analyst jobs?

2. What skills are required for top paying data analyst jobs?

3. What is the most in-demand skill for data analyst?

4. What is the top paying data analyst skills based on salary?

5. What is the most optimal skills for data analyst? (High paying and high demanding)

## 🛠 Tools I Used
- **SQL:** My main tool for pulling insights from the data.

- **PostgreSQL:** The database I worked with.

- **Visual Studio Code:** My coding environment.

- **Git & GitHub:** For version control and sharing my work.

## 🧠 Results

### 1. What are the top paying data analyst jobs?

![top 10 paying data analyst jobs](Visualizations\#1.png)

*Source:- ChatGPT generated image*

I filtered job listings by salary, focusing on remote positions. Here's what I found:

- Top salaries ranged from $184,000 to $650,000.
- Big companies like Meta and AT&T are hiring.
- Titles vary—from standard Data Analysts to Directors.

Code:-
```SQL
SELECT j.job_title, c.name AS company, j.job_via AS platform, j.job_location, j.job_country, ROUND(j.salary_year_avg,0) AS salary
FROM job_postings_fact j
LEFT JOIN company_dim c USING(company_id)
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY salary DESC LIMIT 10;
```

### 2. What skills are required for top paying data analyst jobs?

![top 10 data analyst skills](Visualizations\#2.png)

*Source:- ChatGPT generated image*

I checked which skills show up most often in remote data analyst job posts:


I matched those top-paying jobs with their listed skills. Here's the top 3:

- SQL (8 out of 10 jobs)
- Python (7 out of 10)
- Tableau (6 out of 10)

Code:-
```SQL
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
```

### 3. What is the most in-demand skill for data analyst?

![top in-demand data analyst skills](Visualizations\#3.png)

*Source:- ChatGPT generated image*

| Skill     | Demand Count |
|-----------|---------------|
| SQL       | 92,628        |
| Excel     | 67,031        |
| Python    | 57,326        |
| Tableau   | 46,554        |
| Power BI  | 39,468        |

I checked which skills show up most often in remote data analyst job posts:
- SQL (92,628 mentions)
- Excel (67,031)
- Python, Tableau, and Power BI also top the list.

Code:-
```SQL
SELECT s.skills AS skill, COUNT(*) AS count FROM skills_job_dim sj
INNER JOIN job_postings_fact j USING(job_id)
INNER JOIN skills_dim s USING(skill_id)
WHERE J.job_title_short = 'Data Analyst'
GROUP BY skill
ORDER BY count DESC LIMIT 5;
```

### 4. What is the top paying data analyst skills based on salary?
| Skill       | Average Salary (USD) |
|-------------|----------------------|
| SVN         | $400,000             |
| Solidity    | $179,000             |
| Couchbase   | $160,515             |
| DataRobot   | $155,486             |
| Golang      | $155,000             |
| MXNet       | $149,000             |
| dplyr       | $147,633             |
| VMware      | $147,500             |
| Terraform   | $146,734             |
| Twilio      | $138,500             |

Some less common skills bring in big bucks:

- SVN: $400K avg
- Solidity, Couchbase, DataRobot: Over $150K

Code:-
```SQL
SELECT s.skills AS skill, ROUND(AVG(j.salary_year_avg),0) AS salary FROM skills_job_dim sj
INNER JOIN job_postings_fact j USING(job_id)
INNER JOIN skills_dim s USING(skill_id)
WHERE J.job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY skill
ORDER BY salary DESC;
```
### 5. What is the most optimal skills for data analyst? (High paying and high demanding)

![optimal skills for data analyst](Visualizations\#5.png)

*Source:- ChatGPT generated image*
| Skill      | Demand Count | Average Salary (USD) |
|------------|---------------|----------------------|
| SQL        | 92,628        | $96,435              |
| Excel      | 67,031        | $86,419              |
| Python     | 57,326        | $101,512             |
| Tableau    | 46,554        | $97,978              |
| Power BI   | 39,468        | $92,324              |
| R          | 30,075        | $98,708              |
| SAS        | 14,034        | $93,707              |
| PowerPoint | 13,848        | $88,316              |
| Word       | 13,591        | $82,941              |

Data analyst skills that are both in demand and well-paid:

- SQL, Python, R, Excel, Tableau, Power BI

Code:-
```SQL
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
```


# 🧠 What I Learned
- Got better at writing advanced SQL queries using WITH, JOIN, and aggregations.
- Learned how to dig into data and tell a story with numbers.
- Practiced solving real job market questions with data.

# 🔍 Key Takeaways
- Remote data analyst jobs can pay up to $650K!
- SQL is the most important skill—both in demand and pay.
- Learning niche tools like PySpark/Snowflake/AWS/Azure can boost your salary.
- Focus on skills that are both common and highly paid for best results.

# ✨ Final Thoughts
This project sharpened my SQL skills and gave me a clear picture of the data job market. 

# References

1. [SQL for Data Analytics - Learn SQL in 4 Hours by Luke Barousse (Youtube Tutorial)](https://www.youtube.com/watch?v=7mz73uXD9DA&t=14270s)

2. [Luke Barousse SQL Project website](https://www.lukebarousse.com/sql)