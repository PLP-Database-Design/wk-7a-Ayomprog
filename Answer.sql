question 1 
-- Assuming MySQL 8.0+ environment

WITH RECURSIVE SplitProducts AS (
  SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS RestProducts
  FROM ProductDetail

  UNION ALL

  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(RestProducts, ',', 1)),
    SUBSTRING(RestProducts, LENGTH(SUBSTRING_INDEX(RestProducts, ',', 1)) + 2)
  FROM SplitProducts
  WHERE RestProducts <> ''
)

SELECT OrderID, CustomerName, Product
FROM SplitProducts
ORDER BY OrderID;

question 2
-- Step 1: Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Step 2: Insert unique orders into the Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create the OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Insert order items into the OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

