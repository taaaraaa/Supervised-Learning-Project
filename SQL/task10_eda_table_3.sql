SELECT unique_carrier_name, SUM(passengers) AS total_passengers
INTO new_table_3
FROM passengers
GROUP BY unique_carrier_name

select * from new_table_3 

-- Select op_unique_carrier,AVG(total_distance) AS avg_total_distance
-- FROM new_table_2
-- GROUP BY op_unique_carrier