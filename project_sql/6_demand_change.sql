/*
Question: How did demand for the top demanded data analyst skills change across the four quarters of 2023?
- Tracks the number of Data Analyst job postings requiring these skills for each quarter of 2023.
- Compares quarterly demand to identify trends in skill popularity and changes in employer requirements.
- Why? It helps job seekers understand how demand for key technical skills evolves over time, allowing them to prioritize skills that remain consistently valuable or are growing in demand.
*/

WITH top_demanded_skills AS(
    SELECT
        skills.skills
    FROM
        job_postings_fact AS jobs
    INNER JOIN skills_job_dim ON jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
    GROUP BY
        skills.skills
    ORDER BY
        COUNT(jobs.job_id) DESC
    LIMIT 5
),

quarterly_job_totals AS(
    SELECT
        CONCAT('Q',EXTRACT(QUARTER FROM job_posted_date)) AS quarter,
        COUNT(job_id) AS total_postings
    FROM
        job_postings_fact
    WHERE
        job_title_short = 'Data Analyst'
    GROUP BY
        quarter
),

quarterly_skill_demand AS (
    SELECT
        CONCAT('Q', EXTRACT(QUARTER FROM jobs.job_posted_date)) AS quarter_posted,
        skills.skills,
        COUNT(DISTINCT jobs.job_id) AS postings_count,
        ROUND(COUNT(DISTINCT jobs.job_id) * 100.0 / qjt.total_postings,2) AS demand_percentage
    FROM
        job_postings_fact AS jobs
    INNER JOIN skills_job_dim
        ON jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim AS skills
        ON skills.skill_id = skills_job_dim.skill_id
    INNER JOIN quarterly_job_totals AS qjt ON CONCAT('Q', EXTRACT(QUARTER FROM jobs.job_posted_date)) = qjt.quarter
    WHERE
        jobs.job_title_short = 'Data Analyst' AND
        skills.skills IN (
            SELECT
                skills
            FROM
                top_demanded_skills)
    GROUP BY
        quarter_posted,
        skills.skills,
        qjt.total_postings
)

SELECT
    quarter_posted,
    skills,
    postings_count,
    demand_percentage,
    LAG(demand_percentage) OVER (
        PARTITION BY skills
        ORDER BY quarter_posted
    ) AS previous_quarter_demand,
    demand_percentage - LAG(demand_percentage) OVER(
        PARTITION BY skills
        ORDER BY quarter_posted
    ) AS demand_change_pp
FROM
    quarterly_skill_demand
ORDER BY
    quarter_posted,
    skills;