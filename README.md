# Pizza Sales Analysis — 2015

## Task

This project analyzes the 2015 sales data of a pizzeria using SQL and Tableau.

The goal was to help the new owner, Laura Martinez, make data-driven business decisions based on historical sales.

The analysis focuses on three main business areas:

- staffing and workload planning;
- menu optimization;
- promotion opportunities.

Additional analysis was performed to evaluate large orders and the potential for group or corporate offers.

The project answers eight key business questions related to sales performance, seasonality, customer demand, product performance, menu optimization, large orders, and promotion opportunities.

---

## Data

The dataset covers the full year of **2015** and consists of four related tables:

- `orders`
- `order_details`
- `pizzas`
- `pizza_types`

The table relationships are:

- `orders 1:N order_details`
- `order_details N:1 pizzas`
- `pizzas N:1 pizza_types`

The tables are connected through primary and foreign keys.

The original project data is stored in:

[`data/`](data/)

### Data Preparation

Before the analysis, the data was checked for:

- missing values;
- row counts;
- date and time formats;
- price and quantity formats;
- consistency of table relationships;
- possible duplication after joins.

The four source tables were combined using SQL `JOIN`.

Data types were standardized using `CAST`:

- `price` → `REAL`
- `quantity` → `INTEGER`

Date and time components were extracted using `strftime()`.

For Tableau, a SQL view called `sales_lines` was created.

The complete SQL code, including the analytical queries and the creation of the Tableau data source, is stored in:

[`sql/queries.sql`](sql/queries.sql)

The `sales_lines` view contains **48,620 rows**, where one row represents one order line.

The exported dataset used for Tableau is stored separately as:

[`exports/sales_lines.csv`](exports/sales_lines.csv)

Dataset source:

https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales

---

## Key Questions and Answers

All SQL queries for the eight business questions are stored in:

[`sql/queries.sql`](sql/queries.sql)

### 1. What are the main sales KPIs?

The main sales results for 2015 are:

- Total Revenue: **$817,860.05**
- Total Orders: **21,350**
- Pizzas Sold: **49,574**
- Average Order Value: **$38.31**
- Average Pizzas per Order: **2.32**

The Average Order Value was calculated as total revenue divided by the number of distinct orders.

`COUNT(DISTINCT order_id)` was used to ensure that each order was counted only once.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

### 2. Which months performed best and worst?

The strongest month was **July**:

- Revenue: **$72,557.90**
- Orders: **1,935**

The weakest month was **October**:

- Revenue: **$64,027.60**
- Orders: **1,646**

The SQL window function `LAG()` was used to compare each month with the previous month.

The largest positive month-over-month revenue increase was:

- **November: +9.95%**

December showed a decline of:

- **−8.09%**

Overall seasonality was moderate, but October was the weakest month by revenue.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

### 3. When is customer demand highest and lowest?

The strongest weekday was:

- **Friday — 70.76 orders per day**

The weakest weekday was:

- **Sunday — 50.46 orders per day**

The main demand peaks were:

- **12:00–13:00**
- **17:00–19:00**

The strongest weekday-hour combination was:

- **Thursday at 13:00 — 438 orders**

The hour with the highest total number of orders was:

- **12:00 — 2,520 orders**

Demand was much lower around **22:00**.

### Business implication

Staffing should be strengthened on Fridays and during lunch and evening peak periods.

Lower staffing levels may be considered around 22:00, but this should be validated with actual staffing data.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

### 4. Which pizzas are the strongest and weakest performers?

The highest-revenue pizza was:

- **The Thai Chicken Pizza — $43,434.25**

The best-selling pizza by quantity was:

- **The Classic Deluxe Pizza — 2,453 pizzas**

The weakest pizza by both revenue and quantity was:

- **The Brie Carre Pizza**
- **490 pizzas sold**
- **$11,588.50 revenue**

The Top 5 pizzas by revenue were:

- The Thai Chicken Pizza
- The Barbecue Chicken Pizza
- The California Chicken Pizza
- The Classic Deluxe Pizza
- The Spicy Italian Pizza

SQL ranking logic, including `RANK()`, was used to compare product performance.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

### 5. How is revenue distributed across categories and sizes?

Revenue by category was relatively balanced:

- Classic — **26.91%**
- Supreme — **25.46%**
- Chicken — **23.96%**
- Veggie — **23.68%**

Revenue by size:

- L — **45.89%**
- M — **30.49%**
- S — **21.77%**
- XL — **1.72%**
- XXL — **0.12%**

Size **L** was the most important size:

- **18,956 pizzas sold**
- **$375,318.70 revenue**
- **45.89% of total revenue**

XL and XXL together generated less than 2% of total revenue.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

### 6. Which menu items should be reviewed?

Five pizzas were identified as low-selling and low-revenue candidates for further review:

1. The Brie Carre Pizza — **$11,588.50**
2. The Green Garden Pizza — **$13,955.75**
3. The Spinach Supreme Pizza — **$15,277.75**
4. The Mediterranean Pizza — **$15,360.50**
5. The Spinach Pesto Pizza — **$15,595.00**

Together, these five pizzas generated:

- **$71,778.50**
- **8.78% of total revenue**

These products should **not be removed automatically**.

Before making a final menu decision, the following factors should also be analyzed:

- food cost;
- profit margin;
- ingredient overlap;
- ingredient uniqueness;
- customer behavior.

The sales analysis identifies candidates for further review rather than final removal decisions.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

### 7. How important are large orders?

Large orders were defined as orders containing **4 or more pizzas**.

They represent:

- **3,880 of 21,350 orders**
- **18.17% of all orders**

However, they generate:

- **$322,570.90 revenue**
- **39.44% of total revenue**

Orders containing 1–3 pizzas generate:

- **$495,289.15**
- **60.56% of total revenue**

For this analysis, pizza quantity was first aggregated at order level and then classified using `CASE`.

### Business implication

Large orders represent a relatively small share of all orders but generate a disproportionately high share of revenue.

This indicates potential for:

- group packages;
- corporate offers;
- incentives for orders of 4 or more pizzas.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

### 8. When could a promotion be tested?

A weak time window was identified at:

- **Monday at 22:00**

Historical performance in this time slot:

- Orders: **53**
- Current Revenue: **$1,869.05**

A scenario with a 10% revenue increase would result in:

- Additional Revenue: **$186.91**
- Potential Revenue: **$2,055.96**

The 10% increase is a **scenario, not a forecast**.

There is no historical evidence that a promotion would actually increase revenue by 10%.

The real effect should therefore be measured through a controlled promotion test.

SQL: [`sql/queries.sql`](sql/queries.sql)

---

## Tools

### SQL

SQL was used for data preparation, aggregation, ranking, time analysis, business calculations, and preparation of the Tableau data source.

Main SQL techniques:

- `JOIN`
- `GROUP BY`
- `HAVING`
- `CASE`
- CTE
- subqueries
- `COUNT(DISTINCT)`
- `CAST`
- `strftime()`
- `LAG()`
- `RANK()`
- `SUM() OVER`
- `CREATE VIEW`

The complete SQL script is stored in:

[`sql/queries.sql`](sql/queries.sql)

This file contains:

- data preparation logic;
- all eight business analysis queries;
- the SQL code used to create the `sales_lines` view for Tableau.

The exported Tableau dataset is stored in:

[`exports/sales_lines.csv`](exports/sales_lines.csv)

### Tableau

Tableau was used to visualize the results and create two dashboards.

#### Dashboard 1 — Pizza Sales Analysis — 2015

Includes:

- Revenue
- Orders
- Pizzas Sold
- Average Order Value
- Monthly Trend
- Weekday × Hour Heatmap
- Top 5 Pizzas by Revenue
- Bottom 5 Pizzas by Revenue
- Revenue by Category
- Revenue by Size

Interactive filters:

- Month
- Category
- Size

#### Dashboard 2 — Business Recommendations

Includes:

- Menu Removal Candidates
- Large Orders
- Promotion Opportunity

Tableau techniques used in the project include:

- Calculated Fields
- FIXED LOD expressions
- filters
- KPI visualizations
- heatmaps
- rankings
- interactive dashboards

The Tableau workbook is stored in:

[`Tableau/`](Tableau/)

---

## Business Recommendations

Based on the analysis:

- Increase staffing on **Fridays** and during the main demand peaks at **12:00–13:00** and **17:00–19:00**.
- Consider lower staffing levels around **22:00**, subject to actual staffing data.
- Review the five weakest pizzas, but do not remove them before checking **food cost, margin, ingredients, and customer behavior**.
- Test special offers for orders of **4 or more pizzas**, since this segment generates **39.44% of total revenue**.
- Test a promotion on **Monday at 22:00** and measure the actual impact before permanent implementation.

---

## Limitations and Next Steps

### Limitations

- The analysis covers only one year: **2015**.
- Food cost data is not available.
- Profit margin data is not available.
- Staffing and actual shift-hour data are not available.
- The 10% promotion uplift is a scenario, not an A/B test result.

### Next Steps

- Add food cost and margin data for each pizza.
- Analyze ingredient overlap and ingredient uniqueness for weak menu items.
- Run a real promotion test for Monday at 22:00.
- Compare customer demand with actual staffing levels.
- Test group or corporate offers for orders of 4 or more pizzas.
- Measure the effect of these actions on both revenue and profitability.

---

## Links

- **Tableau Public Dashboard:**  
  https://public.tableau.com/views/pizza_dashboard_17910344805020/PizzaSalesAnalysis2015

- **Dataset:**  
  https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales

- **SQL Queries and Tableau Data Preparation:**  
  [`sql/queries.sql`](sql/queries.sql)

- **Tableau Export Dataset:**  
  [`exports/sales_lines.csv`](exports/sales_lines.csv)

- **Tableau Workbook:**  
  [`Tableau/`](Tableau/)

- **Presentation:**  
  [`presentation/`](presentation/)

- **Data Dictionary:** 
  [`docs/data_dictionary.md`](docs/data_dictionary.md)

  ## Author and Copyright

**Project:** Pizza Sales Analysis — 2015

**Author:** [vpnmira-crypto]

**Year:** 2026

**Institution:** Deutsche Tech Akademie

This educational project includes my original SQL analysis, Tableau dashboards, business recommendations, and presentation.

© 2026 [vpnmira-crypto]. All rights reserved for my original work.

The original Pizza Place Sales dataset is sourced from Kaggle and remains subject to its own terms.
