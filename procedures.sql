-- =============================================
-- Inventory & Sales Management System
-- Stored Procedures
-- =============================================

USE InventorySalesDB;
GO

-- Procedure 1: Make a sale
CREATE PROCEDURE sp_MakeSale
    @CustomerID INT,
    @ProductID  INT,
    @Quantity   INT
AS
BEGIN
    DECLARE @UnitPrice   DECIMAL(10,2);
    DECLARE @TotalAmount DECIMAL(10,2);
    DECLARE @SaleID      INT;
    DECLARE @StockQty    INT;

    SELECT @StockQty = Quantity 
    FROM Stock 
    WHERE ProductID = @ProductID;

    IF @StockQty < @Quantity
    BEGIN
        PRINT 'Error: Not enough stock available.';
        RETURN;
    END

    SELECT @UnitPrice = UnitPrice 
    FROM Products 
    WHERE ProductID = @ProductID;

    SET @TotalAmount = @UnitPrice * @Quantity;

    INSERT INTO Sales (CustomerID, TotalAmount, Status)
    VALUES (@CustomerID, @TotalAmount, 'Completed');

    SET @SaleID = SCOPE_IDENTITY();

    INSERT INTO SaleItems (SaleID, ProductID, Quantity, UnitPrice)
    VALUES (@SaleID, @ProductID, @Quantity, @UnitPrice);

    INSERT INTO Invoices (SaleID, AmountDue, AmountPaid, PaymentStatus)
    VALUES (@SaleID, @TotalAmount, 0.00, 'Unpaid');

    PRINT 'Sale recorded successfully. SaleID: ' + CAST(@SaleID AS NVARCHAR);
END;
GO

-- Procedure 2: Process a return
CREATE PROCEDURE sp_ProcessReturn
    @SaleItemID INT,
    @Quantity   INT,
    @Reason     NVARCHAR(255)
AS
BEGIN
    DECLARE @OriginalQty INT;

    SELECT @OriginalQty = Quantity
    FROM SaleItems
    WHERE SaleItemID = @SaleItemID;

    IF @OriginalQty IS NULL
    BEGIN
        PRINT 'Error: SaleItem not found.';
        RETURN;
    END

    IF @Quantity > @OriginalQty
    BEGIN
        PRINT 'Error: Return quantity exceeds original sale quantity.';
        RETURN;
    END

    INSERT INTO Returns (SaleItemID, Quantity, Reason)
    VALUES (@SaleItemID, @Quantity, @Reason);

    PRINT 'Return processed successfully.';
END;
GO

-- Procedure 3: Update invoice payment
CREATE PROCEDURE sp_UpdateInvoicePayment
    @SaleID      INT,
    @AmountPaid  DECIMAL(10,2)
AS
BEGIN
    DECLARE @AmountDue     DECIMAL(10,2);
    DECLARE @TotalPaid     DECIMAL(10,2);
    DECLARE @PaymentStatus NVARCHAR(20);

    SELECT @AmountDue = AmountDue, @TotalPaid = AmountPaid
    FROM Invoices
    WHERE SaleID = @SaleID;

    IF @AmountDue IS NULL
    BEGIN
        PRINT 'Error: Invoice not found.';
        RETURN;
    END

    SET @TotalPaid = @TotalPaid + @AmountPaid;

    IF @TotalPaid >= @AmountDue
        SET @PaymentStatus = 'Paid';
    ELSE IF @TotalPaid > 0
        SET @PaymentStatus = 'Partial';
    ELSE
        SET @PaymentStatus = 'Unpaid';

    UPDATE Invoices
    SET
        AmountPaid    = @TotalPaid,
        PaymentStatus = @PaymentStatus
    WHERE SaleID = @SaleID;

    PRINT 'Invoice updated. Status: ' + @PaymentStatus;
END;
GO