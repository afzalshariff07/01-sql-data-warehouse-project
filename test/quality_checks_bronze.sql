USE DataWarehouse;
GO

-- Quality Check of the Bronze Table: [bronze].[crm_cust_info]

-- [bronze].[crm_cust_info]
-- Check For Nulls or Duplicates in Primary Key
-- Expectation : No Result

-- Explore 1st quality issues and then write the transformations to fix them
SELECT * FROM bronze.crm_cust_info;

-- Detect and identify the quality issues
-- Detect the Null and duplicate in Primary Key using Aggregate
SELECT
	cst_id,
	COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Now we have an Issue Duplicate and NULLs
SELECT
	*
FROM bronze.crm_cust_info
WHERE cst_id = 29466;
-- Here we have 3 lines for single record
-- New one is the latest and updated information
-- RANK them based on created date and pick the latest one
SELECT
	*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

-- We are interested in Rank Number 1 which is the latest one
SELECT
* 
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
)t WHERE flag_last = 1;

-- CHECK 
SELECT
* 
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
)t WHERE flag_last = 1 AND cst_id = 29466;

-- Check for unwanted Spaces: cst_firstname
-- Expectation: No Results
SELECT
	cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check for unwanted Spaces: cst_lastname
-- Expectation: No Results
SELECT
	cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for unwanted Spaces: cst_marital_status
-- Expectation: No Results
SELECT
	cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

-- Check for unwanted Spaces: cst_gndr
-- Expectation: No Results
SELECT
	cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);


-- Data Standardization & Consistency
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

----

-- [bronze].[crm_prd_info]
-- Check For Nulls or Duplicates in Primary Key
-- Expectation : No Result
SELECT
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- [bronze].[crm_prd_info]
-- Filters out unmatched data
SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') NOT IN 
	(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2);

-- [bronze].[crm_prd_info]
-- Filters out unmatched data
-- To check if any of the Product category is part of Sales Table
-- The below query will show how many product categories which were not sold
SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN (
	SELECT sls_prd_key from [bronze].[crm_sales_details]
	WHERE sls_prd_key LIKE 'FK-16%'
);

-- [bronze].[crm_prd_info]
-- The below query shows which product were sold as part of sales table 
-- (Matching product categories)
SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) IN (
	SELECT sls_prd_key from [bronze].[crm_sales_details] );

-- [bronze].[crm_prd_info]
-- Check for unwanted spaces
-- Expectation: No Results
SELECT
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- [bronze].[crm_prd_info]
-- Check For Nulls or Duplicates in Primary Key
-- Expectation : No Result
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost > 0 OR prd_cost IS NULL;

-- [bronze].[crm_prd_info]
-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- [bronze].[crm_prd_info]
-- Check for Invalid Date Orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt;

-- [bronze].[crm_prd_info]
-- To fix the end date which is smaller than start-date, analyse in excel
-- brainstorm and see if you can interchange logically and with approvals proceed
-- Add minus 1 in Windows function to bring the one day prior date
SELECT
	prd_id,
	prd_key,
	prd_nm,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER( PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R' , 'AC-HE-HL-U509')


-- [bronze].[crm_sales_details]
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
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- [bronze].[crm_sales_details]
-- Check the integrity of keys : prd_key
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
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN
(SELECT prd_key FROM silver.crm_prd_info);

-- [bronze].[crm_sales_details]
-- Check the integrity of keys : cust_id
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
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN
(SELECT cst_id FROM silver.crm_cust_info);

-- [bronze].[crm_sales_details]
-- Check for Invalid Dates: sls_order_dt
SELECT 
	NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101; -- Check for boundaries of date

-- [bronze].[crm_sales_details]
-- Check for Invalid Dates : sls_ship_dt
SELECT
	NULLIF(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101; -- Check for boundaries of date

-- [bronze].[crm_sales_details]
-- Check for Invalid Dates : sls_due_dt
SELECT 
	NULLIF(sls_due_dt,0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101; -- Check for boundaries of date

-- [bronze].[crm_sales_details]
-- Check for Invalid Dates : sls_due_dt
-- Order Date shouldn't be > Ship Date or Due Date
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- [bronze].[crm_sales_details]
-- Check Data Consistency: Between Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero or Negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


SELECT DISTINCT
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price AS old_sls_price,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
		 THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,

	CASE WHEN sls_price IS NULL OR sls_price <= 0 
		 THEN sls_sales / NULLIF(sls_quantity,0)
		 ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- bronze.erp_cust_az12
-- Filters out unmatched data
-- Expectation : No Result
SELECT
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	 ELSE cid
END AS cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	 ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

SELECT * FROM [silver].[crm_cust_info]

-- If we remove Case Statement in Where condition we will find entries,
-- This means our transformation is working
SELECT
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	 ELSE cid
END AS cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE cid IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

-- Identify Out-of-Range Dates
SELECT *
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12

-- CHECK
SELECT DISTINCT 
	CASE WHEN UPPER(TRIM(gen)) IN ('F' , 'Female') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M' , 'Male' ) THEN 'Male'
		 ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12;

-- bronze.erp_loc_a101
-- Filters out unmatched data
-- Expectation : No Result
SELECT
	REPLACE(cid, '-','') AS cid,
	cntry
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-','') NOT IN
(SELECT DISTINCT cst_key FROM silver.crm_cust_info);

-- bronze.erp_loc_a101
-- Data Standardization & Consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

-- Fix using Case statement
SELECT DISTINCT
	cntry AS old_cntry,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101;

-- [bronze].[erp_px_cat_g1v2]
-- Check the integrity of keys : id
SELECT id FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT DISTINCT cat_id FROM silver.crm_prd_info)

SELECT * FROM silver.crm_prd_info
WHERE cat_id = 'CO_PD'

-- [bronze].[erp_px_cat_g1v2]
-- Check fro unwanted Spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Data Standardization & consistency (Cardinality)
SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2;

