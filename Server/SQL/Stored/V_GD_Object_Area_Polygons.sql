prompt === View V_GD_Object_Area_Polygons ===

create or replace force view V_GD_Object_Area_Polygons
  (object_id,
   alt,
   lat_list,
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
select object_id, avg(altitude) alt, '['||LISTAGG('[' || to_char(longitude,'fm90.000000') || ',' || to_char(latitude,'fm90.000000') || ']' , ', ') WITHIN GROUP (order by rownum) || ']' as lat_list,
 o.id, object_name, government_contract_num, government_contract_date, building_area, owner, general_contractor, building_license_num, building_license_date
   from gd_object_area t, gd_object o
 where t.object_id = o.id
   group by object_id, o.id, object_name, government_contract_num, government_contract_date, building_area, owner, general_contractor, building_license_num, building_license_date;

comment on table  V_GD_Object_Area_Polygons                          is 'GAMITY.  (01.11.2020)';

comment on column V_GD_Object_Area_Polygons.object_id                is '';
comment on column V_GD_Object_Area_Polygons.alt                      is '';
comment on column V_GD_Object_Area_Polygons.lat_list                 is '';
comment on column V_GD_Object_Area_Polygons.id                       is '';
comment on column V_GD_Object_Area_Polygons.object_name              is '';
comment on column V_GD_Object_Area_Polygons.government_contract_num  is '';
comment on column V_GD_Object_Area_Polygons.government_contract_date is '';
comment on column V_GD_Object_Area_Polygons.building_area            is '';
comment on column V_GD_Object_Area_Polygons.owner                    is '';
comment on column V_GD_Object_Area_Polygons.general_contractor       is '';
comment on column V_GD_Object_Area_Polygons.building_license_num     is '';
comment on column V_GD_Object_Area_Polygons.building_license_date    is '';
