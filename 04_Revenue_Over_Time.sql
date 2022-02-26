-- URL: https://platform.stratascratch.com/coding/10314-revenue-over-time?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=GeJUvdkJKEc&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=4

-- 3-STEP SOLUTION FRAMEWORK

-- 1. UNDERSTAND YOUR DATA
---- For questions, ask the interviewer for example values.
---- Returns = Negative Prchase Values (Exclude This!)

SELECT * FROM amazon_purchases;

-- 2. FORMULATE YOUR APPROACH
---- Breaking down your solution in steps and writing out each step in text format,
---- not writing out in code to get it validated by an interviewer.
---- Use COMMON TABLE EXPRESSION (CTE) AND INTERVAL FUNCTION to get our data structures to calculate 3-month rolling average.

-- 3.A WRITE CODE 

WITH revenues as( -- Define CTE with total revenue per month
    SELECT to_date(to_char(created_at::date, 'YYYY-MM'), 'YYYY-MM-01') AS month_year, -- Type cast column to data dtype when aggregating
           SUM(purchase_amt) AS revenue_month
    FROM amazon_purchases
    WHERE purchase_amt >= 0 -- Filter out negative purchase amounts
    GROUP BY month_year)

SELECT 
    to_char(m1.month_year, 'YYYY-MM') AS month,
    (m1.revenue_month + m2.revenue_month + m3.revenue_month)/3 AS rolling_avg -- Calculate average
FROM revenues m1
JOIN revenues m2 -- Merge the CTE with itself twice adding a monthly shift
    ON m2.month_year = m1.month_year - INTERVAL '1 months'
JOIN revenues m3
    ON m3.month_year = m1.month_year - INTERVAL '2 months'
ORDER BY m2.month_year; -- Order results earliest to latest

-- This solution doesn't include the rolling average for January and February

-- 3.B WRITE CODE

-- Define CTE with total revenue per month
-- Type cast column to data dtype when aggregating
-- Filter out negative purchase amounts
-- Use window function to calculate rolling average (different approach from the first solution)
-- Order results from earliest month to latest month

WITH revenues AS (
    SELECT to_char(created_at::date, 'YYYY-MM') AS month_year,
           SUM(purchase_amt) AS revenue_month
    FROM amazon_purchases
    WHERE purchase_amt >= 0
    GROUP BY month_year)

SELECT month_year,
	   -- Use window function to calculate rolling average
       avg(revenue_month) OVER (ORDER BY month_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM revenues

-- COMPARISON OF APPROACHES / OPTIMIZATION DISCUSSION

-- My Solution: Place ORDER BY in CTE:
WITH revenues AS (
     SELECT to_char(created_at::date, 'YYYY-MM') AS month_year,
            SUM(purchase_amt) AS revenue_month
        FROM amazon_purchases
        WHERE purchase_amt >= 0
        GROUP BY month_year
        ORDER BY month_year)

SELECT month_year,
       avg(revenue_month) OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
       -- window of rows that the function operates on is three rows in size, 
       -- starting with 2 rows preceding until and including the current row
FROM revenues
