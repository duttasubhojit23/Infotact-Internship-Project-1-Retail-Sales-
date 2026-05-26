-- Retail Sales Analysis using SQL
-- This file contains queries for analyzing sales performance

--  CREATE A TABLE for aggregation
CREATE TABLE sales_analytics (
	Order_Id INT PRIMARY KEY,
	Order_Date DATE,
	Order_Month_Num INT,
    Order_Month VARCHAR (10),
    Order_Time TIME,
    Order_Hour INT,
	Order_Time_Period VARCHAR (10),
    Product_Id VARCHAR (5),
    Product_Name VARCHAR (20),
	Category VARCHAR (15),
	Quantity INT,
	Unit_Price INT,
	Discount DECIMAL (5,2),
	Revenue DECIMAL (7,2),
	City VARCHAR (20),
	State VARCHAR (20),
	Store_Type VARCHAR (15),
	Customer_Id VARCHAR (15),
	Customer_Segment VARCHAR (15)
);

select * from sales_analytics;

-- Null Values checking for any missing values
SELECT
	SUM(CASE WHEN Order_Id IS NULL THEN 1 ELSE 0 END) AS Order_Id,
	SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Order_Date,
	SUM(CASE WHEN Order_Month_Num IS  NULL THEN 1 ELSE 0 END) AS Order_Month_Num,
	SUM(CASE WHEN Order_Month IS NULL THEN 1 ELSE 0 END) AS Order_Month,
	SUM(CASE WHEN Order_Time IS NULL THEN 1 ELSE 0 END) AS Order_Time,
	SUM(CASE WHEN Order_Hour IS NULL THEN 1 ELSE 0 END) AS Order_Hour,
	SUM(CASE WHEN Order_Time_Period IS NULL THEN 1 ELSE 0 END) AS Order_Time_Period,
	SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS Product_Name,
	SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Category,
	SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Quantity,
	SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END)AS Unit_Price,
	SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS Discount,
	SUM(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS Revenue,
	SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City,
	SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END)AS State,
	SUM(CASE WHEN Store_Type IS NULL THEN 1 ELSE 0 END)AS Store_Type,
	SUM(CASE WHEN Customer_Id IS NULL THEN 1 ELSE 0 END)AS Customer_Id,
	SUM(CASE WHEN Customer_Segment IS NULL then 1 ELSE 0 END)AS Customer_Segment
FROM sales_analytics;

-- Duplicate Detection for any same or mistaken values
SELECT 
Order_Id,Order_Date,Order_Month_Num,Order_Month,Order_Time,Order_Hour,Order_Time_Period,
Product_Id,Product_Name,Category,Quantity,Unit_Price,Discount,Revenue,City,State,Store_Type,
Customer_Id,Customer_Segment FROM sales_analytics
GROUP BY Order_Id,Order_Date,Order_Month_Num,Order_Month,Order_Time,Order_Hour,Order_Time_Period,
Product_Id,Product_Name,Category,Quantity,Unit_Price,Discount,Revenue,City,State,Store_Type,
Customer_Id,Customer_Segment HAVING COUNT(*) >1;

-- KPI Queries for Insights


-- Total Revanue
SELECT SUM(Revenue) AS Total_Revnue
FROM sales_analytics;

-- Total Orders 
SELECT COUNT(DISTINCT Order_Id) AS Total_Order
FROM sales_analytics;

-- Total Discount
SELECT SUM(Discount) AS Total_Discount
FROM sales_analytics;

-- Avarage Revanue
SELECT ROUND(SUM(Revenue),2)AS Avg_Revnue    
FROM sales_analytics;

-- Avarage Orders
SELECT AVG(Order_Id) AS Avg_Orders
FROM sales_analytics;

-- Total Units Sold
SELECT SUM(Quantity) AS Total_Units_Sold
FROM sales_analytics;

-- Revenue Sales Analysis by time periods

-- Monthly Sales Trend
SELECT Order_month AS Month,
SUM(Revenue) AS Monthly_Sales
FROM sales_analytics
GROUP BY Month
ORDER BY Monthly_Sales DESC;

-- Time Period Revenue
SELECT 
Order_Time_period,
ROUND(SUM(Revenue),0) AS Orders
FROM sales_analytics
GROUP BY 1
ORDER BY 2 DESC;

-- Yearly Growth using extraction
SELECT EXTRACT(YEAR FROM Order_Date) AS Year,
SUM(Revenue) AS Revenue
FROM sales_analytics
GROUP BY Year

-- Order Trend Analysis based on orders and time periods

-- Order Trend Analysis
SELECT 
Order_Month AS Month,
COUNT(Order_id) AS Orders
FROM sales_analytics
GROUP BY Month
ORDER BY Orders DESC;

-- Time Period Analysis
SELECT 
Order_Time_period,
COUNT(Order_id) AS Orders
FROM sales_analytics
GROUP BY 1
ORDER BY 2 DESC;

-- Quarterly Trends BY Revenue and Orders
SELECT CASE
	WHEN Order_Month_Num BETWEEN 1 AND 3 THEN 'Q1 (Jan-Mar)'
	WHEN Order_Month_Num BETWEEN 4 AND 6 THEN 'Q2 (Apr-Jun)'
	WHEN Order_Month_Num BETWEEN 7 AND 9 THEN 'Q3 (Jul-Sep)'
	WHEN Order_Month_Num BETWEEN 10 AND 12 THEN 'Q4 (Oct-Dec)'
	END AS Quarter,
	COUNT(Order_Id) AS Total_Orders,
	ROUND(SUM(Revenue),2) AS Quarterly_Revenue
FROM sales_analytics
GROUP BY Quarter
ORDER BY Quarter;

-- Time-Based Insights for detailed understanding

-- Hour Base Orders
SELECT 
	EXTRACT(HOUR FROM Order_Time)AS Hour,
	COUNT(*) AS Total_Orders
FROM sales_analytics
GROUP BY 1
ORDER BY 1;

-- Peack Days of Week,Total Sales and Revenue
SELECT
	TO_CHAR(Order_Date,'Day') AS Day,
	COUNT(*) AS Total_Orders,
	SUM(Revenue) AS Total_Revenue
FROM sales_analytics
GROUP BY Day
ORDER BY 3 DESC;

-- Peack Time Period Revenue and Revenue
SELECT 
	Order_Time_Period,
	COUNT(*) AS Total_Orders,
	SUM(Revenue) AS Total_Revenue
FROM sales_analytics
GROUP BY 1
ORDER BY Total_Revenue DESC;

-- Product performance analysis
SELECT
	Category AS Category,
	Product_Name AS Product_Name,
	COUNT(Order_Id) AS Total_Order,
	SUM(Quantity) AS Unit_Sold,
	SUM(Discount) AS Total_Discount,
	ROUND(SUM(Revenue),0) AS Total_Revenue
FROM sales_analytics
GROUP BY Category,Product_Name
ORDER BY 1 ;

-- Top selling products
SELECT Product_Name,SUM(Quantity) AS Total_Sold
FROM sales_analytics
GROUP BY Product_Name
ORDER BY Total_Sold DESC;

-- Best - Selling Products and Category by Revenue
SELECT
	Product_Id,
	Product_Name,
	Category,
	SUM(Quantity) Total_Unit_Sold,
	COUNT(Order_Id) AS Total_Orders,
	ROUND(AVG(Unit_Price),2) AS Avg_Unit_Price,
	ROUND(SUM(Revenue),2) AS Total_Revenue
FROM sales_analytics
GROUP BY 1,2,3
ORDER BY Total_Revenue DESC;

-- Category wise Revenue
SELECT Category,
	COUNT(Order_Id) AS Total_Orders,
	SUM(Revenue) AS Total_Revenue
FROM sales_analytics
GROUP BY Category
ORDER BY Total_Revenue DESC;

-- Product wise Revenue
SELECT 
	Product_Id,Product_Name,
	COUNT(Order_Id) AS Orders,
	SUM(Quantity) AS Quantity,
	ROUND(SUM(Revenue),2) AS Total_Revenue
FROM sales_analytics
GROUP BY 1,2
ORDER BY Total_Revenue DESC;

-- Product Rank Within each category
SELECT Category,	
	Product_Name,
	ROUND(SUM(Revenue),2) AS Total_Revenue,
	RANK() OVER(
	PARTITION BY Category
	ORDER BY SUM(Revenue)DESC 
		) AS Rank_In_Category
FROM sales_analytics
GROUP BY Category,Product_Name
ORDER BY Category,Rank_In_Category;

--Geographical Sales Insights

-- Total Revenue by City Wise
SELECT City,SUM(Revenue) AS Total_Revenue
FROM sales_Analytics
GROUP BY City
ORDER BY Total_Revenue DESC;

-- Revenue Analysis by City and State
SELECT City,
	State,
	COUNT(Order_Id) AS Total_Orders,
	SUM(Quantity) AS Untis_sold,
	ROUND(SUM(Revenue),2) AS Total_Revenue,
	 ROUND(100.0 * SUM(revenue) /
             SUM(SUM(revenue)) OVER (), 2) AS revenue_share_pct
FROM sales_analytics
GROUP BY City,State;

-- Revenue Analysis for City and State by Store Type

SELECT city, state,
       store_type,
       COUNT(order_id)       AS orders,
       ROUND(SUM(revenue),2) AS revenue
FROM  sales_analytics
GROUP  BY city, state, store_type;

-- City and State Monthly Revenue
SELECT State,City
	Order_Month_Num,
	Order_Month,
	SUM(Quantity) AS Unit_Sold,
	COUNT(Order_Id) AS Total_Order,
	ROUND(SUM(Revenue),2) AS Total_Revenue
FROM Sales_analytics
GROUP BY 1,2,3
ORDER BY 1,2,3

-- Top Celling Product by City
WITH Ranked AS(
	SELECT City,
	Product_Name,
	ROUND(SUM(Revenue),2) AS Revenue,
	RANK() OVER(
		PARTITION BY City
		ORDER BY SUM(Revenue) DESC
	) AS Rnk
FROM sales_analytics
GROUP BY City,Product_Name
)
SELECT City,Product_Name,Revenue
FROM Ranked
WHERE Rnk = 1
ORDER BY Revenue DESC;


-- Online VS Offline Channel Analysis

-- Revenue and Total Orders 
SELECT Store_Type,
	COUNT(DISTINCT Order_Id) as Total_Orders,
	SUM(Revenue) AS Revenue
FROM sales_analytics
GROUP BY 1	

--  Online and Offline Channel Performance 
SELECT
	Store_Type,State,City,
	COUNT(Order_Id)AS Total_Orders,
	SUM(Quantity) AS Units_Sold,
	ROUND(AVG(Revenue),2) AS Avg_Order_Value,
	ROUND(SUM(Revenue),2) AS Total_Revenue,
	ROUND(100.0 * SUM(Revenue) /
		SUM(SUM(Revenue)) OVER (),2) AS Revenue_shere_pct
FROM sales_analytics
GROUP BY 1,2,3
ORDER BY 1;

-- Customer Insights

-- Revenue by Customer Segment
SELECT
	Customer_Segment,
	SUM(Revenue) AS Revenue
FROM sales_analytics
GROUP BY Customer_Segment;

-- Total Order by Customer Segment
SELECT
	Customer_Segment,
	COUNT(order_Id) as Total_Order
FROM sales_analytics
GROUP BY Customer_Segment
ORDER BY Total_Order DESC;

-- Top 10 Customers By Lifetime Revenue
SELECT 
	Customer_Id,
	Customer_Segment,
	COUNT(Order_Id) AS Total_Orders,
	SUM(Quantity) AS Total_Units,
	ROUND(SUM(Revenue),2) AS Lifetime_Revenue,
	ROUND(AVG(Revenue),2) AS Avg_Order_Revenue,
	MIN(Order_Date) AS First_Purchase,
	MIN(Order_Date) AS Last_Purchase
FROM sales_analytics
GROUP BY 1,2
ORDER BY Lifetime_Revenue DESC
LIMIT 10;

-- Discount Analysis
SELECT CASE
		WHEN Discount = 0 THEN 'NO Discount'
		WHEN Discount <= 0.05 THEN '1-5%'
		WHEN Discount <= 0.10 THEN '6-10%'
		WHEN Discount <= 0.15 THEN '11-15%'
		ELSE '>15%'
	END AS Discount_Rate,
	COUNT(Order_Id) AS Orders,
	ROUND(SUM(Revenue),2) AS Total_Revenue,
	ROUND(AVG(Revenue),2) AS Avg_Revenue
FROM sales_analytics
GROUP BY 1
ORDER BY MIN(Discount);

-- Monthly New and Return Revenue
SELECT order_month_num,
       order_month,
       ROUND(SUM(CASE WHEN customer_segment='New' THEN revenue ELSE 0 END),2) AS new_customer_revenue,
       ROUND(SUM(CASE WHEN customer_segment='Returning' THEN revenue ELSE 0 END),2) AS returning_customer_revenue,
       ROUND(SUM(revenue),2) AS total_revenue
FROM sales_analytics
GROUP  BY order_month_num, order_month
ORDER  BY order_month_num;

select * from sales_analytics;
