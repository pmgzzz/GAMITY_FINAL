SELECT "object_name",
       "employee_name",
       "post_name"
FROM
  (SELECT object_name AS "object_name",
          employee_name AS "employee_name",
          post_name AS "post_name"
   FROM "GD".v_gd_trace_current
   GROUP BY object_name,
            employee_name,
            post_name
   ORDER BY COUNT(*) DESC)
WHERE ROWNUM <= 10000;
