-- URL: https://platform.stratascratch.com/coding/2004-number-of-comments-per-user-in-past-30-days?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=yY7yau9j3xk&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=7

-- 1. Understand your data
-- 2. Formulate your approach
-- 3. Code execution

-- Filter dataset from 2020-02-10 to 30 days before
-- Calculate the sum of the number of comments
-- Group by user id

-- dynamic method
SELECT 
    user_id,
    sum(number_of_comments) AS total_comments
FROM fb_comments_count
WHERE created_at BETWEEN ('2020-02-10'::date - 30 * INTERVAL '1 day') AND '2020-02-10'::date
GROUP BY user_id
-- INTERVAL: function that will help you create minutes of time for the 'datetime' data type
-- 30 * INTERVAL '1 day': 30 days as a 'datatime' data type

-- Additional Technical Concepts:
---- '2020-02-10'::date (cast '2020-02-10' to a 'date' data type using '::date')

-- cast() as date: can also be used in MySQL database as well
SELECT 
    user_id,
    sum(number_of_comments) AS total_comments
FROM fb_comments_count
WHERE created_at BETWEEN (cast('2020-02-10' as date) - 30 * INTERVAL '1 day') AND cast('2020-02-10' as date)
GROUP BY user_id

-- using >= and <=
SELECT 
    user_id,
    sum(number_of_comments) AS total_comments
FROM fb_comments_count
WHERE created_at >= (cast('2020-02-10' as date) - 30 * INTERVAL '1 day') AND created_at <= cast('2020-02-10' as date)
GROUP BY user_id


-- My Solution: (solution still matches :))

-- GROUP BY user_id
-- SUM(number_of_comments)
-- WHERE created b/w 2020-02-10 & 2020-01-10
-- WHERE number_of_comments != 0

SELECT
    user_id,
    SUM(number_of_comments) total_comments
FROM fb_comments_count
WHERE created_at <= '2020-02-10' AND created_at >= '2020-01-10' AND number_of_comments != 0
GROUP BY user_id;
