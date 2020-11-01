prompt === View V_GD_Work_Shift ===

create or replace force view V_GD_Work_Shift
  (object_name,
   date_time_begin,
   date_time_end,
   all_time,
   productive_time,
   employee_name,
   post_name)
as
select GD_Object.object_name,
       GD_Work_Shift.date_time_begin,
       GD_Work_Shift.date_time_end,
       Decode(GD_Work_Shift.all_time,null,'',Trunc(GD_Work_Shift.all_time)||':'||Trunc((GD_Work_Shift.all_time-Trunc(GD_Work_Shift.all_time))*60)) all_time,
       Decode(GD_Work_Shift.productive_time,null,'',Trunc(GD_Work_Shift.productive_time)||':'||Trunc((GD_Work_Shift.productive_time-Trunc(GD_Work_Shift.productive_time))*60)) productive_time,
       V_GD_Employee.name employee_name,
       V_GD_Employee.post_name
  from GD_Work_Shift,
       V_GD_Employee,
       GD_Object
  where V_GD_Employee.id=GD_Work_Shift.employee_id and
        GD_Object.id=GD_Work_Shift.object_id;

comment on table  V_GD_Work_Shift                 is 'GAMITY.  (01.11.2020)';

comment on column V_GD_Work_Shift.object_name     is '';
comment on column V_GD_Work_Shift.date_time_begin is '';
comment on column V_GD_Work_Shift.date_time_end   is '';
comment on column V_GD_Work_Shift.all_time        is '';
comment on column V_GD_Work_Shift.productive_time is '';
comment on column V_GD_Work_Shift.employee_name   is '';
comment on column V_GD_Work_Shift.post_name       is '';
