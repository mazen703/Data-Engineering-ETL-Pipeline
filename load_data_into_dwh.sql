-- TASK 2 — Load data from GCS

INSERT INTO company_dim
SELECT * FROM read_csv_auto(
    'https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT = true
);

INSERT INTO skills_dim
SELECT skill_id, skills, type
FROM read_csv_auto(
    'https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT = true
);

INSERT INTO job_postings_fact
SELECT job_id, company_id, job_title_short, job_title,
       job_location, job_via, job_schedule_type, job_work_from_home,
       search_location, job_posted_date, job_no_degree_mention,
       job_health_insurance, job_country, salary_rate, salary_year_avg
FROM read_csv_auto(
    'https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT = true
);

INSERT INTO skills_job_dim
SELECT job_id, skill_id
FROM read_csv_auto(
    'https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT = true
);


SELECT
    'company_dim' AS table_name,
    COUNT(*) AS number_of_rows
FROM company_dim

UNION ALL

SELECT
    'skills_dim',
    COUNT(*)
FROM skills_dim

UNION ALL

SELECT
    'job_postings_fact',
    COUNT(*)
FROM job_postings_fact

UNION ALL

SELECT
    'skills_job_dim',
    COUNT(*)
FROM skills_job_dim;