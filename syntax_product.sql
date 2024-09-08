-- Each product is stored uniquely.
CREATE TABLE Product (
    ProductID INT,
    ProductName NVARCHAR(255),
    Price DECIMAL(10,2)
);

SELECT * FROM Product;

-- Load Product Data From Staging Area to Designated Product Table.
INSERT INTO Product (ProductID, ProductName, Price)
SELECT DISTINCT ProductID, ProductName, Price
FROM HeapSalesData;

-- Syntax to find the number of counts of duplicates.
SELECT ProductID, COUNT(*) AS DuplicateCount
FROM Product
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- Removing duplicate records from Products using CTE
WITH Product_Duplicates AS (
    SELECT 
        ProductID,
        ProductName,
        ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY ProductID) AS RowNum
    FROM Product
)
DELETE FROM Product_Duplicates
WHERE RowNum > 1;

-- Create New Table
CREATE TABLE Product_New (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price NVARCHAR(50)
);

-- Step 2: Copy data from the old table to the new table (excluding ProductID)
INSERT INTO Product_New (ProductName, Price)
SELECT ProductName, Price
FROM Product;

-- Step 3: Drop the old table
DROP TABLE Product;

-- Step 4: Renaming the new table to the original table name
EXEC sp_rename 'Product_New', 'Product';