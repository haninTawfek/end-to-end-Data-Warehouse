-- Customers
-- ================1- Nulls======
select *
from Bronze.Customers;

SELECT 
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS blank_id,
    SUM(CASE WHEN loyalty_tier IS NULL OR loyalty_tier = '' THEN 1 ELSE 0 END) AS blank_loyality,
    SUM(CASE WHEN gender IS NULL OR gender = '' THEN 1 ELSE 0 END) AS blank_gender,
    SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) AS blank_city,
    SUM(CASE WHEN job IS NULL OR job = '' THEN 1 ELSE 0 END) AS blank_job,
    SUM(CASE WHEN zip IS NULL OR zip = '' THEN 1 ELSE 0 END) AS blank_zip
FROM Bronze.Customers;

-- ============= 2- Confirm zip blank
SELECT 
    t1.[entry_mode],
    t2.[zip],
    COUNT(*) AS CNT
FROM Bronze.Transactions t1
JOIN Bronze.Customers t2 
    ON t1.[customer_id] = t2.[customer_id]
WHERE t2.[zip] IS NULL OR t2.[zip] = ''
GROUP BY 
    t1.[entry_mode],
    t2.[zip];
-- ================3- Inconsistent Categorical Values======
Select Distinct gender from Bronze.Customers;
Select Distinct loyalty_tier from Bronze.Customers;
Select Distinct email_domain from Bronze.Customers;
Select Distinct job from Bronze.Customers;

-- ================4- Duplicates IDS======
Select customer_id,
  count(*) AS cnt
  from Bronze.Customers
  group by(customer_id)
  having COUNT(*) > 1;
-- ================5- Total Rows count======
Select count(*) AS Total_rows
  from Bronze.Customers;
------------------------------------------------------------------
-- Merchants
-- ================1- Nulls======
select *
from Bronze.Merchants;

SELECT 
    SUM(CASE WHEN merchant_id IS NULL OR merchant_id = '' THEN 1 ELSE 0 END) AS blank_id
FROM Bronze.Merchants;

-- ================2- Inconsistent Categorical Values======
Select Distinct dominant_category from Bronze.Merchants;

-- ================3- Duplicates IDS======
Select merchant_id,
  count(*) AS cnt
  from Bronze.Merchants
  group by(merchant_id)
  having COUNT(*) > 1;
-- ================4- Total Rows count======
Select count(*) AS Total_rows
  from Bronze.Merchants;
---------------------------------------------------

-- Transaction
-- ================1- Nulls======
select *
from Bronze.Transactions;

SELECT 
    SUM(CASE WHEN transaction_id IS NULL OR transaction_id = '' THEN 1 ELSE 0 END) AS blank_id,
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS blank_customer_id,
    SUM(CASE WHEN merchant_id IS NULL OR merchant_id = '' THEN 1 ELSE 0 END) AS blank_merchant_id,
    SUM(CASE WHEN session_id IS NULL OR session_id = '' THEN 1 ELSE 0 END) AS blank_session_id,
    SUM(CASE WHEN trans_date_trans_time IS NULL OR trans_date_trans_time = '' THEN 1 ELSE 0 END) AS blank_Date,
    SUM(CASE WHEN amt IS NULL OR amt = '' THEN 1 ELSE 0 END) AS blank_amt,
    SUM(CASE WHEN tax_amt IS NULL OR tax_amt = '' THEN 1 ELSE 0 END) AS blank_tax_amt,
    SUM(CASE WHEN discount_amt IS NULL OR discount_amt = '' THEN 1 ELSE 0 END) AS blank_discount_amt
FROM Bronze.Transactions;

-- ================2- Inconsistent Categorical Values======
Select Distinct category from Bronze.Transactions;
Select Distinct payment_method from Bronze.Transactions;
Select Distinct transaction_status from Bronze.Transactions;
Select Distinct device_type from Bronze.Transactions;
Select Distinct entry_mode from Bronze.Transactions;
Select Distinct channel from Bronze.Transactions;

-- ================3- Duplicates IDS======
Select transaction_id,
  count(*) AS cnt
  from Bronze.Transactions
  group by(transaction_id)
  having COUNT(*) > 1;
-- ==================4- Orphan customers=====
select t.* from Bronze.Transactions AS t
left join Bronze.Customers AS u
    ON TRY_CAST(t.customer_id As int) = TRY_CAST(u.customer_id AS int)
WHERE u.customer_id IS NULL;

select t.* from Bronze.Transactions AS t
left join Bronze.Merchants AS m
    ON TRY_CAST(t.merchant_id As int) = TRY_CAST(m.merchant_id AS int)
WHERE m.merchant_id IS NULL;
-- ================5- Total Rows count======
Select count(*) AS Total_rows
  from Bronze.Transactions;
