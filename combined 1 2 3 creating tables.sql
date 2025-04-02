-- Use the fraud database
USE fraud_db;

-- Create the cc_trx table if it doesn't already exist
CREATE TABLE IF NOT EXISTS cc_trx (
    MyUnknownColumn INT,
    trans_date_tran_time TEXT,
    merchant TEXT,
    category TEXT,
    amt DOUBLE,
    gender TEXT,
    city TEXT,
    state TEXT,
    zip INT,
    city_pop INT,
    job TEXT,
    dob TEXT,
    chunk_num INT
    -- Add other columns as needed
);

-- Insert data from each of your 21 tables into the cc_trx table
-- Replace the table names (e.g., fraud_data_1, cc_1, etc.) with the actual names of your CSV files.

INSERT INTO cc_trx (MyUnknownColumn, trans_date_tran_time, merchant, category, amt, gender, city, state, zip, city_pop, job, dob, chunk_num)
SELECT MyUnknownColumn, trans_date_tran_time, merchant, category, amt, gender, city, state, zip, city_pop, job, dob, chunk_num
FROM fraud_data_1;

INSERT INTO cc_trx (MyUnknownColumn, trans_date_tran_time, merchant, category, amt, gender, city, state, zip, city_pop, job, dob, chunk_num)
SELECT MyUnknownColumn, trans_date_tran_time, merchant, category, amt, gender, city, state, zip, city_pop, job, dob, chunk_num
FROM cc_1;

-- Continue adding INSERT INTO for each of 21 CSV tables
-- Example for a third table:
INSERT INTO cc_trx (MyUnknownColumn, trans_date_tran_time, merchant, category, amt, gender, city, state, zip, city_pop, job, dob, chunk_num)
SELECT MyUnknownColumn, trans_date_tran_time, merchant, category, amt, gender, city, state, zip, city_pop, job, dob, chunk_num
FROM fraud_data_2;

-- Repeat the above INSERT INTO for each of the remaining 18 tables (total of 21).
