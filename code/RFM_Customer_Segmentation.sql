
use olist;

# Calculate Recency, Frequency, and Monetary Value for Each Customer
WITH t AS(
SELECT c.customer_unique_id, 
       DATEDIFF('2018-08-31', MAX(order_purchase_timestamp)) AS Recency,
       COUNT(DISTINCT order_id) AS Frequency, 
       ROUND(SUM(payment_value),2) AS Monetary
FROM orders_clean oc JOIN customers c USING (customer_id) 
                     JOIN order_payments op USING(order_id)
GROUP BY 1), 


# Calculate Recency score, Frequency score, and Monetary Value score
t2 AS (
SELECT *,
       CASE WHEN Recency <= 100 THEN 4 WHEN Recency>100 AND Recency<=200 THEN 3 WHEN Recency>200 AND Recency<=300 THEN 2 ELSE 1 END AS R,
       CASE WHEN Frequency >=3 THEN 4 WHEN Frequency=2 THEN 3 WHEN Frequency=1 THEN 2 ELSE 1 END AS F,
       CASE WHEN Monetary >= 500 THEN 4 WHEN Monetary>300 AND Monetary<500 THEN 3 WHEN Monetary>100 AND Monetary<=300 THEN 2 ELSE 1 END AS M
FROM t)


# Segmentation based on RFM score
SELECT *, 
       CASE WHEN R=4 AND F=4 AND M=4 THEN 'Best Customers' 
            WHEN R!=4 AND F=4 AND M!=4 THEN 'Loyal Customers'
            WHEN R=4 AND F!=4 AND M=4 THEN 'Potential Big Spender'
            WHEN R!=4 AND F!=4 AND M=4 THEN 'Need_Attention Big Spender'
            WHEN R=4 AND F!=4 AND M!=4 THEN 'Recent Customers'
            WHEN R=1 AND F=1 AND M=1 THEN 'Lost Custmers'
            ELSE 'Regular Customers' END AS 'Group'
FROM t2;