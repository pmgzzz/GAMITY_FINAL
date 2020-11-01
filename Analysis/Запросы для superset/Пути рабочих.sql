SELECT "employee_path",
       "__timestamp"
FROM
  (SELECT employee_path AS "employee_path",
          TRUNC(CAST(date_time as DATE), 'DDD') AS "__timestamp"
   FROM "GD".v_gd_trace_today
   WHERE date_time >= TO_TIMESTAMP('2020-10-25T00:00:00', 'YYYY-MM-DD"T"HH24:MI:SS.ff6')
     AND date_time <= TO_TIMESTAMP('2020-11-01T00:00:00', 'YYYY-MM-DD"T"HH24:MI:SS.ff6')
     AND employee_path IS NOT NULL)
WHERE ROWNUM <= 10000;
