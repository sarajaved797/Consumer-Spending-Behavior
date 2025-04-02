USE fraud_db;

-- Calculating basic summary statistics for 'amount' and categorical columns 
SELECT 
    COUNT(*) AS total_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(MIN(amount), 2) AS min_amount,
    ROUND(MAX(amount), 2) AS max_amount,
    ROUND(STDDEV(amount), 2) AS stddev_amount
FROM cc_trx;

-- Frequency distribution for categorical column 'Category'
SELECT Category, COUNT(*) AS frequency
FROM cc_trx
GROUP BY Category;

-- Distribution of 'amount' in each category
SELECT 
    Category, 
    COUNT(*) AS count, 
    ROUND(AVG(amount), 2) AS avg_amount, 
    ROUND(MIN(amount), 2) AS min_amount, 
    ROUND(MAX(amount), 2) AS max_amount
FROM cc_trx
GROUP BY Category;

-- Flagging high-value transactions (over $1000)--- my defination of potential fraudulatent transaction
ALTER TABLE cc_trx ADD COLUMN high_transaction_flag BOOLEAN;

UPDATE cc_trx 
SET high_transaction_flag = CASE
    WHEN amount > 1000 THEN TRUE
    ELSE FALSE
END;

-- Feature Engineering---creating new columns for in depth analysis
-- Adding 'Payment_method' and 'Transaction_Type' columns based on 'category' column
ALTER TABLE cc_trx 
ADD COLUMN Payment_method VARCHAR(255), 
ADD COLUMN Transaction_Type VARCHAR(255);

-- Now inputting data into the columns created
UPDATE cc_trx
SET 
    Transaction_Type = CASE
        WHEN category LIKE '%_pos' THEN 'POS'
        WHEN category LIKE '%_net' THEN 'Net'
        ELSE 'Other'
    END;


-- Checking counts of 'Transaction_Type'
SELECT Transaction_Type, COUNT(*) AS Count
FROM cc_trx
GROUP BY Transaction_Type;

-- Cleaning up 'Transaction_Type' by setting NULL or empty values to 'Other'
UPDATE cc_trx
SET Transaction_Type = 'Other'
WHERE Transaction_Type IS NULL OR Transaction_Type = '';


-- Dropping the  'Payment_method' column (since it's no longer needed)
ALTER TABLE cc_trx  
DROP COLUMN Payment_method;
