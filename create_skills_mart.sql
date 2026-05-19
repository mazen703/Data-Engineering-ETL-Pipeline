-- Drop old schema

DROP SCHEMA IF EXISTS skills_mart CASCADE;

CREATE SCHEMA skills_mart;

--------------------------------------------------
-- Skills Dimension
--------------------------------------------------

CREATE TABLE skills_mart.skills_dim
(
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

INSERT INTO skills_mart.skills_dim

SELECT
    skill_id,
    skills,
    type
FROM skills_dim;

--------------------------------------------------
-- Month Dimension
--------------------------------------------------

CREATE TABLE skills_mart.skills_dim_month
(
    month_start_date DATE PRIMARY KEY,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    quarter_name VARCHAR,
    year_quarter VARCHAR
);

INSERT INTO skills_mart.skills_dim_month

SELECT DISTINCT

    DATE_TRUNC('month',job_posted_date)::DATE
        AS month_start_date,

    EXTRACT(YEAR FROM job_posted_date)::INTEGER
        AS year,

    EXTRACT(QUARTER FROM job_posted_date)::INTEGER
        AS quarter,

    EXTRACT(MONTH FROM job_posted_date)::INTEGER
        AS month,

    'Q' ||
    EXTRACT(QUARTER FROM job_posted_date)::VARCHAR
        AS quarter_name,

    EXTRACT(YEAR FROM job_posted_date)::VARCHAR
    || '-Q' ||
    EXTRACT(QUARTER FROM job_posted_date)::VARCHAR
        AS year_quarter

FROM job_postings_fact

ORDER BY month_start_date;


SELECT * FROM skills_mart.skills_dim_month limit 10 ;
SELECT COUNT(*) FROM skills_mart.skills_dim_month;

CREATE TABLE skills_mart.skills_fact_demand_monthly
(
    skill_id INTEGER,
    month_start_date DATE,
    job_title_short VARCHAR,

    postings_count INTEGER,
    remote_postings_count INTEGER,
    health_insurance_postings_count INTEGER,
    no_degree_postings_count INTEGER,

    PRIMARY KEY
    (
        skill_id,
        month_start_date,
        job_title_short
    ),

    FOREIGN KEY(skill_id)
        REFERENCES skills_mart.skills_dim(skill_id),

    FOREIGN KEY(month_start_date)
        REFERENCES skills_mart.skills_dim_month(month_start_date)
);

INSERT INTO skills_mart.skills_fact_demand_monthly

WITH job_fact_cte AS
(
    SELECT
        jpf.job_title_short,

        DATE_TRUNC('month', jpf.job_posted_date)::DATE
            AS month_start_date,

        sjd.skill_id,

        COALESCE(jpf.job_work_from_home,FALSE)::INTEGER
            AS is_remote,

        COALESCE(jpf.job_health_insurance,FALSE)::INTEGER
            AS has_health_insurance,

        COALESCE(jpf.job_no_degree_mention,FALSE)::INTEGER
            AS has_degree_mentioned

    FROM job_postings_fact jpf

    INNER JOIN skills_job_dim sjd
        ON jpf.job_id = sjd.job_id
)

SELECT
    skill_id,
    month_start_date,
     job_title_short,

    COUNT(*) AS postings_count,

    SUM(is_remote)
        AS remote_postings_count,

    SUM(has_health_insurance)
        AS health_insurance_postings_count,

    SUM(has_degree_mentioned)
        AS no_degree_postings_count

FROM job_fact_cte

GROUP BY ALL

ORDER BY
    job_title_short,
    month_start_date,
    skill_id;




select 'skills_dim' as table_name ,COUNT(*) from skills_mart.skills_dim 
                 union all select 'skills_dim_month',count(*) from skills_mart.skills_dim_month  
                 union all select 'fact_table',Count(*) from skills_mart.skills_fact_demand_monthly;
