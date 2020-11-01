prompt === Package GD_Work_Pkg ===

create or replace
package GD_Work_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Работа
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
type TR_Trace is
  record (
    date_time GD_Trace.date_time%type,
    latitude GD_Trace.latitude%type,
    longitude GD_Trace.longitude%type,
    altitude GD_Trace.altitude%type);
type TT_Trace is
  table of TR_Trace;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Начало смены
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Start(pEmployeeId  in     GD_Work_Shift.employee_id%type,  -- Id работника
                           pObjectId    in     GD_Work_Shift.object_id%type  ,  -- Id объекта
                           pWorkShiftId    out GD_Work_Shift.id%type         ,  -- Id смены
                           pTime           out Integer                       ,  -- Время смены (сек)
                           pResult         out Integer                       ,  -- Результат (0 - OK, иначе ошибка)
                           pErrMes         out VarChar2                      ); -- Сообщение об ошибке
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Окончание смены
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Stop(pWorkShiftId in     GD_Work_Shift.id%type,  -- Id смены
                          pResult         out Integer              ,  -- Результат (0 - OK, иначе ошибка)
                          pErrMes         out VarChar2             ); -- Сообщение об ошибке
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Добавление телеметрии
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Add_Trace(pWorkShiftId in     GD_Work_Shift.id%type,  -- Id смены
                    pTrace       in     TT_Trace             ,  -- Телеметрия
                    pResult         out Integer              ,  -- Результат (0 - OK, иначе ошибка)
                    pErrMes         out VarChar2             ); -- Сообщение об ошибке
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/

create or replace
package body GD_Work_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Работа
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
E_Fake exception;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Начало смены
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Start(pEmployeeId  in     GD_Work_Shift.employee_id%type,    -- Id работника
                           pObjectId    in     GD_Work_Shift.object_id%type  ,    -- Id объекта
                           pWorkShiftId    out GD_Work_Shift.id%type         ,    -- Id смены
                           pTime           out Integer                       ,    -- Время смены (сек)
                           pResult         out Integer                       ,    -- Результат (0 - OK, иначе ошибка)
                           pErrMes         out VarChar2                      ) is -- Сообщение об ошибке
  rWorkShift GD_Work_Shift%RowType;
begin
  begin
    select GD_Work_Shift.*
      into rWorkShift
      from GD_Work_Shift
      where GD_Work_Shift.employee_id=pEmployeeId and
            GD_Work_Shift.object_id=pObjectId and
            GD_Work_Shift.is_open=1;
    pResult:=0;
    pTime:=Trunc((SysDate-rWorkShift.date_time_begin)*24*60*60);
    pWorkShiftId:=rWorkShift.id;
    return;
  exception
    when No_Data_Found then
      pTime:=0;
      rWorkShift.object_id:=pObjectId;
      rWorkShift.is_open:=1;
      rWorkShift.date_time_begin:=SysDate;
      rWorkShift.employee_id:=pEmployeeId;
      rWorkShift.gadget_id:=GD_Api_Pkg.Get_Employee_By_Id(pEmployeeId).gadget_id;
      insert into GD_Work_Shift
        values rWorkShift
        returning id into pWorkShiftId;
  end;
  pResult:=0;
exception
  when E_Fake then
    pResult:=-1;
  when Others then
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Окончание смены
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Stop(pWorkShiftId in     GD_Work_Shift.id%type,    -- Id смены
                          pResult         out Integer              ,    -- Результат (0 - OK, иначе ошибка)
                          pErrMes         out VarChar2             ) is -- Сообщение об ошибке
  rWorkShift GD_Work_Shift%RowType;
begin
  rWorkShift:=GD_Api_Pkg.Get_Work_Shift_By_Id(pWorkShiftId);
  if rWorkShift.is_open is null then
    pErrMes:='Смена уже закрыта';
    raise E_Fake;
  end if;
  rWorkShift.is_open:='';
  rWorkShift.date_time_end:=SysDate;
  rWorkShift.all_time:=(rWorkShift.date_time_end-rWorkShift.date_time_begin)*24;
  rWorkShift.productive_time:=rWorkShift.all_time;
  rWorkShift.count_sos:=0;
  update GD_Work_Shift set
      row=rWorkShift
    where id=pWorkShiftId;
  pResult:=0;
exception
  when E_Fake then
    pResult:=-1;
  when Others then
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Добавление телеметрии
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Add_Trace(pWorkShiftId in     GD_Work_Shift.id%type,    -- Id смены
                    pTrace       in     TT_Trace             ,    -- Телеметрия
                    pResult         out Integer              ,    -- Результат (0 - OK, иначе ошибка)
                    pErrMes         out VarChar2             ) is -- Сообщение об ошибке
  rWorkShift GD_Work_Shift%RowType;
  rTrace GD_Trace%RowType;
begin
  rWorkShift:=GD_Api_Pkg.Get_Work_Shift_By_Id(pWorkShiftId);
  rTrace.object_id:=rWorkShift.object_id;
  rTrace.employee_id:=rWorkShift.employee_id;
  rTrace.work_shift_id:=rWorkShift.id;
  rTrace.gadget_id:=rWorkShift.gadget_id;
  GD_Object_Pkg.Init;
  for i in 1..pTrace.Count loop
    rTrace.latitude:=pTrace(i).latitude;
    rTrace.longitude:=pTrace(i).longitude;
    rTrace.altitude:=pTrace(i).altitude;
    rTrace.date_time:=pTrace(i).date_time;
    if GD_Object_Pkg.In_Area(rTrace.object_id,rTrace.latitude,rTrace.longitude) then
        rTrace.in_area:='Y';
      else
        rTrace.in_area:='N';
    end if;
    insert into GD_Trace
      values rTrace;
  end loop;
  pResult:=0;
exception
  when E_Fake then
    pResult:=-1;
  when Others then
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/
