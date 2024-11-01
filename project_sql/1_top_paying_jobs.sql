/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely or in Texas.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying internship opportunities for data analysts available either remotely or in Texas.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title LIKE ANY (ARRAY['%Intern', '%Internship', '%Entry%', '%Junior%'])
        AND (job_work_from_home = TRUE OR job_location LIKE '%TX') 
        AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10