use fraud_db;

-- 3️ Fraud Detection (High-Risk Transactions & Suspicious Patterns)

 -- 15.	Gender which has more transactions in different states on the same day.
 
SELECT 
    gender,
    COUNT(*) AS trx_count,
    state,
    CASE
        WHEN DAYOFWEEK(tran_date) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(tran_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(tran_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(tran_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(tran_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(tran_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(tran_date) = 7 THEN 'Saturday'
    END AS trx_day
FROM cc_trx
GROUP BY gender, state, trx_day
HAVING COUNT(*) > 1
ORDER BY trx_count DESC;

-- 16 Identify transactions where the amount is .5% higher than the average for that gender.

SELECT gender, ROUND(AVG(amount), 2) AS avg_amt_spent
FROM cc_trx
GROUP BY gender;


SELECT 
    gender,
    COUNT(*) AS trx_count,
    ROUND(AVG(amount), 2) AS avg_amt_spent
FROM cc_trx
GROUP BY gender
HAVING COUNT(*) > 0
   AND AVG(amount) * .50 < 
   -- subquery
   (SELECT AVG(amount) FROM cc_trx WHERE gender = cc_trx.gender)
ORDER BY gender;


-- 17 Detect multiple high-value transactions ($1000+) within a short time frame (e.g., 1 hour)

SELECT 
    a.gender, 
    a.state, 
    a.tran_date, 
    a.amount,
    b.tran_date AS next_tran_date,
    b.amount AS next_tran_amount
FROM cc_trx a
JOIN cc_trx b
    ON a.gender = b.gender
    AND a.state = b.state
    AND a.tran_date < b.tran_date
WHERE a.amount >= 1000
    AND b.amount >= 1000
    AND TIMESTAMPDIFF(HOUR, a.tran_date, b.tran_date) <= 1
ORDER BY a.tran_date;




-- 18 Compare fraud-prone spending categories vs. normal categories spending among gender.
SELECT 
    category,
    gender,
    ROUND(SUM(amount), 2) AS amt_spent,
    ROUND((SUM(amount) / (SELECT SUM(amount) FROM cc_trx)) * 100, 2) AS percent_spent, -- subquery
    CASE 
        WHEN category IN ('entertainment', 'personal_care', 'misc_net', 'shopping_net') THEN 'fraud_prone'
        ELSE 'normal'
    END AS category_classification
FROM cc_trx
GROUP BY category, gender
ORDER BY category_classification DESC, percent_spent DESC;

