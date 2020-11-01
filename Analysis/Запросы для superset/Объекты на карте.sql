SELECT "lat_list",
       "__timestamp",
       "AVG(alt)"
FROM
  (SELECT lat_list AS "lat_list",
          TRUNC(CAST(government_contract_date as DATE), 'DDD') AS "__timestamp",
          AVG(alt) AS "AVG(alt)"
   FROM "GD".v_gd_object_area_polygons
   GROUP BY lat_list,
            TRUNC(CAST(government_contract_date as DATE), 'DDD')
   ORDER BY AVG(alt) DESC)
WHERE ROWNUM <= 10000;
