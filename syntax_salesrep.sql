-- Stores information about the sales representatives.
CREATE TABLE SalesRep (
    SalesRepID INT,
    First_Name NVARCHAR(100),
	Last_Name NVARCHAR(100),
    RegionID INT FOREIGN KEY REFERENCES Regions(RegionID)
);

-- Load Data from staging area to designated SalesRep Table
INSERT INTO SalesRep (First_Name, Last_Name, RegionID)
SELECT DISTINCT 
    LEFT(SalesRep, CHARINDEX(' ', SalesRep) - 1) AS First_Name,  -- Extract first name
    RIGHT(SalesRep, LEN(SalesRep) - CHARINDEX(' ', SalesRep)) AS Last_Name, -- Extract last name
    r.RegionID  -- Get RegionID from the Regions table
FROM HeapSalesData hs
JOIN Regions r ON hs.Region = r.RegionName
WHERE CHARINDEX(' ', SalesRep) > 0;  -- Ensure there's a space in SalesRep to split first/last name

CREATE TABLE SalesRep_New (
    SalesRepID INT PRIMARY KEY IDENTITY(1,1),
    First_Name NVARCHAR(100),
	Last_Name NVARCHAR(100),
    RegionID INT FOREIGN KEY REFERENCES Regions(RegionID)
);

-- Step 2: Copy data from the old table to the new table
INSERT INTO SalesRep_New (First_Name, Last_Name, RegionID)
SELECT First_Name, Last_Name, RegionID
FROM SalesRep;

TRUNCATE TABLE SalesRep_New;

-- Step 3: Drop the old table
DROP TABLE SalesRep;

-- Step 4: Renaming the new table to the original table name
EXEC sp_rename 'SalesRep_New', 'SalesRep';