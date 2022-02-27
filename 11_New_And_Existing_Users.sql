-- URL: https://platform.stratascratch.com/coding/2028-new-and-existing-users?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube Video: https://www.youtube.com/watch?v=xtbMCAVXDmU&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=11

-- 1. Explore data
  -- Explore the column headers
  -- time_id, user_id (don't need to use all of them)
-- 2. List assumptions
  -- Narrow down the solution space.
  -- Listing your assumptions on how you are interviewing column headers
  -- or your data. Identify edge cases as you are talking to the interviewer
-- 3. Outline approach
-- 4. Code in increments
-- 5. Optimize code


-- time_id indicates when the user is using a service. All the data is
-- from 2020. This will help us identify new and existing users.
-- user_id is all we need to identify users.
-- Each time a user uses a service, it's logged in th table so users are listed multiple times in the table
-- Event_type is the service but that isn't needed for the solution since we're considering all services or events

-- Each step in your approach contains only 1 logical statement/business rule

-- Approach
  -- Find the new users which are defined as users that started using services for the first time. I can use the min() to find the first date a user used a service
  -- Calculate all the users that have used services by month. This will give us existing users once we subtract out the new users
  -- Join the new users and all users table by month
  -- Calculate the shares by dividing the count of new users by the count of all users. Calculating the share of existing users is merely the difference between 1 and the share of new users.

-- Coding in increments
  -- Find the new users which are defined as users that have started using services from the first time. I can use the min() to find the first date a user used a service. (Calculate new users)
WITH sq AS(
    SELECT
        user_id,
        MIN(time_id) AS new_user_start_date
    FROM fact_events
    GROUP BY user_id)
, new_users AS(
    SELECT
        DATE_PART('month', new_user_start_date) AS month,
        COUNT(DISTINCT user_id) AS new_users
    FROM sq
    GROUP BY month)
, all_users AS (
    -- Calculate all the users that have used services by month. This will give us existing users once we subtract out the new users
    SELECT
        DATE_PART('month', time_id) AS month,
        COUNT(DISTINCT user_id) AS all_users
    FROM fact_events
    GROUP BY month)
SELECT
-- Calculate user share
    au.month,
    new_users/all_users::decimal AS share_new_users,
    1 - (new_users/all_users::decimal) AS share_existing_users
FROM all_users au
-- Join tables
JOIN new_users nu
    ON nu.month = au.month;
 
-- Whether or not you can optimize this code?
  -- No way to optimize this code to optimize this code. 3 ctes take a lot of time.
  -- Using a CASE statment, you can bypass ctes or subqueries, but here, you are
  -- trying to get a count of users (both new and existing based on a month) but in
  -- a case statment, you are going row by row and evaluating the logic or data in that
  -- row, but in this case, we are aggregating the entire table and partitioning by month
  -- before we do it by month... So there's no way to make this faster by refactoring the code.
  -- Only way to make it faster is by indexing the data by month, which could help it run faster.
