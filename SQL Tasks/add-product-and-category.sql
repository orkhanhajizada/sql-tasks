CREATE PROCEDURE AddProductWithCategory
    @CategoryName NVARCHAR(50),
    @Description NVARCHAR(255),
    @ProductName NVARCHAR(100),
    @UnitPrice DECIMAL(18, 2),
    @UnitsInStock INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CategoryId INT;

    IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = @CategoryName)
    BEGIN
        INSERT INTO Categories (CategoryName, Description)
        VALUES (@CategoryName, @Description);
        Print @CategoryName  + ' added';
        SET @CategoryId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SELECT @CategoryId = CategoryID FROM Categories WHERE CategoryName = @CategoryName;
        PRINT @CategoryName + ' already exists in the database';
    END

    INSERT INTO Products (ProductName, UnitPrice, UnitsInStock, CategoryID)
    VALUES (@ProductName, @UnitPrice, @UnitsInStock, @CategoryId);

    PRINT 'Product added';
END;



EXEC AddProductWithCategory
     'Beverages',
     'Test Description',
     'Chivas Regal',
     88.00,
     10; -- Beverages already exists in the database, Product added
EXEC AddProductWithCategory
     'New category',
     'New product category desc',
     'New product',
     50.00,
     30; -- New category added, Product added