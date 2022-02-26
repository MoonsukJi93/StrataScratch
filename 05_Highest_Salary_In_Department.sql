-- URL: https://platform.stratascratch.com/coding/9897-highest-salary-in-department?python&utm_source=youtube&utm_medium=click&utm_campaign=YT+description+link
-- YouTube: https://www.youtube.com/watch?v=GGURenNfXI0&list=PLv6MQO1Zzdmq5w4YkdkWyW8AaWatSQ0kX&index=5

-- My Solution:

WITH max_salary AS(
    SELECT
        department,
        MAX(salary)
    FROM employee
    GROUP BY department
)

SELECT department,
       first_name,
       salary
FROM employee
WHERE (department, salary) IN (SELECT * FROM max_salary);

-- 1. UNDERSTAND YOUR DATA
---- Explore the data or ask questions to interview about the data structure.
SELECT * FROM employee;
-- 2. FORMULATE YOUR APPROACH
---- Break down steps and explain to an interviewer
-- 3. CODE EXECUTION

-- Solution 1: Subquery
  -- Subquery to get department name and corresponding highest salary
  -- Use MAX() function to find the highest salary
  -- Group records by the department
  -- Use an outer query to find employees with matching values of the highest salary found in the subquery.

SELECT
    department,
    first_name,
    salary
FROM employee
WHERE (department, salary) IN (
    SELECT -- subquery
        department,
        MAX(salary)
    FROM employee
    GROUP BY department)

-- Solution 2: Self-Join
-- Define self-join table with department names and corresponding highest salaries
-- Use MAX() function to find the highest salary
-- Group records by the department
-- Join tables using the highest salary and department as keys so that you're left with the department and the highest salaries
-- Select necessary columns (first_name, department, salary)

SELECT
    e.first_name,
    e.department,
    e.salary
FROM employee e
JOIN (
    SELECT
        department,
        MAX(salary) AS max_salary
    FROM employee
    GROUP BY department) a
ON e.department=a.department AND e.salary=max_salary;

-- Solution 3: Window function - max()
-- Use a subquery to create an additional column with the highest salary in department
-- Use window function using OVER and PARTITION by department
-- In outer query only select 3 columns (first_name, department, salary)
-- Filter the results such that the salary equals the highest salary

SELECT
    department,
    first_name,
    salary
FROM (SELECT *,
       MAX(salary) OVER (PARTITION BY department) AS highest_salary
      FROM employee) a
WHERE salary = highest_salary;

-- Solution 4: Window function - rank()
    -- In subquery first name, department name, and salary
    -- Using Rank function and a window function, add a column with ranking of the salaries in each department
    -- Use the outer query to only leave rows where rank is 1

SELECT
    department,
    first_name,
    salary
FROM (
    SELECT department,
           first_name,
           salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
    FROM employee) a
WHERE rank = 1;

-- QUESTION: Which solution is the fastest?
---- Because each of these solutions have a subquery, we can't make the code any faster because we have to execute the subquery
---- before we execute the outer query. In general, window functions are generally faster because there aren't GROUP BY clause in the first
---- solution or a JOIN function in the second solution that slows things down a bit, so a window function is slightly faster. So, windows
---- function is the most fastest solution but there's no difference between MAX() function or RANK() function.
