SELECT op_unique_carrier, EXTRACT(MONTH FROM CAST(fl_date AS DATE)) AS month, SUM(arr_delay) AS total_delay
INTO new_table
FROM flights
GROUP BY op_unique_carrier, month


Select op_unique_carrier,AVG(total_delay) AS avg_monthly_delay
FROM new_table
GROUP BY op_unique_carrier