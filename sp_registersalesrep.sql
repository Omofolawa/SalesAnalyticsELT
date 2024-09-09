-- Create stored procedure to insert data into SalesRep table with transaction control
CREATE PROCEDURE RegisterSalesRep
    -- Declare input parameters
    @First_Name NVARCHAR(50),   -- First name of the SalesRep
    @Last_Name NVARCHAR(50),    -- Last name of the SalesRep
    @RegionID INT               -- RegionID of the SalesRep
AS
BEGIN
    -- Declare a variable to check the state of the transaction
    DECLARE @TransactionState BIT = 0;

    -- Start transaction
    BEGIN TRANSACTION;
    
    -- Validate RegionID is within the range 1 to 6
    IF @RegionID < 1 OR @RegionID > 6
    BEGIN
        -- If RegionID is not valid, return an error message and exit the procedure
        PRINT 'Error: RegionID must be between 1 and 6.';

        -- Rollback transaction because of invalid input
        ROLLBACK TRANSACTION;

        -- Return to prevent further processing
        RETURN;
    END

    -- Starting the error handling module
    BEGIN TRY
        -- Insert data into the SalesRep table
        INSERT INTO SalesRep (First_Name, Last_Name, RegionID)
        VALUES (@First_Name, @Last_Name, @RegionID);

        -- If insert is successful, mark transaction as successful
        SET @TransactionState = 1;

        -- Commit the transaction if everything went well
        COMMIT TRANSACTION;

        -- Notify success
        PRINT 'SalesRep record inserted successfully!';
    END TRY
    BEGIN CATCH
        -- Error handling block
        -- Retrieve the error message and error code
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        -- Assign system error information to local variables
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Print the error details to the console
        PRINT 'An error occurred while inserting the SalesRep record:';
        PRINT @ErrorMessage;

        -- Rollback the transaction if any error occurs
        IF @TransactionState = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;
    END CATCH;
END;

EXEC RegisterSalesRep 
    @First_Name = 'Jane', 
    @Last_Name = 'Smith', 
    @RegionID = 8;
