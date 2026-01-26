USE DataWarehouse;
GO

-- Quality Check of the silver Table: [silver].[crm_cust_info]

-- [silver].[crm_cust_info]
-- Check For Nulls or Duplicates in Primary Key
-- Expectation : No Result

-- Explore 1st quality issues and then write the transformations to fix them
SELECT * FROM silver.crm_cust_info;

-- Detect and identify the quality issues
-- Detect the Null and duplicate in Primary Key using Aggregate
SELECT
	cst_id,
	COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted Spaces: cst_firstname
-- Expectation: No Results
SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check for unwanted Spaces: cst_lastname
-- Expectation: No Results
SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for unwanted Spaces: cst_marital_status
-- Expectation: No Results
SELECT
	cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

-- Check for unwanted Spaces: cst_gndr
-- Expectation: No Results
SELECT
	cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);


-- Data Standardization & Consistency
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info;

--------------------------------------------------------------------------
-- Quality Check of the Silver Table: crm_prd_info
-- Check For Nulls or Duplicates in Primary Key
-- Expectation : No Result

SELECT TOP 10 * FROM silver.crm_prd_info;

SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces
-- Expectation: No Results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != prd_nm;

-- Check for NULLS or Negative Numbers
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;

SELECT * FROM silver.crm_prd_info

--------------------------------------------------------------------------
-- Quality Check of the Silver Table: crm_sales_details
-- Check For Nulls or Duplicates in Primary Key
-- Expectation : No Result

SELECT TOP 10 * FROM silver.crm_sales_details;

-- [silver].[crm_sales_details]
-- Check for unwanted spaces
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- [silver].[crm_sales_details]
-- Check for Invalid Dates : sls_due_dt
-- Order Date shouldn't be > Ship Date or Due Date
SELECT
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- [silver].[crm_sales_details]
-- Check Data Consistency: Between Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero or Negative
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

SELECT * FROM silver.crm_sales_details;

-- [silver].[erp_cust_az12]
-- Identify Out-of-Range Dates
SELECT DISTINCT 
	bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

SELECT DISTINCT 
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-- Check 
SELECT TOP 100 *
FROM silver.erp_cust_az12;

-- [silver].[erp.loc_a101]
-- Data Standardization & Consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

SELECT * FROM [silver].[erp_loc_a101];

-- [silver].[erp_px_cat_g1v2]
SELECT * FROM silver.erp_px_cat_g1v2;

