SELECT
    job_id,
    job_title,
    job_location AS location,
    job_schedule_type,
    salary_year_avg AS salary,
    job_posted_date,
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
    10;