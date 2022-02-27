-- URL: https://platform.stratascratch.com/coding/2005-share-of-active-users?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=XRwxYOhHdE8&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=12

-- My Solution:

-- 1. Understand data
select * from fb_active_users;
-- 2. Formulate approach
-- SELECT monthly active users (COUNT(user_id))
-- WHERE country = USA, status = open
-- cte for active users
-- cte for active users in USA
-- share = ratio = active users in USA / all active users USA
-- 3. Write Code
WITH active_users_USA AS (
    SELECT 
        COUNT(user_id) AS active_users
    FROM fb_active_users
    WHERE country = 'USA' AND status = 'open'
)
, all_users_USA AS (
    SELECT COUNT(user_id) AS all_active_users
    FROM fb_active_users
    WHERE country = 'USA'
)
SELECT (1.0 * active_users)/all_active_users AS share_active_users_US
FROM active_users_USA, all_users_USA;

-- 1. Explore the data to take a look at how it behaves
/*
    SELECT
        user_id,
        COUNT(*)
    FROM fb_active_users
    WHERE country = 'USA'
    GROUP BY user_id;
*/
-- 2. Identify the required columns needed to solve the question
  -- user_id, status, country
-- 3. Visualize the output
-- output ratio (active users / all users)
  -- Filter for US users only
  -- Count the number of users with status = 'open'
  -- Count the number of total users
  -- Take the number of status open users and divide by the total number of users
  
-- 4. Code in increments
/*
SELECT
    COUNT(CASE WHEN STATUS = 'open' THEN user_id ELSE NULL END)/COUNT(*)::FLOAT AS ratio_active_users
FROM fb_active_users
WHERE country = 'USA';
*/

-- Using subquery:
  -- 1. more organized and logical
  -- 2. talking the interview through the logic in the subquery (logical step to take when you are guiding you interview)
  -- 3. This is not an efficient way to solve this problem
SELECT active_users/total_users::FLOAT AS share_active_users
FROM (
    SELECT
        COUNT(CASE WHEN STATUS = 'open' THEN user_id ELSE NULL END) AS active_users,
        COUNT(*) AS total_users
    FROM fb_active_users
    WHERE country = 'USA') a;
