-- ======= 1. Dim Date ====== --
CREATE TABLE Gold.Dim_Date(
  datekey INT Not Null Primary Key,
  full_date Date Not Null,
  [year] INT Not Null,
  [quarter] INT Not Null,
  [month] INT Not Null,
  month_name Varchar(20) Not Null,
  [day] INT Not Null,
  day_name VARCHAR(20) Not Null,
  is_weekend BIT Not NULL )

DECLARE @start_date DATE, @end_date DATE, @current_date DATE;


SELECT 
    @start_date = MIN(CAST(trans_date AS DATE)),
    @end_date = MAX(CAST(trans_date AS DATE)) 
FROM Silver.Transactions;

SET @current_date = @start_date;

WHILE @current_date <= @end_date
BEGIN
    INSERT INTO Gold.Dim_Date ( 
        datekey,
        full_date,
        [year],
        [quarter], 
        [month],
        month_name,
        [day],
        day_name,
        is_weekend 
    )
    SELECT 
        CAST(CONVERT(VARCHAR(8), @current_date, 112) AS INT) AS datekey, -- int (مثال: 20240101)
        @current_date AS full_date,                                      -- date
        YEAR(@current_date) AS [year],
        DATEPART(QUARTER, @current_date) AS [quarter],
        MONTH(@current_date) AS [month],
        DATENAME(MONTH, @current_date) AS month_name,
        DAY(@current_date) AS [day],
        DATENAME(WEEKDAY, @current_date) AS day_name,
        CASE 
            WHEN DATEPART(WEEKDAY, @current_date) IN (1, 7) THEN 1
            ELSE 0
        END AS is_weekend;

    SET @current_date = DATEADD(DAY, 1, @current_date);
END;

Select * from Gold.Dim_Date;
-- ======================================== --
-- ================= 2. Dim_Customers ==================== --
Select * 
INTO Gold.Dim_Customers
From Silver.Customers;

SELECT *
FROM Gold.Dim_Customers;

ALTER TABLE Gold.Dim_Customers ALTER COLUMN customer_id INT Not Null;
ALTER TABLE Gold.Dim_Customers ADD CONSTRAINT PK_DimCusomers Primary Key (customer_id);
-- ====================================== --
-- ============== 3. Dim_Merchants ====================== --
Select * 
INTO Gold.Dim_Merchants
From Silver.Merchants;

SELECT *
FROM Gold.Dim_Merchants;

ALTER TABLE Gold.Dim_Merchants ALTER COLUMN merchant_id INT Not Null;
ALTER TABLE Gold.Dim_Merchants ADD CONSTRAINT PK_DimMerchant Primary Key (merchant_id);
-- ====================================== --
-- ============== 3. Fact_Transactions ====================== --
Select 
 [transaction_id],
 CAST(FORMAT([trans_date],'yyyyMMdd') AS INT) AS date_key,
 [customer_id],
 [merchant_id],
 [category],
 [amt],
 [tax_amt],
 [discount_amt],
 [currency],
 [payment_method],
 [channel],
 [entry_mode],
 [device_type],
 [transaction_status],
 [trans_num],
 [session_id],
 [unix_time],
 [is_fraud]
INTO Gold.Fact_Transactions
From Silver.Transactions;

SELECT *
FROM Gold.Fact_Transactions;

ALTER TABLE Gold.Fact_Transactions ALTER COLUMN transaction_id INT Not Null;
ALTER TABLE Gold.Fact_Transactions ADD CONSTRAINT PK_FactTransaction Primary Key (transaction_id);


-- ================== Foregin Keys ======== --
 ALTER TABLE Gold.Fact_Transactions
  ADD CONSTRAINT FK_Fact_Dim_Date FOREIGN KEY (date_key)
  REFERENCES Gold.Dim_Date ([datekey]);

ALTER TABLE Gold.Fact_Transactions
 ADD CONSTRAINT FK_Fact_Dim_Customers FOREIGN KEY ([customer_id])
 REFERENCES Gold.Dim_Customers ([customer_id]);

ALTER TABLE Gold.Fact_Transactions
 ADD CONSTRAINT FK_Fact_Dim_Merchants FOREIGN KEY ([merchant_id])
 REFERENCES Gold.Dim_Merchants ([merchant_id]);

-- ========= Indexes ============= --
Create INDEX IX_Fact_DateKey ON Gold.Fact_Transactions (date_key);
Create INDEX IX_Fact_CustomerID ON Gold.Fact_Transactions (customer_id);
Create INDEX IX_Fact_MerchantID ON Gold.Fact_Transactions (merchant_id);
