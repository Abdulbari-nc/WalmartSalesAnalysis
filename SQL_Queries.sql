create table sales (
	invoice_id VARCHAR not null PRIMARY KEY,
	branch varchar,
	city varchar,
	customer_type varchar,
	gender varchar,
	product_line varchar,
	unit_price decimal,
	quantity int,
	VAT decimal(,
	total decimal,
	date date,
	time timestamp,
	payment_method varchar,
	cogs decimal,
	gross_margin_pecentage decimal,
	gross_income decimal,
	rating decimal
);

---- Feature Engineering -----
----time_of_day---------------
select time, case 
when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening' end
as time_of_day
from sales;

alter table sales add time_of_day varchar;
update sales
set time_of_day=( case 
when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '16:00:00' then 'Afternoon'
else 'Evening' end);

------Day_name-----------
select to_char(date,'Day') from sales;
alter table sales add Day_name varchar;
update sales set  Day_name= to_char (date,'Day');

-----Month_name-----------
select to_char(date,'Month') from sales;
alter table sales add Month_name varchar;
update sales set Month_name=to_char(date,'Month');

----Generic---------------
----How many unique cities does the data have?-----
select distinct city from sales;

----In which city is each branch?------------------
select distinct city, branch from sales;	

----Product---------------
----How many unique product lines does the data have?
select distinct product_line from sales;

----What is the most common payment method?---------
select payment_method,count(payment_method) from sales group by payment_method order by count desc;

----What is the most selling product line?-------
select product_line,count(product_line) as PL_CTN from sales group by product_line order by PL_CTN desc;

----What is the total revenue by month?----------
select month_name as month, sum(total) as total_revenue from sales group by month_name order by total_revenue desc;

----What month had the largest COGS?--------
select month_name as month, sum(cogs) as cost_of_goods_sold from sales group by month order by cost_of_goods_sold desc;

----What product line had the largest revenue?
select product_line,sum(total) as largest_revenue from sales group by product_line order by largest_revenue desc;

----What is the city with the largest revenue?
select branch,city, sum(total) as largest_revenue from sales group by city,branch order by largest_revenue desc;

----What product line had the largest VAT?---
select product_line, avg(vat) as value_added_tax from sales group by product_line order by value_added_tax desc;

----Which branch sold more products than average product sold?
select branch, sum(quantity) as qty from sales group by branch 
having sum(quantity) > (select avg(quantity) from sales); 

----What is the most common product line by gender?
select gender,product_line,count(gender) as total_cnt from sales group by gender,product_line 
order by product_line desc;

----What is the average rating of each product line?
select product_line, round (avg(rating),2) as avg_rating from sales group by product_line order by avg_rating desc;

----Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity) as avg_qty from sales;
select product_line,
	case when avg(quantity) > 5 then 'Good'
	else 'Bad' end
	from sales group by product_line;

----sales--------------------------
----Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales from sales group by time_of_day order by total_sales desc;

----Which of the customer types brings the most revenue?
select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;

----Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, avg(vat) as vat from sales group by city order by vat desc;

----Which customer type pays the most in VAT?--------
select customer_type, avg(vat) vat from sales group by customer_type order by vat desc;

----customer------------------------
----How many unique customer types does the data have?
select distinct customer_type from sales;

----How many unique payment methods does the data have?
select distinct payment_method from sales;

----What is the most common customer type?----------
select customer_type, count(customer_type) as tot_count from sales group by customer_type order by tot_count desc;

----Which customer type buys the most?--------------
select customer_type, sum(total) as tot_revenue from sales group by customer_type order by tot_revenue desc;

----What is the gender of most of the customers?----
select gender, count(*) as tot_count from sales group by gender order by tot_count desc;

----What is the gender distribution per branch?-----
select gender, branch, count(*) as tot_count from sales group by gender,branch order by branch;

----Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avg_rating from sales group by time_of_day order by avg_rating desc;

----Which time of the day do customers give most ratings per branch?
select time_of_day,branch, avg(rating) as avg_rating from sales group by time_of_day,branch order by branch asc;

----Which day of the week has the best avg ratings?--
select day_name, avg(rating) as avg_rating from sales group by day_name order by avg_rating desc;

----Which day of the week has the best average ratings per branch?
select day_name,branch, avg(rating) as avg_rating from sales group by day_name, branch order by branch asc;
