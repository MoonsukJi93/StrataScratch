-- URL: https://platform.stratascratch.com/coding/2007-rank-variance-per-country?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=PlpUo6bHsBQ&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=6

-- 1. Understand your data
-- 2. Formulate your approach
-- 3. Code Execution

-- Join the 2 tables on user_id (LEFT JOIN because not all users may
-- have made comments)
-- Filter our table for Dec 2019 and Jan 2020 (create 2 subqueries)
-- Exclude rows where country is empty
-- Sum the number of comments per country
-- Create subqueries for Dec and Jan (Used cte instead of subqueries)
-- Use a LEFT JOIN to compare Dec 19 and Jan 20 comments
-- Rank 2019 comment counts and 2020 comment comments
-- Apply final filter to fetch only countries with ranking decline(Jan rank < Dec rank)

with dec_summary as (
    SELECT
        country,
        sum(number_of_comments) AS number_of_comments_dec,
        dense_rank() over(order by sum(number_of_comments) DESC) as country_rank -- dense_rank(): doesn't skip rankings
    FROM fb_active_users as a
    LEFT JOIN fb_comments_count as b
        on a.user_id = b.user_id
    WHERE created_at <= '2019-12-31' and created_at >= '2019-12-01'
        AND country IS NOT NULL
    GROUP BY country
),
jan_summary as (
    SELECT
        country,
        sum(number_of_comments) AS number_of_comments_jan,
        dense_rank() over(order by sum(number_of_comments) DESC) as country_rank -- dense_rank(): doesn't skip rankings
    FROM fb_active_users as a
    LEFT JOIN fb_comments_count as b
        on a.user_id = b.user_id
    WHERE created_at <= '2020-01-31' and created_at >= '2020-01-01'
        AND country IS NOT NULL
    GROUP BY country
)
SELECT j.country
FROM jan_summary j
LEFT JOIN dec_summary d ON d.country = j.country
WHERE (j.country_rank < d.country_rank) OR d.country IS NULL;
-- countries that don't have comments in January, don't have risen in
-- rankings
