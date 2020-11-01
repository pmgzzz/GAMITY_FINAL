prompt === View V_GD_Trace_Current ===

create or replace force view V_GD_Trace_Current
  (object_name,
   employee_name,
   post_name,
   id,
   object_id,
   employee_id,
   work_shift_id,
   latitude,
   longitude,
   altitude,
   gadget_id,
   in_work,
   in_area,
   date_time)
as
select O.object_name,
       E.name employee_name,
       E.post_name,
       T."ID",T."OBJECT_ID",T."EMPLOYEE_ID",T."WORK_SHIFT_ID",T."LATITUDE",T."LONGITUDE",T."ALTITUDE",T."GADGET_ID",T."IN_WORK",T."IN_AREA",T."DATE_TIME"
  from table(GD_Api_Pkg.Get_Trace(9)) T,
       GD_Object O,
       V_GD_Employee E
  where O.id=T.object_id and
        E.id=T.employee_id;

comment on table  V_GD_Trace_Current               is 'GAMITY.  (01.11.2020)';

comment on column V_GD_Trace_Current.object_name   is '';
comment on column V_GD_Trace_Current.employee_name is '';
comment on column V_GD_Trace_Current.post_name     is '';
comment on column V_GD_Trace_Current.id            is '';
comment on column V_GD_Trace_Current.object_id     is '';
comment on column V_GD_Trace_Current.employee_id   is '';
comment on column V_GD_Trace_Current.work_shift_id is '';
comment on column V_GD_Trace_Current.latitude      is '';
comment on column V_GD_Trace_Current.longitude     is '';
comment on column V_GD_Trace_Current.altitude      is '';
comment on column V_GD_Trace_Current.gadget_id     is '';
comment on column V_GD_Trace_Current.in_work       is '';
comment on column V_GD_Trace_Current.in_area       is '';
comment on column V_GD_Trace_Current.date_time     is '';
