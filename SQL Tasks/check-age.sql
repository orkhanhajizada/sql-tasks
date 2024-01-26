CREATE FUNCTION dbo.CheckAge (@birth_date DATE, @age INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @result NVARCHAR(100);

    DECLARE @birth_year INT;
    DECLARE @current_year INT;
    DECLARE @birth_month INT;
    DECLARE @current_month INT;
    DECLARE @birth_day INT;
    DECLARE @current_day INT;

    SET @birth_year = YEAR(@birth_date);
    SET @current_year = YEAR(GETDATE());
    SET @birth_month = MONTH(@birth_date);
    SET @current_month = MONTH(GETDATE());
    SET @birth_day = DAY(@birth_date);
    SET @current_day = DAY(GETDATE());

    IF @current_year - @birth_year > @age
        SET @result = 'Yıl olarak doldurmuştur, ay ve gün olarak doldurmamıştır';
    ELSE IF @current_year - @birth_year = @age
        IF @current_month > @birth_month
            SET @result = 'Yıl olarak doldurmuştur, ay ve gün olarak doldurmamıştır';
        ELSE IF @current_month = @birth_month
            IF @current_day >= @birth_day
                SET @result = 'Yıl ve ay olarak doldurmuştur, gün olarak doldurmamıştır';
            ELSE
                SET @result = 'Kişi henüz yıl, ay ve gün olarak yaşını doldurmamıştır';
        ELSE
            SET @result = 'Kişi henüz yıl, ay ve gün olarak yaşını doldurmamıştır';
    ELSE
        SET @result = 'Kişi henüz yıl, ay ve gün olarak yaşını doldurmamıştır';

    RETURN @result;
END;




SELECT dbo.CheckAge('1990-01-01', 30) AS Result1; -- Yıl olarak doldurmuştur, ay ve gün olarak doldurmamıştır
SELECT dbo.CheckAge('1985-05-15', 40) AS Result2; -- Yıl ve ay olarak doldurmuştur, gün olarak doldurmamıştır
SELECT dbo.CheckAge('2000-12-31', 20) AS Result3; -- Kişi henüz yıl, ay ve gün olarak yaşını doldurmamıştır