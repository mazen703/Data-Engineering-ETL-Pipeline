Drop Schema if exists priority_mart cascade;

create Schema priority_mart;

create table priority_mart.priority_roles 
(
    role_id INTEGER PRIMARY KEY ,
    role_name VARCHAR ,
    priority_level VARCHAR
);

INSERT INTO  priority_mart.priority_roles (role_id,role_name,priority_level)
 Values(1,'data Engineer',1),
    (2,'Data Analyst',2),
    (3,'Software Engineer',3),
     (4,'Data Scientist',4);
   
    


    select *  from priority_mart.priority_roles;


CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot
(
    job_id INTEGER PRIMARY KEY,

    job_title_short VARCHAR,

    company_name VARCHAR,

    job_posted_date DATE,

    salary_year_avg DOUBLE,

    priority_level INTEGER,

    updated_at TIMESTAMP
);
INSERT INTO priority_mart.priority_jobs_snapshot
(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_level,
    updated_at
)

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_name,
    jpf.job_posted_date::DATE,
    jpf.salary_year_avg,
    pr.priority_level,
    CURRENT_TIMESTAMP

FROM job_postings_fact jpf

LEFT JOIN company_dim cd
    ON jpf.company_id = cd.company_id

INNER JOIN priority_mart.priority_roles pr
    ON jpf.job_title_short = pr.role_name;

 
