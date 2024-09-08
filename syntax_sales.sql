-- Entities Identified are Customers, Products, Sales, Regions, and SalesReps
-- Sytax to Create each of the tables are as follows;

SELECT * FROM HeapSalesData;

-- Stores sales transactions, linked to the other normalized tables.
CREATE TABLE Sale (
    SaleID INT,
    CustomerID INT,
    ProductID INT ,
    SalesRepID INT,
    Quantity INT,
    TotalAmount DECIMAL(12,2),
    SalesDate DATE
);

INSERT INTO Sale (SaleID, CustomerID, ProductID, SalesRepID, Quantity, TotalAmount, SalesDate)
SELECT hs.SaleID, hs.CustomerID, hs.ProductID, sr.SalesRepID, hs.Quantity, hs.TotalAmount, hs.SalesDate
FROM HeapSalesData hs
JOIN SalesReps sr ON hs.SalesRep = sr.SalesRepName;


-- Syntax to find duplicate data
SELECT SaleID, COUNT(*)
FROM HeapSalesData
GROUP BY SaleID
HAVING COUNT(*) > 1;

-- ALtering Sale Table to make	SaleID a PK
CREATE TABLE Sale_New (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID INT,
    ProductID INT ,
    SalesRepID INT,
    Quantity INT,
    TotalAmount DECIMAL(12,2),
    SalesDate DATE
);

-- Step 2: Copy data from the old table to the new table (excluding CustomerID)
INSERT INTO Sale_New (CustomerID, ProductID, SalesRepID, Quantity, TotalAmount, SalesDate)
SELECT CustomerID, ProductID, SalesRepID, Quantity, TotalAmount, SalesDate
FROM Sale;

-- Step 3: Drop the old table
DROP TABLE Sale;

-- Step 4: Renaming the new table to the original table name
EXEC sp_rename 'Sale_New', 'Sale';

-- Implementing Relationship Constraints (primary key and add foreign keys).
ALTER TABLE Sale
ADD CONSTRAINT FK_Sale_Customer FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);

ALTER TABLE Sale
ADD CONSTRAINT FK_Sale_Product FOREIGN KEY (ProductID)
REFERENCES Product(ProductID);

ALTER TABLE Sale
ADD CONSTRAINT FK_Sale_SalesRep FOREIGN KEY (SalesRepID)
REFERENCES SalesRep(SalesRepID);

SELECT DISTINCT CustomerID
FROM Sale
WHERE CustomerID NOT IN (SELECT CustomerID FROM Customer);

SET IDENTITY_INSERT Product ON;

-- Insert missing customers into Customer table from HeapSalesData
INSERT INTO Customer (CustomerID, First_Name, Last_Name)
SELECT DISTINCT hs.CustomerID, 
       LEFT(hs.CustomerName, CHARINDEX(' ', hs.CustomerName) - 1) AS First_Name, -- Split First Name
       RIGHT(hs.CustomerName, LEN(hs.CustomerName) - CHARINDEX(' ', hs.CustomerName)) AS Last_Name -- Split Last Name
FROM HeapSalesData hs
LEFT JOIN Customer c ON hs.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;  -- Only insert missing CustomerID
