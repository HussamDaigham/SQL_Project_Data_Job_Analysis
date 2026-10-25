/*
Question: What are the top-paying data analyst jobs, and what skills are required?
- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS( -- query used previously to determine the top 10 Data Analyst jobs (with some modifications)
    SELECT
        job_id,
        job_title,
        companies.name AS compnay_name,
        salary_year_avg
    FROM
        job_postings_fact AS jobs
    LEFT JOIN company_dim AS companies ON jobs.company_id = companies.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*, -- grabs all the columns from the top_paying_jobs table in addition to anything we specifiy afterwards (if any)
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
/*
INNER JOIN will omit jobs that have no skills listed. LEFT JOIN will include them.
In this case, 2 job results will be omitted.
We will use INNER JOIN anyway because we're evaluating the skills required for top jobs.
*/
ORDER BY
    salary_year_avg DESC;

/*
Key findings
- SQL dominates: It appears in every posting, making it the strongest technical requirement in this sample.
- Python is nearly universal: Seven of eight postings require it, suggesting programming is especially valuable for these higher-paying analytical positions.
- Tableau leads visualization: It appears in six postings, versus two for Power BI.
- Excel is less prominent: It appears in three postings. That doesn't mean Excel is unimportant; these are unusually high-paying, often senior positions where some foundational skills may be assumed.
*/