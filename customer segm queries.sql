use fraud_db;


-- Customer Segmentation Queries

-- 1.	Find the total transaction amount and count per customer.

SELECT 
    gender, 
    ROUND(SUM(amount), 2) AS tot_trx_amt, 
    COUNT(*) AS trx_count
FROM cc_trx
GROUP BY gender;


-- 2.Find the average spending per job type from highest to lowest.
Select round(avg(amount),2) avg_amt_spent,profession
from cc_trx
GROUP BY profession
order by avg_amt_spent desc;



-- 3. Identify the higher spending gender by calculating the top 10% based on total spending.
--  NTILE(10) splits the dataset into 10 equal parts and picks the top 10%.

SELECT gender, total_spent
FROM (
    SELECT 
        gender, 
        ROUND(SUM(amount), 2) AS total_spent,
        NTILE(10) OVER (ORDER BY SUM(amount) DESC) AS spending_decile
    FROM cc_trx
    GROUP BY gender
) subquery
WHERE spending_decile = 1;  -- Top 10% of spenders


--  4.	Show all categories ranked by frequency for each gender.
SELECT gender, category, COUNT(*) AS category_count
FROM cc_trx
GROUP BY gender, category
ORDER BY gender, category_count DESC;


-- 4. The most common category per gender
 SELECT gender, category, category_count
FROM (
    SELECT 
        gender, 
        category, 
        COUNT(*) AS category_count,
        RANK() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rnk
    FROM cc_trx
    GROUP BY gender, category
) subquery
WHERE rnk = 1;


-- 5. Determine the most common spending category per profession.

Select count(category) as count_cat,profession
from cc_trx
group by profession
ORDER BY count_cat desc limit 1;



-- 6.	Find the top 5 highest-spending states based on total transaction amounts.
Select round(sum(amount),2) as tot_amt_spent, state
from cc_trx
GROUP BY state
order by tot_amt_spent desc limit 5;


-- 6a  Find the top 5 highest-spending states per gender.

SELECT state, gender, tot_amt_spent,rnk
FROM (
    SELECT 
        state, 
        gender, 
        ROUND(SUM(amount), 2) AS tot_amt_spent,
        RANK() OVER (PARTITION BY gender ORDER BY SUM(amount) DESC) AS rnk
    FROM cc_trx
    GROUP BY state, gender
) subquery
WHERE rnk <= 5;


-- 7 Compare spending behavior in large cities vs. small cities 

SELECT 
    CASE 
        WHEN city_pop <= 5000 THEN 'Small City'
        ELSE 'Large City'
    END AS city_size,
    ROUND(AVG(amount), 2) AS avg_spent,
    COUNT(*) AS num_transactions
FROM cc_trx
GROUP BY city_size;




-- Explaination
-- CASE creates two groups: "Small City" vs. "Large City"
-- AVG(amount) shows average spending per city size
-- COUNT(*) shows how many transactions happened in each type of city



