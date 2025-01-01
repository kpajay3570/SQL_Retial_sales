-------- 1.Table creation-----------------
CREATE TABLE retial_sales
(
  transactions_id INT PRIMARY KEY,
  sale_date DATE,
  sale_time	TIME,
  customer_id INT,
  gender VARCHAR(15),	
  age INT,
  category	VARCHAR(15),
  quantiy	INT,
  price_per_unit FLOAT,
  cogs	FLOAT,
  total_sale FLOAT
);
------To check first 10 rows with " limit "----- 
SELECT * FROM retial_sales
LIMIT 10
SELECT COUNT(*) FROM retial_sales
---- TO CHECK WHETHER NULL VALUES PRESENT OR NOT IN EVERY COLUMN----
SELECT * FROM retial_sales
WHERE 
 transactions_id IS NULL
 OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
 gender IS NULL
 OR
 age IS NULL
 OR
 category IS NULL
 OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 total_sale IS NULL;

 -----To Delete null rows-----
 DELETE FROM retial_sales
 WHERE 
 transactions_id IS NULL
 OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
 gender IS NULL
 OR
 age IS NULL
 OR
 category IS NULL
 OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 total_sale IS NULL;

 ----Again to check all the rows-----
 SELECT COUNT(*) FROM retial_sales;
 -------  2.Date Exploration-----
 ---- To Check total number of sales from table------ 
SELECT COUNT(*) AS total_sale FROM retial_sales;
------ Retrive all col for sales made on 2022-11-05------
SELECT * FROM retial_sales 
WHERE sale_date = '2022-11-05';
-------query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:-----
SELECT * FROM retial_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4
----query to calculate the total sales (total_sale) for each category----
SELECT category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retial_sales
GROUP BY 1

----- query to find the average age of customers who purchased items from the 'Beauty' category----
SELECT ROUND(AVG(age), 2) as avg_age
FROM retial_sales
WHERE category = 'Beauty'

------ SQL query to find all transactions where the total_sale is greater than 1000----
SELECT * FROM retial_sales
WHERE total_sale > 1000
------ SQL query to find all transactions where the total_sale is between 1000 and 1500----
SELECT * FROM retial_sales
WHERE total_sale BETWEEN 1000 AND 1500
------query to find the total number of transactions (transaction_id) made by each gender in each category------
SELECT category,gender,
COUNT(*) as total_trans
FROM retial_sales
GROUP BY category,gender
ORDER BY 1
------query to calculate the average sale for each month. Find out best selling month in each year-----
SELECT year,month,avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retial_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-----------SQL query to find the top 5 customers based on the highest total sales----
SELECT customer_id,
SUM(total_sale) as total_sales
FROM retial_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

------------query to find the number of unique customers who purchased items from each category-----
SELECT category, COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retial_sales
GROUP BY category

------query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)-----
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retial_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift