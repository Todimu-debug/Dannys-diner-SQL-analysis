# Danny's Diner SQL Analysis
SQL analysis of Danny's Diner case study using MySQL.

## Overview
This project analyzes customer purchasing behavior for Danny's Diner using SQL. The goal is to answer key business questions about customer spending, visit frequency, menu popularity, and the restaurant's loyalty program.

## Dataset
The project uses three tables:
- **Sales** – Customer purchase records
- **Menu** – Menu items and prices
- **Members** – Loyalty program join dates

## SQL Skills Used
- SELECT
- WHERE
- GROUP BY
- ORDER BY
- INNER JOIN
- LEFT JOIN
- Aggregate Functions (COUNT, SUM, MIN)
- CASE Statements
- Common Table Expressions (CTEs)
- Window Functions (ROW_NUMBER, DENSE_RANK)

## Business Questions
- Total amount spent by each customer
- Number of customer visits
- First item purchased
- Most popular menu item
- Most popular item for each customer
- Customer purchases before and after joining the loyalty program
- Loyalty points calculation

## Key Insights
- Customer A spent the most overall.
- Ramen was the restaurant's most popular item.
- Customer B showed equal preference for all menu items.
- The loyalty program rewarded repeat customers through bonus points.

## Files
- `schema.sql` – Creates the database tables
- `data.sql` – Inserts the sample data
- `analysis.sql` – SQL solutions to all case study questions
- `business_insights.md` – Summary of findings

## Acknowledgement
This project is based on **Case Study #1 – Danny's Diner** from the **8 Week SQL Challenge** by Danny Ma.
