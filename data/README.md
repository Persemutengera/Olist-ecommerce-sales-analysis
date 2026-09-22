# Data Documentation
## Dataset

This project uses the Brazilian Olist e-commerce public dataset.

The dataset contains multiple relational tables covering customers, orders, products, sellers, payments, reviews, and geographic information.

## Tables

|Table	        |  Rows       	|  Description                                       |
|---------------|-------------- |----------------------------------------------------|
|customers	    |    99,441	    |  Customer IDs and geographic information           |
|orders	        |    99,441	    |  Order status and timestamps                       |
|order_items    |	  112,650	    |  Products, sellers, prices and freight             |
|order_payments | 	103,886	    |  Payment methods, installments and payment values  |
|order_reviews  |    99,222	    |  Review scores and review comments                 |
|products	      |    32,951	    |  Product categories and physical attributes        |
|sellers        |     3,095	    |  Seller information and locations                  |
|geolocation	  |  1,000,163	  |     Brazilian ZIP-code geographic coordinates      |

# Important Relationships
## Customers → Orders
   customers.customer_id
        ↓
    orders.customer_id
## Orders → Order Items
   orders.order_id
        ↓
   order_items.order_id
##Orders → Payments
orders.order_id
        ↓
order_payments.order_id
## Orders → Reviews
orders.order_id
        ↓
order_reviews.order_id
## Products → Order Items
products.product_id
        ↓
order_items.product_id
## Sellers → Order Items
sellers.seller_id
        ↓
order_items.seller_id

## Data Notes
The dataset contains multiple payment records for some orders.
order_items.price represents item-level prices and does not include freight.
order_payments.payment_value was used to calculate total recorded payment value.
Delivery analysis uses orders with non-null delivery timestamps.
September and October 2018 contain relatively few records and should be treated as partial periods.
Some product category values may be missing.
Review records contain fewer rows than the total number of orders.

## Data Loading

The data was imported into MySQL Workbench and verified using row counts and table structure checks.

The database was analyzed using MySQL 8.0.
