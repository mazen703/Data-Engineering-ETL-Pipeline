-----Create Schema For Flat Mart Table
---ACCESSING FLAT_MART DB

-----duckdb flat_mart.duckdb
DROP Schema if exists flat_mart cascade;
Create schema flat_mart;


CREATE  OR REPlACE TABLE flat_mart.flat_table as 
select jpf.job_id, jpf.company_id, jpf.job_title_short, jpf.job_title,
       jpf.job_location, jpf.job_via, jpf.job_schedule_type, jpf.job_work_from_home,
       jpf.search_location, jpf.job_posted_date, jpf.job_no_degree_mention,
       jpf.job_health_insurance, jpf.job_country, jpf.salary_rate, jpf.salary_year_avg,
       cd.company_name,
       ARRAY_AGG(
        STRUCT_PACK(
            skill:=sd.skills,
            type:=sd.type
        )
       ) as skills_and_type
    

       from job_postings_fact as jpf 
       left join company_dim cd 
       on jpf.company_id =cd.company_id

       left join skills_job_dim  as sjd on 

       sjd.job_id =jpf.job_id

       left join skills_dim as sd 
       on sd.skill_id =sjd.skill_id

       group by all;
       -----------Testing flat table--------------------------

       select 'flat_table' as table_name ,COUNT(*) from flat_mart.flat_table;

       select * from flat_mart.flat_table
       where salary_year_avg is not null  limit 10 ;
       


