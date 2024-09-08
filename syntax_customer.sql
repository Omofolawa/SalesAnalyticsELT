-- Each customer is stored uniquely.
CREATE TABLE Customer (
    CustomerID INT,
    First_Name NVARCHAR(100),
	Last_Name NVARCHAR(100)
);

-- Load Customer Data From Staging Area to Designated Customer Table.
INSERT INTO Customer (CustomerID, First_Name, Last_Name)
SELECT DISTINCT
    CustomerID,
    LEFT(CustomerName, CHARINDEX(' ', CustomerName) - 1) AS First_Name,  -- This extracts the first name by finding the position of the first space (CHARINDEX(' ', CustomerName)) and then taking the substring to the left of that position.
    RIGHT(CustomerName, LEN(CustomerName) - CHARINDEX(' ', CustomerName)) AS Last_Name  -- This extracts the last name by finding the position of the first space and taking the substring starting from that position to the end of the string (RIGHT)
FROM HeapSalesData;

-- Looking up Duplicate Customer's Data
SELECT CustomerID, COUNT(*) AS DuplicateCount
FROM Customer
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- Removing duplicate records using CTE 
WITH Customer_Duplicates AS (
    SELECT 
        CustomerID,
        First_Name,
		Last_Name,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY CustomerID) AS RowNum
    FROM Customer
)
DELETE FROM Customer_Duplicates
WHERE RowNum > 1;

-- The CustomerID table has to be in auto_increment format so that new records entry can be uniquely identified and designated with a automatic ID.
-- However, we cannot directly ALTER a Column to implement the IDENTITY Command, I will create a new Table to implement the IDENTITY Function and Copy the Data to the new table.

-- Step 1: Creating a new table with CustomerID as an IDENTITY column
CREATE TABLE Customer_New (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    First_Name NVARCHAR(50),
    Last_Name NVARCHAR(50)
);

-- Step 2: Copy data from the old table to the new table (excluding CustomerID)
INSERT INTO Customer_New (First_Name, Last_Name)
SELECT First_Name, Last_Name
FROM Customer;

-- Step 3: Drop the old table
DROP TABLE Customer;

-- Step 4: Renaming the new table to the original table name
EXEC sp_rename 'Customer_New', 'Customer';
