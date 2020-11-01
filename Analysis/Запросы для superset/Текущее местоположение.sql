SELECT "longitude",
       "latitude",
       "post_name"
FROM
  (SELECT longitude AS "longitude",
          latitude AS "latitude",
          post_name AS "post_name"
   FROM "GD".v_gd_trace_current
   WHERE latitude IS NOT NULL
     AND longitude IS NOT NULL)
WHERE ROWNUM <= 10000;
