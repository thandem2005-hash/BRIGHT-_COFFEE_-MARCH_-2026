
--Coffee Shop Sales Analysis using SQL
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2.Checking the starting date and the last date of the collection
--QUERY 1. Limit --Vieving the first 10 raws of the Table.
SELECT * 
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`
LIMIT 10;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- QUERY 2. Checking the starting date and the last date of the collection. Alias is used
SELECT MIN(transaction_date) AS start_date, MAX(transaction_date) AS last_date
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUERY 3.  Viewing DISTINCT store location.
SELECT DISTINCT store_location
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- QUERY 4.  The number of unique products.
SELECT COUNT(DISTINCT product_id) AS unique_products
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  QUERY 5. The avalailable products.
SELECT DISTINCT product_id, product_category, product_type, product_detail
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- QUERY 6. The total revenue of the shop.
SELECT SUM(unit_price * transaction_qty) AS total_revenue
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- QUERY  7.1 The total revenue by store location returns the lowest revenue for each store.
SELECT store_location, SUM(unit_price * transaction_qty) AS total_revenue
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`
GROUP BY store_location
ORDER BY total_revenue DESC;

-- QUERY 7.2 The total revenue by store location returns the Highest revenue for each store
SELECT store_location, SUM(unit_price * transaction_qty) AS total_revenue
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`
GROUP BY store_location
ORDER BY total_revenue ASC;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- QUERY  8. The most expensive product.
SELECT MAX(unit_price) AS most_expensive_product
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;

--  QUERY 9. The most Cheapest product.  
SELECT MIN(unit_price) AS Less_expensive_product
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 10. Counting how many stores,products and transactions are in the dataset
SELECT COUNT(*) AS number_of_raws,
       COUNT(DISTINCT store_id) AS Number_of_stores,
       COUNT(DISTINCT transaction_id) AS Number_of_transactions,
       COUNT(DISTINCT product_id) AS number_of_produts
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--QUERY 12. Aggregating the transaction date
SELECT transaction_date,
DAYNAME(transaction_date) AS day_name,
DAYOFMONTH(transaction_date) AS day_of_month,
COUNT(DISTINCT transaction_id) AS Number_sales,
SUM(unit_price * transaction_qty) AS revenue_per_transaction
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`
GROUP BY transaction_date, day_name,
 day_of_month;
--------------------------------------------------------------------------------------------------------------------------
----Let the Good Time Roll
SELECT 
      transaction_date,
      store_location,
      product_id,
      product_category,
      product_detail,
      unit_price,
      transaction_qty,
      transaction_id
      total_revenue,
      store_id,
      ----Revenue
      unit_price * transaction_qty AS revenue_per_transaction,    
      --Enhansing better signht with new Columns.
      DAYNAME(transaction_date) AS day_name,
      DAYOFMONTH(transaction_date) AS day_of_month,
      MONTHNAME(transaction_date) AS month_name,
---Specifying weekdays of the week      
CASE
       WHEN DAYNAME(transaction_date) IN ('Sunday','Saturday') THEN 'Weekends'
       ELSE 'Weekday'
    END AS Special_operation,
  --Time bucket
  CASE
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '1.Dawn_Rush'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '2.Late_morning'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '13:00:00' AND '15:59:59' THEN '3.Early Afternoon'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '16:00:00' AND '18:59:59' THEN '3.Late afternoon'
        else '4.Night'
END AS time_basket,
  --- Check the Nulls in our various column
WHERE  transaction_date IS NULL
      OR transaction_qty IS NULL 
      OR store_id IS NULL
      OR store_location IS NULL
      OR product_id IS NULL
      OR unit_price IS NULL
      OR product_category IS NULL
      OR product_type IS NULL
      OR product_detail IS NULL,
--Spending bucket
CASE
    WHEN (unit_price* transaction_qty) >= 50 THEN 'Budget'
    WHEN (unit_price* transaction_qty) <= 100 THEN 'Standard'
    WHEN (unit_price* transaction_qty) <= 150 THEN 'Premium'
     ELSE 'Duluxe'
     END AS spending_bucket
FROM `workspace`.`casestudy`.`MARCH2026_bright_coffee_shop_sales`
GROUP BY ALL
ORDER BY total_revenue;
