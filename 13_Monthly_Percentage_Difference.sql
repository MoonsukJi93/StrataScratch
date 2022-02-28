-- 1. Understand my data
select * from sf_transactions;
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
    ORDER BY year_month
)
SELECT 
    b.year_month AS second_month,
    ROUND((b.monthly_revenue - a.monthly_revenue)/(a.monthly_revenue)*100, 2) AS percent_change
FROM revenue b
JOIN revenue a
    ON a.year_month = b.year_month - 1 * INTERVAL '1 month'
