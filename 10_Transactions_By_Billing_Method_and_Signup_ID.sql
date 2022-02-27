
-- My Solution:
  -- 1. Understand my data
  -- signups: signup_id, signup_start_date, signup_stop_date, plain_id, location
  -- transactions: transaction_id, signup_id, transaction_start_date, amt
  -- plans: id, billing_cycle, avg_revenue, currency
  -- 2. Formulate my approach
  -- SELECT billing_cycle, signup_id, AVG(amt)
  -- JOIN singups and transactions ON signup_id
  -- JOIN plans ON plan_id
  -- WHERE signup_start_date earlier than 10 months from March 2021.
  -- AVG(amt), GROUP BY  billing_cycle
  -- ORDER BY billing_cycle DESC, signup_id ASC

SELECT
    p.billing_cycle,
    s.signup_id,
    AVG(t.amt) AS transaction_average
FROM signups s
JOIN transactions t
    ON s.signup_id = t.signup_id
JOIN plans p
    ON s.plan_id = p.id
WHERE s.signup_start_date < '2021-03-01'::date - 10 * INTERVAL '1 months' -- The question gives 'March 2021' as a date but the result remains the same
GROUP BY s.signup_id, p.billing_cycle
ORDER BY p.billing_cycle DESC, s.signup_id ASC;

-- 1. Understand your data
---- List your assumption about the data columns. View first rows or talk to the 
---- interviewer about the data stored in that table to identify edge cases
-- 2. Formulate your approach
---- Logical steps I would take to solve the problem. Guide the interviewer through
---- your though process. If you are making a wrong assumption, they will help you out.
-- 3. Code Execution
---- Build my code in steps just like what I outlined with your interviewer. Write out
---- steps in how you are going to implement your code. Not complicate your code with
---- a lot of logic. One or two logical statements in each section of my code (subquery
---- or a cte). Add one or two logical statements as you code. Lastly, speak up as you
---- write your code.

-- foreign key: prefaced with the table name

-- Join the 3 tables together based on signup_id, plan_id.
-- Filter the data on transactions that were made early than 10 months ago from today using the transaction_start_date column.
   -- Subtract 10 months from today's data using 'now() - 10 * interval '1 month'' 
-- Calculate average amount of all transactions per user per billing cycle.
-- Sort date

SELECT 
    billing_cycle,
    s.signup_id,
    AVG(amt) AS avg_amt
FROM transactions t
JOIN signups s 
    ON t.signup_id = s.signup_id
JOIN plans p 
    ON s.plan_id = p.id
WHERE transaction_start_date < NOW() - 10 * INTERVAL '1 month'
GROUP BY
    billing_cycle,
    s.signup_id
ORDER BY
    billing_cycle DESC,
    s.signup_id ASC
-- 2020-05-28 - 10 months = 2020-08-28

-- Whether or not there's a way to optimize this code.
-- To me there is no way to optimize this code. CASE statement is not going to work in our approach, so we will not be
-- able to remove JOIN in this case. Using subquery or cte that has a WHERE clause can reduce the dataset, but not
-- affect the efficiency that much.
