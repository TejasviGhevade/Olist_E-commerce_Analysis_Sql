-- kpi 1
-- year and Quarter wise sale
select year(order_purchase_timestamp) as year ,quarter(order_purchase_timestamp) as Quarter , Round(sum(payment_value),0) as Sales
from olist_orders_dataset as o_d
left join olist_order_payments_dataset as o_p
on o_d.order_id = o_p.order_id
group by year , Quarter 
order by year;

-- kpi 2
-- month wise total_Quantity
select date_format(order_purchase_timestamp , '%m') as month_nu, monthname(order_purchase_timestamp) as month_name , count(order_id) as total_Quantity
from olist_orders_dataset
group by month_nu , month_name
order by month_nu;

-- kpi 3
-- top 10 products by revenue 
select product_category_name_english , round(sum(payment_value),0) as total_revenue
from product_category_name_translation a
inner join olist_products_dataset b
on a.product_category_name = b.product_category_name
join olist_order_items_dataset c
on b.product_id = c.product_id
join olist_order_payments_dataset d
on c.order_id= d.order_id
group by product_category_name_english
order by total_sale desc
limit 10;

-- kpi 4
-- which payment method is commonly used
select payment_type , count(payment_type) as num
from olist_order_payments_dataset
group by payment_type
order by num desc;

-- kpi 5
-- What is the distribution of seller ratings , and how does this impact sales performance?
select 
case 
when review_score = 5 then "Excellent"
when review_score = 4 then "very good"
when review_score = 3 then "good"
when review_score = 2 then "bad"
when review_score = 1 then "very bad"
end as Rating ,
count(a.order_id) as total_orders , round(sum(c.payment_Value),2) as total_rev 
from olist_orders_dataset a
join olist_order_reviews_dataset b
on a.order_id = b.order_id
join olist_order_payments_dataset c
on b.order_id = c.order_id
group by Rating
order by total_orders desc;

-- kpi 6
-- avg rating for each product
select product_category_name , avg(review_score ) as avg_rating
from olist_order_reviews_dataset a
join olist_order_items_dataset b on a.order_id=b.order_id
join olist_products_dataset c on b.product_id=c.product_id
group by product_category_name;

-- kpi 7
-- Avg price for particulare city (" sao paulo")
select round(Avg(price),2) as avg_price, customer_city
from olist_order_items_dataset a 
join olist_orders_dataset b
on (a.order_id=b.order_id) 
join olist_customers_dataset c 
on (b.customer_id=c.customer_id)
where customer_city= 'sao paulo';

-- kpi 8
-- Avg payment_value for paticulare city ("sao paulo")
select round(Avg(payment_value),2) , customer_city
from olist_order_payments_dataset a 
join olist_orders_dataset b
on (a.order_id=b.order_id) 
join olist_customers_dataset c 
on (b.customer_id=c.customer_id)
where customer_city= 'sao paulo';


-- kpi 9
-- weekend vs weekday payment_stat
select
case 
 when dayofweek(order_purchase_timestamp) in (2,3,4,5,6) then 'weekday'
 else 'weekend'
 end as purchase_day_category ,
round(sum(payment_value),2) as payment_stat
from olist_orders_dataset a
inner join olist_order_payments_dataset b
on a.order_id = b.order_id
group by purchase_day_category;


-- kpi 10
-- Avg  number of days taken for order_delivered_customer_date for pet_shop
select product_category_name , round(AVG(DATEDIFF(order_delivered_customer_date , order_purchase_timestamp)),0)  AS avg_days
from olist_products_dataset as p_d
left join olist_order_items_dataset as o_i
on p_d.product_id = o_i.product_id
left join olist_orders_dataset as o_d
on o_i.order_id = o_d.order_id
where product_category_name = "pet_shop" ;

-- kpi 11
-- Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT coalesce(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp),"NA") AS shipping_days,
	   round(Avg(r.review_score),0) as avg_review_score
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
group by shipping_days
order by avg_review_score desc;


-- kpi 12
-- Number of Orders with review score 5 and payment type as credit card.
select count(b.order_id) as Number_of_Orders , payment_type , review_score
from olist_order_payments_dataset a 
inner join olist_order_reviews_dataset b on (a.order_id = b.order_id)
where review_score = 5 and payment_type = 'Credit_card';


-- kpi 13
-- How many customers have made repeat purchases
select count(*)
from (select customer_state , customer_unique_id , count( distinct order_id)
from olist_orders_dataset a
join olist_customers_dataset b
on a.customer_id = b.customer_id
group by  customer_state , customer_unique_id 
having  count(order_id) > 1
order by customer_unique_id  desc)sub;


-- kpi 14 
-- average order value  and how does this vary by product category 
select product_category_name  , round((sum(b.payment_value)/ count(a.order_id)),2) as avg_order_value
from olist_orders_dataset a
join olist_order_payments_dataset b on a.order_id = b.order_id
join olist_order_items_dataset c on a.order_id = c.order_id
join olist_products_dataset d on c.product_id = d.product_id
group by product_category_name
order by avg_order_value desc ;

-- kpi 15
-- average order value  and how does this vary by payment_type
select payment_type , round((sum(b.payment_value)/ count(a.order_id)),2) as avg_order_value
from olist_orders_dataset a
join olist_order_payments_dataset b on a.order_id = b.order_id
join olist_order_items_dataset c on a.order_id = c.order_id
group by payment_type
order by avg_order_value desc ;










