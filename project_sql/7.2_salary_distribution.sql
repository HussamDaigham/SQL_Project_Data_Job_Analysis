/*
This query will grab the salary for all remote and non-remote jobs for Data Analyst role that have a salary listed.
This will be used to create the box and whiskers graph in excel
*/

SELECT
    CASE
        WHEN job_work_from_home = TRUE THEN 'remote'
        ELSE 'non-remote'
    END AS work_arrangement,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL;
