-- URL: https://platform.stratascratch.com/coding/2055-average-customers-per-city?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/results?search_query=SQL+interview+in+data+engineer+facebook

-- Solution 1:
SELECT
    country.country_name AS country,
    city.city_name AS city,
    count(customer.id) AS total_customers
-- The table linkedin_country is the first table listed here,
-- so it's considered a reference table
FROM linkedin_country country
INNER JOIN linkedin_city city
    ON city.country_id = country.id
-- Join another table by writing the INNER JOIN keyword, after
-- which you write the third table you want to join
INNER JOIN linkedin_customers customer
    ON city.id = customer.city_id
GROUP BY
    country.country_name,
    city.city_name;

-- Variation:
-- Select all the columns from all three joined tables
SELECT *
FROM linkedin_city city
INNER JOIN linkedin_customers customers
    ON city.id = customers.city_id
INNER JOIN linkedin_country country
    ON city.country_id = country.id;
-- The output will show only data that exists in all three
-- tables that are joined

-- INNER JOIN returns:
-- Only the matching rows from the joined tables

-- LEFT JOIN returns:
-- All rows from the reference table. The rows that
-- don't match will be NULL.

-- No matching values in the column id, business_name,
-- and city_id
SELECT *
-- The table linkedin_city is the first one in this query,
-- so it's a reference table
FROM linkedin_city city
LEFT JOIN linkedin_customers customers
    ON city.id = customers.city_id
LEFT JOIN linkedin_country country
    ON city.country_id = country.id;
-- A general priniple is if you use one LEFT JOIN, all the
-- remaining joins should usually be LEFT JOINs too

SELECT *


FROM linkedin_customers customers
LEFT JOIN linkedin_city city
    ON city.id = customers.city_id
LEFT JOIN linkedin_country country
    ON city.country_id = country.id;
-- No New York, and there is no USA in this table
-- Because the table linkedin_customers is the reference
-- table. This is your basis for getting the number of rows

-- If you don't choose the right table as your reference table,
-- you can get your answers completely wrong.

-- Solution 2:
-- Use the LEFT JOIN, and everything else will remain the same
SELECT
    country.country_name AS country,
    city.city_name AS city,
    count(customer.id) AS total_customers
-- The table linkedin_country is the first table listed here,
-- so it's considered a reference table
FROM linkedin_country country -- reference table
LEFT JOIN linkedin_city city
    ON city.country_id = country.id
-- Join another table by writing the INNER JOIN keyword, after
-- which you write the third table you want to join
LEFT JOIN linkedin_customers customer
    ON city.id = customer.city_id
GROUP BY
    country.country_name,
    city.city_name;
-- Compared to the INNER JOIN output, these's one additional
-- row. If you had used as a reference table, the result would
-- have been the same as when using the INNER JOIN

-- Difference between getting the correct and the wrong answer
