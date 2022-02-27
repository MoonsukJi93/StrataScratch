-- 1. Understand your data
---- Understand values in the data set and column set
-- 2. Formulate your approach
---- Write down what I'm going to do to solve the problem and get it
---- validated by an interviewer. How to write out our data and what
---- functions we can use.
-- 3. Code execusion
---- Code my solution.

-- Filter data on client_id so we only are looking at mobile usage
-- Count the numbre of events for mobile usage
-- Rank records based on count of events
  -- row_number(), rank(), dense_rank()
  -- Conversation with your interviewer of you knowledge of ranking functions
-- Use an outer query to fetch data for 2 bottom ranks from the query written above.

SELECT
    customer_id,
    events
FROM (SELECT
        customer_id,
        COUNT(*) AS events,
        DENSE_RANK() OVER (ORDER BY COUNT(*)) AS rank
      FROM fact_events
      WHERE client_id = 'mobile'
      GROUP BY customer_id) subquery
WHERE rank <= 2
ORDER BY events ASC

-- How you write your queries really matter (execution time, memory use, RAM use)
-- Use a cte instead of a subquery. Can write other pieces of code there. OR I can create
-- permanent, temporary table so that I can reuse the code and don't have to run the 
-- subquery each an every time for other problems I have to solve.
-- In terms of execution & run-time, I can't make this query any faster.


-- My Solution: Incorrect with using a bad approach of using LIMIT 3
-- (b/c we can only know how many rows to limit onced we looked at the table)

---- cutomer_id = company
---- RANK()
---- mobile usage: number of events WHERE client_id = 'mobile'
---- GROUP BY customer_id
---- ORDER BY number of events ASC
---- return all companiles where multiple comapnies tied for bottom ranks (1 or 2)

SELECT customer_id,
       COUNT(event_id) AS number_of_events
FROM fact_events
WHERE client_id = 'mobile'
GROUP BY customer_id
ORDER BY DENSE_RANK() OVER (ORDER BY COUNT(event_id) ASC)
LIMIT 3;
