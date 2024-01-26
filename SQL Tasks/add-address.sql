-- Create new database
CREATE DATABASE AddressDatabase;

-- Use AddressDatabase
USE AddressDatabase;

-- Countries table
CREATE TABLE Countries (
    CountryID INT PRIMARY KEY IDENTITY(1,1),
    CountryName NVARCHAR(50) NOT NULL
);

-- Cities table
CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(50) NOT NULL,
    CountryID INT FOREIGN KEY REFERENCES Countries(CountryID)
);

-- Districts table
CREATE TABLE Districts (
    DistrictID INT PRIMARY KEY IDENTITY(1,1),
    DistrictName NVARCHAR(50) NOT NULL,
    CityID INT FOREIGN KEY REFERENCES Cities(CityID)
);

-- Towns table
CREATE TABLE Towns (
    TownID INT PRIMARY KEY IDENTITY(1,1),
    TownName NVARCHAR(50) NOT NULL,
    DistrictID INT FOREIGN KEY REFERENCES Districts(DistrictID)
);

CREATE PROCEDURE AddAddress
    @CountryName NVARCHAR(50),
    @CityName NVARCHAR(50),
    @DistrictName NVARCHAR(50),
    @TownName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CountryID INT, @CityID INT, @DistrictID INT;

    -- Country control and add
    IF NOT EXISTS (SELECT 1 FROM Countries WHERE CountryName = @CountryName)
    BEGIN
        INSERT INTO Countries (CountryName) VALUES (@CountryName);
        SET @CountryID = SCOPE_IDENTITY();
        PRINT 'Country added.';
    END
    ELSE
    BEGIN
        SELECT @CountryID = CountryID FROM Countries WHERE CountryName = @CountryName;
        PRINT 'This country already exists.';
    END

    -- City control and add
    IF NOT EXISTS (SELECT 1 FROM Cities WHERE CityName = @CityName AND CountryID = @CountryID)
    BEGIN
        INSERT INTO Cities (CityName, CountryID) VALUES (@CityName, @CountryID);
        SET @CityID = SCOPE_IDENTITY();
        PRINT 'City added.';
    END
    ELSE
    BEGIN
        SELECT @CityID = CityID FROM Cities WHERE CityName = @CityName AND CountryID = @CountryID;
        PRINT 'This city already exists.';
    END

    -- District control and add
    IF NOT EXISTS (SELECT 1 FROM Districts WHERE DistrictName = @DistrictName AND CityID = @CityID)
    BEGIN
        INSERT INTO Districts (DistrictName, CityID) VALUES (@DistrictName, @CityID);
        SET @DistrictID = SCOPE_IDENTITY();
        PRINT 'District added.';
    END
    ELSE
    BEGIN
        SELECT @DistrictID = DistrictID FROM Districts WHERE DistrictName = @DistrictName AND CityID = @CityID;
        PRINT 'This district already exists.';
    END

    -- Town control and add
    IF NOT EXISTS (SELECT 1 FROM Towns WHERE TownName = @TownName AND DistrictID = @DistrictID)
    BEGIN
        INSERT INTO Towns (TownName, DistrictID) VALUES (@TownName, @DistrictID);
        PRINT 'Town added.';
    END
    ELSE
    BEGIN
        PRINT 'This town already exists.';
    END
    PRINT 'Address added.';
END;


EXEC AddAddress 
     'Turkey', 
     'Istanbul', 
     'Uskudar', 
     'Kuzguncuk'; -- Country added, City added, District added, Town added, Address added.

EXEC AddAddress 
     'Turkey', 
     'Izmir', 
     'Kordon', 
     'Alsancak'; -- This country already exists, City added, District added, Town added, Address added.

EXEC AddAddress 
     'Turkey', 
     'Istanbul', 
     'Kadikoy', 
     'Fenerbahche'; -- This country already exists, This city already exists, District added, Town added, Address added.

EXEC AddAddress 
     'Turkey',
     'Istanbul', 
     'Uskudar', 
     'Kuzguncuk'; -- This country already exists, This city already exists, This district already exists, This town already exists, Address added.

