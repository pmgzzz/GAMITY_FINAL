prompt === Package GD_Api_Pkg ===

create or replace
package GD_Api_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Api
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
type TT_Trace is
  table of GD_Trace%RowType;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ���� ���������� �� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Trace(pObjectId in GD_Trace.object_id%type, -- Id �������
                   pDateTime in GD_Trace.date_time%type) -- ����/����� �����
return TT_Trace pipelined;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������� ���������� �� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Trace(p in Integer)
return TT_Trace pipelined;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Registration(pName        in GD_Emp_Personnel.name%type   ,  -- �.�.�.
                       pSNILS       in GD_Emp_Personnel.snils%type  ,  -- �����
                       pPostId      in GD_Emp_Personnel.post_id%type,  -- Id ���������
                       pEmployerINN in GD_Emp_Employer.inn%type     ,  -- ��� ������������
                       pPhoneNumber in GD_Gadget.phone_number%type  ,  -- � ��������
                       pMaccAddress in GD_Gadget.mac_address%type   ,  -- MAC �����
                       pPIN         in VarChar2                     ,  -- ������
                       pResult         out Integer                  ,  -- ��������� (0 - OK, ����� ������)
                       pErrMes         out VarChar2                 ); -- ��������� �� ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ������� �� MAC ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Gadget_By_Mac_Address(pMacAddress in GD_Gadget.mac_address%type) -- MAC �����
return GD_Gadget%RowType;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ��������� �� Id
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Employee_By_Id(pId in GD_Employee.id%type) -- Id
return GD_Employee%RowType;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ����� �� Id
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Work_Shift_By_Id(pId in GD_Work_Shift.id%type) -- Id
return GD_Work_Shift%RowType;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ������� �� �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Get_Object(pLatitude     in     GD_Object_Area.latitude%type ,  -- ������
                     pLongitude    in     GD_Object_Area.longitude%type,  -- �������
                     pObjectId        out GD_Object.id%type            ,  -- Id �������
                     pObjectName      out GD_Object.object_name%type   ,  -- ������������ �������
                     pResult          out Integer                      ,  -- ��������� (0 - OK, ����� ������)
                     pErrMes          out VarChar2                     ); -- ��������� �� ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������ �����
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Start(pYmployeeId  in     GD_Work_Shift.employee_id%type,  -- Id ���������
                           pObjectId    in     GD_Work_Shift.object_id%type  ,  -- Id �������
                           pWorkShiftId    out GD_Work_Shift.id%type         ,  -- Id �����
                           pTime           out Integer                       ,  -- ����� ����� (���)
                           pResult         out Integer                       ,  -- ��������� (0 - OK, ����� ������)
                           pErrMes         out VarChar2                      ); -- ��������� �� ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� �����
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Stop(pWorkShiftId in     GD_Work_Shift.id%type,  -- Id �����
                          pResult         out Integer              ,  -- ��������� (0 - OK, ����� ������)
                          pErrMes         out VarChar2             ); -- ��������� �� ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/

create or replace
package body GD_Api_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Api
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
E_Fake exception;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ���� ���������� �� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Trace(pObjectId in GD_Trace.object_id%type, -- Id �������
                   pDateTime in GD_Trace.date_time%type) -- ����/����� �����
return TT_Trace pipelined is
begin
  for rWorkShift in (select GD_Work_Shift.id
                       from GD_Work_Shift
                       where GD_Work_Shift.object_id=pObjectId and
                             GD_Work_Shift.is_open=1 and
                             GD_Work_Shift.date_time_begin<=pDateTime
                     union all
                     select GD_Work_Shift.id
                       from GD_Work_Shift
                       where GD_Work_Shift.object_id=pObjectId and
                             GD_Work_Shift.is_open is null and
                             pDateTime between GD_Work_Shift.date_time_begin and GD_Work_Shift.date_time_end) loop
    for rTrace in (select GD_Trace.*
                      from GD_Trace
                      where GD_Trace.work_shift_id=rWorkShift.id and
                            GD_Trace.date_time<=pDateTime
                      order by GD_Trace.date_time desc) loop
      pipe row(rTrace);
      exit;
    end loop;
  end loop;
  return;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������� ���������� �� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Trace(p in Integer)
return TT_Trace pipelined is
begin
  for rWorkShift in (select GD_Work_Shift.id
                       from GD_Work_Shift
                       where GD_Work_Shift.is_open=1) loop
    for rTrace in (select GD_Trace.*
                      from GD_Trace
                      where GD_Trace.work_shift_id=rWorkShift.id
                      order by GD_Trace.date_time desc) loop
      pipe row(rTrace);
      exit;
    end loop;
  end loop;
  return;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Registration(pName        in GD_Emp_Personnel.name%type   ,    -- �.�.�.
                       pSNILS       in GD_Emp_Personnel.snils%type  ,    -- �����
                       pPostId      in GD_Emp_Personnel.post_id%type,    -- Id ���������
                       pEmployerINN in GD_Emp_Employer.inn%type     ,    -- ��� ������������
                       pPhoneNumber in GD_Gadget.phone_number%type  ,    -- � ��������
                       pMaccAddress in GD_Gadget.mac_address%type   ,    -- MAC �����
                       pPIN         in VarChar2                     ,    -- ������
                       pResult         out Integer                  ,    -- ��������� (0 - OK, ����� ������)
                       pErrMes         out VarChar2                 ) is -- ��������� �� ������
  vPersonnelId GD_Emp_Employer.id%type;
  vGadgetId    GD_Gadget.id%type;
  vEmployeeId  GD_Employee.id%type;
begin
  GD_Emp_Api_Pkg.Registration(pName,pSNILS,pPostId,pEmployerINN,pPIN,vPersonnelId,pResult,pErrMes);
  if pResult!=0 then
    raise E_Fake;
  end if;
  GD_Pkg.Add_Gadget(pPhoneNumber,pMaccAddress,vGadgetId,pResult,pErrMes);
  if pResult!=0 then
    raise E_Fake;
  end if;
  GD_Pkg.Add_Employee(vGadgetId,vPersonnelId,vEmployeeId,pResult,pErrMes);
  if pResult!=0 then
    raise E_Fake;
  end if;
  pResult:=0;
  Commit;
exception
  when E_Fake then
    RollBack;
    pResult:=-1;
  when Others then
    RollBack;
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ������� �� MAC ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Gadget_By_Mac_Address(pMacAddress in GD_Gadget.mac_address%type) -- MAC �����
return GD_Gadget%RowType is
  rGadget GD_Gadget%RowType;
begin
  select GD_Gadget.*
    into rGadget
    from GD_Gadget
    where GD_Gadget.mac_address=pMacAddress;
  return rGadget;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ��������� �� Id
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Employee_By_Id(pId in GD_Employee.id%type) -- Id
return GD_Employee%RowType is
  rEmployee GD_Employee%RowType;
begin
  select GD_Employee.*
    into rEmployee
    from GD_Employee
    where GD_Employee.id=pId;
  return rEmployee;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ����� �� Id
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Work_Shift_By_Id(pId in GD_Work_Shift.id%type) -- Id
return GD_Work_Shift%RowType is
  rWorkShift GD_Work_Shift%RowType;
begin
  select GD_Work_Shift.*
    into rWorkShift
    from GD_Work_Shift
    where GD_Work_Shift.id=pId;
  return rWorkShift;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ������� �� �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Get_Object(pLatitude     in     GD_Object_Area.latitude%type ,    -- ������
                     pLongitude    in     GD_Object_Area.longitude%type,    -- �������
                     pObjectId        out GD_Object.id%type            ,    -- Id �������
                     pObjectName      out GD_Object.object_name%type   ,    -- ������������ �������
                     pResult          out Integer                      ,    -- ��������� (0 - OK, ����� ������)
                     pErrMes          out VarChar2                     ) is -- ��������� �� ������
  rObject GD_Object%RowType;
begin
  rObject:=GD_Object_Pkg.Get_Object(pLatitude,pLongitude);
  if rObject.id is null then
    pErrMes:='���������� ���������� ������';
    raise E_Fake;
  end if;
  pObjectId:=rObject.id;
  pObjectName:=rObject.object_name;
  pResult:=0;
exception
  when E_Fake then
    pResult:=-1;
  when Others then
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������ �����
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Start(pYmployeeId  in     GD_Work_Shift.employee_id%type,    -- Id ���������
                           pObjectId    in     GD_Work_Shift.object_id%type  ,    -- Id �������
                           pWorkShiftId    out GD_Work_Shift.id%type         ,    -- Id �����
                           pTime           out Integer                       ,    -- ����� ����� (���)
                           pResult         out Integer                       ,    -- ��������� (0 - OK, ����� ������)
                           pErrMes         out VarChar2                      ) is -- ��������� �� ������
begin
  Commit;
  pResult:=0;
exception
  when E_Fake then
    RollBack;
    pResult:=-1;
  when Others then
    RollBack;
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� �����
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Work_Shift_Stop(pWorkShiftId in     GD_Work_Shift.id%type,    -- Id �����
                          pResult         out Integer              ,    -- ��������� (0 - OK, ����� ������)
                          pErrMes         out VarChar2             ) is -- ��������� �� ������
begin
  Commit;
  pResult:=0;
exception
  when E_Fake then
    RollBack;
    pResult:=-1;
  when Others then
    RollBack;
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/
