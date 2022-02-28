-- 1. Explore underlying data
  -- Study the columns: 
    -- created_at (object -- this datatype is varchar or text datatype, so need to convert this to varchar)
    -- value
-- 2. Identify required columns
-- 3. Visualize the output 
  -- What aggregations I need to implement

-- required columns: created_at, value
-- output: year-month using created_at, month-over-month percentage change using the value column

-- 1. Format date to YYYY-MM
  -- cast column to date dtype
  -- format date using to_char()

-- 2. Calculate month-over-month percentage change in revenue
  -- formula: (this month's revenue - last month's revenue) / last month's revenue
  -- 2a. Calculate the total revenue of the current month (or day's value)
  -- 2b. Calculate the last month's revenue (or the last records revenue)
  -- 2c. Aggregate the dates to year-month
  -- 2d. Implement the month-over-month difference formula
  
SELECT
    -- TO_CHAR(CAST(created_at AS date), 'YYYY-MM') AS year_month
    TO_CHAR(created_at::date, 'YYYY-MM') AS year_month,
     -- LAG (???, 1) = just the row above it
    ROUND((SUM(value) - LAG(SUM(value), 1) OVER (w)) /
    LAG(SUM(value), 1) OVER (w) * 100, 2) AS revenue_diff
FROM sf_transactions
GROUP BY year_month
-- Applying a window alias
WINDOW w AS (ORDER BY TO_CHAR(created_at::date, 'YYYY-MM'))
ORDER BY year_month ASC;


-- My Solution:
-- 1. Understand my data
SELECT * FROM sf_transactions;
-- 2. Formulate approach
-- SELECT
    -- year-month date (YYYY-MM) fromat using to_date()
    -- percent change = (this month revenue - last month reveue) / last month revenue * 100 (populate from second month, rounded to second dec point)
-- SORT BY year (created-at)ASC
-- 3. Write Code
WITH revenue AS (
    SELECT 
        to_date(to_char(created_at, 'YYYY-MM'), 'YYYY-MM-01') year_month,
        SUM(value) AS monthly_revenue
    FROM sf_transactions 
    GROUP BY year_month
    ORDER BY year_month ASC
)
SELECT 
    b.year_month AS second_month,
    ROUND((b.monthly_revenue - a.monthly_revenue)/(a.monthly_revenue)*100, 2) AS percent_change
FROM revenue b
JOIN revenue a
    ON a.year_month = b.year_month - 1 * INTERVAL '1 month'
