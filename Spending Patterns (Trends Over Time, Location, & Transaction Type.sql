use fraud_db;
 -- 2 Spending Patterns (Trends Over Time, Location, & Transaction Type)
 
 -- 8.	Find the (count) spending of each category per month
 
 Select month(tran_date) as month,count(category)as cat_count
 from cc_trx
 group by month(tran_date), category
 ORDER BY cat_count;
 
 
 -- 8a  Find the most common category overall across all months
 
 
 SELECT 
    MONTH(tran_date) AS month, 
    category, 
    COUNT(category) AS cat_count
FROM 
    cc_trx
GROUP BY 
    MONTH(tran_date), 
    category
ORDER BY 
    month, cat_count DESC
LIMIT 1;


-- 8b Find the most common category for each  month 
SELECT 
    month, 
    category, 
    cat_count
FROM (
    SELECT 
        MONTH(tran_date) AS month, 
        category, 
        COUNT(category) AS cat_count,
        ROW_NUMBER() OVER (PARTITION BY MONTH(tran_date) ORDER BY COUNT(category) DESC) AS row_num
    FROM 
        cc_trx
    GROUP BY 
        MONTH(tran_date), 
        category
) AS ranked_categories
WHERE row_num = 1
ORDER BY 
    month;
    
    
-- 9 Compare average spending per transaction type (POS vs. online).

Select round(avg(amount),2) as avg_spent,transaction_type as trx_type
from cc_trx
GROUP BY trx_type;


-- 10 Find out if customers spend more on weekends vs. weekdays .

SELECT 
    CASE 
        WHEN DAYOFWEEK(tran_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    gender,
    ROUND(SUM(amount), 2) AS amt_spent,category
FROM 
    cc_trx
GROUP BY 
    day_type, gender,category;


-- Explanation:
-- DAYOFWEEK(tran_date) is used to check the day of the week for each transaction.
-- The CASE statement is used to categorize the days as "Weekend" (if it's Sunday or Saturday) or "Weekday" (Monday to Friday).
-- We're grouping by day_type (the calculated weekend or weekday) and gender to see spending patterns for each group. 

-- 

-- 10a Top 5 spending categories by gender for weekdays and weekends--(data is limited no other categories)

SELECT 
    day_type, 
    gender, 
    category, 
    amt_spent
FROM (
    SELECT 
        CASE 
            WHEN DAYOFWEEK(tran_date) IN (1, 7) THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,
        gender, 
        category, 
        ROUND(SUM(amount), 2) AS amt_spent,
        ROW_NUMBER() OVER (PARTITION BY 
            CASE 
                WHEN DAYOFWEEK(tran_date) IN (1, 7) THEN 'Weekend'
                ELSE 'Weekday'
            END,
            gender 
            ORDER BY SUM(amount) DESC) AS rnk
    FROM 
        cc_trx
    GROUP BY 
        gender, category, tran_date
) AS ranked_categories
WHERE rnk <= 5
ORDER BY day_type, gender, rnk;



-- 11.	Determine the percentage of transactions over $1000 (high_transaction_flag = 1).

SELECT 
    -- Calculate the percentage of transactions over $1000
    ROUND((COUNT(CASE WHEN amount > 1000 THEN 1 END) / total_trx_count) * 100, 2) AS high_trx_percentage
FROM 
    cc_trx,
    (
        -- Subquery: Get the total number of transactions in the dataset
        SELECT COUNT(*) AS total_trx_count FROM cc_trx
    ) AS total_trx;



-- The comment before the subquery explains that it's calculating the total number of transactions in the dataset.
-- The main query then calculates the percentage of transactions where amount > 1000 compared to the total count from the subquery.



-- Explanation:
-- Subquery: (SELECT COUNT(*) AS total_trx_count FROM cc_trx) AS total_trx:

-- This counts the total number of transactions in the dataset and gives it the alias total_trx_count. 
-- It’s calculating the denominator — the total number of transactions.
-- COUNT(CASE WHEN amount > 1000 THEN 1 END):

-- This counts the number of transactions where the amount is greater than $1000.
-- The CASE WHEN amount > 1000 THEN 1 END part works like a filter. 
-- If the transaction is over $1000, it counts as 1, otherwise, it counts as NULL (which is not included in the COUNT).
-- ROUND((COUNT(...) / total_trx_count) * 100, 2):

-- This divides the number of transactions over $1000 by the total number of transactions 
-- (using the result from the subquery), then multiplies by 100 to get the percentage. 
-- Finally, it rounds the result to 2 decimal places.



-- 12.	Compare spending habits in different age groups (e.g., 18-25, 26-40, etc.)

SELECT 
    -- Display the actual age range as a string
    CASE
        WHEN age BETWEEN 6 AND 12 THEN '6-12 (Children)'
        WHEN age BETWEEN 13 AND 19 THEN '13-19 (Teens)'
        WHEN age BETWEEN 20 AND 39 THEN '20-39 (Young Adults)'
        WHEN age BETWEEN 40 AND 64 THEN '40-64 (Mid-Aged Adults)'
        WHEN age >= 65 THEN '65+ (Senior)'
        ELSE 'Other'
    END AS age_range,
    ROUND(AVG(amount), 2) AS avg_spent,  -- Average amount spent
    COUNT(*) AS num_trx  -- Number of transactions in each age group
FROM 
    cc_trx
GROUP BY 
    CASE
        WHEN age BETWEEN 6 AND 12 THEN '6-12 (Children)'
        WHEN age BETWEEN 13 AND 19 THEN '13-19 (Teens)'
        WHEN age BETWEEN 20 AND 39 THEN '20-39 (Young Adults)'
        WHEN age BETWEEN 40 AND 64 THEN '40-64 (Mid-Aged Adults)'
        WHEN age >= 65 THEN '65+ (Senior)'
        ELSE 'Other'
    END;


-- Explanation:
-- The CASE expression categorizes the age into ranges like "Children," "Teens," etc.
-- ROUND(AVG(amount), 2) calculates the average amount spent by each age group, rounded to 2 decimal places.
-- COUNT(*) counts the number of transactions for each age group.
-- The GROUP BY now repeats the same CASE expression to ensure it groups the data properly by age range.

-- The reason SQL requires the same `CASE` statement to be used in both the **`SELECT`** and **`GROUP BY`** clauses is that
-- **SQL needs to know how to group the rows before it can compute aggregates** like `AVG` or `COUNT`.

-- Here's why:

 -- **`SELECT` Clause**: This is where you define what you want to show in the final output. 
 -- In this case, you want to display the **age range** as a string.

 -- **`GROUP BY` Clause**: This is where you tell SQL how to group the rows in your data to perform aggregation (like `AVG` and `COUNT`). 
 -- Since you're using a computed value for grouping (like the age range), SQL needs the exact same logic in the `GROUP BY` to properly aggregate the data.

-- While it may feel repetitive, it’s just the way SQL processes grouping and aggregation—
-- it's a bit rigid but effective once you get used to it.

-- It's a trade-off for flexibility, but it would definitely be more elegant 
-- if SQL allowed for reusing computed columns directly across clauses. 

-- 13.	Find the top 3 merchants by  transaction volume and category
SELECT count(rec_num) as trx_count,merchant,category
from cc_trx
group by merchant,Category
order by merchant desc limit 3;


-- 14 Identify top 5 cities and states that have the highest average spending per transaction.
Select city,state, round(avg(amount),2) as avg_amt_spent
from cc_trx
group by city,state
order by avg_amt_spent desc limit 5;
