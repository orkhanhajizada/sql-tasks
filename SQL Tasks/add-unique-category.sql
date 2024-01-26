CREATE PROCEDURE AddUniqueCategory
    @CategoryName NVARCHAR(50),
    @Description NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = @CategoryName)
    BEGIN
        INSERT INTO Categories (CategoryName, Description)
        VALUES (@CategoryName, @Description);
        PRINT 'Category added';
    END
    ELSE
    BEGIN
        PRINT 'This category (' + @CategoryName + ') already exists';
    END
END;


EXEC AddUniqueCategory 'Beverages', 'Cola,Beer,Coffee'; -- This category (Beverages) already exists
EXEC AddUniqueCategory 'TestNewCategory', 'TestNewCategoryDescription'; --  Category added