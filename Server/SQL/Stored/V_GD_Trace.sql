prompt === View V_GD_Trace ===

create or replace force view V_GD_Trace
  (object_name,
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
select o.object_name, t."ID",t."OBJECT_ID",t."EMPLOYEE_ID",t."WORK_SHIFT_ID",t."LATITUDE",t."LONGITUDE",t."ALTITUDE",t."GADGET_ID",t."IN_WORK",t."IN_AREA",t."DATE_TIME" from GD_Trace t, Gd_Object o where t.object_id = o.id;

comment on table  V_GD_Trace               is 'GAMITY.  (01.11.2020)';

comment on column V_GD_Trace.object_name   is '';
comment on column V_GD_Trace.id            is '';
comment on column V_GD_Trace.object_id     is '';
comment on column V_GD_Trace.employee_id   is '';
comment on column V_GD_Trace.work_shift_id is '';
comment on column V_GD_Trace.latitude      is '';
comment on column V_GD_Trace.longitude     is '';
comment on column V_GD_Trace.altitude      is '';
comment on column V_GD_Trace.gadget_id     is '';
comment on column V_GD_Trace.in_work       is '';
comment on column V_GD_Trace.in_area       is '';
comment on column V_GD_Trace.date_time     is '';
