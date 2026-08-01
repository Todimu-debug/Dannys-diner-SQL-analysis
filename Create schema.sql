-- Create Database --
CREATE DATABASE dannys_diner;

-- Use Database --
USE dannys_diner;

-- Create sales table --
CREATE TABLE sales (
    customer_id VARCHAR(5),
    order_date DATE,
    product_id INT
);

-- Create Menu Table
CREATE TABLE menu (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(20),
    price INT
);


-- Create Members Table
CREATE TABLE members (
    customer_id VARCHAR(5),
    join_date DATE
);

