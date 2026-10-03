-- ============================================
-- ПЕРВИННА ПЕРЕВІРКА ДАНИХ
-- ============================================
/*
-- 1. Кількість рядків у кожній таблиці
SELECT 'orders' AS table_name, COUNT(*) AS row_count
FROM orders
UNION ALL
SELECT 'order_details', COUNT(*)
FROM order_details
UNION ALL
SELECT 'pizzas', COUNT(*)
FROM pizzas
UNION ALL
SELECT 'pizza_types', COUNT(*)
FROM pizza_types;
*/

/*
-- 2. Перевірка пропусків у таблиці orders
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN time IS NULL THEN 1 ELSE 0 END) AS null_time
FROM orders;
*/
/*
-- 3. Перевірка пропусків у таблиці order_details
SELECT
    SUM(CASE WHEN order_details_id IS NULL THEN 1 ELSE 0 END) AS null_order_details_id,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_id,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity
FROM order_details;
*/
/*
-- 4. Перевірка пропусків у таблиці pizzas
SELECT
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_id,
    SUM(CASE WHEN pizza_type_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_type_id,
    SUM(CASE WHEN size IS NULL THEN 1 ELSE 0 END) AS null_size,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price
FROM pizzas;
*/
/*
-- 5. Перевірка пропусків у таблиці pizza_types
SELECT
    SUM(CASE WHEN pizza_type_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_type_id,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN ingredients IS NULL THEN 1 ELSE 0 END) AS null_ingredients
FROM pizza_types;
*/
/*
-- 6. Перевірка формату дати та часу
SELECT
    order_id,
    date,
    time,
    strftime('%Y', date) AS year_check,
    strftime('%m', date) AS month_check,
    strftime('%H', time) AS hour_check
FROM orders
LIMIT 10;
*/
/*
-- 7. Перевірка числових полів price та quantity
SELECT
    p.price AS price_original,
    typeof(p.price) AS price_type,
    CAST(p.price AS REAL) AS price_numeric,

    od.quantity AS quantity_original,
    typeof(od.quantity) AS quantity_type,
    CAST(od.quantity AS INTEGER) AS quantity_numeric

FROM pizzas p
JOIN order_details od
    ON p.pizza_id = od.pizza_id

LIMIT 10;
*/
/*
-- 8. Перевірка JOIN усіх чотирьох таблиць
SELECT
    (SELECT COUNT(*)
     FROM order_details) AS order_details_rows,

    COUNT(*) AS joined_rows

FROM order_details od

JOIN orders o
    ON od.order_id = o.order_id

JOIN pizzas p
    ON od.pizza_id = p.pizza_id

JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id;
    */
-- 9. Повна перевірка коректності форматів даних
-- Перевіряємо всі рядки на некоректні дати, час,
-- ціни та кількість.
/*
SELECT
    -- Дати, які SQLite не може розпізнати
    (
        SELECT COUNT(*)
        FROM orders
        WHERE strftime('%Y-%m-%d', date) IS NULL
    ) AS invalid_dates,

    -- Час, який SQLite не може розпізнати
    (
        SELECT COUNT(*)
        FROM orders
        WHERE strftime('%H:%M:%S', time) IS NULL
    ) AS invalid_times,

    -- Некоректні або недодатні ціни
    (
        SELECT COUNT(*)
        FROM pizzas
        WHERE price IS NULL
           OR CAST(price AS REAL) <= 0
    ) AS invalid_prices,

    -- Некоректна або недодатна кількість
    (
        SELECT COUNT(*)
        FROM order_details
        WHERE quantity IS NULL
           OR CAST(quantity AS INTEGER) <= 0
    ) AS invalid_quantities;
  */  
-- ============================================
-- КЛЮЧОВІ ПИТАННЯ
-- ============================================
/*
-- Питання 1.
-- Загальні показники за 2015 рік:
-- виручка, кількість замовлень, кількість проданих піц,
-- середній чек та середня кількість піц у замовленні.

SELECT
    ROUND(SUM(CAST(p.price AS REAL) * CAST(od.quantity AS INTEGER)), 2)
        AS total_revenue,

    COUNT(DISTINCT o.order_id)
        AS total_orders,

    SUM(CAST(od.quantity AS INTEGER))
        AS total_pizzas_sold,

    ROUND(
        SUM(CAST(p.price AS REAL) * CAST(od.quantity AS INTEGER))
        / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value,

    ROUND(
        CAST(SUM(CAST(od.quantity AS INTEGER)) AS REAL)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_pizzas_per_order

FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id;
*/    
/*
-- Питання 2.
-- Динаміка по місяцях:
-- виручка, кількість замовлень та зміна виручки
-- до попереднього місяця у відсотках.

WITH monthly_sales AS (
    SELECT
        strftime('%m', o.date) AS month,
        
        ROUND(
            SUM(CAST(p.price AS REAL) * CAST(od.quantity AS INTEGER)),
            2
        ) AS revenue,
        
        COUNT(DISTINCT o.order_id) AS orders
        
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
        
    GROUP BY strftime('%m', o.date)
),

monthly_with_previous AS (
    SELECT
        month,
        revenue,
        orders,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    month,
    revenue,
    orders,
    
    ROUND(
        (revenue - previous_month_revenue)
        / previous_month_revenue * 100,
        2
    ) AS revenue_change_pct

FROM monthly_with_previous

ORDER BY month;
*/
-- Питання 3.1.
-- Навантаження за днями тижня:
-- загальна кількість замовлень та середня кількість
-- замовлень за один день відповідного типу.
/*
SELECT
    CASE strftime('%w', date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT date) AS number_of_days,

    ROUND(
        CAST(COUNT(DISTINCT order_id) AS REAL)
        / COUNT(DISTINCT date),
        2
    ) AS avg_orders_per_day

FROM orders

GROUP BY strftime('%w', date)

ORDER BY
    CASE strftime('%w', date)
        WHEN '1' THEN 1
        WHEN '2' THEN 2
        WHEN '3' THEN 3
        WHEN '4' THEN 4
        WHEN '5' THEN 5
        WHEN '6' THEN 6
        WHEN '0' THEN 7
    END;
*/

-- Питання 3.2.
-- Навантаження за годинами:
-- кількість замовлень у кожну годину доби.
/*
SELECT
    strftime('%H', time) AS hour,
    COUNT(DISTINCT order_id) AS total_orders

FROM orders

GROUP BY strftime('%H', time)

ORDER BY hour;
*/
-- Питання 3.3.
-- Навантаження: день тижня × година.
-- Кількість замовлень для кожної комбінації
-- дня тижня та години.
/*
SELECT
    CASE strftime('%w', date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,

    strftime('%H', time) AS hour,

    COUNT(DISTINCT order_id) AS total_orders

FROM orders

GROUP BY
    strftime('%w', date),
    strftime('%H', time)

ORDER BY
    CASE strftime('%w', date)
        WHEN '1' THEN 1
        WHEN '2' THEN 2
        WHEN '3' THEN 3
        WHEN '4' THEN 4
        WHEN '5' THEN 5
        WHEN '6' THEN 6
        WHEN '0' THEN 7
    END,
    hour;
    */
-- Питання 3.4.
-- ТОП-10 найбільш завантажених комбінацій
-- день тижня × година.
/*
SELECT
    CASE strftime('%w', date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,

    strftime('%H', time) AS hour,

    COUNT(DISTINCT order_id) AS total_orders

FROM orders

GROUP BY
    strftime('%w', date),
    strftime('%H', time)

ORDER BY total_orders DESC

LIMIT 10;
*/
-- Питання 3.5.
-- ТОП-10 найменш завантажених комбінацій
-- день тижня × година в основний робочий час 11:00–22:00.
/*
SELECT
    CASE strftime('%w', date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,

    strftime('%H', time) AS hour,

    COUNT(DISTINCT order_id) AS total_orders

FROM orders

WHERE CAST(strftime('%H', time) AS INTEGER) BETWEEN 11 AND 22

GROUP BY
    strftime('%w', date),
    strftime('%H', time)

ORDER BY total_orders ASC

LIMIT 10;
*/
-- ============================================
-- Питання 4.
-- Бестселери та аутсайдери:
-- TOP-5 і BOTTOM-5 піц за виручкою
-- та за кількістю проданих піц.
-- Усі розміри однієї піци об'єднуємо.
-- ============================================
/*

WITH pizza_sales AS (
    SELECT
        pt.name AS pizza_name,
        SUM(CAST(od.quantity AS INTEGER)) AS pizzas_sold,
        ROUND(
            SUM(CAST(p.price AS REAL) * CAST(od.quantity AS INTEGER)),
            2
        ) AS revenue

    FROM order_details od

    JOIN pizzas p
        ON od.pizza_id = p.pizza_id

    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id

    GROUP BY pt.name
),

pizza_ranks AS (
    SELECT
        pizza_name,
        pizzas_sold,
        revenue,

        RANK() OVER (ORDER BY revenue DESC) AS revenue_rank_top,
        RANK() OVER (ORDER BY revenue ASC) AS revenue_rank_bottom,

        RANK() OVER (ORDER BY pizzas_sold DESC) AS sales_rank_top,
        RANK() OVER (ORDER BY pizzas_sold ASC) AS sales_rank_bottom

    FROM pizza_sales
)

SELECT
    pizza_name,
    pizzas_sold,
    revenue,
    revenue_rank_top,
    revenue_rank_bottom,
    sales_rank_top,
    sales_rank_bottom

FROM pizza_ranks

WHERE revenue_rank_top <= 5
   OR revenue_rank_bottom <= 5
   OR sales_rank_top <= 5
   OR sales_rank_bottom <= 5

ORDER BY revenue DESC;
*/


-- ============================================
-- Питання 5.1.
-- Категорії піц:
-- виручка та частка кожної категорії
-- у загальній виручці.
-- ============================================
/*

WITH category_sales AS (
    SELECT
        pt.category,

        SUM(
            CAST(p.price AS REAL) *
            CAST(od.quantity AS INTEGER)
        ) AS revenue

    FROM order_details od

    JOIN pizzas p
        ON od.pizza_id = p.pizza_id

    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id

    GROUP BY pt.category
)

SELECT
    category,

    ROUND(revenue, 2) AS revenue,

    ROUND(
        revenue /
        (SELECT SUM(revenue) FROM category_sales) * 100,
        2
    ) AS revenue_share_pct

FROM category_sales

ORDER BY revenue DESC;
*/

-- ============================================
-- Питання 5.2.
-- Розміри піц:
-- кількість проданих піц, виручка
-- та частка кожного розміру у загальній виручці.
-- ============================================

/*
WITH size_sales AS (
    SELECT
        p.size,

        SUM(
            CAST(od.quantity AS INTEGER)
        ) AS pizzas_sold,

        SUM(
            CAST(p.price AS REAL) *
            CAST(od.quantity AS INTEGER)
        ) AS revenue

    FROM order_details od

    JOIN pizzas p
        ON od.pizza_id = p.pizza_id

    GROUP BY p.size
)

SELECT
    size,
    pizzas_sold,

    ROUND(revenue, 2) AS revenue,

    ROUND(
        revenue /
        (SELECT SUM(revenue) FROM size_sales) * 100,
        2
    ) AS revenue_share_pct

FROM size_sales

ORDER BY pizzas_sold DESC;
*/


-- ============================================
-- Питання 6.
-- Кандидати на вилучення з меню:
-- піци з найменшими продажами та найменшою
-- часткою виручки.
-- Показуємо 5 найслабших позицій
-- і скільки виручки вони разом дають.
-- ============================================
/*

WITH pizza_sales AS (
    SELECT
        pt.name AS pizza_name,

        SUM(
            CAST(od.quantity AS INTEGER)
        ) AS pizzas_sold,

        SUM(
            CAST(p.price AS REAL) *
            CAST(od.quantity AS INTEGER)
        ) AS revenue

    FROM order_details od

    JOIN pizzas p
        ON od.pizza_id = p.pizza_id

    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id

    GROUP BY pt.name
),

pizza_metrics AS (
    SELECT
        pizza_name,
        pizzas_sold,
        revenue,

        ROUND(
            revenue /
            (SELECT SUM(revenue) FROM pizza_sales) * 100,
            2
        ) AS revenue_share_pct,

        CASE
            WHEN pizzas_sold <= 1000
            THEN 'Low sales'
            ELSE 'Other'
        END AS sales_group

    FROM pizza_sales
),

bottom_5 AS (
    SELECT
        pizza_name,
        pizzas_sold,
        revenue,
        revenue_share_pct,
        sales_group

    FROM pizza_metrics

    ORDER BY revenue ASC, pizzas_sold ASC

    LIMIT 5
)

SELECT
    pizza_name,
    pizzas_sold,
    ROUND(revenue, 2) AS revenue,
    revenue_share_pct,
    sales_group,

    ROUND(
        SUM(revenue) OVER (),
        2
    ) AS bottom_5_total_revenue,

    ROUND(
        SUM(revenue) OVER () /
        (SELECT SUM(revenue) FROM pizza_sales) * 100,
        2
    ) AS bottom_5_total_revenue_pct

FROM bottom_5

ORDER BY revenue ASC;

*/

-- ============================================
-- Питання 7.
-- Великі замовлення:
-- яка частка замовлень містить 4 і більше піц
-- і скільки виручки вони дають.
-- ============================================
/*

WITH order_level AS (
    SELECT
        od.order_id,

        SUM(
            CAST(od.quantity AS INTEGER)
        ) AS pizzas_in_order,

        SUM(
            CAST(p.price AS REAL) *
            CAST(od.quantity AS INTEGER)
        ) AS order_revenue

    FROM order_details od

    JOIN pizzas p
        ON od.pizza_id = p.pizza_id

    GROUP BY od.order_id
),

order_groups AS (
    SELECT
        order_id,
        pizzas_in_order,
        order_revenue,

        CASE
            WHEN pizzas_in_order >= 4
            THEN '4+ pizzas'
            ELSE '1-3 pizzas'
        END AS order_group

    FROM order_level
)

SELECT
    order_group,

    COUNT(*) AS orders,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM order_groups),
        2
    ) AS orders_share_pct,

    ROUND(
        SUM(order_revenue),
        2
    ) AS revenue,

    ROUND(
        SUM(order_revenue) * 100.0 /
        (SELECT SUM(order_revenue) FROM order_groups),
        2
    ) AS revenue_share_pct

FROM order_groups

GROUP BY order_group

ORDER BY orders DESC;

*/

-- ============================================
-- Питання 8.
-- Акція:
-- виручка та кількість замовлень
-- за днями тижня та годинами.
-- Також показуємо потенційну виручку
-- при зростанні на 10%.
-- ============================================
/*

SELECT
    CASE strftime('%w', o.date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,

    strftime('%H', o.time) AS hour,

    COUNT(DISTINCT o.order_id) AS orders,

    ROUND(
        SUM(
            CAST(p.price AS REAL) *
            CAST(od.quantity AS INTEGER)
        ),
        2
    ) AS current_revenue,

    ROUND(
        SUM(
            CAST(p.price AS REAL) *
            CAST(od.quantity AS INTEGER)
        ) * 0.10,
        2
    ) AS additional_revenue_10pct,

    ROUND(
        SUM(
            CAST(p.price AS REAL) *
            CAST(od.quantity AS INTEGER)
        ) * 1.10,
        2
    ) AS potential_revenue

FROM orders o

JOIN order_details od
    ON o.order_id = od.order_id

JOIN pizzas p
    ON od.pizza_id = p.pizza_id
WHERE CAST(strftime('%H', o.time) AS INTEGER) BETWEEN 11 AND 22
GROUP BY
    strftime('%w', o.date),
    strftime('%H', o.time)

ORDER BY current_revenue ASC
LIMIT 10;
*/
-- ============================================
-- SALES_LINES — ВИБІРКА ДЛЯ TABLEAU
-- ============================================

DROP VIEW IF EXISTS sales_lines;

CREATE VIEW sales_lines AS
SELECT
    o.order_id AS order_id,
    o.date AS order_date,
    o.time AS order_time,
    strftime('%m', o.date) AS month,

    CASE strftime('%w', o.date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,

    strftime('%H', o.time) AS hour,
    pt.name AS pizza_name,
    pt.category AS category,
    p.size AS size,
    CAST(p.price AS REAL) AS unit_price,
    CAST(od.quantity AS INTEGER) AS quantity,
    CAST(p.price AS REAL) * CAST(od.quantity AS INTEGER) AS revenue

FROM orders o

JOIN order_details od
    ON o.order_id = od.order_id

JOIN pizzas p
    ON od.pizza_id = p.pizza_id

JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id;


-- ============================================
-- ПЕРЕВІРКА КІЛЬКОСТІ РЯДКІВ
-- ============================================

SELECT COUNT(*) AS sales_lines_rows
FROM sales_lines;


-- ============================================
-- ПЕРЕВІРКА ПЕРШИХ 10 РЯДКІВ
-- ============================================

SELECT *
FROM sales_lines
LIMIT 10;

SELECT *
FROM sales_lines;