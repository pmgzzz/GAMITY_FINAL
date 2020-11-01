SELECT "object_name",
       "post_name",
       "__timestamp",
       "count"
FROM
  (SELECT object_name AS "object_name",
          post_name AS "post_name",
          TRUNC(CAST(date_time as DATE), 'HH') AS "__timestamp",
          COUNT(*) AS "count"
   FROM "GD".v_gd_trace_today
   JOIN
     (SELECT "object_name__",
             "post_name__",
             "mme_inner__"
      FROM
        (SELECT object_name AS "object_name__",
                post_name AS "post_name__",
                COUNT(*) AS "mme_inner__"
         FROM "GD".v_gd_trace_today
         GROUP BY object_name,
                  post_name
         ORDER BY COUNT(*) DESC)
      WHERE ROWNUM <= 5) anon_1 ON object_name = "object_name__"
   AND post_name = "post_name__"
   GROUP BY object_name,
            post_name,
            TRUNC(CAST(date_time as DATE), 'HH')
   ORDER BY COUNT(*) DESC)
WHERE ROWNUM <= 10000;
