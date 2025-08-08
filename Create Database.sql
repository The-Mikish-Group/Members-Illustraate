-- ================================================
-- COMPLETE MEMBERS DATABASE RECREATION SCRIPT
-- ================================================
-- This script will recreate the entire Members database structure
-- Run this on a NEW, EMPTY database

-- ================================================
-- STEP 1: CREATE TABLES
-- ================================================

-- Table: dbo.__EFMigrationsHistory
CREATE TABLE [dbo].[__EFMigrationsHistory] (
    [MigrationId] nvarchar(150) NOT NULL,
    [ProductVersion] nvarchar(32) NOT NULL
);
GO

-- Table: dbo.AdminTaskInstances
CREATE TABLE [dbo].[AdminTaskInstances] (
    [TaskInstanceID] int NOT NULL,
    [TaskID] int NOT NULL,
    [Year] int NOT NULL,
    [Month] int NOT NULL,
    [Status] int NOT NULL DEFAULT ((1)),
    [AssignedToUserId] nvarchar(450) NULL,
    [CompletedDate] datetime2(7) NULL,
    [CompletedByUserId] nvarchar(450) NULL,
    [Notes] nvarchar(1000) NULL,
    [IsAutomatedCompletion] bit NOT NULL DEFAULT ((0)),
    [DateCreated] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [LastUpdated] datetime2(7) NOT NULL DEFAULT (getutcdate())
);
GO

-- Table: dbo.AdminTasks
CREATE TABLE [dbo].[AdminTasks] (
    [TaskID] int NOT NULL,
    [TaskName] nvarchar(200) NOT NULL,
    [Description] nvarchar(1000) NULL,
    [Frequency] int NOT NULL DEFAULT ((1)),
    [DayOfMonthStart] int NOT NULL DEFAULT ((1)),
    [DayOfMonthEnd] int NOT NULL DEFAULT ((5)),
    [Priority] int NOT NULL DEFAULT ((2)),
    [PageUrl] nvarchar(200) NULL,
    [ActionHandler] nvarchar(100) NULL,
    [IsActive] bit NOT NULL DEFAULT ((1)),
    [CanAutomate] bit NOT NULL DEFAULT ((0)),
    [IsAutomated] bit NOT NULL DEFAULT ((0)),
    [DateCreated] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [LastUpdated] datetime2(7) NOT NULL DEFAULT (getutcdate())
);
GO

-- Table: dbo.AspNetRoleClaims
CREATE TABLE [dbo].[AspNetRoleClaims] (
    [Id] int NOT NULL,
    [RoleId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(MAX) NULL,
    [ClaimValue] nvarchar(MAX) NULL
);
GO

-- Table: dbo.AspNetRoles
CREATE TABLE [dbo].[AspNetRoles] (
    [Id] nvarchar(450) NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(MAX) NULL
);
GO

-- Table: dbo.AspNetUserClaims
CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id] int NOT NULL,
    [UserId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(MAX) NULL,
    [ClaimValue] nvarchar(MAX) NULL
);
GO

-- Table: dbo.AspNetUserLogins
CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider] nvarchar(128) NOT NULL,
    [ProviderKey] nvarchar(128) NOT NULL,
    [ProviderDisplayName] nvarchar(MAX) NULL,
    [UserId] nvarchar(450) NOT NULL
);
GO

-- Table: dbo.AspNetUserRoles
CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] nvarchar(450) NOT NULL,
    [RoleId] nvarchar(450) NOT NULL
);
GO

-- Table: dbo.AspNetUsers
CREATE TABLE [dbo].[AspNetUsers] (
    [Id] nvarchar(450) NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(MAX) NULL,
    [SecurityStamp] nvarchar(MAX) NULL,
    [ConcurrencyStamp] nvarchar(MAX) NULL,
    [PhoneNumber] nvarchar(MAX) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset(7) NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL
);
GO

-- Table: dbo.AspNetUserTokens
CREATE TABLE [dbo].[AspNetUserTokens] (
    [UserId] nvarchar(450) NOT NULL,
    [LoginProvider] nvarchar(128) NOT NULL,
    [Name] nvarchar(128) NOT NULL,
    [Value] nvarchar(MAX) NULL
);
GO

-- Table: dbo.BillableAssets
CREATE TABLE [dbo].[BillableAssets] (
    [BillableAssetID] int NOT NULL,
    [PlotID] nvarchar(100) NOT NULL,
    [UserID] nvarchar(450) NULL,
    [DateCreated] datetime2(7) NOT NULL,
    [LastUpdated] datetime2(7) NOT NULL,
    [Description] nvarchar(500) NULL,
    [AssessmentFee ] decimal(18,2) NULL DEFAULT ((0.00))
);
GO

-- Table: dbo.CategoryFiles
CREATE TABLE [dbo].[CategoryFiles] (
    [FileID] int NOT NULL,
    [CategoryID] int NOT NULL,
    [FileName] nvarchar(255) NOT NULL,
    [SortOrder] int NOT NULL
);
GO

-- Table: dbo.ColorVars
CREATE TABLE [dbo].[ColorVars] (
    [Id] int NOT NULL,
    [Name] nvarchar(50) NOT NULL,
    [Value] nvarchar(7) NOT NULL
);
GO

-- Table: dbo.CreditApplications
CREATE TABLE [dbo].[CreditApplications] (
    [CreditApplicationID] int NOT NULL,
    [UserCreditID] int NOT NULL,
    [InvoiceID] int NOT NULL,
    [AmountApplied] decimal(18,2) NOT NULL,
    [ApplicationDate] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [IsReversed] bit NOT NULL DEFAULT ((0)),
    [ReversedDate] datetime2(7) NULL,
    [Notes] nvarchar(500) NULL
);
GO

-- Table: dbo.DataProtectionKeys
CREATE TABLE [dbo].[DataProtectionKeys] (
    [Id] int NOT NULL,
    [FriendlyName] nvarchar(MAX) NULL,
    [Xml] nvarchar(MAX) NULL
);
GO

-- Table: dbo.ImportFile
CREATE TABLE [dbo].[ImportFile] (
    [FirstName] nvarchar(100) NULL,
    [MiddleName] nvarchar(100) NULL,
    [LastName] nvarchar(100) NULL,
    [Email] nvarchar(255) NOT NULL,
    [PhoneNumber] nvarchar(50) NULL,
    [HomePhoneNumber] nvarchar(50) NULL,
    [AddressLine1] nvarchar(255) NULL,
    [AddressLine2] nvarchar(255) NULL,
    [City] nvarchar(100) NULL,
    [State] nvarchar(50) NULL,
    [ZipCode] nvarchar(20) NULL,
    [Plot] nvarchar(100) NULL
);
GO

-- Table: dbo.Invoices
CREATE TABLE [dbo].[Invoices] (
    [InvoiceID] int NOT NULL,
    [UserID] nvarchar(450) NOT NULL,
    [InvoiceDate] datetime2(7) NOT NULL,
    [DueDate] datetime2(7) NOT NULL,
    [Description] nvarchar(500) NOT NULL,
    [AmountDue] decimal(18,2) NOT NULL,
    [AmountPaid] decimal(18,2) NOT NULL DEFAULT ((0.00)),
    [Status] int NOT NULL,
    [Type] int NOT NULL,
    [DateCreated] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [LastUpdated] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [BatchID] nvarchar(100) NULL,
    [ReasonForCancellation] nvarchar(500) NULL
);
GO

-- Table: dbo.Payments
CREATE TABLE [dbo].[Payments] (
    [PaymentID] int NOT NULL,
    [InvoiceID] int NULL,
    [UserID] nvarchar(450) NOT NULL,
    [PaymentDate] datetime2(7) NOT NULL,
    [Amount] decimal(18,2) NOT NULL,
    [Method] int NOT NULL,
    [ReferenceNumber] nvarchar(100) NULL,
    [Notes] nvarchar(500) NULL,
    [DateRecorded] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [IsVoided] bit NOT NULL DEFAULT ((0)),
    [VoidedDate] datetime2(7) NULL,
    [ReasonForVoiding] nvarchar(500) NULL,
    [LastUpdated] datetime2(7) NULL,
    [TotalPayments] decimal(18,2) NOT NULL DEFAULT ((0))
);
GO

-- Table: dbo.PDFCategories
CREATE TABLE [dbo].[PDFCategories] (
    [CategoryID] int NOT NULL,
    [CategoryName] nvarchar(255) NOT NULL,
    [SortOrder] int NOT NULL,
    [IsAdminOnly] bit NOT NULL DEFAULT ((0))
);
GO

-- Table: dbo.TaskStatusMessages
CREATE TABLE [dbo].[TaskStatusMessages] (
    [MessageID] int NOT NULL,
    [UserId] nvarchar(450) NOT NULL,
    [DismissedAt] datetime2(7) NOT NULL,
    [DismissalCount] int NOT NULL DEFAULT ((1))
);
GO

-- Table: dbo.UserCredits
CREATE TABLE [dbo].[UserCredits] (
    [UserCreditID] int NOT NULL,
    [UserID] nvarchar(450) NOT NULL,
    [CreditDate] datetime2(7) NOT NULL,
    [Amount] decimal(18,2) NOT NULL,
    [SourcePaymentID] int NULL,
    [Reason] nvarchar(500) NOT NULL,
    [IsApplied] bit NOT NULL DEFAULT ((0)),
    [AppliedDate] datetime2(7) NULL,
    [AppliedToInvoiceID] int NULL,
    [ApplicationNotes] nvarchar(500) NULL,
    [DateCreated] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [LastUpdated] datetime2(7) NOT NULL DEFAULT (getutcdate()),
    [IsVoided] bit NOT NULL DEFAULT ((0))
);
GO

-- Table: dbo.UserProfile
CREATE TABLE [dbo].[UserProfile] (
    [UserId] nvarchar(450) NOT NULL,
    [FirstName] nvarchar(100) NULL,
    [MiddleName] nvarchar(100) NULL,
    [LastName] nvarchar(100) NULL,
    [AddressLine1] nvarchar(255) NULL,
    [AddressLine2] nvarchar(255) NULL,
    [City] nvarchar(100) NULL,
    [State] nvarchar(50) NULL,
    [ZipCode] nvarchar(20) NULL,
    [Plot] nvarchar(100) NULL,
    [Birthday] datetime NULL,
    [Anniversary] datetime NULL,
    [HomePhoneNumber] nvarchar(MAX) NULL,
    [LastLogin] datetime NULL,
    [IsBillingContact] bit NULL,
    [Balance] decimal(18,0) NULL
);
GO

-- ================================================
-- STEP 2: ADD PRIMARY KEY CONSTRAINTS
-- ================================================
ALTER TABLE [dbo].[__EFMigrationsHistory] ADD CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY (MigrationId);
ALTER TABLE [dbo].[AdminTaskInstances] ADD CONSTRAINT [PK__AdminTas__548FCB3E4E1C06AE] PRIMARY KEY (TaskInstanceID);
ALTER TABLE [dbo].[AdminTasks] ADD CONSTRAINT [PK__AdminTas__7C6949D182BAAFC2] PRIMARY KEY (TaskID);
ALTER TABLE [dbo].[AspNetRoleClaims] ADD CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY (Id);
ALTER TABLE [dbo].[AspNetRoles] ADD CONSTRAINT [PK_AspNetRoles] PRIMARY KEY (Id);
ALTER TABLE [dbo].[AspNetUserClaims] ADD CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY (Id);
ALTER TABLE [dbo].[AspNetUserLogins] ADD CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY (LoginProvider, ProviderKey);
ALTER TABLE [dbo].[AspNetUserRoles] ADD CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY (UserId, RoleId);
ALTER TABLE [dbo].[AspNetUsers] ADD CONSTRAINT [PK_AspNetUsers] PRIMARY KEY (Id);
ALTER TABLE [dbo].[AspNetUserTokens] ADD CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY (UserId, LoginProvider, Name);
ALTER TABLE [dbo].[BillableAssets] ADD CONSTRAINT [PK_BillableAssets] PRIMARY KEY (BillableAssetID);
ALTER TABLE [dbo].[CategoryFiles] ADD CONSTRAINT [PK__Category__6F0F989F715171EF] PRIMARY KEY (FileID);
ALTER TABLE [dbo].[ColorVars] ADD CONSTRAINT [PK__ColorVar__3214EC07BA486D82] PRIMARY KEY (Id);
ALTER TABLE [dbo].[CreditApplications] ADD CONSTRAINT [PK_CreditApplications] PRIMARY KEY (CreditApplicationID);
ALTER TABLE [dbo].[DataProtectionKeys] ADD CONSTRAINT [PK_DataProtectionKeys] PRIMARY KEY (Id);
ALTER TABLE [dbo].[ImportFile] ADD CONSTRAINT [PK__tmp_ms_x__A9D105359AF17BFF] PRIMARY KEY (Email);
ALTER TABLE [dbo].[Invoices] ADD CONSTRAINT [PK_Invoices] PRIMARY KEY (InvoiceID);
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [PK_Payments] PRIMARY KEY (PaymentID);
ALTER TABLE [dbo].[PDFCategories] ADD CONSTRAINT [PK__PDFCateg__19093A2BB49C67B8] PRIMARY KEY (CategoryID);
ALTER TABLE [dbo].[TaskStatusMessages] ADD CONSTRAINT [PK__TaskStat__C87C037C14BA6B2D] PRIMARY KEY (MessageID);
ALTER TABLE [dbo].[UserCredits] ADD CONSTRAINT [PK_UserCredits] PRIMARY KEY (UserCreditID);
ALTER TABLE [dbo].[UserProfile] ADD CONSTRAINT [PK__tmp_ms_x__1788CC4C1974C704] PRIMARY KEY (UserId);
GO

-- ================================================
-- STEP 3: ADD FOREIGN KEY CONSTRAINTS
-- ================================================
-- Note: You still need to run the Foreign Key query to get these
-- Add the FK constraints here when you get them

-- ================================================
-- STEP 4: CREATE INDEXES
-- ================================================
CREATE NONCLUSTERED INDEX [IX_AdminTaskInstances_Status] ON [dbo].[AdminTaskInstances] (Status ASC);
CREATE NONCLUSTERED INDEX [IX_AdminTaskInstances_TaskID] ON [dbo].[AdminTaskInstances] (TaskID ASC);
CREATE NONCLUSTERED INDEX [IX_AdminTaskInstances_Year_Month] ON [dbo].[AdminTaskInstances] (Year ASC, Month ASC);
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims] (RoleId ASC);
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles] (NormalizedName ASC);
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims] (UserId ASC);
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins] (UserId ASC);
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles] (RoleId ASC);
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers] (NormalizedEmail ASC);
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers] (NormalizedUserName ASC);
CREATE NONCLUSTERED INDEX [IX_CategoryFiles_CategoryID] ON [dbo].[CategoryFiles] (CategoryID ASC);
CREATE NONCLUSTERED INDEX [IX_CreditApplications_InvoiceID] ON [dbo].[CreditApplications] (InvoiceID ASC);
CREATE NONCLUSTERED INDEX [IX_CreditApplications_UserCreditID] ON [dbo].[CreditApplications] (UserCreditID ASC);
CREATE NONCLUSTERED INDEX [IX_Invoices_UserID] ON [dbo].[Invoices] (UserID ASC);
CREATE NONCLUSTERED INDEX [IX_Payments_InvoiceID] ON [dbo].[Payments] (InvoiceID ASC);
CREATE NONCLUSTERED INDEX [IX_Payments_UserID] ON [dbo].[Payments] (UserID ASC);
CREATE NONCLUSTERED INDEX [IX_TaskStatusMessages_UserId] ON [dbo].[TaskStatusMessages] (UserId ASC);
CREATE NONCLUSTERED INDEX [IX_UserCredits_SourcePaymentID] ON [dbo].[UserCredits] (SourcePaymentID ASC);
CREATE NONCLUSTERED INDEX [IX_UserCredits_UserID] ON [dbo].[UserCredits] (UserID ASC);
GO

-- ================================================
-- SCRIPT COMPLETE
-- ================================================
PRINT 'Database structure created successfully!'
PRINT 'Tables: 22'
PRINT 'Primary Keys: 22' 
PRINT 'Indexes: 19'
PRINT 'Note: Foreign keys still need to be added if they exist in your source database'