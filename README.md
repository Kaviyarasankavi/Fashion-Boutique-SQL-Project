# Fashion-Boutique-SQL-Project
Fashion Boutique SQL Project – A retail dataset analysis using SQL. Includes 50 queries exploring product categories, pricing, discounts, customer ratings, and return behavior. Demonstrates SQL skills in filtering, joins, aggregation, and insights into fashion sales trends.



## 📌 Overview
This project analyzes a **Fashion Boutique dataset** using SQL. The dataset contains product details such as category, brand, season, size, color, pricing, stock, customer ratings, and return information.  
I wrote **50 SQL queries** to answer business-related questions and uncover insights into fashion retail trends, customer behavior, and product performance.

---

## 📂 Dataset Information
- **File:** `fashion_boutique_dataset.csv`
- **Rows:** 359 products
- **Columns:**
  - `product_id` – Unique product identifier  
  - `category` – Product category (Tops, Dresses, Shoes, etc.)  
  - `brand` – Brand name (Zara, Mango, H&M, etc.)  
  - `season` – Season of release (Spring, Summer, Fall, Winter)  
  - `size` – Product size (XS, S, M, L, XL, XXL)  
  - `color` – Product color  
  - `original_price` – Original price before discount  
  - `markdown_percentage` – Discount percentage  
  - `current_price` – Price after discount  
  - `purchase_date` – Date of purchase  
  - `stock_quantity` – Available stock  
  - `customer_rating` – Rating given by customers  
  - `is_returned` – Whether the product was returned  
  - `return_reason` – Reason for return (if applicable)  

---

## 🎯 Objectives
- Practice SQL by solving **50 analytical questions**.  
- Explore insights such as:
  - Best-selling categories and brands  
  - Seasonal fashion trends  
  - Impact of discounts on sales  
  - Customer return behavior and reasons  
  - Average customer ratings by brand and category  

---

## 📂 Project Structure

Fashion-Boutique-SQL-Project/
│
├── dataset/
│   └── fashion_boutique_dataset.csv
│
├── queries/
│   ├── Q1.sql
│   ├── Q2.sql
│   └── ...
│
├── results/
│   ├── Q1_result.csv
│   ├── Q2_result.csv
│   └── ...
│
└── README.md


---

## 🛠️ How to Use
1. Import the dataset into your SQL database (MySQL/PostgreSQL).  
2. Run the queries provided in the `queries/` folder.  
3. Check the `results/` folder for saved outputs of each query.  
4. Explore insights and patterns in the dataset.  

---

## 📊 Example Query & Result
```sql
-- Q1: Find the top 5 brands with the highest average customer rating
SELECT brand, AVG(customer_rating) AS avg_rating
FROM fashion_boutique
WHERE customer_rating IS NOT NULL
GROUP BY brand
ORDER BY avg_rating DESC
LIMIT 5;


| Brand | Avg Rating |
| --- | --- |
| Gap | 4.5 |
| Ann Taylor | 4.4 |
| Banana Republic | 4.3 |
| H&M | 4.2 |
| Mango | 4.1 |
