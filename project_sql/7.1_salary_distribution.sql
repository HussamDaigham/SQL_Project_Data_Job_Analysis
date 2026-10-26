/*
Question: How do salary distributions differ between remote and on-site Data Analyst positions?
- Compares annual salary distributions for remote and on-site Data Analyst job postings.
- Examines average, median, and salary ranges to identify differences in compensation between work arrangements.
- Why? It helps job seekers evaluate how remote and on-site opportunities compare financially, allowing them to make more informed decisions about job preferences and salary expectations.
*/

SELECT
    CASE
        WHEN job_work_from_home = TRUE THEN 'remote'
        ELSE 'non-remote'
    END AS work_arrangement,
    COUNT(job_id) AS job_count,
    ROUND(MIN(salary_year_avg),0) AS min_salary,
    ROUND(MAX(salary_year_avg),0) AS max_salary,
    ROUND(AVG(salary_year_avg),0) AS average_salary,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP(
        ORDER BY salary_year_avg)::NUMERIC,0) AS salary_25th,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP(
        ORDER BY salary_year_avg)::NUMERIC,0) AS median_salary,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP(
        ORDER BY salary_year_avg)::NUMERIC,0) AS salary_75th   
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    work_arrangement;