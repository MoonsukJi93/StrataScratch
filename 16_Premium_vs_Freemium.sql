-- URL: https://platform.stratascratch.com/coding/10300-premium-vs-freemium?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=lG0PbUq4wkg&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=15

-- join the 3 tables together
-- categorize paying and non-paying users
-- count total number of downloads between user types
-- Include only records where non-paying customers have more downloads than paying customers
SELECT *
FROM (
    SELECT
        date,
        SUM(CASE WHEN paying_customer = 'yes' THEN downloads END) AS paying,
        SUM(CASE WHEN paying_customer = 'no' THEN downloads END) AS non_paying
    FROM ms_user_dimension a
    LEFT JOIN ms_acc_dimension b
        ON a.acc_id = b.acc_id
    LEFT JOIN ms_download_facts c
        ON a.user_id = c.user_id
    GROUP BY date
    ORDER BY date ASC) t
GROUP BY
    t.date,
    t.paying,
    t.non_paying
HAVING (non_paying - paying) > 0
ORDER BY t.date ASC

-- My Solution:
-- 1. Understand data
 -- columns: date, non-paying downloads, paying downloads
-- 2. Formulate approach
 -- SELECT SUM(non-paying download), SUM(paying download)
 -- JOIN ms_acc_dimension ON acc_id
 -- JOIN ms_download_facts ON user_id
 -- WHERE COUNT(download non-paying) > COUNT(download paying)
 -- GROUP BY date
 -- ORDER BY date
-- 3. Execute Code
WITH cte AS (
    SELECT
        c.date,
        -- total number of downloads for non-paying users
        SUM(CASE WHEN paying_customer='no' THEN downloads ELSE 0 END) AS total_non_paying,
        -- total number of downloads for paying users
        SUM(CASE WHEN paying_customer='yes' THEN downloads ELSE 0 END) AS total_paying
    FROM ms_user_dimension a
    JOIN ms_acc_dimension b
        ON a.acc_id = b.acc_id
    JOIN ms_download_facts c
        ON a.user_id = c.user_id
    GROUP BY c.date
    ORDER BY c.date ASC
)
SELECT *
FROM cte
WHERE total_non_paying > total_paying;
