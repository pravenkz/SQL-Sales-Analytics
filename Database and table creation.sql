---creating database--
drop database if exists FashionDB;
create database FashionDB ;
go

use FashionDB;
go
---schema--
drop schema if exists fashion;
go
CREATE SCHEMA fashion;
go

---drop table if exists--
IF OBJECT_ID('fashion.sales', 'U') IS NOT NULL DROP TABLE fashion.sales;
IF OBJECT_ID('fashion.customers', 'U') IS NOT NULL DROP TABLE fashion.customers;
IF OBJECT_ID('fashion.products', 'U') IS NOT NULL DROP TABLE fashion.products;
GO

create table fashion.products (
product_id int primary key,
product_name varchar(50),
category varchar(50),
brand varchar(50),
color varchar(50),
size varchar(50),
catalog_price decimal(10,2),
cost_price decimal(10,2),
gender varchar(20)
);

create table fashion.customers (
customer_id int primary key,
country varchar(50),
age_range varchar(50),
signup_date date
);


create table fashion.sales(
sale_id int primary key,
product_id int,
quantity int,
unit_price decimal(10,2),
discount_applied decimal (10,2),
discount_percent decimal (10,2),
discounted decimal(10,2),
total_sales decimal(10,2),
sale_date date,
channel varchar(50),
channel_campaign varchar(50),
customer_id int,
foreign key (customer_id) references fashion.customers(customer_id),
foreign key (product_id) references fashion.products(product_id)
);


--bulk insert from csv file--


BULK INSERT fashion.products
FROM 'C:\Users\Rounak\Desktop\sql portfolio\products.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT fashion.customers
FROM 'C:\Users\Rounak\Desktop\sql portfolio\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT fashion.sales
FROM 'C:\Users\Rounak\Desktop\sql portfolio\salesitems.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);



