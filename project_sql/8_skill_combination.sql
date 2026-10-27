/*
Question: Are Data Analyst jobs requiring both SQL and Python associated with higher salaries than jobs requiring SQL without python?
- Compares annual salaries for Data Analyst job postings requiring both SQL and Python against those requiring SQL without Python.
- Analyzes average and median salaries to identify potential salary differences between the two skill combinations.
- Examines job posting counts to compare the demand for each skill combination among postings with reported annual salaries.
- Why? It helps aspiring Data Analysts understand whether learning Python alongside SQL is associated with higher compensation, allowing them to make more informed decisions about which technical skills to develop.
*/

WITH sql_no_python AS(
    SELECT
        jobs.job_id,
        jobs.salary_year_avg
    FROM
        job_postings_fact AS jobs
    WHERE
        salary_year_avg IS NOT NULL AND
        job_title_short = 'Data Analyst' AND
        EXISTS(
            SELECT *
            FROM skills_job_dim AS sjd
            INNER JOIN skills_dim AS skills ON sjd.skill_id = skills.skill_id
            WHERE sjd.job_id = jobs.job_id
            AND skills.skills = 'sql'
        ) AND
        NOT EXISTS(
            SELECT *
            FROM skills_job_dim AS sjd
            INNER JOIN skills_dim AS skills2 ON sjd.skill_id = skills2.skill_id
            WHERE sjd.job_id = jobs.job_id AND
            skills2.skills = 'python'
        )
),

sql_and_python AS(
    SELECT
        jobs.job_id,
        jobs.salary_year_avg
    FROM
        job_postings_fact AS jobs
        WHERE
        salary_year_avg IS NOT NULL AND
        job_title_short = 'Data Analyst' AND
        EXISTS(
            SELECT *
            FROM skills_job_dim as sjd
            INNER JOIN skills_dim AS skills2 ON sjd.skill_id = skills2.skill_id
            WHERE sjd.job_id = jobs.job_id AND
            skills2.skills = 'sql'
        ) AND
        EXISTS(
            SELECT *
            FROM skills_job_dim AS sjd
            INNER JOIN skills_dim AS skills ON sjd.skill_id = skills.skill_id
            WHERE sjd.job_id = jobs.job_id AND
            skills.skills = 'python'
        )
)

SELECT
    skill_combo,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg),0) AS average_salary,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP(
        ORDER BY salary_year_avg)) AS median_salary,
    ROUND(MIN(salary_year_avg),0) AS min_salary,
    ROUND(MAX(salary_year_avg),0) AS max_salary
FROM(
    SELECT
        'sql without python' AS skill_combo,
        salary_year_avg
    FROM
        sql_no_python

    UNION ALL

    SELECT
        'sql with python' AS skill_combo,
        salary_year_avg
    FROM
        sql_and_python
) AS combined_jobs
GROUP BY
    skill_combo;
