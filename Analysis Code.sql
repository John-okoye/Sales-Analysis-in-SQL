--Task 1.1
WITH t1 AS (SELECT
  custadd.CustomerID, 
  contactid,
  accountnumber,
  MAX(custadd.AddressID) AS max_address_id,  
  COUNT(SalesOrderID) AS number_orders,
  SUM(TotalDue) AS total_amt,
  MAX(OrderDate) AS date_last_order
FROM
  tc-da-1.adwentureworks_db.salesorderheader sales
  JOIN tc-da-1.adwentureworks_db.customeraddress custadd ON sales.customerid = custadd.customerid
GROUP BY custadd.CustomerID, contactid, accountnumber
)


SELECT
  t1.CustomerId,
  contact.FirstName,
  contact.LastName,
  CONCAT(contact.FirstName, " ", contact.LastName) AS FullName,
  CASE WHEN Title IS NULL THEN CONCAT ("Dear ", contact.LastName) ELSE CONCAT(Title, " ", contact.LastName) END AS addressing_title,
  contact.EmailAddress,
  contact.Phone,
  t1.AccountNumber, 
  customer.CustomerType,
  city,
  AddressLine1,
  AddressLine2,
  state.name AS state,
  country.name AS country,
  t1.number_orders,
  total_amt,
  date_last_order

FROM t1
JOIN tc-da-1.adwentureworks_db.customer customer ON customer.customerID = t1.customerID 
JOIN tc-da-1.adwentureworks_db.address address ON address.addressid = t1.max_address_id 
JOIN tc-da-1.adwentureworks_db.contact contact ON contact.contactID = t1.contactID
JOIN tc-da-1.adwentureworks_db.stateprovince state ON state.stateprovinceid = address.stateprovinceid
JOIN tc-da-1.adwentureworks_db.countryregion country ON country.countryregioncode = state.countryregioncode
WHERE customertype = "I"
ORDER BY total_amt DESC
LIMIT 200



-- Task 1.2
WITH t1 AS (SELECT
  custadd.CustomerID, 
  contactid,
  stateprovinceid,
  accountnumber,
  addressline1,
  addressline2,
  city,
  MAX(custadd.AddressID), 
  MAX(address.ModifiedDate), 
  COUNT(SalesOrderID) AS number_orders,
  SUM(TotalDue) AS total_amt,
  MAX(OrderDate) AS date_last_order
FROM 
  tc-da-1.adwentureworks_db.salesorderheader sales
  JOIN tc-da-1.adwentureworks_db.customeraddress custadd ON sales.customerid = custadd.customerid
  JOIN tc-da-1.adwentureworks_db.address address ON address.addressid = custadd.addressid 
GROUP BY   custadd.CustomerID, contactid, stateprovinceid, accountnumber, addressline1, addressline2, city
)


SELECT
  t1.CustomerId,
  contact.FirstName,
  contact.LastName,
  CONCAT(contact.FirstName, " ", contact.LastName) AS FullName,
  CASE WHEN Title IS NULL THEN CONCAT ("Dear ", contact.LastName) ELSE CONCAT(Title, " ", contact.LastName) END AS addressing_title,
  contact.EmailAddress,
  contact.Phone,
  t1.AccountNumber, 
  customer.CustomerType,
  city,
  AddressLine1,
  AddressLine2,
  state.name AS state,
  country.name AS country,
  t1.number_orders,
  ROUND(total_amt,3),
  date_last_order

FROM t1
JOIN tc-da-1.adwentureworks_db.customer customer ON customer.customerID = t1.customerID 
JOIN tc-da-1.adwentureworks_db.contact contact ON contact.contactID = t1.contactID
JOIN tc-da-1.adwentureworks_db.stateprovince state ON state.stateprovinceid = t1.stateprovinceid
JOIN tc-da-1.adwentureworks_db.countryregion country ON country.countryregioncode = state.countryregioncode
WHERE customertype = "I" AND date_last_order < DATE_SUB((SELECT MAX(orderdate) FROM tc-da-1.adwentureworks_db.salesorderheader), INTERVAL 365 DAY)
ORDER BY total_amt DESC
LIMIT 200




--Task 1.3
WITH t1 AS (SELECT
  custadd.CustomerID, 
  contactid,
  stateprovinceid,
  accountnumber,
  addressline1,
  addressline2,
  city,
  MAX(custadd.AddressID), 
  MAX(address.ModifiedDate), 
  COUNT(SalesOrderID) AS number_orders,
  SUM(TotalDue) AS total_amt,
  MAX(OrderDate) AS date_last_order
FROM
  tc-da-1.adwentureworks_db.salesorderheader sales
  JOIN tc-da-1.adwentureworks_db.customeraddress custadd ON sales.customerid = custadd.customerid
  JOIN tc-da-1.adwentureworks_db.address address ON address.addressid = custadd.addressid 
GROUP BY 1,2,3,4,5,6,7
)


SELECT
  t1.CustomerId,
  contact.FirstName,
  contact.LastName,
  CONCAT(contact.FirstName, " ", contact.LastName) AS FullName,
  CASE WHEN Title IS NULL THEN CONCAT ("Dear ", contact.LastName) ELSE CONCAT(Title, " ", contact.LastName) END AS addressing_title,
  contact.EmailAddress,
  contact.Phone,
  t1.AccountNumber, 
  customer.CustomerType,
  city,
  AddressLine1,
  AddressLine2,
  state.name AS state,
  country.name AS country,
  t1.number_orders,
  ROUND(total_amt,2),
  date_last_order,
  CASE WHEN date_last_order < (SELECT DATE_SUB(MAX(OrderDate), INTERVAL 365 DAY) FROM tc-da-1.adwentureworks_db.salesorderheader) THEN "Inactive" ELSE "Active" END AS customer_status

FROM t1
JOIN tc-da-1.adwentureworks_db.customer customer ON customer.customerID = t1.customerID 
JOIN tc-da-1.adwentureworks_db.contact contact ON contact.contactID = t1.contactID
JOIN tc-da-1.adwentureworks_db.stateprovince state ON state.stateprovinceid = t1.stateprovinceid
JOIN tc-da-1.adwentureworks_db.countryregion country ON country.countryregioncode = state.countryregioncode
WHERE customertype = "I"
ORDER BY customerid DESC
LIMIT 500




-- Task 1.4
WITH t1 AS (SELECT
  custadd.CustomerID, 
  territoryid,
  contactid,
  accountnumber,
  MAX(custadd.AddressID) AS max_address_id,  
  COUNT(SalesOrderID) AS number_orders,
  SUM(TotalDue) AS total_amt,
  MAX(OrderDate) AS date_last_order
FROM
  tc-da-1.adwentureworks_db.salesorderheader sales
  JOIN tc-da-1.adwentureworks_db.customeraddress custadd ON sales.customerid = custadd.customerid
GROUP BY custadd.customerID, territoryid, contactid, accountnumber
),


customer_status_cte AS (
  SELECT
    t1.CustomerId,
    contact.FirstName,
    contact.LastName,
    CONCAT(contact.FirstName, " ", contact.LastName) AS FullName,
    CASE 
      WHEN Title IS NULL THEN CONCAT("Dear ", contact.FirstName) 
      ELSE CONCAT(Title, " ", contact.FirstName) 
    END AS addressing_title,
    contact.EmailAddress,
    contact.Phone,
    t1.AccountNumber, 
    customer.CustomerType,
    city,
    AddressLine1,
    SUBSTRING(addressline1, 1, STRPOS(addressline1, " ")) AS address_number,
    SUBSTRING(addressline1, STRPOS(addressline1, " "))AS address_st,
    AddressLine2,
    state.name AS state,
    country.name AS country,
    t1.number_orders,
    total_amt,
    date_last_order,
    CASE 
      WHEN date_last_order < (SELECT DATE_SUB(MAX(OrderDate), INTERVAL 365 DAY) FROM tc-da-1.adwentureworks_db.salesorderheader) 
      THEN "Inactive" 
      ELSE "Active" 
    END AS customer_status,
    territory.Group AS territory_group
  FROM t1
JOIN tc-da-1.adwentureworks_db.customer customer ON customer.customerID = t1.customerID 
JOIN tc-da-1.adwentureworks_db.address address ON address.addressid = t1.max_address_id 
JOIN tc-da-1.adwentureworks_db.contact contact ON contact.contactID = t1.contactID
JOIN tc-da-1.adwentureworks_db.stateprovince state ON state.stateprovinceid = address.stateprovinceid
JOIN tc-da-1.adwentureworks_db.countryregion country ON country.countryregioncode = state.countryregioncode
JOIN tc-da-1.adwentureworks_db.salesterritory territory ON territory.territoryID = t1.territoryID
)

SELECT *
FROM customer_status_cte
WHERE CustomerType = 'I' 
  AND customer_status = 'Active'
  AND territory_group = 'North America'
  AND (total_amt > 2500 OR number_orders > 5)
ORDER BY 
  country, 
  state, 
  date_last_order DESC
LIMIT 500;



--Task 2.1
SELECT 
  LAST_DAY(DATE(orderdate)) AS order_month,
  territory.countryregioncode,
  territory.name AS region,
  COUNT(salesorderid) AS number_orders,
  COUNT(DISTINCT customerid) AS number_customers,
  COUNT(DISTINCT salespersonid) AS no_salespersons,
  ROUND(SUM(TotalDue)) AS total_w_tax
FROM tc-da-1.adwentureworks_db.salesorderheader sales 
JOIN tc-da-1.adwentureworks_db.salesterritory territory ON territory.territoryID = sales.territoryID
GROUP BY  LAST_DAY(DATE(orderdate)), territory.countryregioncode, territory.name
LIMIT 200  


--Task 2.2 
WITH
  t1 AS (
  SELECT
    LAST_DAY(DATE(orderdate)) AS order_month,
    territory.countryregioncode,
    territory.name AS region,
    COUNT(salesorderid) AS number_orders,
    COUNT(DISTINCT customerid) AS number_customers,
    COUNT(DISTINCT salespersonid) AS no_salespersons,
    ROUND(SUM(TotalDue)) AS total_w_tax,
  FROM
    tc-da-1.adwentureworks_db.salesorderheader sales
  JOIN
    tc-da-1.adwentureworks_db.salesterritory territory
  ON
    territory.territoryID = sales.territoryID
  GROUP BY LAST_DAY(DATE(orderdate)), territory.countryregioncode, territory.name)

SELECT
  order_month,
  countryregioncode,
  region,
  number_orders,
  number_customers,
  no_salespersons,
  total_w_tax,
  SUM(CAST(total_w_tax AS INT64)) OVER (PARTITION BY countryregioncode, region ORDER BY order_month) AS cummulative_sum
FROM t1 




-- Task 2.3
WITH t1 AS (
  SELECT
    LAST_DAY(DATE(orderdate)) AS order_month,
    territory.countryregioncode,
    territory.name AS region,
    COUNT(salesorderid) AS number_orders,
    COUNT(DISTINCT customerid) AS number_customers,
    COUNT(DISTINCT salespersonid) AS no_salespersons,
    ROUND(SUM(TotalDue)) AS total_w_tax,
  FROM
    tc-da-1.adwentureworks_db.salesorderheader sales
  JOIN
    tc-da-1.adwentureworks_db.salesterritory territory
  ON
    territory.territoryID = sales.territoryID
  GROUP BY  LAST_DAY(DATE(orderdate)), territory.countryregioncode, territory.name)

SELECT
  order_month,
  countryregioncode,
  region,
  number_orders,
  number_customers,
  no_salespersons,
  total_w_tax,
  DENSE_RANK() OVER(PARTITION BY countryregioncode, region ORDER BY total_w_tax DESC) AS sales_rank,
  SUM(total_w_tax) OVER (PARTITION BY countryregioncode, region ORDER BY order_month) AS cummulative_sum
FROM t1
WHERE region = "France"
ORDER BY sales_rank 


-- Task 2.4
WITH t1 AS (
  SELECT
    LAST_DAY(DATE(orderdate)) AS order_month,
    territory.countryregioncode,
    territory.name AS region,
    COUNT(salesorderid) AS number_orders,
    COUNT(DISTINCT customerid) AS number_customers,
    COUNT(DISTINCT salespersonid) AS no_salespersons,
    ROUND(SUM(TotalDue)) AS total_w_tax,
  FROM
    tc-da-1.adwentureworks_db.salesorderheader sales
  JOIN
    tc-da-1.adwentureworks_db.salesterritory territory
  ON
    territory.territoryID = sales.territoryID
  GROUP BY LAST_DAY(DATE(orderdate)), territory.countryregioncode, territory.name),

t0 AS (SELECT
    st.CountryRegionCode AS Country,
    st.Name AS Region,
    sp.StateProvinceCode,
    MAX(TaxRate) AS mean_tax_rate
  FROM
    tc-da-1.adwentureworks_db.salesterritory st
  JOIN
    tc-da-1.adwentureworks_db.stateprovince sp
  ON
    st.TerritoryID=sp.TerritoryID
  JOIN
    tc-da-1.adwentureworks_db.salestaxrate str
  ON
    sp.StateProvinceID=str.StateProvinceID
  GROUP BY
    Country,
    Region,
    stateprovincecode

),

t2 AS (SELECT 
state_province.CountryRegionCode, 
AVG(t0.mean_tax_rate) as tax_rate,
COUNT(salestaxrate.StateProvinceID)/COUNT(state_province.StateProvinceID) as provinces_with_tax
from`adwentureworks_db.salestaxrate` salestaxrate
right join `adwentureworks_db.stateprovince` state_province
on salestaxrate.StateProvinceID =state_province.StateProvinceID
right join t0 ON t0.country = state_province.countryregioncode
group by state_province.CountryRegionCode 
)

SELECT
  order_month,
  t1.countryregioncode,
  region,
  number_orders,
  number_customers,
  no_salespersons,
  total_w_tax,
  DENSE_RANK() OVER(PARTITION BY t1.countryregioncode, region ORDER BY total_w_tax DESC) AS sales_rank,
  SUM(total_w_tax) OVER (PARTITION BY t1.countryregioncode, region ORDER BY order_month) AS cummulative_sum,
  ROUND(tax_rate,1), 
  ROUND(provinces_with_tax,2)
FROM t1 
JOIN t2 ON t1.countryregioncode = t2.countryregioncode
WHERE t1.countryregioncode = "US"
























































































































































