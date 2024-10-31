/*
Question: What skills are required for the top-paying data analyst internships?
- Use the top 10 highest-paying Data Analyst internships from first query.
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying internships demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries.
*/

WITH top_paying_internships AS (
    SELECT
        job_id
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
)

SELECT
    skills_dim.skills AS skill_name,
    COUNT(*) AS skill_count
FROM 
    top_paying_internships
INNER JOIN skills_job_dim ON top_paying_internships.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skill_name
ORDER BY
    skill_count DESC
LIMIT 5

/*
Of these top 10 internships, 7 require SQL, 7 require Python,
6 require SAS, 5 require R, and just 3 require Java. These represent the five most in-demand
languages amongs the highest paying internships available to me.
*/