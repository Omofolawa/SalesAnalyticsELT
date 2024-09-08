CREATE TABLE Region (
    RegionID INT,
    RegionName NVARCHAR(100) NULL
);

SELECT * FROM Region;

-- Load Data into Dedicated Region Table
INSERT INTO Region (RegionName)
SELECT DISTINCT Region
FROM HeapSalesData;

-- Syntax to find the number of counts of duplicates.
SELECT RegionName, COUNT(*) AS DuplicateCount
FROM Region
GROUP BY RegionName
HAVING COUNT(*) > 1;


CREATE TABLE Region (
    RegionID INT,
    RegionName NVARCHAR(100) NULL
);

-- Create New Table
CREATE TABLE Region_New (
    RegionID INT IDENTITY(1,1) PRIMARY KEY,
    RegionName NVARCHAR(50)
);

-- Step 2: Copy data from the old table to the new table
INSERT INTO Region_New (RegionName)
SELECT RegionName
FROM Region;

-- Step 3: Drop the old table
DROP TABLE Region;

-- Step 4: Renaming the new table to the original table name
EXEC sp_rename 'Region_New', 'Region';
