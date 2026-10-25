/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.
*/

SELECT
    skills.skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
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


/*
Four major trends in higher-paying positions:

Trend 1: Machine learning and AI skills appear frequently
DataRobot ($155,486), MXNet ($149,000), Keras ($127,013), PyTorch ($125,226), Hugging Face ($123,950), TensorFlow ($120,647).
Six of the top 25 skills relate directly to machine learning or AI. This suggests a strong association between specialized modeling skills and higher-paying technical positions.

Trend 2: Data engineering skills feature prominently
Couchbase ($160,515), Kafka ($129,999), Cassandra ($118,407), Airflow ($116,387).
Skills that support large-scale data storage, streaming, and workflow orchestration appear near the top. These are commonly associated with engineering-heavy data roles.

Trend 3: Infrastructure and automation skills are valuable
VMware ($147,500), Terraform ($146,734), GitLab ($134,126), Puppet ($129,820), Ansible ($124,370).
Employers advertising these skills may be seeking analysts who can work in production-oriented technical environments, or hybrid analyst-engineer roles.

Trend 4: Specialized programming skills stand out
Solidity ($179,000), Golang ($155,000), dplyr ($147,633), Perl ($124,686), Scala ($115,480).
Specialized programming skills appear alongside the more typical analyst technology stack. However, Solidity and Golang are more closely connected to software engineering than conventional business analytics.
*/