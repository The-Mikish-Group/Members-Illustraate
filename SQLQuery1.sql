-- Fix DataProtectionKeys table
-- Drop and recreate the table with proper IDENTITY configuration
IF OBJECT_ID('dbo.DataProtectionKeys', 'U') IS NOT NULL
    DROP TABLE dbo.DataProtectionKeys;

CREATE TABLE dbo.DataProtectionKeys (
    Id int IDENTITY(1,1) NOT NULL,
    FriendlyName nvarchar(max) NULL,
    Xml nvarchar(max) NULL,
    CONSTRAINT PK_DataProtectionKeys PRIMARY KEY (Id)
);

-- Fix ColorVars table 
-- Drop and recreate the table with proper IDENTITY configuration
IF OBJECT_ID('dbo.ColorVars', 'U') IS NOT NULL
    DROP TABLE dbo.ColorVars;

CREATE TABLE dbo.ColorVars (
    Id int IDENTITY(1,1) NOT NULL,
    Name nvarchar(50) NOT NULL,
    Value nvarchar(7) NOT NULL,
    CONSTRAINT PK_ColorVars PRIMARY KEY (Id)
);

-- Optional: Add index for better performance on Name lookups
CREATE NONCLUSTERED INDEX IX_ColorVars_Name ON dbo.ColorVars (Name);