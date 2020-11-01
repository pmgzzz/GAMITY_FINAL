SELECT "object_name",
       "__timestamp",
       "count"
FROM
  (SELECT object_name AS "object_name",
          TRUNC(CAST(date_time as DATE), 'HH') AS "__timestamp",
          COUNT(*) AS "count"
   FROM "GD".v_gd_trace_today
   WHERE object_name IN ('»Õ»ŒÕ –¿Õ (‘√”)')
   GROUP BY object_name,
            TRUNC(CAST(date_time as DATE), 'HH')
   ORDER BY COUNT(*) DESC)
WHERE ROWNUM <= 10000;
