-- URL: https://platform.stratascratch.com/coding/2036-lowest-revenue-generated-restaurants?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=T1UhSuKqy3A&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=9

-- 1. Understand your data
---- Understand the columns I need to use and the values in those
---- columns to see what data I can use
-- SELECT * FROM doordash_delivery;
-- 2. Formulate your approach
---- Write down the steps you will need to take to build your 
---- solutions.Communicate with the interviewer, write down each step
---- in sentence for what you are going to do and get the interviewer
---- approve your steps.
-- 3. Code Execution
---- Code up each step. As you are coding, speak to your interviewer
---- what you are coding and what functions you are using.

-- Filter data to use only May 2020 using customer_placed_order_datetime column
-- Calculate revenue by sum(order_total) and grouping by restaurant_id
-- Find percentiles by splitting total order into even buckets using NTILE(50) to give you 2% buckets
-- Isolate the 1st NTLIE using an outer query

-- NTILE() function makes the first bucket bigger
WITH cte AS (
    SELECT 
        restaurant_id,
        SUM(order_total) AS total_order,
        NTILE(50) OVER (ORDER BY SUM(order_total)) 
    FROM doordash_delivery
    WHERE customer_placed_order_datetime BETWEEN '2020-05-01' AND '2020-05-31'
    -- >= and <=
    GROUP BY restaurant_id
    )

SELECT
    restaurant_id,
    total_order
FROM cte
WHERE NTILE=1
ORDER BY 2 DESC

-- Interviewer Question: Is there a way to optimize your code?
-- Talk about any optimiztion that can take place. If not, how to structure your code
---- Having a subquery is computationally heavy. You can write a common table expression (cte).
---- It's probably going to take just as long to execute and run through but in terms of 
---- readability, it's a littl it easier to read a cte than a subquery. Another advantage
---- of using a cte is that you can reuse that table or cte in other parts of the query.
