--Create Table
Drop Table If Exists Retail_sales;
Create Table Retail_sales(
	transactions_id INT PRIMARY KEY	,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category Varchar(15),
	quantiy INT,
	price_per_unit Float,
	cogs Float,
	total_sale Float

);


--Sample Data
Select *From Retail_sales
Limit 10;

--COUNT OF ROWS
Select COUNT(*)From Retail_sales;

----Data Cleaning 

--NUll Values
Select * FROM Retail_sales
Where transactions_id IS NULL
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
total_sale IS NULL ;

--Removing NULL Data
Delete From Retail_sales
Where 
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
	total_sale IS NULL ;

----Data Exploration

--How many sales we have?
Select Count(*) as "Total Sale" From Retail_sales;

--How many customers we have
Select Count(Distinct(Customer_id)) as "Total Customers" 
From Retail_sales;

--How many categories we have
Select Distinct(category) as "Total Category"
From Retail_sales;

--Data  Analysis And Business Key Problems And Answers

-- Q.1 Write a SQL query to retrive all columns for sales made on 2022-11-05
Select * From Retail_Sales
Where Sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrive all transaction where the category is clothing and the quantity sold is more than 4 in the month of  Nov-2022
Select * From Retail_sales
Where category ='Clothing'
AND  To_Char(sale_date,'YYYY-MM') ='2022-11'
AND  quantiy >4;

-- Q.3 Write a SQL query to calculate the total sale (total_sale) for Each Category
Select category , Sum(total_sale) As Total_Sale,Count(*)as Total_Orders
From Retail_sales
Group by category;

-- Q.4 Write a SQL query to find average age of customers who purchased items from the 'Beauty' category.
Select Round(AVG(age),2) AS "Average Age"
From Retail_sales
Where category ='Beauty';

-- Q.5 Write a SQL query to find al transactions where the total_sale is greater than 1000.
Select *From Retail_Sales
Where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transaction (transaction_id) made by each gender in each category
select Distinct category , gender , Count(transactions_id) as  " total number of transaction "
From Retail_sales
Group by category , gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out  best selling month in each year.
Select  year,Month,avg_sale from
(Select 
     Extract(Year From sale_date) As year,
	 Extract(Month From sale_date) As Month,
	 AVG(total_sale) As avg_sale,
	 Dense_rank() Over(partition By Extract(Year From sale_date) Order By Extract(Month From sale_date) Desc ) as rank
	 From retail_sales
	 Group by 1,2
	 )as t1
Where rank=1;

-- Q.8 Write a SQL query to Find the top 5 customers based on the highest total sale
Select customer_id, Sum(total_sale) As "Total Sale"
From Retail_sales
Group By customer_id
Order By Sum(total_sale) Desc
Limit 5;

-- Q.9  Write a SQL query to find the number of unique customers who purchased items from each category
Select category,Count(customer_id) As "Count Of Unique Customer"
From Retail_sales
Group by 1;

-- Q.10  Write a SQL query to create each shift and number of orders (Example morning <=12,Afternoon Between 12 & 17 ,Evening >17)
With Hourly
As 
(
Select *,
    Case
	   When Extract (HOUR From sale_time)<12 Then 'Morning'
	   When  Extract (HOUR From sale_time) Between 12 AND 17 Then 'Afternoon'
	   Else 'Evening'
	 End As "shift"
From Retail_sales
)
Select shift, count(*) as Total_Orders
From Hourly
Group By Shift;
