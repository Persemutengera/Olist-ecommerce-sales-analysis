-- OLIST E-COMMERCE SQL DATA ANALYSIS
-- Database: olist_ecommerce
-- Tool: MySQL Workbench


USE olist_ecommerce;

SELECT DATABASE();

CREATE TABLE customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

DESCRIBE customers;

CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

DESCRIBE orders;

USE olist_ecommerce;

SHOW TABLES;

CREATE TABLE order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),

    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

DESCRIBE order_items;

CREATE TABLE order_payments (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_order_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

DESCRIBE order_payments;

CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

DESCRIBE order_reviews;

CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(255),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

DESCRIBE products;

CREATE TABLE sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

DESCRIBE sellers;

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10, 8),
    geolocation_lng DECIMAL(11, 8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

DESCRIBE geolocation;

SHOW TABLES;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
FROM customers
LIMIT 5;

DESCRIBE customers;

SELECT COUNT(*) AS total_customers
FROM customers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DESCRIBE orders;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    order_estimated_delivery_date
)
SET
    order_delivered_carrier_date =
        NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date =
        NULLIF(@order_delivered_customer_date, '');
        
TRUNCATE TABLE orders;

DELETE FROM orders;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
    order_approved_at = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');
    
SELECT COUNT(*) AS total_orders
FROM orders;

DESCRIBE order_items;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_order_items
FROM order_items;

DESCRIBE order_payments;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_order_payments
FROM order_payments;

DESCRIBE order_reviews;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_creation_date = NULLIF(@review_creation_date, ''),
    review_answer_timestamp = NULLIF(@review_answer_timestamp, '');
    
SELECT COUNT(*) AS review_rows
FROM order_reviews;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_creation_date = NULLIF(@review_creation_date, ''),
    review_answer_timestamp = NULLIF(@review_answer_timestamp, '');
    
SELECT COUNT(*) AS total_reviews
FROM order_reviews;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_clean.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_creation_date = NULLIF(@review_creation_date, ''),
    review_answer_timestamp = NULLIF(@review_answer_timestamp, '');
    
DELETE FROM products;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');
    
SELECT COUNT(*) AS total_reviews
FROM order_reviews;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_products
FROM products;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_sellers
FROM sellers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_geolocation
FROM geolocation;

SELECT 
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS duplicate_count
FROM geolocation
GROUP BY 
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1
LIMIT 10;

SHOW INDEX FROM geolocation;

DELETE FROM geolocation;

SELECT COUNT(*) AS total_geolocation
FROM geolocation;

SET SESSION net_read_timeout = 600;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_geolocation
FROM geolocation;

-- 0. TOTAL REVENUE

SELECT 
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;

-- 1. MONTHLY SALES TRENDS

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- 2. TOP-SELLING PRODUCTS

SELECT
    oi.product_id,
    COUNT(*) AS units_sold,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM order_items oi
GROUP BY oi.product_id
ORDER BY units_sold DESC
LIMIT 10;

-- 3. TOP PRODUCT CATEGORIES

SELECT
    COALESCE(p.product_category_name, 'Unknown') AS category,
    COUNT(oi.order_item_id) AS units_sold,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY COALESCE(p.product_category_name, 'Unknown')
ORDER BY total_sales DESC
LIMIT 10;

-- 4. BEST-PERFORMING SELLERS

SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS units_sold,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_sales DESC
LIMIT 10;

-- 5. PAYMENT METHOD ANALYSIS

SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value), 2) AS total_payment,
    ROUND(AVG(payment_value), 2) AS average_payment
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment DESC;

-- 6. CUSTOMER ANALYSIS

SELECT
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
ORDER BY total_spent DESC
LIMIT 10;

-- 7. REVIEW SCORE ANALYSIS

SELECT
    review_score,
    COUNT(*) AS number_of_reviews,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_reviews),
        2
    ) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

-- 8A. AVERAGE DELIVERY TIME

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;
  
-- 8B. ACTUAL VS ESTIMATED DELIVERY
  
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ),
        2
    ) AS average_days_difference
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
  
-- 9A. CUSTOMERS BY STATE
  
SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- 9B. TOP CUSTOMER CITIES

SELECT
    customer_city,
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city, customer_state
ORDER BY total_customers DESC
LIMIT 10;

-- 10. BUSINESS KPIs

SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM orders) AS total_orders,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    (SELECT COUNT(DISTINCT product_id)
     FROM products) AS total_products,

    (SELECT COUNT(DISTINCT seller_id)
     FROM sellers) AS total_sellers,

    (SELECT ROUND(SUM(payment_value), 2)
     FROM order_payments) AS total_revenue,

    (SELECT ROUND(AVG(payment_value), 2)
     FROM order_payments) AS average_order_payment,

    (SELECT ROUND(AVG(review_score), 2)
     FROM order_reviews) AS average_review_score,

    (SELECT COUNT(*)
     FROM orders
     WHERE order_status = 'delivered') AS delivered_orders;
