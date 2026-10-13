# Data Dictionary — Pizza Sales Analysis 2015

## Overview

The project uses four related source tables:

- `orders`
- `order_details`
- `pizzas`
- `pizza_types`

The relationships between the tables are:

- `orders 1:N order_details`
- `order_details N:1 pizzas`
- `pizzas N:1 pizza_types`

The data covers the full year of **2015**.

---

## Table: `orders`

One row represents one customer order.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `order_id` | INTEGER | PK | Unique identifier of an order |
| `date` | TEXT | — | Date when the order was placed |
| `time` | TEXT | — | Time when the order was placed |

---

## Table: `order_details`

One row represents one order line / item in an order.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `order_details_id` | INTEGER | PK | Unique identifier of an order line |
| `order_id` | INTEGER | FK | References `orders.order_id` |
| `pizza_id` | TEXT | FK | References `pizzas.pizza_id` |
| `quantity` | INTEGER | — | Number of pizzas in the order line |

---

## Table: `pizzas`

One row represents one pizza variant, including its size and price.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `pizza_id` | TEXT | PK | Unique identifier of a pizza variant |
| `pizza_type_id` | TEXT | FK | References `pizza_types.pizza_type_id` |
| `size` | TEXT | — | Pizza size |
| `price` | REAL | — | Unit price of the pizza |

---

## Table: `pizza_types`

One row represents one pizza type.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `pizza_type_id` | TEXT | PK | Unique identifier of a pizza type |
| `name` | TEXT | — | Pizza name |
| `category` | TEXT | — | Pizza category |
| `ingredients` | TEXT | — | List of ingredients |

---

## Derived Tableau Data Source: `sales_lines`

For Tableau, the four source tables were joined in SQL and a view called `sales_lines` was created.

One row in `sales_lines` represents one order line.

The view contains **48,620 rows**.

The project SQL includes the logic used to create this view:

[`../sql/queries.sql`](../sql/queries.sql)

The exported Tableau dataset is stored here:

[`../exports/sales_lines.csv`](../exports/sales_lines.csv)

Known fields used in the view include:

| Field | Description |
|---|---|
| `order_id` | Order identifier |
| `date` | Order date |
| `time` | Order time |
| `pizza_name` | Pizza name |
| `size` | Pizza size |
| `unit_price` | Pizza unit price |
| `quantity` | Quantity in the order line |
| `revenue` | Revenue for the order line (`unit_price × quantity`) |

---

## Data Preparation Notes

Before the analysis, the data was checked for:

- missing values;
- row counts;
- date and time formats;
- price and quantity formats;
- consistency of table relationships;
- possible duplication after joins.

For analysis and Tableau preparation:

- the four tables were connected using SQL `JOIN`;
- `price` was converted to `REAL`;
- `quantity` was converted to `INTEGER`;
- date and time components were extracted using `strftime()`;
- the `sales_lines` view was created as a consistent Tableau data source.

---

## Source

Original dataset:

https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales
