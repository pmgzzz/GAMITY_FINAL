prompt === Package GD_Pkg ===

create or replace
package GD_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ���������� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Add_Gadget(pPhoneNumber in     GD_Gadget.phone_number%type,  -- � ��������
                     pMacAddress  in     GD_Gadget.mac_address%type ,  -- MAC �����
                     pId             out GD_Gadget.id%type          ,  -- Id
                     pResult         out Integer                    ,  -- ��������� (0 - OK, ����� ������)
                     pErrMes         out VarChar2                   ); -- ��������� �� ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ���������� ���������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Add_Employee(pGadgetId   in     GD_Employee.gadget_id%type  ,  -- Id �������
                       pEmployeeId in     GD_Employee.employee_id%type,  -- Id ����������
                       pId            out GD_Employee.id%type         ,  -- Id
                       pResult        out Integer                     ,  -- ��������� (0 - OK, ����� ������)
                       pErrMes        out VarChar2                    ); -- ��������� �� ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/

create or replace
package body GD_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ���������� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Add_Gadget(pPhoneNumber in     GD_Gadget.phone_number%type,    -- � ��������
                     pMacAddress  in     GD_Gadget.mac_address%type ,    -- MAC �����
                     pId             out GD_Gadget.id%type          ,    -- Id
                     pResult         out Integer                    ,    -- ��������� (0 - OK, ����� ������)
                     pErrMes         out VarChar2                   ) is -- ��������� �� ������
  rGadget GD_Gadget%RowType;
begin
  rGadget.phone_number:=pPhoneNumber;
  rGadget.mac_address :=pMacAddress;
  insert into GD_Gadget
    values rGadget
    returning id into pId;
  pResult:=0;
exception
  when Others then
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ���������� ���������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Add_Employee(pGadgetId   in     GD_Employee.gadget_id%type  ,    -- Id �������
                       pEmployeeId in     GD_Employee.employee_id%type,    -- Id ����������
                       pId            out GD_Employee.id%type         ,    -- Id
                       pResult        out Integer                     ,    -- ��������� (0 - OK, ����� ������)
                       pErrMes        out VarChar2                    ) is -- ��������� �� ������
  rEmployee GD_Employee%RowType;
begin
  rEmployee.gadget_id:=pGadgetId;
  rEmployee.employee_id:=pEmployeeId;
  insert into GD_Employee
    values rEmployee
    returning id into pId;
  pResult:=0;
exception
  when Others then
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/
