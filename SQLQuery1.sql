CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(10000, 1), 
    AccountNumber NVARCHAR(20) UNIQUE,            
    Balance DECIMAL(10, 2)                        
);
GO

INSERT INTO Accounts (AccountNumber, Balance)
VALUES ('1234567890', 5000.00),  
       ('9876543210', 3000.00); 
GO

DECLARE @SourceAccount NVARCHAR(20) = '1234567890'; 
DECLARE @TargetAccount NVARCHAR(20) = '9876543210'; 
DECLARE @Amount DECIMAL(10, 2) = 1000.00;           

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @SourceBalance DECIMAL(10, 2);
    SELECT @SourceBalance = Balance FROM Accounts WHERE AccountNumber = @SourceAccount;

    IF @SourceBalance < @Amount
    BEGIN
        RAISERROR('Insufficient funds in the senders account.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountNumber = @SourceAccount;

    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountNumber = @TargetAccount;

    COMMIT TRANSACTION;

    PRINT 'Transaction is completed.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    PRINT 'Transaction error.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

