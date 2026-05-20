CREATE OR REPLACE TEMP TABLE src_table AS

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_name,
    jpf.job_posted_date::DATE AS job_posted_date,
    jpf.salary_year_avg,
    pr.priority_level,
    CURRENT_TIMESTAMP AS updated_at

FROM job_postings_fact jpf

LEFT JOIN company_dim cd
    ON jpf.company_id = cd.company_id

INNER JOIN priority_mart.priority_roles pr
    ON LOWER(jpf.job_title_short)=LOWER(pr.role_name);


MERGE INTO priority_mart.priority_jobs_snapshot AS target_table

USING src_table AS src

ON target_table.job_id = src.job_id


WHEN MATCHED
AND target_table.priority_level
    IS DISTINCT FROM src.priority_level

THEN UPDATE SET

    priority_level = src.priority_level,
    updated_at = src.updated_at


WHEN NOT MATCHED THEN

INSERT
(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_level,
    updated_at
)

VALUES
(
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_level,
    src.updated_at
);


-- optional
-- WHEN NOT MATCHED BY SOURCE THEN DELETE;