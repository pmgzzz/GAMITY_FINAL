prompt === View V_GD_Object_Area ===

create or replace force view V_GD_Object_Area
  (latitude,
   longitude,
   altitude,
   id,
   object_name,
   government_contract_num,
   government_contract_date,
   building_area,
   owner,
   general_contractor,
   building_license_num,
   building_license_date)
as
select a.latitude, a.longitude, a.altitude, o.id, object_name, government_contract_num, government_contract_date, building_area, owner, general_contractor, building_license_num, building_license_date
  from gd_object_area a, gd_object o
 where a.object_id = o.id;

comment on table  V_GD_Object_Area                          is 'GAMITY.  (01.11.2020)';

comment on column V_GD_Object_Area.latitude                 is '';
comment on column V_GD_Object_Area.longitude                is '';
comment on column V_GD_Object_Area.altitude                 is '';
comment on column V_GD_Object_Area.id                       is '';
comment on column V_GD_Object_Area.object_name              is '';
comment on column V_GD_Object_Area.government_contract_num  is '';
comment on column V_GD_Object_Area.government_contract_date is '';
comment on column V_GD_Object_Area.building_area            is '';
comment on column V_GD_Object_Area.owner                    is '';
comment on column V_GD_Object_Area.general_contractor       is '';
comment on column V_GD_Object_Area.building_license_num     is '';
comment on column V_GD_Object_Area.building_license_date    is '';
