----eda analysis ---

--Database exploration--

select * from INFORMATION_SCHEMA.TABLES  --checking for tables--

select * from INFORMATION_SCHEMA.COLUMNS --checking for columns--

select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'products';

--data overview--
select COUNT(*) as total_rows from fashion.sales;

select COUNT(distinct customer_id) as unique_customers from fashion.sales;

select COUNT(distinct product_id) as unique_products from fashion.sales;

--check for nulls--
select
    sum(case when total_sales is null then 1 else 0 end) as null_sales,
    sum(case when product_id is null then 1 else 0 end) as null_products,
    sum(case when customer_id is null then 1 else 0 end) as null_customers
from fashion.sales;

--date exploration--

select min(sale_date) as start_date ,max(sale_date) as end_date,datediff(day,min(sale_date),max(sale_date)) as days_span,
count(distinct format(sale_date,'yyyy-MM')) as  months_covered from fashion.sales;

--total sales summary stats--
select avg(total_sales) as avg_sales ,max(total_sales) as max_sale,min(total_sales) as min_sale,
stdev(total_sales) as std_dev_sale from fashion.sales;  -- high std_dev here data spread is wide and incosistent--

--customer demographics --
select count(*) as total_customers,count(distinct country) as total_countries,count(distinct age_range) as total_age_group
from fashion.customers;

--product variety --
select count(*) as total_products ,count(distinct category) as total_category ,count(distinct brand) as total_brand
from fashion.products

--price insight--
select avg(catalog_price) as average_catalog_price,avg(cost_price) as avg_cost_price,
avg(catalog_price-cost_price) as avg_margin from fashion.products;

--category wise distribution--
select category, COUNT(*) AS total_products, AVG(catalog_price) as avg_price
from fashion.products
group by category
order by  total_products desc;






