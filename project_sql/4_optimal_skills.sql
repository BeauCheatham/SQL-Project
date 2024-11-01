/* 
Question: What are the most optimal skills to learn (aka it is a high demand and high-paying skill)?
-Identify skills in high demand and associated with high average salaries for Data Analyst internships.
-Concentrates on in-state (TX) and remote positions with specified salaries.
-Why? Targets skills that offer job security (high demand) and financial benefits (high salaries)
    offering strategic insights for career development in data analysis.
*/
WITH skills_demand AS (
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
    )

    SELECT
        skills_dim.skills AS skill_name,
        skills_dim.skill_id AS skill_id,
        COUNT(*) AS skill_count
    FROM 
        top_paying_internships
    INNER JOIN skills_job_dim ON top_paying_internships.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY
        skills_dim.skill_id
    ORDER BY
        skill_count DESC
), average_salary AS (
    SELECT
        skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title LIKE ANY (ARRAY['%Intern', '%Internship', '%Entry%', '%Junior%'])
        AND (job_work_from_home = TRUE OR job_location LIKE '%TX') 
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills
    ORDER BY
        avg_salary DESC
)

SELECT
    skills_demand.skill_id,
    skills_demand.skill_name,
    skills_demand.skill_count,
    average_salary.avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_name = average_salary.skills
WHERE
    skill_count > 5
ORDER BY
    skill_count DESC, 
    avg_salary DESC
LIMIT 25

/*
Findings:
-Allowing only for skills that at least five different internships require creates
    a clear picture of the most relevant skills by both demand and salary.
-Most optimal skills to learn:
    -SQL
    -Python
    -R
    -Excel
    -Oracle
*/