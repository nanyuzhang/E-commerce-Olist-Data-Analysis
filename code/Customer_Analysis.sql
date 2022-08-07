
USE olist;


# Number of Customers 
SELECT COUNT(customer_unique_id) 
FROM customers;


# Customer Geological Distribution
SELECT customer_state AS State, COUNT(customer_unique_id) AS Num_Customers
FROM customers
GROUP BY 1
ORDER BY 2 DESC;


# Monthly Active & New Customers
WITH t AS(
SELECT customer_unique_id, 
       MIN(order_purchase_timestamp) AS first_purchase
FROM orders_clean INNER JOIN customers USING (customer_id)
GROUP BY 1),

t1 AS 
(SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS Time,
        YEAR( order_purchase_timestamp) AS year,
        MONTH(order_purchase_timestamp) AS month,
        COUNT(DISTINCT customer_unique_id) AS mau
FROM orders INNER JOIN customers USING(customer_id)
GROUP BY 1 ORDER BY 1),

t2 AS(
SELECT DATE_FORMAT(first_purchase, '%Y-%m') AS Time, 
       YEAR( first_purchase) AS year,
        MONTH(first_purchase) AS month,
       COUNT(customer_unique_id) AS New_Customers
FROM t GROUP BY 1 ORDER BY 1)

SELECT Time, t2.year, t2.month, mau, New_Customers
FROM t1 JOIN t2 USING (Time) ORDER BY 1;



# Total Transactions & Spending per user
SELECT customer_unique_id, 
       COUNT(order_id) AS Num_Total_Orders,
       SUM(payment_value) AS Total_Spending
FROM orders_clean o INNER JOIN customers c USING(customer_id) 
                    INNER JOIN order_payments op USING(order_id)
GROUP BY 1;


# Yealy Growth of New Customers
WITH total_customer AS(
SELECT YEAR(order_purchase_timestamp) AS Year, 
       COUNT(DISTINCT customer_unique_id) AS Num_Customers             
FROM orders_clean INNER JOIN customers USING(customer_id)
GROUP BY 1),

t AS(
SELECT customer_unique_id, MIN(order_purchase_timestamp) AS first_purchase
FROM orders_clean INNER JOIN customers USING (customer_id)
GROUP BY 1),

new_customer AS(
SELECT '2017' AS Year, COUNT(*) AS New_Customers FROM t WHERE first_purchase = 2017
UNION 
SELECT '2018' AS Year, COUNT(*) AS New_Customers FROM t WHERE first_purchase = 2018),

t1 AS(
SELECT *, LAG(Num_Customers) OVER (ORDER BY Year) AS existing_customers
FROM total_customer tc LEFT JOIN new_customer nc USING(Year))

SELECT Year, CONCAT(ROUND(IFNULL(New_Customers/existing_customers,0),2)*100, '%') AS Customer_Growth_Rate
FROM t1;



### Core Customers

# Spending Distribution
WITH t AS(
SELECT customer_unique_id, 
       CASE WHEN SUM(payment_value) < 100 THEN 'spending_100_below'
            WHEN SUM(payment_value) >= 100 AND SUM(payment_value) < 500 THEN 'spending_100_500'
            WHEN SUM(payment_value) >= 500 AND SUM(payment_value) < 1000 THEN 'spending_500_1000'
            WHEN SUM(payment_value) >= 1000 AND SUM(payment_value) < 3000 THEN 'spending_1000_3000'
            WHEN SUM(payment_value) > 3000 THEN 'spending_3000_above' END AS Spending
FROM orders_clean o INNER JOIN customers c USING(customer_id) 
                    INNER JOIN order_payments op USING(order_id)
GROUP BY 1 ORDER BY 2 DESC)

SELECT Spending, COUNT(customer_unique_id) AS Num_Customers
FROM t
GROUP BY 1;


# Transactions distribution
WITH t AS(
SELECT customer_unique_id, 
       COUNT(order_id) AS Num_orders
FROM orders_clean o INNER JOIN customers c USING(customer_id)
GROUP BY 1)

SELECT Num_orders, COUNT(customer_unique_id) AS Num_customers
FROM t
GROUP BY 1 ORDER BY 2 DESC;



# Payment Preference of Core Customers (Define: with more than 2 purchases in 2017-2018)
WITH t1 AS(
SELECT customer_unique_id, COUNT(order_id) AS num_orders, order_id
FROM orders_clean o INNER JOIN customers c USING(customer_id)
GROUP BY 1 
HAVING COUNT(order_id) >= 2
ORDER BY 2 DESC)

SELECT Payment_Type, COUNT(customer_unique_id) AS Customer_Count
FROM t1 JOIN order_payments USING (order_id)
GROUP BY 1 ORDER BY 2 DESC;



# Weekday Shopping Pattern of Core Customers (Define: with more than 2 purchases in 2017-2018)
WITH t1 AS(
SELECT customer_unique_id, COUNT(order_id) AS num_orders, customer_id
FROM orders_clean o INNER JOIN customers c USING(customer_id)
GROUP BY 1 
HAVING COUNT(order_id) >= 2)

SELECT customer_unique_id, order_purchase_timestamp
FROM orders_clean oc INNER JOIN t1 USING(customer_id);



# Customers With both High Frequency and High Monetary Value
WITH t1 AS(
SELECT customer_unique_id, COUNT(order_id) AS num_orders
FROM orders_clean o INNER JOIN customers c USING(customer_id)
GROUP BY 1 
HAVING COUNT(order_id) >= 2
ORDER BY 2 DESC),

t2 AS (
SELECT customer_unique_id, SUM(payment_value) AS total_spending
FROM orders_clean o INNER JOIN customers c USING(customer_id) 
                    INNER JOIN order_payments op USING(order_id)
GROUP BY 1 
HAVING SUM(payment_value) > 1000
ORDER BY 2 DESC )

SELECT t1.customer_unique_id, num_orders, total_spending
FROM t1 INNER JOIN t2 USING(customer_unique_id)
ORDER BY 2 DESC, 3 DESC;


### Customer Retention

# Returning Customer Rate
WITH t AS(
SELECT customer_unique_id AS id
FROM orders o INNER JOIN customers c USING(customer_id)
GROUP BY 1 
HAVING COUNT(order_id) > 1),

t1 AS (
SELECT customer_unique_id AS id
FROM orders o INNER JOIN customers c USING(customer_id))

SELECT CONCAT(ROUND(COUNT(t.id)/COUNT(t1.id)*100, 2), '%') AS Returning_Customer_Rate
FROM t RIGHT JOIN t1 USING(id);


### Other Analysis

# Total Transactions, 2017 Transactions, and 2018 Transactions
SELECT customer_unique_id, COUNT(order_id) AS Num_Total_Orders, 
       SUM(IF(YEAR(order_purchase_timestamp)=2017,1,0)) AS Num_2017_Orders,
       SUM(IF(YEAR(order_purchase_timestamp)=2018,1,0)) AS Num_2018_Orders
FROM orders_clean o INNER JOIN customers c USING(customer_id)
GROUP BY 1;


# Monthly Active Users and Growth Rate
WITH MAU AS 
(SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month, COUNT(DISTINCT customer_unique_id) AS mau
FROM orders INNER JOIN customers USING(customer_id)
WHERE YEAR(order_purchase_timestamp) = 2017
GROUP BY 1),

mau_lag AS (SELECT month,mau, LAG(mau) OVER (ORDER BY month ASC) AS last_mau
FROM mau)

SELECT month AS Month, mau AS MAU, ROUND(IFNULL((mau-last_mau)/last_mau*100, 0),2) AS Growth_Rate
FROM mau_lag
ORDER BY month;




