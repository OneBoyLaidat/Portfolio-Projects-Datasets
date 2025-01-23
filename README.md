# Introduction
Embark on an epic journey through the realm of data jobs! This project zooms in on the intriguing world of data analysts, uncovering the highest-paying roles, the hottest skills, and the ultimate intersections of high demand and high salaries. 📊💸

Check out the SQL queries used for the analysis here: [sql queries](/project_sql/).


# Background
Fueled by a passion to decode the data analyst job market, this project was born. I aimed to pinpoint top-paid and in-demand skills, making it a breeze for me to navigate the career quest of becoming a Data Analyst.

The treasure trove of data comes from an SQL Course by Luke Barousse, packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
To tackle this quest, I wielded a mighty arsenal:

- **SQL**: The backbone of the analysis, perfect for unearthing critical insights.

- **PostgreSQL**: The trusty database management system.

- **Visual Studio Code**: An exciting tool for database management and executing SQL queries.

- **Git & GitHub**: Ensuring the SQL scripts and analyses are shared and tracked for easy collaboration.

# The Analysis
 I wrote multiple queries each aiming to understand specific mysteries of the data analyst job market and answer questions I had. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs 
To pinpoint the highest-paying roles, I filtered data analyst positions by average yearly salary and location, specifically targeting remote jobs and jobs in Nigeria. This query showcases the lucrative opportunities in the field.

``` sql
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
    (job_location = 'Anywhere' OR  
    job_location LIKE '%Nigeria')
ORDER BY 
    salary DESC
LIMIT 
    10;
```

Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top Paying Jobs
To determine which skills are essential for the highest-paying jobs, I joined the job postings with the skills data, revealing what employers prioritize for high-compensation roles.

``` sql
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
```
Here's the breakdown of the most demanded skills for the top 10 highest-paying data analyst jobs in 2023:

- **SQL** leads with a count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is also highly sought after, with a count of 6.
- Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts
This query pinpointed the skills most frequently requested in job postings, highlighting areas with high demand.

``` sql
SELECT
    skills_dim.skills AS skills,
    COUNT(skills_dim.skills) AS demand_count

FROM 
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT
    5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023:

- **SQL** and **Excel** remain fundamental, highlighting the necessity of strong foundational skills in data processing and spreadsheet manipulation.

- **Programming** and **visualization tools** like **Python**, **Tableau**, and **Power BI** are essential, underscoring the growing importance of technical skills in data storytelling and decision support.


| Skills | Demand Count|
|--------|-------------|
|SQL     |7291         |
|Excel   |4611         |
|Python  |4330         |
|Tableau |3745         |
|Power BI| 2609        |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed the highest-paying ones.

``` sql
SELECT
    skills_dim.skills AS skills,
    COUNT(skills_dim.skills) AS demand_count,
    ROUND(
        AVG(salary_year_avg),
        0
    ) AS avg_salary

FROM 
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'Yes'
GROUP BY
    skills
HAVING
    COUNT(skills_dim.skills) > 10
ORDER BY
    avg_salary DESC
LIMIT
    25;
```
Here's a breakdown of the results for top-paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills**: Analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy) command top salaries, showcasing the high valuation of data processing and predictive modeling capabilities in the industry.
- **Software Development & Deployment Proficiency**: Proficiency in development and deployment tools (GitLab, Kubernetes, Airflow) signifies a lucrative crossover between data analysis and engineering, highlighting the premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise**: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skill        | Average Salary ($) |
|--------------|--------------------|
| PySpark      | 208,172            |
| Bitbucket    | 189,155            |
| Couchbase    | 160,515            |
| Watson       | 160,515            |
| DataRobot    | 155,486            |
| GitLab       | 154,500            |
| Swift        | 153,750            |
| Jupyter      | 152,777            |
| Pandas       | 151,821            |
| Elasticsearch| 145,000            |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn

By combining insights from demand and salary data, this query aimed to identify skills that are both highly demanded and well-compensated, providing a strategic focus for skill development.

``` sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

| Skill ID | Skills      | Demand Count | Average Salary ($) |
|----------|-------------|---------------|---------------------|
| 8        | go          | 27            | 115,320             |
| 234      | confluence  | 11            | 114,210             |
| 97       | hadoop      | 22            | 113,193             |
| 80       | snowflake   | 37            | 112,948             |
| 74       | azure       | 34            | 111,225             |
| 77       | bigquery    | 13            | 109,654             |
| 76       | aws         | 32            | 108,317             |
| 4        | java        | 17            | 106,906             |
| 194      | ssis        | 12            | 106,683             |
| 233      | jira        | 20            | 104,918             |

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages**: Python and R stand out with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies**: Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools**: Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies**: The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I Learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **Complex Query Crafting**: Mastered advanced SQL, merging tables like a pro and wielding `WITH` clauses for ninja-level temp table maneuvers.
- **Data Aggregation**: Got cozy with `GROUP BY` and turned aggregate functions like `COUNT()` and `AVG()` into my data-summarizing sidekicks.
- **Analytical Wizardry**: Leveled up my real-world puzzle-solving skills, transforming questions into actionable, insightful SQL queries.
- **Version Control & Collaboration**: Got to use and understand Git and GitHub for efficient version control and seamless collaboration.

# Conclusion

### Insights
From the analysis I discovered some insights into the data analyst job market.

- **Top-Paying Jobs:** Data analysts can earn anywhere from $184,000 to $650,000, working for diverse employers like SmartAsset, Meta, and AT&T.

- **Skills for Top-Paying Jobs:** Mastery of SQL, Python, and Tableau are highly valued, with SQL leading the pack.

- **In-Demand Skills:** SQL, Excel, Python, Tableau, and Power BI are essential, highlighting the need for strong technical skills.

- **Skills Based on Salary:** Big data and machine learning skills (like PySpark and DataRobot) command top salaries, reflecting their high value.

- **Most Optimal Skills to Learn:** Cloud tools, business intelligence, and database technologies (Snowflake, Azure, AWS, Tableau, etc.) are both high in demand and high-paying.

### Closing Thoughts

This project not only enhanced my SQL skills but also provided invaluable insights into the data analyst job market. Aspiring data analysts can prioritize high-demand, high-salary skills to better position themselves in a competitive landscape. This analysis also underscores the critical need for continuous learning and adaptation to emerging trends in the field of data analytics.