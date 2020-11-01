SELECT "employee_name",
       "longitude",
       "latitude"
FROM
  (SELECT employee_name AS "employee_name",
          longitude AS "longitude",
          latitude AS "latitude"
   FROM "GD".v_gd_trace_today
   WHERE latitude IS NOT NULL
     AND longitude IS NOT NULL)
WHERE ROWNUM <= 50000;
