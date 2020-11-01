prompt === Create table GD_Object_Area ===

create table GD_Object_Area
  (object_id Integer not null,
   latitude  Number  not null,
   longitude Number  not null,
   altitude  Number  not null);

comment on table GD_Object_Area           is 'GAMITY. Границы объекта (01.11.2020)';

comment on column GD_Object_Area.object_id is 'Id проекта';
comment on column GD_Object_Area.latitude  is 'Широта';
comment on column GD_Object_Area.longitude is 'Долгота';
comment on column GD_Object_Area.altitude  is 'Высота';

alter table GD_Object_Area add
  constraint FK_GD_Obj_Are_2_Obj
    foreign key (object_id)
    references GD_Object (id);
