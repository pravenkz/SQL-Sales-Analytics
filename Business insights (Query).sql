
--sales based metrics--

--total sales--
select total_sales from fashion.vw_sales_summary;

--total quantity sold--
select  total_quantity from fashion.vw_sales_summary;

--total transaction--
select  total_transactions from fashion.vw_sales_summary; 

--average order value --
select  AOV from fashion.vw_sales_summary;

--revenue by month--
select month,revenue from fashion.vw_monthly_revenue order by revenue desc ;

--month on month  growth %--
select month,revenue ,
 prev_month_revenue, concat(coalesce(((revenue - prev_month_revenue) *1.0 /prev_month_revenue) *100,0),'%') as mom_growth
from fashion.vw_monthly_revenue;
select * from fashion.vw_monthly_revenue
--revenue growth by month--
  --without using view---
select month,sales_per_month,sum(sales_per_month) over(order by month) as running_revenue from
  (select  month(sale_date) as month,sum(total_sales) sales_per_month from fashion.sales 
   group by month(sale_date))t;

select month,revenue, sum(revenue) over(order by month)as running_revenue from fashion.vw_monthly_revenue;

--revenue by channel campaign and its contribution toward total revenue
select channel_campaign,total_sales,sum(total_sales) over() as all_sales,
concat(round(total_sales/sum(total_sales) over() *100,2),'%') as contribution_percentage
   from
   (select channel_campaign ,sum(total_sales) as total_sales from fashion.sales group by channel_campaign)t;

--customer based metrics--

--total no of customers who signed up--
select count(*) as total_customer from fashion.customers;


--total no of customers who purchased(active customer)--
select sum(active_customers)as active_customers from fashion.vw_customer_summary;

--customer distribution by signup month--
 select month(signup_date) as month ,count(customer_id) total_cus from fashion.customers 
 group by month(signup_date)
 order by total_cus desc;

--average time in days for first purchase from signup date --
with first_purchase as(
  select customer_id,min(sale_date) as first_purchase_date from fashion.sales group by customer_id
)
select avg(DATEDIFF(day,c.signup_date,f.first_purchase_date)) as avg_days_order
from first_purchase f left join fashion.customers c on f.customer_id=c.customer_id
where f.first_purchase_date > c.signup_date ;

--total customers by country and their revenue--
select country,active_customers,total_revenue from fashion.vw_customer_summary;


--revenue contribution %  by country---
select country,total_rev,sum(total_rev) over() as all_rev,
total_rev*1.0 / sum(total_rev) over()*100 as rev_contribution from
    (select c.country, SUM(s.total_sales) as total_rev from fashion.sales s join fashion.customers c 
    on s.customer_id =c.customer_id group by c.country)t 
    order by rev_contribution desc;

--average revenue per customer (ARPC) --
select sum(total_sales)*1.0 /count(distinct customer_id) as ARPC from fashion.sales

---top 10 customer based on revenue---
select top 10 customer_id , sum(total_sales) as total_sale from fashion.sales 
 group by customer_id order by total_sale desc;


 --monthly repeat purchase rate--
 with monthly_orders as (
    select format(sale_date,'yyyy-MM') purchase_date,customer_id,count(sale_id) total_monthly_orders from fashion.sales 
    group by customer_id,format(sale_date,'yyyy-MM')
 )
 select purchase_date , 
 count(case when total_monthly_orders > 3 then customer_id end) *1.0 / count(distinct customer_id) *100 as monthly_percentage
 from monthly_orders group by purchase_date;

 --customers loyal to one channel---
 select count(*) as loyal_to_one_channel from 
    (select customer_id ,count(distinct channel) as t_channel from
    fashion.sales group by customer_id having count(distinct channel) =1)t

--customers from only one channel--
select channel ,count(customer_id) from 
  (select customer_id ,max(channel) as channel from fashion.sales 
  group by customer_id having count(distinct channel) =1 )t
  group by channel;

--product based metrics--

--revenue share by product category--

select category,total_rev,sum(total_rev) over() as total_all_rev,
total_rev*1.0/sum(total_rev) over() *100 as percentage_share from
    (select category,sum(total_revenue) as total_rev from fashion.vw_product_performance
     group by category)t

--most sold size--
select p.size , count(s.sale_id) total_count from fashion.sales s join fashion.products p on s.product_id=p.product_id
   group by p.size order by total_count desc

--total quantity sold by product--
select product_id,product_name,sum(total_quantity) as total_quantity_sold from fashion.vw_product_performance
group by product_id,product_name order by total_quantity_sold desc;

--average selling price per product--
select sum(total_revenue) *1.0 / count(product_id) as AVG_SP_PProduct from fashion.vw_product_performance

--profit per product--

--with the use of view--
select product_id ,product_name,total_profit from fashion.vw_product_performance order by total_profit desc

--same insight without view---
select p.product_id , p.product_name,sum((s.unit_price - p.cost_price)*s.quantity) as total
  from fashion.sales s left join fashion.products p on s.product_id=p.product_id
  group by p.product_id, p.product_name order by total desc

--profit per category--
select p.category ,sum((s.unit_price-p.cost_price)*s.quantity) as total
  from fashion.sales s left join fashion.products p on s.product_id=p.product_id
  group by p.category order by total desc

--product with higest profit margin --

--with view--
select top 1 product_id,product_name,profit_margin from fashion.vw_product_performance order by profit_margin desc;

--without view--
select top 1 p.product_id ,p.product_name, 
sum((s.unit_price - p.cost_price)*s.quantity) / sum(s.unit_price * s.quantity) *100 as sp 
 from fashion.sales s left join fashion.products p on s.product_id=p.product_id
 group by  p.product_id,p.product_name order by sp desc

--product with  lowest profit margin --
--with view--
select top 1 product_id,product_name,profit_margin from fashion.vw_product_performance order by profit_margin ; 

--without view--
select top 1 p.product_id ,p.product_name, 
sum((s.unit_price - p.cost_price)*s.quantity) / sum(s.unit_price * s.quantity) *100 as sp 
   from fashion.sales s left join fashion.products p on s.product_id=p.product_id
   group by  p.product_id,p.product_name order by sp asc;

--most sold category--
select p.category ,sum(s.quantity) total_quantity
 from fashion.sales s left join fashion.products p on s.product_id=p.product_id
    group by p.category order by total_quantity desc

--with view--
select category,sum(total_quantity) as total_quantity_sold from fashion.vw_product_performance 
    group by category;

 -- trend analysis--
 --first date vs last date per product--
 with active as(
 select p.product_id,p.product_name,DATEDIFF(day,min(s.sale_date),max(s.sale_date)) as active_days
 from fashion.sales s left join fashion.products p on s.product_id=p.product_id 
    group by p.product_id,p.product_name
)
select product_name,active_days,
    case when active_days <20 then 'short lived product'
         when active_days >=20 and active_days <50 then 'lasting product'
         else 'evergreen product' end as product_type
from active order by active_days desc;

--product gaining or losing popularity by month--
with trend as (
    select month(s.sale_date) month,p.product_name,sum(s.quantity) CM_quantity_sold 
    from fashion.sales s left join fashion.products p on s.product_id=p.product_id
    group by month(s.sale_date),p.product_name
)
select *,case when CM_quantity_sold > PYM_quantity_sold then 'Gaining popularity' else 'Losing popularity' end as popularity 
    from 
    (select month,product_name,cm_quantity_sold,
    coalesce(lag(cm_quantity_sold) over(partition by product_name order by month),0) as PYM_quantity_sold
    from trend )t

--RFM analysis--
with RFM as (
    select c.customer_id , datediff(day,max(s.sale_date),GETDATE()) as recency,count(s.sale_id) as frequency ,sum(s.total_sales)
    as monetary
    from fashion.sales s left join fashion.customers c on s.customer_id=c.customer_id
    group by c.customer_id),

   RFM_sc as (select * ,case when recency < 120 then 1 
               when  recency >=120 and recency<150 then 2
               else 3 end as r_score,
          case when frequency < 3 then  1
               when frequency >=3 and frequency < 7 then 2
               else 3 end as f_score,
          case when monetary < 500 then 1 
               when monetary >= 500 and monetary < 1000 then 2
          else 3 end as m_score from RFM)

select *,case when r_score=3 and f_score=3 and m_score=3 then 'vip customer'
              when r_score>=2 and f_score>=2 and m_score >=2 then 'Loyal customer'
              else 'regular customer' end as loyality_segment


from RFM_sc ;

--customer lifetime value clv---
with clv as(
    select customer_id , sum(total_sales) *1.0/ count(distinct sale_id) as aov,
    count(sale_id)/count(distinct customer_id) as purchase_frequency , datediff(day,min(sale_date),max(sale_date))
    as average_time ,
    sum(total_sales) *1.0/ count(distinct sale_id) * count(sale_id)/count(distinct customer_id) * 
    datediff(day,min(sale_date),max(sale_date)) estimated_clv
    from fashion.sales  group by customer_id 
)                       
select * ,NTILE(3) over(order by estimated_clv) as clv_quartile from clv
order by estimated_clv desc;

--customer churn indicator--
with ci as (
    select customer_id, max(sale_date) as last_purchase_date,
    datediff(day,max(sale_date),'2025-08-01') as date_since_last_purchase
    from fashion.sales group by customer_id
)
select * ,case when date_since_last_purchase <45 then 'active'
               when date_since_last_purchase between 45 and 90 then 'at risk'
               else 'churned' end as churn_indicator
from ci;

---churn rate %----
with churn as (
  Select customer_id,
      case
          when DATEDIFF(DAY, MAX(sale_date), '2025-08-01') > 90 THEN 'Churned'
          else 'Active'
      end AS churn_flag
  From fashion.sales
  group by  customer_id
)
Select count(case when churn_flag = 'Churned' then 1 end) * 100.0 / COUNT(*) AS churn_rate_percent
FROM churn;



