-- =================== 1. Customers ============ --
Select 
    TRY_CAST(customer_id AS INT) AS customer_id,
    TRY_CAST(cc_num AS BIGINT) AS cc_num,
    TRY_CAST(first_name AS nvarchar(50)) AS first_name,
    TRY_CAST(last_name AS nvarchar(50)) AS last_name,
    ISNULL( LTRIM(RTRIM(gender)),'') AS gender,
    ISNULL( LTRIM(RTRIM(street)),'') AS street,
    ISNULL( LTRIM(RTRIM(city)),'') AS city,
    ISNULL( LTRIM(RTRIM(state)),'') AS state,
    TRY_CAST(LTRIM(RTRIM(zip)) AS float) AS zip,
    TRY_CAST(lat AS float) AS lat,
    TRY_CAST(long AS float) AS long,
    TRY_CAST(city_pop AS INT) AS city_pop,
    TRY_CAST(job AS nvarchar(50)) AS job,
    TRY_CAST(loyalty_tier AS nvarchar(50)) AS loyalty_tier,
    TRY_CAST(email_domain AS nvarchar(50)) AS email_domain,
    TRY_CAST(LTRIM(RTRIM(dob)) AS DATE) AS dob,
    TRY_CAST(LTRIM(RTRIM(signup_date)) AS DATE) AS signup_date
INTO Silver.Customers
From Bronze.Customers

Alter Table Silver.Customers Alter Column customer_id INT NOT NULL;
Alter Table Silver.Customers ADD Constraint pk_silver_customer Primary Key (customer_id);
ALTER TABLE Silver.Customers ADD Full_name NVARCHAR(100);
UPDATE Silver.Customers SET Full_name = CONCAT(LTRIM(RTRIM(first_name)), ' ', LTRIM(RTRIM(last_name)));

ALTER TABLE Silver.Customers
DROP COLUMN first_name, last_name;

WITH CityZipMode AS (
    SELECT 
        city, 
        zip,
        ROW_NUMBER() OVER(PARTITION BY city ORDER BY COUNT(*) DESC) AS rn
    FROM Silver.Customers
    WHERE zip IS NOT NULL
    GROUP BY city, zip
)
UPDATE s
SET s.zip = czm.zip
FROM Silver.Customers s
JOIN CityZipMode czm ON s.city = czm.city AND czm.rn = 1
WHERE s.zip IS NULL;


UPDATE Silver.Customers
SET job = 'Unknown'
WHERE job IS NULL;

UPDATE Silver.Customers
SET loyalty_tier = 'No Tier'
WHERE loyalty_tier IS NULL;

select * from Silver.Customers;

-- ====================================================================== --
-- ======================= 2. Merchants ================================ --
Select 
    TRY_CAST(merchant_id AS INT) AS merchant_id,
    TRY_CAST(merchant_name AS nvarchar(50)) AS merchant_name,
    TRY_CAST(dominant_category AS nvarchar(50)) AS dominant_category,
    ISNULL( LTRIM(RTRIM(merchant_city)),'') AS merchant_city,
    ISNULL( LTRIM(RTRIM(merchant_state)),'') AS merchant_state,
    TRY_CAST(merchant_lat AS float) AS merchant_lat,
    TRY_CAST(merchant_long AS float) AS merchant_long,
    TRY_CAST(LTRIM(RTRIM(merchant_since)) AS DATE) AS merchant_since,
    TRY_CAST(is_active AS bit) AS is_active
INTO Silver.Merchants
From Bronze.Merchants

Alter Table Silver.Merchants Alter Column merchant_id INT NOT NULL;
Alter Table Silver.Merchants ADD Constraint pk_silver_merchant Primary Key (merchant_id);

WITH StateCityMode AS (
    SELECT 
        merchant_state, 
        merchant_city,
        ROW_NUMBER() OVER(PARTITION BY merchant_state ORDER BY COUNT(*) DESC) AS rn
    FROM Silver.Merchants
    WHERE merchant_city IS NOT NULL AND merchant_city <> ''
    GROUP BY merchant_state, merchant_city
)
UPDATE m
SET m.merchant_city = scm.merchant_city
FROM Silver.Merchants m
JOIN StateCityMode scm ON m.merchant_state = scm.merchant_state AND scm.rn = 1
WHERE m.merchant_city IS NULL OR m.merchant_city = '';

Select * from Silver.Merchants;

-- ====================================================================== --
-- =========================== 3. Transaction ============================ --
Select 
    TRY_CAST(transaction_id AS INT) AS transaction_id,
    TRY_CAST(LTRIM(RTRIM(trans_date_trans_time)) AS DATETIME2(7)) AS trans_date,
    TRY_CAST(customer_id AS INT) AS customer_id,
    TRY_CAST(merchant_id AS INT) AS merchant_id,
    ISNULL( LTRIM(RTRIM(category)),'') AS category,
    TRY_CAST(amt AS float) AS amt,
    TRY_CAST(tax_amt AS float) AS tax_amt,
    TRY_CAST(discount_amt AS float) AS discount_amt,
    ISNULL( LTRIM(RTRIM(currency)),'') AS currency,
    ISNULL( LTRIM(RTRIM(payment_method)),'') AS payment_method,
    ISNULL( LTRIM(RTRIM(channel)),'') AS channel,
    ISNULL( LTRIM(RTRIM(entry_mode)),'') AS entry_mode,
    ISNULL( LTRIM(RTRIM(device_type)),'') AS device_type,
    ISNULL( LTRIM(RTRIM(transaction_status)),'') AS transaction_status,
    TRY_CAST(trans_num AS nvarchar(50)) AS trans_num,
    TRY_CAST(session_id AS nvarchar(50)) AS session_id,
    TRY_CAST(unix_time AS INT) AS unix_time,
    TRY_CAST(is_fraud AS bit) AS is_fraud
   
INTO Silver.Transactions
From Bronze.Transactions

Alter Table Silver.Transactions Alter Column transaction_id INT NOT NULL;
Alter Table Silver.Transactions ADD Constraint pk_silver_transaction Primary Key (transaction_id);

UPDATE Silver.Transactions
SET session_id = 'N/A'
WHERE session_id IS NULL OR LTRIM(RTRIM(session_id)) = '';


UPDATE Silver.Transactions
SET discount_amt = 0
WHERE discount_amt IS NULL;

UPDATE Silver.Transactions
SET tax_amt = 0
WHERE tax_amt IS NULL;

Select * from Silver.Transactions;

ALTER TABLE Silver.Transactions
ALTER COLUMN trans_date DATE;