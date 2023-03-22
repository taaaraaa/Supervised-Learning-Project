-- -- Get column names of flights test 
-- SELECT
--     column_name,
--     data_type
-- FROM
--     information_schema.columns
-- WHERE
--     table_name = 'flights_test';



-- -- Get size of all tables
-- SELECT
--   schema_name,
--   relname,
--   pg_size_pretty(table_size) AS size,
--   table_size

-- FROM (
--        SELECT
--          pg_catalog.pg_namespace.nspname           AS schema_name,
--          relname,
--          pg_relation_size(pg_catalog.pg_class.oid) AS table_size

--        FROM pg_catalog.pg_class
--          JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
--      ) t
-- WHERE schema_name NOT LIKE 'pg_%'
-- ORDER BY table_size DESC;



-- -- Check # records in trainable data in flights table (Answer: 16M records)
-- SELECT Count(*) FROM flights;

-- -- Check structure of the flights table
-- SELECT * FROM flights LIMIT 100;
-- SELECT * FROM flights Where flights != 1 LIMIT 100;

-- -- Get date range of flights  {min: jan 1 2018, max: dec 31, 2019}
-- SELECT MIN(fl_date), MAX(fl_date) FROM flights;



-- -- Reducing Data Size - Part 1
-- -- 16M records is too large for our machines to process.
-- -- So we create 3 sample tables (small, 10k records; medium, 100k; large, 1,000k) for training the model. 
-- -- Since evauation is done with data from Jan 1-7 of 2020 we will chose dates near that point in the year.
-- -- There are approx. 154k flights per week, 22k flights per day.
-- -- Small dataset = Jan 1, 2019; medium = Jan 1-7, 2019; large = Jan 1-7, 2018 & Dec 24-Jan 14, 2019 & Dec 24-31, 2019
-- -- Reducing Data Size - Part 2
-- -- Most features from the flights table will not be available for predicting delays 1 week in advance, i.e. taxi time
-- -- Used features from flights_test and removed unnecessary and redundant columns: {branded_code_share, mkt_carrier,op_carrier_fl_num, flights, dup}
-- -- Reducing Data Size - Part 3
-- -- Notice that cancelled flights never have an arrival delay, and so are removable.
-- SELECT * FROM flights WHERE cancelled = 0 AND arr_delay != 0;


-- -- -- Large Data Pull: 6 weeks, 892k records: Jan 1-14, 2018 & Dec 24-Jan 14, 2019 & Dec 24-Dec 31, 2019
-- CREATE TABLE flights_sample_large AS (
-- SELECT 
-- fl_date, mkt_unique_carrier, mkt_carrier_fl_num, op_unique_carrier, tail_num, origin_airport_id, origin, origin_city_name, dest_airport_id, dest, dest_city_name, crs_dep_time, crs_arr_time, crs_elapsed_time, distance
-- , arr_delay
-- FROM flights
-- WHERE
-- 	cancelled = 0 AND
-- 	((fl_date::date >= '2018-01-01' AND fl_date::date <= '2018-01-14') OR
-- 	(fl_date::date >= '2018-12-24' AND fl_date::date <= '2019-01-14') OR
-- 	(fl_date::date >= '2019-12-24' AND fl_date::date <= '2019-12-31'))
-- );



-- -- Duplicate record check: most efficent using temporary table if possible.
-- -- Create a new temp table with only unique rows:
-- CREATE TABLE temp AS
--     SELECT DISTINCT ON (fl_date,mkt_unique_carrier, mkt_carrier_fl_num,tail_num,origin_airport_id,dest_airport_id) * FROM flights_sample_large;

-- -- Check the before and after counts:
-- SELECT COUNT(*) AS before FROM temp;
-- SELECT COUNT(*) AS after FROM flights_sample_large;

-- -- Now drop the original table & rename the temp one
-- DROP TABLE flights_sample_large;
-- ALTER TABLE temp RENAME TO flights_sample_large;



-- -- -- Small Data Pull: 1 day, 19k records: 2019-01-01  
-- CREATE TABLE flights_sample_small AS (
-- SELECT *
-- FROM flights_sample_large
-- WHERE fl_date::date = '2019-01-01'
-- );

-- -- -- Medium Data Pull: 1 week: 146k records: 2019-01-01 to 2019-01-07
-- CREATE TABLE flights_sample_medium AS (
-- SELECT *
-- FROM flights_sample_large
-- WHERE fl_date::date >= '2019-01-01' AND fl_date::date <= '2019-01-07'
-- );



-- Copy created sample tables to local machine, needed to be done using psql shell
-- \copy flights_sample_small TO '/Users/connorl/Downloads/LHL/w7-midterm_project/Supervised-Learning-Project/data/flights_sample_small.csv' CSV HEADER;
-- \copy flights_sample_medium TO '/Users/connorl/Downloads/LHL/w7-midterm_project/Supervised-Learning-Project/data/flights_sample_medium.csv' CSV HEADER;
-- \copy flights_sample_large TO '/Users/connorl/Downloads/LHL/w7-midterm_project/Supervised-Learning-Project/data/flights_sample_large.csv' CSV HEADER;