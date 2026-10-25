/*
Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

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

/*
This query returns the same results as 5.1_optimal_skills.sql without the use of CTEs.

Benefits of writing the query this way include:
1. Less repetitive code.
2. Potentially better performance.
3. Easier to maintain.
4. Appropriate use of HAVING.

Drawbacks include:
1. Can become harder to read as the analysis grows.
2. Less separation between analytical steps.
3. Not suitable for every analytical problem.

*/