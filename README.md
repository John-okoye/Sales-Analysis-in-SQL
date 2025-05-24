# Sales-Analysis-in-SQL
# Customer and Sales Reporting SQL Tasks

## 1. An Overview of Customers

### 1.1 Overview of Individual Customers

Create a detailed overview of all individual customers. Individual customers are defined by:

- `CustomerType = 'I'`
- And/or are stored in the `individual_customer` table

**Output Columns**:
- `CustomerId`
- `FirstName`
- `LastName`
- `FullName` (concatenation of FirstName and LastName)
- `addressing_title`  
  - If `Title` exists: `Title LastName` (e.g., `Mr. Achong`)
  - Else: `Dear LastName`
- `Email`
- `Phone`
- `AccountNumber`
- `CustomerType`
- `City`
- `State`
- `Country`
- `Address`
- `NumberOfOrders`
- `TotalAmountWithTax`
- `LastOrderDate`

**Notes**:
- Use the latest available address (`MAX(AddressId)`) to avoid duplicates.
- Limit results to **Top 200** rows ordered by `TotalAmountWithTax DESC`.

---

### 1.2 Lapsed High-Value Customers

Find the **top 200 customers** by `TotalAmountWithTax` who have **not placed an order in the last 365 days**.

**Hints**:
- Base the query on the result from 1.1 (via CTE, subquery, or temp table).
- Determine the current date by finding the **latest `OrderDate`** from the `orders` table.

---

### 1.3 Customer Activity Flag

Enhance the query in 1.1 by adding an **`ActivityStatus`** column:
- `Active` if the customer placed an order within the last 365 days
- `Inactive` otherwise

**Output**:
- Return **Top 500** rows
- Ordered by `CustomerId DESC`

---

### 1.4 Active North American Customers

Return **active customers from North America** that meet at least one of the following criteria:
- `TotalAmountWithTax >= 2500`
- `NumberOfOrders >= 5`

**Additional Requirements**:
- Address should be split into:
  - `Address_No` (e.g., `8603`)
  - `Address_St` (e.g., `Elmhurst Lane`)
- Output ordered by:
  - `Country`
  - `State`
  - `Date_Last_Order`

---

## 2. Reporting Sales Numbers

Primary source table: `salesorderheader`

### 2.1 Monthly Sales Summary

Generate monthly sales data **by Country and Region**.

**Output Columns**:
- `YearMonth`
- `Country`
- `Region`
- `NumberOfOrders`
- `NumberOfUniqueCustomers`
- `NumberOfSalespersons`
- `TotalAmountWithTax`

Includes **all customer types**.

---

### 2.2 Cumulative Sales

Enhance query 2.1 with **cumulative total amount (with tax)** per `Country` and `Region`.

**Hint**:
- Use a CTE or subquery to calculate cumulative sum.

---

### 2.3 Sales Ranking by Region

Enhance query 2.2 by adding a `SalesRank` column that:
- Ranks regions from **highest to lowest** `TotalAmountWithTax` **per Country and Month**
- `Rank = 1` for the highest total

---

### 2.4 Tax Rate Insights

Enhance query 2.3 by adding **country-level tax insights**:

**Additional Columns**:
- `mean_tax_rate`: 
  - Average of the **highest** tax rate per province/state in each country.
  - Avoid double-counting provinces.
- `perc_provinces_w_tax`:
  - Percentage of provinces/states with available tax data.
  - Example: 2 out of 5 provinces → 0.40

---

## Preview Notes

- Data samples should display correct formatting for names, addresses, amounts, and calculated fields.
- Consider indexing fields used in `JOIN`, `WHERE`, and `ORDER BY` clauses for performance in large datasets.

---
