/*====================================================
Question 1
What is the total amount each customer spent?
====================================================*/

SELECT sales.customer_id, 
SUM(price) AS Total_spent
FROM sales
JOIN menu
	ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;

/*====================================================
Question 2
How many days has each customer visited the restaurant?
====================================================*/

SELECT customer_id, 
COUNT(distinct order_date) AS visit_days
FROM sales
GROUP BY customer_id;


/*====================================================
Question 3
-- What was the first item from the menu purchased by each customer?
====================================================*/

WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order
    FROM sales
    GROUP BY customer_id
)

SELECT
    s.customer_id,
    m.product_name
FROM first_orders f
JOIN sales s
    ON f.customer_id = s.customer_id
   AND f.first_order = s.order_date
JOIN menu m
    ON s.product_id = m.product_id
ORDER BY s.customer_id;


/*====================================================
Question 4
-- What is the most purchased item on the menu and 
-- how many times was it purchased by all customers?
====================================================*/

SELECT
    m.product_name,
    COUNT(*) AS total_purchases
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchases DESC
LIMIT 1;


/*====================================================
Question 5
-- Which item was the most popular for each customer?
====================================================*/

WITH item_counts AS (
    SELECT
        s.customer_id,
        m.product_name,
        COUNT(*) AS purchase_count
    FROM sales s
    JOIN menu m
        ON s.product_id = m.product_id
    GROUP BY
        s.customer_id,
        m.product_name
),
ranked_items AS (
    SELECT
        customer_id,
        product_name,
        purchase_count,
        DENSE_RANK() OVER (
            PARTITION BY customer_id
            ORDER BY purchase_count DESC
        ) AS rank_num
    FROM item_counts
)

SELECT
    customer_id,
    product_name,
    purchase_count
FROM ranked_items
WHERE rank_num = 1
ORDER BY customer_id;


/*====================================================
Question 6
-- Which item was purchased first by the customer after they became a member?
====================================================*/

WITH member_purchases AS (
    SELECT
        s.customer_id,
        s.order_date,
        m.product_name,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date
        ) AS rn
    FROM sales s
    JOIN members mem
        ON s.customer_id = mem.customer_id
    JOIN menu m
        ON s.product_id = m.product_id
    WHERE s.order_date >= mem.join_date
)

SELECT
    customer_id,
    order_date,
    product_name
FROM member_purchases
WHERE rn = 1;


/*====================================================
Question 7
-- Which item was purchased just before the customer became a member?
====================================================*/

WITH before_member AS (
    SELECT
        s.customer_id,
        s.order_date,
        m.product_name,
        ROW_NUMBER() OVER(
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC
        ) AS rn
    FROM sales s
    JOIN members mem
        ON s.customer_id = mem.customer_id
    JOIN menu m
        ON s.product_id = m.product_id
    WHERE s.order_date < mem.join_date
)

SELECT
    customer_id,
    order_date,
    product_name
FROM before_member
WHERE rn = 1;


/*====================================================
Question 8
-- What is the total items and 
-- amount spent for each member before they became a member?
====================================================*/

SELECT
    s.customer_id,
    COUNT(*) AS total_items,
    SUM(m.price) AS total_amount
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
JOIN members mem
    ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;


/*====================================================
Question 9
-- If each $1 spent equals 10 points and 
-- sushi earns double points, how many points does each customer have?
====================================================*/

SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN m.product_name = 'sushi'
                THEN m.price * 20
            ELSE
                m.price * 10
        END
    ) AS points
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
GROUP BY s.customer_id;


/*====================================================
Question 10
-- During the first week after joining, customers earn 2× points on every item.
====================================================*/

SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN s.order_date BETWEEN mem.join_date
                                 AND DATE_ADD(mem.join_date, INTERVAL 6 DAY)
                THEN m.price * 20

            WHEN m.product_name = 'sushi'
                THEN m.price * 20

            ELSE
                m.price * 10
        END
    ) AS points
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
JOIN members mem
    ON s.customer_id = mem.customer_id
WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id;


/*====================================================
Bonus Question 1
-- Join All The Things
====================================================*/

SELECT
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE
        WHEN mem.join_date IS NOT NULL
         AND s.order_date >= mem.join_date
            THEN 'Y'
        ELSE 'N'
    END AS member
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
LEFT JOIN members mem
    ON s.customer_id = mem.customer_id
ORDER BY
    s.customer_id,
    s.order_date,
    m.product_name;
    

/*====================================================
Bonus Question 2
-- RANK ALLTHE THINGS
====================================================*/


WITH joined AS (
    SELECT
        s.customer_id,
        s.order_date,
        m.product_name,
        m.price,
        CASE
            WHEN mem.join_date IS NOT NULL
             AND s.order_date >= mem.join_date
                THEN 'Y'
            ELSE 'N'
        END AS member
    FROM sales s
    JOIN menu m
        ON s.product_id = m.product_id
    LEFT JOIN members mem
        ON s.customer_id = mem.customer_id
)

SELECT
    customer_id,
    order_date,
    product_name,
    price,
    member,
    CASE
        WHEN member = 'Y'
        THEN DENSE_RANK() OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        )
        ELSE NULL
    END AS ranking
FROM joined
ORDER BY
    customer_id,
    order_date,
    product_name;





