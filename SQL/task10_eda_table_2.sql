SELECT unique_carrier_name, EXTRACT(MONTH FROM CAST(fl_date AS DATE)) AS month, SUM(distance) AS total_distance
INTO new_table_2
FROM flights
GROUP BY op_unique_carrier, month



Select op_unique_carrier,AVG(total_distance) AS avg_total_distance
FROM new_table_2
GROUP BY op_unique_carrier