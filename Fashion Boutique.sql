CREATE DATABASE retail_fashion;
USE retail_fashion;

show tables;
SELECT * FROM retail_fashion.fashion_boutique_dataset;

RENAME table fashion_boutique_dataset to sales_data;

select * from sales_data;


/* Find the missing ratings:*/

SELECT COUNT(*) AS missing_ratings 
FROM sales_data 
WHERE customer_rating IS NULL;



select customer_rating from sales_data;

SELECT COUNT(*) AS missing_ratings 
FROM sales_data 
WHERE customer_rating < '2.3' ;
  /* OR customer_rating = 'null' */
  /* OR customer_rating = '[null]' */
  
  
UPDATE sales_data
SET customer_rating = NULL
WHERE customer_rating = '';


ALTER TABLE sales_data
MODIFY COLUMN customer_rating DECIMAL(3,1);

/* Clean the data (Replace NULLs):*/

SELECT product_id, 
       category, 
       COALESCE(customer_rating, 0) AS cleaned_rating
FROM sales_data;



ALTER TABLE sales_data
MODIFY COLUMN purchase_date DATE;

select count(product_id) from sales_data where month(purchase_date)=6;

/* Total Revenue and Order Volume by Category:*/
SELECT category,SUM(current_price) AS total_revenue,COUNT(product_id) AS total_orders
FROM sales_data
GROUP BY category
ORDER BY total_revenue DESC;

/*Specific Targeted Filtering:*/
SELECT * FROM sales_data
WHERE category = 'Bottoms'AND YEAR(purchase_date) = 2025 AND MONTH(purchase_date) = 5 AND stock_quantity >=1;

select category,purchase_date from sales_data;
  
 /* Calculate the Return Rate by Brand:*/ 
SELECT brand,
       COUNT(*) AS total_purchases,
       SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) AS total_returns,
       ROUND((SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS return_rate_percentage
FROM sales_data
GROUP BY brand
ORDER BY return_rate_percentage DESC;


/* Window Functions: Rank the Top Sales Month per Year:*/
SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM purchase_date) AS year, 
           EXTRACT(MONTH FROM purchase_date) AS month, 
           AVG(current_price) AS avg_sale,
           RANK() OVER(PARTITION BY EXTRACT(YEAR FROM purchase_date) ORDER BY AVG(current_price) DESC) AS sales_rank
    FROM sales_data
    GROUP BY 1, 2
) AS ranked_sales
WHERE sales_rank = 1;


/*sales in every season*/
select is_returned from sales_data;

select season,count(product_id) from sales_data 
where is_returned='False'
group by season;


/*1. Retrieve all columns and rows from the dataset.*/


SELECT * FROM sales_data;

/*2. Count the total number of transactions in the dataset.*/

SELECT COUNT(*) AS total_transactions FROM sales_data;

/*3. List all the unique fashion categories available.*/

SELECT DISTINCT category FROM sales_data;

/*4.List all the unique fashion brands in the dataset.*/

SELECT DISTINCT brand FROM sales_data;

/*5. Find the total number of items currently in stock across all products.*/


SELECT SUM(stock_quantity) AS total_inventory FROM sales_data;

/*6. Retrieve all sales that occurred in the 'Fall' season.*/

SELECT * FROM sales_data WHERE season = 'Fall';

/*7. Find all products that have a perfect customer rating of 5.0.*/


SELECT * FROM sales_data WHERE customer_rating = 5.0;

/*8. List all transactions where the item was returned.*/


SELECT * FROM sales_data WHERE is_returned = 'True';

/*9. Find transactions where the selling price is greater than $100.*/

SELECT * FROM sales_data WHERE current_price > 100;

/*10. Show the first 10 transactions sorted by the most recent purchase date.*/


SELECT * FROM sales_data ORDER BY purchase_date DESC LIMIT 10;

/*11. Find all 'Clothing' items sold specifically in the 'Summer' season.*/

SELECT * FROM sales_data WHERE category = 'Clothing' AND season = 'Summer';


/*12. Find all transactions for 'Zara' with a customer rating below 3.0.*/


SELECT * FROM sales_data WHERE brand = 'Zara' AND customer_rating < 3.0;

/*13. Find products with low stock (less than 10) but high ratings (4.5 or above).*/

SELECT * FROM sales_data WHERE stock_quantity < 10 AND customer_rating >= 4.5;

/*14. List transactions where a markdown of more than 20% was applied.*/

SELECT * FROM sales_data WHERE markdown_percentage > 20;

/*15. Find all sales that were successfully kept (NOT returned).*/

SELECT * FROM sales_data WHERE is_returned = 'False';

/*Phase 2: Aggregations & Grouping (16-30)*/

/*16. Calculate the total revenue generated across all time.*/

SELECT SUM(current_price) AS total_revenue FROM sales_data;

/*17. Calculate the average customer rating across all products.*/

SELECT ROUND(AVG(customer_rating), 2) AS average_rating FROM sales_data;

/*18. Find the total revenue generated per clothing category.*/

SELECT category, SUM(current_price) AS total_revenue 
FROM sales_data GROUP BY category;

/*19. Count the number of transactions per brand.*/

SELECT brand, COUNT(*) AS transaction_count 
FROM sales_data GROUP BY brand;

/*20. Calculate the average price of items sold per season.*/

SELECT season, ROUND(AVG(current_price), 2) AS avg_price 
FROM sales_data GROUP BY season;

/*21. Find the maximum and minimum price paid in the 'Accessories' category.*/

SELECT MAX(current_price) AS max_price, MIN(current_price) AS min_price 
FROM sales_data WHERE category = 'Accessories';

/*22. Find the average markdown (discount) percentage given per brand.*/

SELECT brand, ROUND(AVG(markdown_percentage), 2) AS avg_discount 
FROM sales_data GROUP BY brand;

/*23. Find the total number of returned items per category.*/

SELECT category, COUNT(*) AS total_returns 
FROM sales_data WHERE is_returned = 'True' GROUP BY category;

/*24. Count the number of items sold per year.*/

SELECT EXTRACT(YEAR FROM purchase_date) AS sales_year, COUNT(*) AS items_sold 
FROM sales_data GROUP BY sales_year;

/*25. Find brands that have generated more than $5,000 in total revenue.*/

SELECT brand, SUM(current_price) AS total_revenue 
FROM sales_data GROUP BY brand HAVING total_revenue > 5000;

/*26. Find the average stock quantity available per category.*/

SELECT category, ROUND(AVG(stock_quantity), 0) AS avg_stock 
FROM sales_data GROUP BY category;

/*27. Calculate the total revenue by season and order it from highest to lowest.*/


SELECT season, SUM(current_price) AS total_revenue 
FROM sales_data GROUP BY season ORDER BY total_revenue DESC;

/*28. Find categories where the average customer rating is strictly above 4.0.*/

SELECT category, AVG(customer_rating) AS avg_rating 
FROM sales_data GROUP BY category HAVING avg_rating > 4.0;


/*29. Count how many sales were made each month.*/

SELECT MONTHNAME(purchase_date) AS month, COUNT(*) AS total_sales 
FROM sales_data GROUP BY month;

/*30. Find the total revenue generated by items that were not returned.*/

SELECT SUM(current_price) AS true_revenue 
FROM sales_data WHERE is_returned = 'False';

/*Phase 3: Intermediate Business Analytics (31-40)*/

/*31. Calculate the overall return rate percentage for the boutique.*/

SELECT ROUND((SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS return_rate_pct 
FROM sales_data;

/*32. Calculate the return rate percentage per brand.*/

SELECT brand, ROUND((SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS return_rate_pct 
FROM sales_data GROUP BY brand ORDER BY return_rate_pct DESC;

/*33. Find the average customer rating for returned vs. non-returned items.*/

SELECT is_returned, ROUND(AVG(customer_rating), 2) AS avg_rating 
FROM sales_data GROUP BY is_returned;

/*34. Identify the top 3 best-selling brands by total revenue.*/

SELECT brand, SUM(current_price) AS total_revenue 
FROM sales_data GROUP BY brand ORDER BY total_revenue DESC LIMIT 3;

/*35. Find the specific date that generated the highest single-day revenue.*/

SELECT purchase_date, SUM(current_price) AS daily_revenue 
FROM sales_data GROUP BY purchase_date ORDER BY daily_revenue DESC LIMIT 1;

/*36. Compare the average current price of returned items versus kept items per brand.*/

SELECT brand, is_returned, ROUND(AVG(current_price), 2) AS avg_price 
FROM sales_data GROUP BY brand, is_returned ORDER BY brand;

/*37. Count the number of missing customer ratings per category.*/

SELECT category, COUNT(*) AS missing_ratings 
FROM sales_data WHERE customer_rating = 0 OR customer_rating IS NULL GROUP BY category;

/*38. Find the highest-priced item sold in each season.*/

SELECT season, MAX(current_price) AS highest_price 
FROM sales_data GROUP BY season;

/*39. Categorize products into 'High', 'Medium', and 'Low' price tiers and count them.*/


SELECT 
    CASE 
        WHEN current_price > 150 THEN 'High Tier'
        WHEN current_price BETWEEN 50 AND 150 THEN 'Medium Tier'
        ELSE 'Low Tier' 
    END AS price_tier, 
    COUNT(*) AS total_items
FROM sales_data GROUP BY price_tier;

/*40. Calculate the estimated original price before the markdown was applied.*/

SELECT product_id, current_price, markdown_percentage, 
       ROUND(current_price / (1 - (markdown_percentage / 100)), 2) AS original_price 
FROM sales_data WHERE markdown_percentage > 0 LIMIT 10;

/*Phase 4: Advanced Analytics & Window Functions (41-50)*/

/*41. Rank the brands by total revenue within each season.*/


WITH SeasonBrandSales AS (
    SELECT season, brand, SUM(current_price) AS revenue 
    FROM sales_data GROUP BY season, brand
)
SELECT season, brand, revenue, 
       RANK() OVER(PARTITION BY season ORDER BY revenue DESC) AS rank_in_season
FROM SeasonBrandSales;

/*42. Find the top-selling month for the year 2024.*/

WITH MonthlySales AS (
    SELECT MONTH(purchase_date) AS month, SUM(current_price) AS revenue
    FROM sales_data WHERE YEAR(purchase_date) = 2024 GROUP BY month
)
SELECT month, revenue, 
       RANK() OVER(ORDER BY revenue DESC) AS sales_rank 
FROM MonthlySales LIMIT 1;

/*43. Calculate the running cumulative total of revenue across the months in 2024.*/

WITH MonthlyRevenue AS (
    SELECT MONTH(purchase_date) AS month, SUM(current_price) AS revenue
    FROM sales_data WHERE YEAR(purchase_date) = 2024 GROUP BY month
)
SELECT month, revenue, 
       SUM(revenue) OVER(ORDER BY month) AS running_total
FROM MonthlyRevenue;

/*44. Calculate the Month-over-Month (MoM) revenue growth percentage.*/

WITH MonthlyData AS (
    SELECT EXTRACT(YEAR FROM purchase_date) AS yr, EXTRACT(MONTH FROM purchase_date) AS mo, SUM(current_price) AS rev
    FROM sales_data GROUP BY yr, mo
)
SELECT yr, mo, rev, 
       ROUND(((rev - LAG(rev) OVER(ORDER BY yr, mo)) / LAG(rev) OVER(ORDER BY yr, mo)) * 100, 2) AS growth_pct
FROM MonthlyData;

/*45. Identify the top 5 most expensive products purchased that were NOT returned.*/

SELECT product_id, brand, category, current_price 
FROM sales_data WHERE is_returned = 'False' 
ORDER BY current_price DESC LIMIT 5;

/*46. Calculate the percentage of total overall revenue that each brand contributes.*/

WITH TotalRev AS (SELECT SUM(current_price) AS global_revenue FROM sales_data)
SELECT brand, SUM(current_price) AS brand_revenue, 
       ROUND((SUM(current_price) / (SELECT global_revenue FROM TotalRev)) * 100, 2) AS pct_of_total
FROM sales_data GROUP BY brand ORDER BY pct_of_total DESC;

/*47. Use a dense rank to order categories by average customer rating.*/

WITH AvgRatings AS (
    SELECT category, AVG(customer_rating) AS avg_rat 
    FROM sales_data WHERE customer_rating > 0 GROUP BY category
)
SELECT category, ROUND(avg_rat, 2) AS rating, 
       DENSE_RANK() OVER(ORDER BY avg_rat DESC) AS category_rank
FROM AvgRatings;

/*48. Find the average sales revenue over a rolling 3-month window.*/


WITH MonthlyRev AS (
    SELECT DATE_FORMAT(purchase_date, '%Y-%m') AS month_yr, SUM(current_price) AS revenue
    FROM sales_data GROUP BY month_yr
)
SELECT month_yr, revenue, 
       AVG(revenue) OVER(ORDER BY month_yr ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3m_avg
FROM MonthlyRev;

/*49. Identify "At-Risk" Brands (High Returns + Low Ratings).*/

SELECT brand, 
       ROUND((SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS return_rate,
       ROUND(AVG(customer_rating), 2) AS avg_rating
FROM sales_data 
WHERE customer_rating > 0 
GROUP BY brand 
HAVING return_rate > 15 AND avg_rating < 4.0
order by avg_rating;


/*50. Find the difference in sales revenue between each month and the average monthly revenue for the entire year.*/

select * from sales_data;

WITH MonthlySales AS (
    SELECT MONTH(purchase_date) AS month, SUM(current_price) AS revenue
    FROM sales_data WHERE YEAR(purchase_date) =2024 GROUP BY month
)
SELECT month, revenue, 
       ROUND(AVG(revenue) OVER(), 2) AS yearly_avg_month,
       ROUND(revenue - AVG(revenue) OVER(), 2) AS difference_from_avg
FROM MonthlySales
order by month ;
 