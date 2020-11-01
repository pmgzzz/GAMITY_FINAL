set define off

spool RunMe.log

prompt V_GD_Employee.sql
@@V_GD_Employee.sql
show errors

prompt V_GD_Emp_Personnel.sql
@@V_GD_Emp_Personnel.sql
show errors

prompt V_GD_Object_Area.sql
@@V_GD_Object_Area.sql
show errors

prompt V_GD_Object_Area_Polygons.sql
@@V_GD_Object_Area_Polygons.sql
show errors

prompt V_GD_Trace.sql
@@V_GD_Trace.sql
show errors

prompt V_GD_Trace_Current.sql
@@V_GD_Trace_Current.sql
show errors

prompt V_GD_Trace_Today.sql
@@V_GD_Trace_Today.sql
show errors

prompt V_GD_Work_Shift.sql
@@V_GD_Work_Shift.sql
show errors

prompt GD_Api_Pkg.sql
@@GD_Api_Pkg.sql
show errors

prompt GD_Emp_Api_Pkg.sql
@@GD_Emp_Api_Pkg.sql
show errors

prompt GD_Emp_Pkg.sql
@@GD_Emp_Pkg.sql
show errors

prompt GD_Object_Pkg.sql
@@GD_Object_Pkg.sql
show errors

prompt GD_Pkg.sql
@@GD_Pkg.sql
show errors

prompt GD_Security_Pkg.sql
@@GD_Security_Pkg.sql
show errors

prompt GD_Work_Pkg.sql
@@GD_Work_Pkg.sql
show errors

spool off
