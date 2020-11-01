set define off

spool RunMe.log

prompt GD_Gadget.sql
@@GD_Gadget.sql
show errors
prompt GD_Object.sql
@@GD_Object.sql
show errors
prompt GD_Emp_Employer.sql
@@GD_Emp_Employer.sql
show errors
prompt GD_Emp_Post.sql
@@GD_Emp_Post.sql
show errors
prompt GD_Object_Area.sql
@@GD_Object_Area.sql
show errors
prompt GD_Emp_Personnel.sql
@@GD_Emp_Personnel.sql
show errors
prompt GD_Employee.sql
@@GD_Employee.sql
show errors
prompt GD_Sos.sql
@@GD_Sos.sql
show errors
prompt GD_Trace.sql
@@GD_Trace.sql
show errors
prompt GD_Work_Shift.sql
@@GD_Work_Shift.sql
show errors

spool off
