# Introduction
Explore the market for data analyst internships! Focusing on remote and in-Texas roles, this project explores top-paying jobs, in demand skills, and where high demand meets high salary for interns in data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/)
# Background
Driven by a desire to explore the job market I will be entering, this project was born from a desire to pinpoint top-paid and in demand skills through data analytics. 

Data hails from [this SQL course](hittps://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.
### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst internship positions?
2. What skills are most in demand for these top-paying jobs?
3. Which skills are associated with higher salaries?
4. What are the most optimal skills to learn?

# Tools I used
For my deep dive into the data analyst job market, I utilized several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking. 
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top-Paying Data Analyst Internships
To identify the highest-paying roles, I filtered data analyst internships by average yearly salary and location, focusing on remote jobs and jobs within Texas. This query highlights the high paying opportunities in the field.

```sql
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
```
Here's the breakdown of the top-paying data analyst internships in 2023:
- **High-paying Opportunities:** Top 10 paying data analyst internships span from $100,000 to $130,000, indicating significant salary potential in the field.
- **High Demand in Texas:** Of the top-paid ten internships, four were from the state of Texas. 
- **Company Diversity:** Companies including IBM, Morgan Hunter, Iron Mountain Inc., and more are amongst the companies offering high salaries. This diversity indicates a potential variety of opportunities for employment.
### 2. Most In Demand Skills
To identify the most in demand skills, I filtered these top-paying internships by the skills that they each required.  This query highlights the most in demand skills for these internships.

```sql
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
```
Here's the breakdown of the most in demand skills of 2023:
- **Most Desirable Skills:** There were 5 clear winners in terms of demand: SQL, Python, SAS, R, and Java. These skills were the most commonly required by top internships in the field. 
### 3. Top-Paying Skills
To identify the top-paying skills, I filtered the average salaries associated with each skill, finding those with the highest average values. This query highlights the pay associated with these skills.

```sql
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
```
Here's the breakdown of the top-paying skills for data analyst internships in 2023:
- **High-Paying Opportunities** The highest average salaries per skills ranged from $90,000 - $115,000. 
- **Core Skills Remain in Demand** Core languages such as C++, Java, and C# remain a valuable skill for prospective data analysts. 
### 4. Most Optimal Skills
To identify the most optimal skills, I filtered the skills by demand, followed by salary, finding the skills offer the most value to a new entrant into this market. This query highlights the most optimal skills for a new entrant to the data analytics job market.

```sql
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
```
Here's the breakdown of the most optimal skills for data analyst internships in 2023:
- **High Value Skills By Demand** The most valuable skills were clear: SQL and Python dominated demand with 68 and 65 jobs requiring each respective skill. The next most valuable skills include R, Excel, Oracle, and Tableau.
- **High Value Skills By Salary** The highest paying skills (exluding outliers with low demand): Java stands as the highest value skill with an average salary of $94,404 across its internships. The next skills include Azure, SAS, R, and Python with salaries ranging from ~$73,690-$80,500 for these skills.
# What I Learned

Throughout this project, I've developed my SQL expertise immensely:

- **Complex Query Crafting** Mastered the usage of advanced SQL, merging tables and the usage of WITH clauses.
- **Data Aggregation** Gained knowledge of aggregate functions such as COUNT() and AVG() and how to perform useful data analysis with them.
- **Analytic Inquiry** Developed the ability to transform questions into actionable, insightful SQL queries. 
# Conclusions
### Insights
1. **Top-Paying Data Analyst Internships**: A high range of salaries is available to interns in the data analysis industry with salaries reaching up to $130,000.
2. **Highest Demand Skills**: The skills highest in demand include SQL, Python, SAS, R, and Java.
3. **High Paying Skills**: The highest average pay for skills ranges from $90,000 - $115,000. Core skills such as C++, Java, and C# are valuable skills.
4. **Most Optimal Skills**: The most in demand skills across data analyst internships are SQL and Python. The skill with the highest average salary across these internships is Java. These three skills represent the most optimal skills to learn for a prospective data analyst intern.

### Closing Thoughts
This project improved my SQL skills and provided valuable insights into the market for interns in the field of data analytics. The findings from the analysis serve as a guide for prioritizing skill development and job search efforts. Aspiring interns in the field can better position themselves within the competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics. 