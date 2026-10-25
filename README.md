# Introduction
Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on data analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

Check out my SQL queries here: [project_sql folder](/project_sql/)

# Background
The motivation behind this project stemmed from my desire to understand the data analyst job market better. I aimed to discover which skills are paid the most and in demand, making my job search more targeted and effective. 

The data for this analysis is from Luke Barousse’s SQL Course:

https://www.youtube.com/watch?v=7mz73uXD9DA

 This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

# Tools I Used
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    companies.name AS compnay_name,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact AS jobs
LEFT JOIN company_dim AS companies ON jobs.company_id = companies.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Anywhere' OR job_work_from_home = TRUE) AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
![Top Paying Jobs](assets/1_Highest-paying%20jobs.png)

**Bar graph visualizing the salary for the top 10 Data Analyst remote jobs; Mantys’s $650,000 posting is a clear outlier, at roughly 1.9 times the next-highest salary. The median salary across these 10 postings is $211,000.**

### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        companies.name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact AS jobs
    LEFT JOIN company_dim AS companies ON jobs.company_id = companies.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        (job_location = 'Anywhere' OR job_work_from_home = TRUE) AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
![Skills for the highest paying jobs](assets/2_Skill%20frequency%20among%20high-paying%20jobs.png)

**Bar graph visualizing the top skills needed for the highest paying Data Analyst jobs; SQL appears in every posting, often alongside Python and Tableau, suggesting a common combination of querying, programming, and visualization.**
### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills.skills,
    COUNT(jobs.job_id) AS demand_count
FROM
    job_postings_fact AS jobs
LEFT JOIN skills_job_dim ON jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Anywhere' OR job_work_from_home = TRUE)
GROUP BY
    skills.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
![Top demanded skills for data analysts](assets/3_Most-demanded%20data%20analyst%20skills.png)

**Column graph visualizing the top demanded skills for data analyst jobs; SQL is the most-demanded skill, appearing in 7,291 postings—about 58% more than Excel. Excel and Python have similar demand, while Tableau leads Power BI among visualization tools. Together, these results highlight the importance of querying data, performing analysis, and communicating insights.**

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills.skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary,
    COUNT(jobs.job_id) AS postings_count
FROM
    job_postings_fact AS jobs
LEFT JOIN skills_job_dim ON jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills.skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
![Highest average salaries by skill](assets/4_Highest%20average%20salaries%20by%20skill.png)

**Combo chart showing the highest salaries based on skills and the number of job postings per skill; SVN’s $400,000 average comes from just one posting, making it a clear outlier and an unreliable indicator of typical pay. Airflow, Scala, and Kafka have lower averages of roughly $116,000–$130,000 but are supported by 40–71 postings each, providing a stronger basis for assessing salary patterns.**

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

#### A. Using CTEs
```sql
WITH top_demanded_skills AS(
    SELECT
    skills.skill_id,
    skills.skills,
    COUNT(jobs.job_id) AS demand_count
FROM
    job_postings_fact AS jobs
LEFT JOIN skills_job_dim ON jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    (job_location = 'Anywhere' OR job_work_from_home = TRUE)
GROUP BY
    skills.skill_id,
    skills.skills
),

top_paying_skills AS(
    SELECT
    skills.skill_id,
    skills.skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact AS jobs
LEFT JOIN skills_job_dim ON jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    (job_location = 'Anywhere' OR job_work_from_home = TRUE)
GROUP BY
    skills.skill_id,
    skills.skills
)

SELECT
    top_demanded_skills.skill_id,
    top_demanded_skills.skills,
    demand_count,
    avg_salary
FROM
    top_demanded_skills
INNER JOIN top_paying_skills ON top_demanded_skills.skill_id = top_paying_skills.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
B. Without Using CTEs:
```sql
SELECT
    skills.skill_id,
    skills.skills,
    COUNT(jobs.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact AS jobs
INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jobs.job_id
INNER JOIN skills_dim AS skills ON skills.skill_id = sjd.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    (job_location = 'Anywhere' OR job_work_from_home = TRUE)
GROUP BY
    skills.skill_id,
    skills.skills
HAVING
    COUNT(jobs.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
![Optimal Skills](assets/5_Skill%20demand%20versus%20average%20salary.png)
**Scatter plot showing the skill demand vs average salary for Data Analyst jobs; Python and Tableau stand out for demand, with 236 and 230 postings and average salaries of $101,397 and $99,288, respectively. Go offers the highest average salary but only 27 postings, while Snowflake and Azure also offer higher salaries with considerably fewer opportunities than Python or Tableau. This highlights a tradeoff between salary and demand**


Each query not only served to answer a specific question but also to improve my understanding of SQL and database analysis. Through this project, I learned to leverage SQL's powerful data manipulation capabilities to derive meaningful insights from complex datasets.

# What I Learned
Throughout this project, I strengthened my SQL skills and gained practical experience in several key areas:

- **Table Joins and Relationships:** Strengthened my understanding of relational databases by using `INNER JOIN` and `LEFT JOIN` to combine data across multiple tables.
- **Data Filtering and Sorting:** Applied `WHERE`, `HAVING`, and `ORDER BY` clauses to filter datasets, refine query results, and identify meaningful trends.
- **Data Aggregation:** Utilized `GROUP BY` and aggregate functions such as `COUNT()` and `AVG()` to summarize data and uncover valuable insights.
- **Complex Query Construction:** Built advanced SQL queries using Common Table Expressions (CTEs) with `WITH` clauses to organize complex logic into smaller, more manageable components.
- **Query Optimization:** Explored ways to improve query efficiency and readability by reducing redundant code and comparing different approaches to achieving the same results.
- **Analytical Thinking:** Developed my ability to translate real-world business questions into SQL queries, analyze the results, and draw actionable insights from the data.
# Conclusions
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.