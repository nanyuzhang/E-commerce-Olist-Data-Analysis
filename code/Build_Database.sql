# Create database and load data

CREATE DATABASE Olist;
USE Olist;

# Create Orders table
DROP TABLE IF EXISTS `orders`;
CREATE TABLE orders 
(order_id VARCHAR(100) PRIMARY KEY, 
customer_id TEXT, 
order_status TEXT, 
order_purchase_timestamp TEXT, 
order_approved_at TEXT, 
order_delivered_carrier_date TEXT,
order_delivered_customer_date TEXT, 
order_estimated_delivery_date TEXT);
# Load data
LOAD DATA LOCAL INFILE 'D:/USC/DAproject/data/olist_orders_dataset.csv' 
INTO TABLE orders FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

# Create Order_payments table
DROP TABLE IF EXISTS `order_payments`;
CREATE TABLE order_payments (
	order_id VARCHAR(100), 
    payment_sequential BIGINT, 
    payment_type TEXT, 
	payment_installments BIGINT, 
    payment_value FLOAT);
LOAD DATA LOCAL INFILE 'D:/USC/DAproject/data/olist_order_payments_dataset.csv' 
INTO TABLE order_payments FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

DROP TABLE IF EXISTS `order_items`;
CREATE TABLE order_items (
	order_id TEXT, 
	order_item_id BIGINT, 
	product_id TEXT, 
	seller_id TEXT, 
	shipping_limit_date TEXT, 
	price FLOAT, 
	freight_value FLOAT
);
LOAD DATA LOCAL INFILE  'D:/USC/DAproject/data/olist_order_items_dataset.csv' 
	INTO TABLE order_items FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
    
# Create order_reviews table
DROP TABLE IF EXISTS `order_reviews`;
CREATE TABLE order_reviews (
	review_id TEXT, 
	order_id TEXT, 
	review_score BIGINT, 
	review_comment_title TEXT, 
	review_comment_message TEXT, 
	review_creation_date TEXT, 
	review_answer_timestamp TEXT
);
LOAD DATA LOCAL INFILE  'D:/USC/DAproject/data/olist_order_reviews_dataset.csv' 
	INTO TABLE order_reviews FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

# Create products table
DROP TABLE IF EXISTS `products`;
CREATE TABLE products (
	product_id VARCHAR(100) PRIMARY KEY, 
	product_category_name TEXT, 
	product_name_lenght INT, 
	product_description_lenght INT, 
	product_photos_qty INT, 
	product_weight_g INT, 
	product_length_cm INT, 
	product_height_cm INT, 
	product_width_cm INT
);
LOAD DATA LOCAL INFILE  'D:/USC/DAproject/data/olist_products_dataset.csv' 
INTO TABLE products FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

# Create product_category_name_translation table
DROP TABLE IF EXISTS `product_category_name`;
CREATE TABLE product_category_name (
	product_category_name TEXT, 
	product_category_name_english TEXT
);
LOAD DATA LOCAL INFILE  'D:/USC/DAproject/data/product_category_name_translation.csv' 
	INTO TABLE product_category_name FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

# Create customers table
DROP TABLE IF EXISTS `customers`;
create table customers (
	customer_id VARCHAR(100) PRIMARY KEY, 
    customer_unique_id TEXT, 
    customer_zip_code_prefix TEXT, 
    customer_city TEXT, 
    customer_state TEXT);
# Load data
LOAD DATA LOCAL INFILE  'D:/USC/DAproject/data/olist_customers_dataset.csv' 
	INTO TABLE customers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

# Create sellers table
DROP TABLE IF EXISTS `sellers`;
CREATE TABLE sellers (
	seller_id VARCHAR(100) PRIMARY KEY, 
	seller_zip_code_prefix TEXT, 
	seller_city TEXT, 
	seller_state TEXT
);
LOAD DATA LOCAL INFILE  'D:/USC/DAproject/data/olist_sellers_dataset.csv' 
INTO TABLE sellers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

    
# Create Geolocation table
DROP TABLE IF EXISTS `geolocation`;
CREATE TABLE geolocation (
	geolocation_zip_code_prefix TEXT, 
	geolocation_lat FLOAT, 
	geolocation_lng FLOAT, 
	geolocation_city TEXT, 
	geolocation_state TEXT);
# Load data
LOAD DATA LOCAL INFILE  'D:/USC/DAproject/data/olist_geolocation_dataset.csv' 
	INTO TABLE geolocation FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


    




