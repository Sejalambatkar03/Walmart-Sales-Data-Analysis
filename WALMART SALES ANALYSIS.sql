USE  WalmartSales;
CREATE TABLE Sales(
	Invoice_ID VARCHAR(30) NOT NULL PRIMARY KEY,
    Branch VARCHAR(5) NOT NULL,
    City VARCHAR(30) NOT NULL,
    Customer_type VARCHAR(30) NOT NULL,
    Gender VARCHAR(30) NOT NULL,
    Product_line VARCHAR(100) NOT NULL,
    Unit_price DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    Tax_5 FLOAT NOT NULL,
    Total DECIMAL(12, 4) NOT NULL,
    Date DATETIME NOT NULL,
    Time TIME NOT NULL,
    Payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    Rating FLOAT
);


---- DATA CLEANING-----
----Calculate the time of day from time column

SELECT Time,
(  CASE 
      WHEN 'Time' BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	  WHEN 'Time' BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
	  ELSE 'Evening'
	  END
)AS Time_of_day
FROM Sales;

ALTER TABLE Sales ADD Time_of_day VARCHAR(20);

UPDATE Sales
SET Time_of_day = (
CASE 
      WHEN 'Time' BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	  WHEN 'Time' BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
	  ELSE 'Evening'
	  END
	  );

------ ADD DAY NAME COLUMN
SELECT Date,FORMAT(Date,'dddd') from Sales;
ALTER TABLE Sales ADD  Day_name VARCHAR(10);

UPDATE Sales
SET Day_name = FORMAT(Date,'dddd');
SELECT * FROM Sales;

---ADD MONTH COLUMN
SELECT Date,DATENAME(MONTH,Date) from Sales;
ALTER TABLE Sales ADD  Month_Name VARCHAR(10);

UPDATE Sales
SET Month_Name = DATENAME(MONTH,Date);
SELECT * FROM Sales;

----QUESTIONS
---How many unique cities does the data have?

SELECT DISTINCT(City) AS unique_city from Sales;

------ In which city is each branch?
SELECT DISTINCT(City),Branch
from Sales;

----- How many unique product lines does the data have?
SELECT DISTINCT(Product_line) as unique_product_line from Sales;

----What is the most selling product line ?
SELECT SUM(Quantity) as Quantity,Product_line
from Sales
Group by Product_line
Order by SUM(Quantity) DESC;

---- What is the total revenue by month ?
SELECT Month_Name as Month,
SUM(Total) AS Total_Revenue 
FROM SALES
GROUP BY Month_Name
ORDER BY Total_Revenue desc;

----What month had the largest COGS?
SELECT Month_Name as Month,SUM(cogs) as largest_cogs
from Sales
GROUP BY Month_Name 
ORDER BY largest_cogs desc;

----- What product line had the largest revenue?
SELECT Product_line , SUM(Total) as largest_revenue
from Sales
GROUP BY Product_line
ORDER BY largest_revenue DESC;

----- What is the city with the largest revenue?
SELECT City ,SUM(Total) as largest_revenue
FROM Sales
GROUP BY City
ORDER BY largest_revenue;



------ What product line had the largest TAX?
SELECT Product_line,AVG(Tax_5) as largest_tax
from Sales
GROUP BY Product_line
ORDER BY largest_tax DESC;

----- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT AVG(Quantity) as Avg_quantity from sales;

SELECT Product_line,
CASE WHEN AVG(Quantity) > 6 THEN 'Good'
ELSE 'Bad'
END AS rm
FROM Sales
GROUP BY Product_line;

-----Which branch sold more products than average product sold?
SELECT Branch,SUM(Quantity) as Quantity
FROM Sales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) from Sales);

-----What is the most common product line by gender ?
SELECT Gender,Product_line,
COUNT(Gender) as total_cnt
from Sales
GROUP BY Gender,Product_line
ORDER BY total_cnt;

------- What is the average rating of each product line
SELECT ROUND(AVG(Rating), 2)as avg_rating ,Product_line FROM 
Sales
GROUP BY Product_line
ORDER BY avg_rating DESC;

SELECT * FROM Sales;

----- How many unique customer types does the data have?
SELECT DISTINCT(Customer_type) as unique_customer_type from Sales;

-----How many unique payment methods does the data have?
SELECT DISTINCT(Payment) as unique_payment_method from Sales;

-----What is the most common customer type?
SELECT Customer_type,COUNT(*) AS count
from Sales
Group By Customer_type
Order by count desc;

------- What is the gender of most of the customers?
SELECT Gender,count(*) as gender_count
from Sales
GROUP BY Gender
ORDER BY gender_count;

--------- What is the gender distribution per branch?
SELECT Gender,COUNT(Gender) as gender_count 
from Sales
WHERE Branch  = 'C'
GROUP BY Gender
ORDER BY gender_count;
----Gender per branch is more or less the same hence, I don't think has
---an effect of the sales per branch and other factors.

------- Which time of the day do customers give most ratings?
SELECT Time_of_day,
AVG(Rating) as avg_rating
from Sales
Group by Time_of_day
Order by avg_rating desc;
---Looks like time of the day does not really affect the rating, its more or less the same rating each time of the day.

-------- Which time of the day do customers give most ratings per branch?
SELECT Time_of_day,AVG(Rating) as avg_rating
FROM Sales
WHERE Branch = 'C'
Group by Time_of_day
Order by avg_rating desc;
-- Branch A and C are doing well in ratings, branch B needs to do a little more to get better ratings.

-------Which day fo the week has the best avg ratings?
SELECT Day_name,AVG(Rating) as avg_rating
FROM Sales
GROUP BY Day_name
ORDER BY  avg_rating DESC;

-------- Which day of the week has the best average ratings per branch?
SELECT Day_name,AVG(Rating) as avg_rating
FROM Sales
WHERE Branch = 'C'
Group by Day_name
Order by avg_rating desc;

SELECT Day_name,AVG(Rating) as avg_rating
FROM Sales
WHERE Branch = 'A'
Group by Day_name
Order by avg_rating desc;

SELECT Day_name,AVG(Rating) as avg_rating
FROM Sales
WHERE Branch = 'B'
Group by Day_name
Order by avg_rating desc;

------Number of sales made in each time of the day per weekday
SELECT Time_of_day,
COUNT(*) AS total_sales
FROM Sales
WHERE Day_name = 'Monday'
GROUP BY Time_of_day
ORDER BY total_sales;
---Evenings experience most sales, the stores are filled during the evening hours

------ Which of the customer types brings the most revenue?
SELECT Customer_type,SUM(Total) as Revenue
FROM Sales
GROUP BY Customer_type
ORDER BY Revenue desc;

-------- Which city has the largest tax/VAT percent?
SELECT City,
ROUND(AVG(Tax_5) ,2)as largest_tax from Sales
GROUP BY City
ORDER BY largest_tax DESC;

------- Which customer type pays the most in VAT?
SELECT top 1 Customer_type,AVG(Tax_5) as total_tax 
from Sales
GROUP BY Customer_type
ORDER BY total_tax desc;

