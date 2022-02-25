-- URL: https://platform.stratascratch.com/coding/2059-player-with-longest-streak?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube Video: https://www.youtube.com/watch?v=hMUf7DqG1nQ&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=2

-- 1. Understand the Data
-- 2. Formulate Approach

---- VARIANT A: using 2 window functions ----
-- Assign unique ID numbers to different streaks:
WITH cte AS( -- we can reuse this whole query
    SELECT *,
    -- The first window function numbers the rows separately for each player
    ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY match_date ASC) row_number1,
    -- Modifided PARTITION BY statement allows to number rows based on the match result
    -- The second window function numbers rows separatedly for each player-result pair
    ROW_NUMBER() OVER (PARTITION BY player_id, match_result ORDER BY match_date ASC) row_number2,
    -- streak_id is the difference between results of the two window functions
    (ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY match_date ASC)) - (ROW_NUMBER() OVER (PARTITION BY player_id, match_result ORDER BY match_date ASC)) streak_id
    FROM players_results
    ORDER BY player_id, match_date ASC
)

-- output the players with longest streaks
SELECT DISTINCT player_id,
                streak_length
FROM (
-- aggregate by streak and count number of rows
    SELECT player_id,
           match_result AS streak_result,
           streak_id,
           count(*) AS streak_length,
           -- RANK(): window function for assigning ranking values to rows
           RANK() OVER (ORDER BY count(*) DESC) AS rnk
    FROM cte
    WHERE match_result = 'W'
    GROUP BY player_id,
             match_result,
             streak_id
    ORDER BY player_id,
             streak_id) a
WHERE rnk = 1;
-- I'm aggregating the data by a player_id-streak_result-streak_id triples

---- VARIANT B: counting previous different results ----

-- assign unique ID numbers to different streaks
WITH cte AS    
    (SELECT *, 
    -- count the numbers of rows from the original table
    -- the subquery appears as a new column when I run the code
        (SELECT COUNT(*) AS streak_id -- The inner query returns the streak ID
            FROM players_results prev_results
            -- The inner query now counts the number of matches of each player
            WHERE curr_results.player_id = prev_results.player_id
            -- The inner query now counts the number of previous matches 
            AND prev_results.match_date <= curr_results.match_date
            -- The inner query now counts the number of previous matches with different result
            AND prev_results.match_result <> curr_results.match_result)
        FROM players_results curr_results)

-- output the players with longest streaks
SELECT DISTINCT player_id,
                streak_length

FROM(
    -- aggregate by streak and count number of rows
    SELECT player_id,
           match_result AS streak_result,
           streak_id,
           count(*) AS streak_length,
           -- rank the streak from longest to shortest
           rank() OVER (ORDER BY count(*) DESC) AS rnk
    FROM cte
    -- filter the data to only output winning streaks
    WHERE match_result = 'W'
    GROUP BY player_id,
             streak_result,
             streak_id
    -- aggregating the data by streak the same as in the previous approach
    ORDER BY player_id,
             streak_id) a
-- The condition rnk=1 allows us to only return rows with longest streaks
WHERE rnk = 1

-- 3. Code Execution
-- While the second approach is more logical, the first results in cleaner code
-- The first approach is faster and more efficient
