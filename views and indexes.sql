
--views--

-- sales summary--
create view fashion.vw_sales_summary as
select
    SUM(total_sales) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(sale_id) AS total_transactions,
    SUM(total_sales)*1.0 / COUNT(sale_id) as aov
from fashion.sales;

--sales trend--
create view fashion.vw_monthly_revenue as
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sales) AS revenue,
    LAG(SUM(total_sales)) OVER (ORDER BY YEAR(sale_date), MONTH(sale_date)) AS prev_month_revenue
FROM fashion.sales
GROUP BY YEAR(sale_date), MONTH(sale_date);

----customer summary---
create view fashion.vw_customer_summary as
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT s.customer_id) AS active_customers,
    SUM(s.total_sales) AS total_revenue,
    SUM(s.total_sales)*1.0 / SUM(SUM(s.total_sales)) OVER() * 100 AS revenue_contribution
FROM fashion.customers c
LEFT JOIN fashion.sales s ON c.customer_id = s.customer_id
GROUP BY c.country;

--products summary---
create view fashion.vw_product_performance as
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(s.quantity) AS total_quantity,
    SUM(s.total_sales) AS total_revenue,
    SUM((s.unit_price - p.cost_price) * s.quantity) AS total_profit,
    (SUM((s.unit_price - p.cost_price) * s.quantity) * 1.0 / NULLIF(SUM(s.total_sales), 0)) * 100 AS profit_margin
FROM fashion.sales s
JOIN fashion.products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category;


----indexes---

--on fact fashion.sales table--
alter table fashion.sales drop constraint PK__sales__E1EB00B2031AB888 ;
alter table fashion.sales add constraint pk__sales primary key nonclustered(sale_id)

create clustered columnstore index idx_cc_sales on fashion.sales; --for faster aggreagations--
create index idx_sales_product on fashion.sales(product_id); --on product id for faster joins--
create index idx_sales_customer on fashion.sales(customer_id); --on customer id for faster joins--

--on dim fashion.customer table--
create index idx_customer_country on fashion.customers(country) -- easy country grouping

--on dim fashion.products --
create index idx_product_category on fashion.products(category) -- category wise filtering


