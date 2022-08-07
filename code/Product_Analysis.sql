
Use olist;


# Number of Products
SELECT COUNT(product_id)
FROM orders_clean INNER JOIN order_items USING(order_id);

# Total Revenue Brought by Products
SELECT ROUND(SUM(price),2) AS Total_Revenue
FROM products JOIN order_items USING(product_id);


# Top 1 Sales Product
SELECT product_category_name,
       COUNT(DISTINCT order_id) AS Transactions
FROM products JOIN order_items USING(product_id)
GROUP BY 1 ORDER BY 2 DESC LIMIT 1;


# Top 1 Growth Category
WITH t AS(
SELECT product_category_name,
       YEAR(order_purchase_timestamp) AS Year,
       COUNT(DISTINCT order_id) AS Transactions
FROM products JOIN order_items oi USING(product_id)
              JOIN orders_clean oc USING (order_id)
GROUP BY 1,2 ORDER BY 1,2), 

t1 AS (
SELECT *, LAG(Transactions) OVER (PARTITION BY product_category_name ORDER BY Year) AS Last_year_sales
FROM t)

SELECT *, ROUND((Last_year_sales-Transactions)/Transactions,2) AS growth_rate
FROM t1 
ORDER BY growth_rate DESC;


# Product Timeframe flowchart
SELECT AVG(DATEDIFF(order_approved_at, order_purchase_timestamp)) AS 'Approved',
       AVG(DATEDIFF(order_delivered_carrier_date, order_approved_at)) AS 'Deliver_to_Carriers',
       AVG(DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date)) AS 'Deliver_to_Customers',
       AVG(DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date)) AS 'Delivery'
FROM orders_clean;


# Translate Product Category to English
UPDATE products
SET product_category_name = (SELECT product_category_name_english FROM product_category_name p
                             WHERE p.product_category_name = products.product_category_name);


# Product Sales and Price
SELECT Product_Category_Name, 
       COUNT(DISTINCT order_id) AS Transactions, 
       ROUND(SUM(price+freight_value),2) AS Revenue,
	   ROUND(AVG(price),2) AS Average_Price
FROM products JOIN order_items USING(product_id)
GROUP BY 1;



# Product Category Sales & Price
SELECT Product_Category_Name, 
       COUNT(DISTINCT order_id) AS Num_Orders, 
       ROUND(AVG(price),2) AS Average_price
FROM products JOIN order_items USING(product_id)
GROUP BY 1
ORDER BY 2 DESC;


# Revenue By Product Category
SELECT Product_Category_Name, 
       ROUND(SUM(price),2) AS Total_Revenue
FROM products JOIN order_items USING(product_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


# Product Category With Most Canceled Orders
SELECT p.product_category_name, COUNT(order_id) AS Num_Canceled_Orders
FROM orders_clean oc JOIN order_items oi USING (order_id) JOIN products p ON oi.product_id = p.product_id
WHERE oc.order_status = 'canceled'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


# Average Review Scores By Product Category
SELECT Product_Category_Name, ROUND(AVG(review_score),2) AS Avg_Review_Scores, 
	COUNT(DISTINCT review_id) AS review_count 
FROM products JOIN order_items USING(product_id)
              JOIN order_reviews USING(order_id)
GROUP BY 1 ORDER BY 2 DESC LIMIT 10;


# Products with 'Recomendo' in Their Reviews
SELECT Product_Category_Name, COUNT(IF(LOWER(review_comment_title) LIKE '%recomendo%',1,0)) AS Count
FROM products JOIN order_items USING(product_id)
              JOIN order_reviews USING(order_id)
GROUP BY 1
ORDER BY 2 DESC;


# popular products with seasonality? 画by time的
WITH t AS(
SELECT Product_Category_Name
FROM products JOIN order_items USING(product_id)
GROUP BY 1 ORDER BY SUM(price+freight_value) DESC
LIMIT 7),

t1 AS (
SELECT DISTINCT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') As Time
FROM orders_clean ORDER BY 1)

SELECT product_category_name, 
       DATE_FORMAT(order_purchase_timestamp,'%Y-%m') As Time,
       ROUND(IFNULL(SUM(price+freight_value),0),2) AS Revenue
FROM orders_clean oc JOIN order_items USING (order_id)
					 JOIN products USING (product_id)
WHERE product_category_name IN (SELECT * FROM t)
GROUP BY 1, 2 ORDER BY 1,2;




