USE DataWarehouse;
GO

-- Check duplicates after adding the JOINS: silver.crm_cust_info
SELECT customer_id, COUNT(*) FROM
(SELECT
    ci.cst_id              AS customer_id,
    ci.cst_key             AS customer_key,
    ci.cst_firstname       AS firstname,
    ci.cst_lastname        AS lastname,
    la.cntry               AS country,
    ci.cst_marital_status  AS marital_status,
        CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the master for gender info
                ELSE COALESCE(ca.gen, 'n/a')
        END                AS gender,
    ca.bdate               AS birthdate,
    ci.cst_create_date     AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON la.cid = ci.cst_key
)t GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Data Consistency for Gender
SELECT DISTINCT
    ci.cst_gndr,
    ca.gen,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender Info
         ELSE COALESCE(ca.gen, 'n/a')
    END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid
ORDER BY 1,2


-- Check duplicates after adding the JOINS : silver.crm_prd_info
SELECT product_number, COUNT(*) AS duplicate_count FROM
(SELECT
    ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_dt
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL -- Filter out all historical data
)t GROUP BY product_number
HAVING COUNT(*) > 1;

