CREATE DATABASE Retail_Sales_Project;

--Retail Sales Analysis
DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales
             (
                 transactions_id INT PRIMARY KEY,
	             sale_date DATE, 
	             sale_time TIME, 
	             customer_id INT,
	             gender VARCHAR(15),
				 age INT,
				 category VARCHAR(20),
	             quantiy INT,
	             price_per_unit FLOAT,
	             cogs FLOAT,
	             total_sale FLOAT
			 );

SELECT * FROM Retail_Sales;

SELECT  
      COUNT(*) 
FROM Retail_Sales;

--Data Cleaning

SELECT 
     * 
FROM Retail_Sales
WHERE 
      transactions_id IS NULL
      OR 
	  sale_date IS NULL
	  OR 
	  sale_time IS NULL
	  OR
	  gender IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR 
	  cogs IS NULL
	  OR 
	  total_sale IS NULL
;


DELETE FROM Retail_Sales
WHERE 
     transactions_id IS NULL
      OR 
	  sale_date IS NULL
	  OR 
	  sale_time IS NULL
	  OR
	  gender IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR 
	  cogs IS NULL
	  OR 
	  total_sale IS NULL
;

--Data Exploration

--1.How many sales we have?

SELECT 
     COUNT(transactions_id) AS total_Sales
FROM Retail_Sales
;

--2. How many unique customers we have?

SELECT   
	 COUNT(DISTINCT customer_id) AS total_customers
FROM Retail_Sales
;

--3.How many categories we have?

SELECT   
	 COUNT(DISTINCT category) 
FROM Retail_Sales
;



-- Data analysis & Business Key Problems & Answers

--1. Retrieve all columns for sales made on '2022-11-05'

SELECT 
      *
FROM Retail_Sales
WHERE sale_date = '2022-11-05'
;

--2. Retreive all transactions where the category is 'Clothing' and the qunatity sold is more than 3 in the month of Nov-2022

SELECT 
     *
FROM Retail_Sales
WHERE category = 'Clothing'
     AND 
	 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	 AND 
	 quantiy >= 3
;

-- 3. Calculate the total sales and total orders for each category

SELECT 
      category,
	  SUM(total_sale) AS total_sales_per_each_category,
	  COUNT(*) AS total_orders
FROM Retail_Sales
GROUP BY 1
ORDER BY 2
;

--4. Find the average of cutomers who purchased items from the 'Beauty' category

SELECT 
     ROUND(AVG(age),2) AS Avg_age
FROM Retail_Sales
WHERE category = 'Beauty'
;

--5. Find all transactions where the total_sale is greater than 1000

SELECT 
     *
FROM Retail_Sales
WHERE total_sale > 1000
;

--6. Find the total number of transactions (transaction_id) made by each gender and each category

SELECT 
     category,
	 gender,
	 COUNT(transactions_id) AS total_transactions
FROM Retail_Sales
GROUP BY 1, 2
ORDER BY 1
;

--7. Calculate the average sales for each month. Find out best selling month in each year

SELECT *
FROM 
(
SELECT 
     EXTRACT(YEAR FROM sale_date) AS sale_year,
	 TO_CHAR(sale_date, 'Month') AS sale_month,
	 AVG(total_sale) AS Avg_sales,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS Rank
FROM Retail_Sales
GROUP BY 1,2
) as tb1
WHERE rank = 1
;

--8. Find the top 5 customers based on the highest total sales

SELECT
      customer_id,
	  SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5
;

--9.Find the number of unique customers who purchased items from each category

SELECT 
     COUNT(DISTINCT customer_id) AS Unique_customers,
	 category
FROM Retail_Sales
GROUP BY 2
ORDER BY 2
;


--10.Create each shift and number of orders (Example Morning <=12, Afternoon Between 12& 17, Evening > 17)

SELECT 
     COUNT(*) AS number_of_orders_per_each_shift,
	 Shift
FROM
(
SELECT 
     *,
     CASE
         WHEN EXTRACT(HOUR FROM sale_time)	<=12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time)	BETWEEN 12 AND 17  THEN 'Afternoon'
         ELSE 'Evening'
     END  AS Shift
FROM Retail_Sales
) as tb2
GROUP BY 2
ORDER BY 1
;


--End of Project

	 