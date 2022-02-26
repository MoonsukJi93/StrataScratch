-- URL: https://platform.stratascratch.com/coding/10300-premium-vs-freemium?utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=30hS-MjpU6E&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=3

-- SQL Syntax Best Practices: How to Structure Your Code
---- 1. Remove multiple nested queries
---- 2. Ensure consistent aliases
---- 3. Remove unnecessary order by clauses
---- 4. Remove unnecessary subqueries and ctes
---- 5. HAVING vs. WHERE
---- 6. Formatting


WITH all_downloads AS
    (
        SELECT downlds.date,
               sum(CASE WHEN accounts.paying_customer = 'yes' THEN downlds.downloads END) AS n_paying,
               sum(CASE WHEN accounts.paying_customer = 'no' THEN downlds.downloads END) AS n_nonpaying
         FROM ms_user_dimension users
         INNER JOIN ms_acc_dimension accounts ON users.acc_id = accounts.acc_id
         INNER JOIN ms_download_facts downlds ON users.user_id = downlds.user_id
         GROUP BY downlds.date)
SELECT date, 
       n_nonpaying,
       n_paying
FROM all_downloads
WHERE (n_nonpaying - n_paying) > 0
GROUP BY date, n_nonpaying, n_paying
ORDER BY date ASC;
