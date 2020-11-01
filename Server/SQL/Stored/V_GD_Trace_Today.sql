prompt === View V_GD_Trace_Today ===

create or replace force view V_GD_Trace_Today
  (object_id,
   object_name,
   employee_id,
   employee_name,
   post_name,
   date_time,
   latitude,
   longitude,
   altitude,
   latitude_next,
   longitude_next,
   altitude_next,
   employee_path)
as
select GD_Object.id object_id,
       GD_Object.object_name,
       V_GD_Employee.id employee_id,
       V_GD_Employee.name employee_name,
       V_GD_Employee.post_name,
       GD_Trace.date_time,
       GD_Trace.latitude,
       GD_Trace.longitude,
       GD_Trace.altitude,
       COALESCE ( lead(GD_Trace.latitude) over (partition by GD_Trace.object_id, GD_Trace.employee_id order by Gd_Trace.Date_Time), GD_Trace.latitude ) latitude_next,
       COALESCE ( lead(GD_Trace.longitude) over (partition by GD_Trace.object_id, GD_Trace.employee_id order by Gd_Trace.Date_Time), GD_Trace.longitude ) longitude_next,
       COALESCE ( lead(GD_Trace.altitude) over (partition by GD_Trace.object_id, GD_Trace.employee_id order by Gd_Trace.Date_Time), GD_Trace.altitude ) altitude_next,
       '[['|| to_char(COALESCE ( lag(GD_Trace.longitude) over (partition by GD_Trace.object_id, GD_Trace.employee_id order by Gd_Trace.Date_Time), GD_Trace.longitude ),'fm90.000000') || ', ' ||
              to_char(COALESCE ( lag(GD_Trace.latitude) over (partition by GD_Trace.object_id, GD_Trace.employee_id order by Gd_Trace.Date_Time), GD_Trace.latitude ),'fm90.000000') ||'], ['||
              to_char(longitude,'fm90.000000') || ', ' || to_char(latitude,'fm90.000000') ||
       ']]' employee_path
  from GD_Work_Shift,
       GD_Trace,
       GD_Object,
       V_GD_Employee
  where GD_Work_Shift.is_open=1 and
        GD_Trace.work_shift_id=GD_Work_Shift.id and
        GD_Object.id=GD_Work_Shift.object_id and
        V_GD_Employee.id=GD_Work_Shift.employee_id;

comment on table  V_GD_Trace_Today                is 'GAMITY.  (01.11.2020)';

comment on column V_GD_Trace_Today.object_id      is '';
comment on column V_GD_Trace_Today.object_name    is '';
comment on column V_GD_Trace_Today.employee_id    is '';
comment on column V_GD_Trace_Today.employee_name  is '';
comment on column V_GD_Trace_Today.post_name      is '';
comment on column V_GD_Trace_Today.date_time      is '';
comment on column V_GD_Trace_Today.latitude       is '';
comment on column V_GD_Trace_Today.longitude      is '';
comment on column V_GD_Trace_Today.altitude       is '';
comment on column V_GD_Trace_Today.latitude_next  is '';
comment on column V_GD_Trace_Today.longitude_next is '';
comment on column V_GD_Trace_Today.altitude_next  is '';
comment on column V_GD_Trace_Today.employee_path  is '';
