-- SETUP
INSTALL httpfs;
LOAD httpfs;
-- TASK 1 — Create tables

DROP TABLE IF EXISTS skills_job_dim;
DROP TABLE IF EXISTS company_dim;
DROP TABLE IF EXISTS job_postings_fact;
DROP TABLE IF EXISTS skills_dim;

CREATE TABLE company_dim (
    company_id INTEGER PRIMARY KEY,
    company_name VARCHAR,
    link VARCHAR,
    google_link VARCHAR,
    thumbnail VARCHAR
);

CREATE TABLE skills_dim (
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

CREATE TABLE job_postings_fact (
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    job_title_short VARCHAR,
    job_title VARCHAR,
    job_location VARCHAR,
    job_via VARCHAR,
    job_schedule_type VARCHAR,
    job_work_from_home BOOLEAN,
    search_location VARCHAR,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country VARCHAR,
    salary_rate VARCHAR,
    salary_year_avg DOUBLE,
    FOREIGN KEY(company_id)
        REFERENCES company_dim(company_id)
);

CREATE TABLE skills_job_dim (
    job_id INTEGER,
    skill_id INTEGER,
    PRIMARY KEY(job_id, skill_id),
    FOREIGN KEY(job_id)
        REFERENCES job_postings_fact(job_id),
    FOREIGN KEY(skill_id)
        REFERENCES skills_dim(skill_id)
);

SHOW TABLES;