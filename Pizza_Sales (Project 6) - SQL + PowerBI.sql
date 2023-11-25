select * from [Pizza DB]..pizza_sales

-- Total Revenue
select SUM(total_price) as Total_Revenue from [Pizza DB]..pizza_sales

-- Average Order Value
select SUM(total_price)/ COUNT(distinct order_id) as Average_order_value from [Pizza DB]..pizza_sales

-- Total Pizza Sold 
select SUM(quantity) as Total_pizza_sold from [Pizza DB]..pizza_sales

-- Total Orders 
select COUNT(distinct order_id) as Total_orders from [Pizza DB]..pizza_sales

-- Average Pizzas Per Order
select cast(cast(SUM(quantity) as decimal(10,2)) / 
cast(COUNT(distinct order_id) as decimal(10,2)) as decimal(10,2)) 
from [Pizza DB]..pizza_sales

-- Daily Trend for Total Orders
select DATENAME(dw, order_date) as order_day, COUNT(distinct order_id) as Total_orders
from [Pizza DB]..pizza_sales
group by DATENAME(dw, order_date)

-- Monthly Trend For Total Orders:
select DATENAME(month, order_date) as month_name, COUNT(distinct order_id) as Total_orders
from [Pizza DB]..pizza_sales
group by DATENAME(month, order_date)
order by Total_orders desc

-- Percentage Of Sales By Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price)from [Pizza DB]..pizza_sales ) AS DECIMAL(10,2)) AS percentage
from [Pizza DB]..pizza_sales
GROUP BY pizza_category

-- Percentage Of Sales By Pizza Size 
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price)from [Pizza DB]..pizza_sales ) AS DECIMAL(10,2)) AS percentage
from [Pizza DB]..pizza_sales
GROUP BY pizza_size
order by percentage desc

-- Total Pizzas Sold By Pizza Category
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
from [Pizza DB]..pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

--Top 5 Pizzas By Revenue 
select top 5 pizza_name, SUM(total_price) as Total_Revenue from [Pizza DB]..pizza_sales
group by pizza_name 
order by Total_Revenue desc

--Bottom 5 Pizzas By Revenue
select top 5 pizza_name, SUM(total_price) as Total_Revenue from [Pizza DB]..pizza_sales
group by pizza_name 
order by Total_Revenue asc

--Top 5 Pizzas By Quantity
select top 5 pizza_name, SUM(quantity) as Total_Pizza_Sold from [Pizza DB]..pizza_sales
group by pizza_name 
order by Total_Pizza_Sold desc 

--Bottom 5 Pizzas By Quantity
select top 5 pizza_name, SUM(quantity) as Total_Pizza_Sold from [Pizza DB]..pizza_sales
group by pizza_name 
order by Total_Pizza_Sold asc

--Top 5 Pizzas By Total Orders
select top 5 pizza_name, COUNT(distinct order_id) as total_orders from [Pizza DB]..pizza_sales
group by pizza_name 
order by total_orders desc

--Borrom 5 Pizzas By Total Orders
select top 5 pizza_name, COUNT(distinct order_id) as total_orders from [Pizza DB]..pizza_sales
group by pizza_name 
order by total_orders asc
