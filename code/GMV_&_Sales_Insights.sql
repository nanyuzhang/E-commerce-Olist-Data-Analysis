
USE olist;

# GMV (2017-2018)
SELECT ROUND(SUM(price+freight_value),2) AS GMV
FROM orders_clean oc JOIN order_items USING(order_id)
WHERE oc.order_status IN ('approved', 'shipped', 'delivered', 'invoiced');


# Average Revenue Per User (ARPU) (2017-2018)
SELECT ROUND(SUM(price)/COUNT(DISTINCT customer_id), 2) AS ARPU
FROM orders_clean oc INNER JOIN order_items oi USING(order_id)
WHERE oc.order_status IN ('approved', 'shipped', 'delivered', 'invoiced');


# Total Transactions
SELECT COUNT(DISTINCT order_id) FROM orders_clean;


# Delivery rate
SELECT SUM(IF(order_status='delivered',1,0))/COUNT(*) AS delivery_rate
FROM orders_clean;


# Average Order Value
SELECT SUM(price+freight_value)/COUNT(DISTINCT order_id) AS aov
FROM orders_clean o INNER JOIN order_items oi USING(order_id);


# GMY By State
SELECT customer_state as state, 
       ROUND(SUM(price+freight_value),2) AS GMV
FROM orders_clean oc JOIN order_items USING(order_id)
		       JOIN customers USING(customer_id)
WHERE oc.order_status IN ('approved', 'shipped', 'delivered', 'invoiced')
GROUP BY 1;

# Monthly GMV, ARPU, Total_Orders, AOV 
SELECT DATE(oc.order_purchase_timestamp) AS TIME,
       YEAR( order_purchase_timestamp) AS Year, 
       MONTH(order_purchase_timestamp) AS Month,
       ROUND(SUM(price+freight_value),2) AS GMV, 
       ROUND(SUM(payment_value)/COUNT(DISTINCT customer_id), 2) AS ARPU,
       COUNT(order_id) AS Total_Orders, 
       ROUND(SUM(price+freight_value)/COUNT(DISTINCT order_id),2) AS AOV
FROM orders_clean oc JOIN order_items oi USING(order_id)
                     JOIN order_payments USING(order_id)
WHERE oc.order_status IN ('approved', 'shipped', 'delivered', 'invoiced')
GROUP BY 1
ORDER BY 1;

# Daily GMV, ARPU
SELECT DATE(oc.order_purchase_timestamp) AS Time, 
       ROUND(SUM(price+freight_value),2) AS GMV,
       ROUND(SUM(payment_value)/COUNT(DISTINCT customer_id), 2) AS ARPU
FROM orders_clean oc JOIN order_items oi USING(order_id)
                     JOIN order_payments USING(order_id)
WHERE oc.order_status IN ('approved', 'shipped', 'delivered', 'invoiced')
GROUP BY 1
ORDER BY 1;



# OTHER ANALYSIS

# Montly Transactions & Growth Rate
WITH t as (
 SELECT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') as order_time,
        COUNT(order_id) AS total_order,
        LAG(COUNT(order_id),1) OVER (ORDER BY DATE_FORMAT(order_purchase_timestamp,'%Y-%m')) AS next_order
 FROM orders_clean
 GROUP BY 1
)
SELECT Order_time, Total_order,
       concat(round(100 * (total_order - next_order)/next_order,2),'%') AS Growth_rate
FROM t
ORDER BY 1;










