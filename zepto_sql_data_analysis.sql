drop table if exists zepto;

create table zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(150),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
);


--DATA EXPLORATION

--COUNT OF ROWS
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 50;

--NULL VALUES
SELECT * FROM zepto
WHERE name IS NULL
OR 
category IS NULL
OR 
mrp IS NULL
OR 
discountpercent IS NULL
OR 
availablequantity IS NULL
OR 
discountedsellingprice IS NULL
OR 
weightingms IS NULL
OR 
outofstock IS NULL
OR
quantity IS NULL;


--differnt product categories
SELECT DISTINCT(category) from zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outofstock,count(sku_id)
FROM zepto
GROUP BY outofstock;

--product name present multiple times
SELECT name,COUNT(sku_id)
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;


--Data cleaning

--product with 0 price
SELECT * FROM zepto
WHERE mrp = 0
OR discountedSellingPrice = 0; --it should not be not like that mrp is 0 so we are deleting that row

DELETE FROM zepto
WHERE mrp=0;


--converting paise to rupees
UPDATE zepto
SET mrp= mrp/100,
discountedSellingPrice = discountedSellingPrice/100;


SELECT mrp,discountedSellingPrice FROM zepto;

--Q1. Find the top 10 best valued products based on discount percentage.

SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
 
--Q2. What are the products with High MRP but OutOfStock

SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = True AND mrp > 300
ORDER BY mrp desc;

--Q3. Calculate the Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * Quantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

--Q4.Find all products where MRP is greater than rs.500 and discount is less than 10%.
SELECT name,mrp,discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent <10
ORDER BY mrp DESC,discountPercent DESC;


--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(avg(discountPercent),2)  AS avg_disc_per
FROM zepto
GROUP BY category
ORDER BY avg_disc_per DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,weightingms,discountedsellingprice
ROUND(discountedsellingprice/weightingms,2) as price_per_gram
FROM zepto
WHERE weightingms >= 100 
ORDER BY price_per_gram;

--Q7. Group the products into categories like Low,Medium,Bulk.
SELECT DISTINCT name,weightingms,
CASE
	WHEN weightingms <1000 THEN 'Low'
	WHEN weightingms <5000 THEN 'Medium'
	ELSE 'Bulk'
END AS weight_category
FROM zepto;

--Q8. What is the Total Inventory Weight Per Category
SELECT category,
SUM(weightingms * availableQuantity) as total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

