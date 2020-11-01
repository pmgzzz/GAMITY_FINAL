prompt === View V_GD_Emp_Personnel ===

create or replace force view V_GD_Emp_Personnel
  (id,
   name,
   employer_id,
   post_id,
   ein,
   employer_name,
   post_name)
as
select GD_Emp_Personnel."ID",GD_Emp_Personnel."NAME",GD_Emp_Personnel."EMPLOYER_ID",GD_Emp_Personnel."POST_ID",GD_Emp_Personnel."EIN",
       GD_Emp_Employer.name employer_name,
       GD_Emp_Post.name post_name
  from GD_Emp_Personnel,
       GD_Emp_Employer,
       GD_Emp_Post
  where GD_Emp_Employer.id=GD_Emp_Personnel.employer_id and
        GD_Emp_Post.id=GD_Emp_Personnel.post_id;

comment on table  V_GD_Emp_Personnel               is 'GAMITY. Отдел кадров. Сотрудники (01.11.2020)';

comment on column V_GD_Emp_Personnel.id            is 'Id';
comment on column V_GD_Emp_Personnel.name          is 'Ф.И.О.';
comment on column V_GD_Emp_Personnel.employer_id   is 'Id работодателя';
comment on column V_GD_Emp_Personnel.post_id       is 'Id должности';
comment on column V_GD_Emp_Personnel.ein           is 'Табельный №';
comment on column V_GD_Emp_Personnel.employer_name is 'Наименование работодателя';
comment on column V_GD_Emp_Personnel.post_name     is 'Наименование должности';
