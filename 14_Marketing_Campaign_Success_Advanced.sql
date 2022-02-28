-- URL: https://platform.stratascratch.com/coding/514-marketing-campaign-success-advanced?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=VYeevsVj4fU&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=14

-- 1. Identigy all scenarios and edge cases
-- 2. Individually map out solution for each scenario
-- 3. Keep the logic separate from each other

-- To be considered in the marketing campaign, user needs to buy
-- a product that isn't the same product as what was bought in
-- their first purchase date
  -- Product needs to be different
  -- Product needs to be purchasesd on a different day

-- Scenarios to consider
  -- user 28 = 1 item, 1 date of purchase (not eligible for marketing campaign)
  -- user 49 = multiple products, 1 date of purchase (not eligible for marketing campaign)
  -- user 50 = 1 product, multiple days (not elligible for marketing campaign)
  -- user 25 = multiple products, multiple days, but same products as the 1st day of purchase (not eligible for marketing campaign)
  -- user 46 = multiple dates, multiple products (should be in marketing campaign)
  
 SELECT *
 FROM marketing_campaign
 WHERE user_id = 28;

-- User bought multiple products but only has one product purchase
 SELECT *
 FROM marketing_campaign
 WHERE user_id = 49;

-- Same product purchased several times
 SELECT *
 FROM marketing_campaign
 WHERE user_id = 50;

-- Same multiple products purchased several times
 SELECT *
 FROM marketing_campaign
 WHERE user_id = 25;
 
 -- Different products purchased after the first purchase date (part of the marketing campaign)
 SELECT *
 FROM marketing_campaign
 WHERE user_id = 46;

-- My Solution: 24 - Incorrect b/c correct solution is 23 
-- (forgot to filter out user 25 with multiple products,
--  multiple days, but same products as the 1st day of purchase,
--  which is not eligible for marketing campaign)
SELECT * FROM marketing_campaign;
-- 1. Understand data
-- columns: user_id, created_at, product_id
-- 2 Formulate approach
-- SELECT COUNT(user_id)
-- GROUP BY user_id
-- edge case: users make multiple purchase on same day don't count (DONE)
-- edge case: users make only the same purchases over time (product_id)
-- 3. Write code
WITH more_than_one AS (
    SELECT
        user_id,
        COUNT(user_id)
    FROM marketing_campaign a
    GROUP BY user_id
    HAVING COUNT(user_id) > 1
)
,distinct_day AS (
    SELECT
        b.user_id,
        COUNT(DISTINCT a.created_at)
    FROM marketing_campaign a
    JOIN more_than_one b
        ON a.user_id = b.user_id
    GROUP BY b.user_id
    HAVING COUNT(DISTINCT a.created_at) > 1
)
, distinct_product AS (
    SELECT 
        b.user_id,
        COUNT (DISTINCT a.product_id)
    FROM marketing_campaign a
    JOIN distinct_day b
     ON a.user_id = b.user_id
    GROUP BY b.user_id
    HAVING COUNT (DISTINCT a.product_id) > 1
)
SELECT COUNT(*)
FROM distinct_product;

