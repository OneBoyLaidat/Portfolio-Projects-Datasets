/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/


WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg AS salary,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        salary_year_avg IS NOT NULL AND 
        job_title_short = 'Data Analyst' AND 
        (job_location = 'Anywhere' OR  job_location LIKE '%Nigeria')
    ORDER BY 
        salary DESC
    LIMIT 
        10
),

top_paying_jobs_skills AS (
SELECT
    top_paying_jobs.job_id,
    top_paying_jobs.job_title,
    top_paying_jobs.salary,
    top_paying_jobs.company_name,
    skills_dim.skills AS skills
FROM 
    top_paying_jobs
INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
)

SELECT
    skills,
    COUNT(skills) AS skill_count
FROM
    top_paying_jobs_skills
GROUP BY
    skills
ORDER BY
    skill_count DESC;