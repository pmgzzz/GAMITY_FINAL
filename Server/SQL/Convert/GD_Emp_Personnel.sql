prompt === Create table GD_Emp_Personnel ===

create table GD_Emp_Personnel
  (id integer generated by default on null as identity not null,
   name        VarChar2(2000)                                                ,
   employer_id Integer                                               not null,
   post_id     Integer                                               not null,
   ein         VarChar2(  30)                                        not null,
   snils       VarChar2(  30)                                                ,
   pin         VarChar2(2000)                                                );

comment on table GD_Emp_Personnel             is 'GAMITY. ����� ������. ���������� (01.11.2020)';

comment on column GD_Emp_Personnel.snils       is '�����';
comment on column GD_Emp_Personnel.pin         is '��� ���';
comment on column GD_Emp_Personnel.id          is 'Id';
comment on column GD_Emp_Personnel.name        is '�.�.�.';
comment on column GD_Emp_Personnel.employer_id is 'Id ������������';
comment on column GD_Emp_Personnel.post_id     is 'Id ���������';
comment on column GD_Emp_Personnel.ein         is '��������� �';

alter table GD_Emp_Personnel add
  constraint PK_GD_Emp_Per
    primary key (id) using index tablespace Indexes;
alter table GD_Emp_Personnel add
  constraint UK_GD_Emp_Per_4_snl
    unique (snils) using index tablespace Indexes;
alter table GD_Emp_Personnel add
  constraint UK_GD_Emp_Per_4_ein
    unique (ein,employer_id) using index tablespace Indexes;
alter table GD_Emp_Personnel add
  constraint FK_GD_Emp_Per_2_Emp_Pst
    foreign key (post_id)
    references GD_Emp_Post (id);
alter table GD_Emp_Personnel add
  constraint FK_GD_Emp_Per_2_Emp_Emp
    foreign key (employer_id)
    references GD_Emp_Employer (id);
