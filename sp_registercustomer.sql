-- Create stored procedure to insert data into Customer table with transaction control
CREATE PROCEDURE RegisterCustomer
    -- Declare input parameters
    @First_Name NVARCHAR(50),   -- First name of the Customer
    @Last_Name NVARCHAR(50)    -- Last name of the Customer
AS
BEGIN
    -- Declare a variable to check the state of the transaction
    DECLARE @TransactionState BIT = 0;

    -- Start transaction
    BEGIN TRANSACTION;
    
    -- Starting the error handling module
    BEGIN TRY
        -- Insert data into the Customer table
        INSERT INTO Customer (First_Name, Last_Name)
        VALUES (@First_Name, @Last_Name);

        -- If insert is successful, mark transaction as successful
        SET @TransactionState = 1;

        -- Commit the transaction if all inputs are valid
	        COMMIT TRANSACTION;

        -- Notify success
        PRINT 'Customer record inserted successfully!';
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
        PRINT 'An error occurred while inserting the Customer record:';
        PRINT @ErrorMessage;

        -- Rollback the transaction if any error occurs
        IF @TransactionState = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;
    END CATCH;
END;

EXEC RegisterCustomer 
    @First_Name = '000', 
    @Last_Name = 'Smith';