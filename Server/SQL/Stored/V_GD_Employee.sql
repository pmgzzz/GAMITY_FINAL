prompt === View V_GD_Employee ===

create or replace force view V_GD_Employee
  (id,
   employee_id,
   gadget_id,
   name,
   employer_id,
   employer_name,
   post_id,
   post_name,
   ein,
   mac_address,
   phone_number)
as
select GD_Employee."ID",GD_Employee."EMPLOYEE_ID",GD_Employee."GADGET_ID",
       V_GD_Emp_Personnel.name,
       V_GD_Emp_Personnel.employer_id,
       V_GD_Emp_Personnel.employer_name,
       V_GD_Emp_Personnel.post_id,
       V_GD_Emp_Personnel.post_name,
       V_GD_Emp_Personnel.ein,
       GD_Gadget.mac_address,
       GD_Gadget.phone_number
  from GD_Employee,
       V_GD_Emp_Personnel,
       GD_Gadget
  where V_GD_Emp_Personnel.id=GD_Employee.employee_id and
        GD_Gadget.id=GD_Employee.gadget_id;

comment on table  V_GD_Employee               is 'GAMITY. ������� (01.11.2020)';

comment on column V_GD_Employee.id            is 'Id';
comment on column V_GD_Employee.employee_id   is 'Id ����������';
comment on column V_GD_Employee.gadget_id     is 'Id �������';
comment on column V_GD_Employee.name          is '�.�.�.';
comment on column V_GD_Employee.employer_id   is 'Id ������������';
comment on column V_GD_Employee.employer_name is '������������ ������������';
comment on column V_GD_Employee.post_id       is 'Id ���������';
comment on column V_GD_Employee.post_name     is '������������ ���������';
comment on column V_GD_Employee.ein           is '��������� �';
comment on column V_GD_Employee.mac_address   is 'MAC �����';
comment on column V_GD_Employee.phone_number  is '� ��������';
