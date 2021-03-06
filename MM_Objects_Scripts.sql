/****** Object:  Table [dbo].[UserAccessFeature]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccessFeature](
	[AccessID] [int] NOT NULL,
	[AccessDescription] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewGMTTimeRange]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewGMTTimeRange]
AS
SELECT        DATEADD(DAY, DATEDIFF(DAY, 0, GETUTCDATE()) - 1, 0) AS LastDayStart, DATEADD(DAY, DATEDIFF(DAY, 0, GETUTCDATE()), 0) AS LastDayEnd, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETUTCDATE()) - 1, 0) 
                         AS LastWeekStart, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETUTCDATE()), 0) AS LastWeekEnd, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETUTCDATE()) - 1, 0) AS LastMonthStart, DATEADD(MONTH, 
                         DATEDIFF(MONTH, 0, GETUTCDATE()), 0) AS LastMonthEnd, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETUTCDATE()) - 1, 0) AS LastYearStart, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETUTCDATE()), 0) AS LastYearEnd
GO
/****** Object:  Table [dbo].[BlacklistTraffic]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlacklistTraffic](
	[BlacklistTrafficID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[MSISDN] [varchar](100) NOT NULL,
	[Via] [varchar](300) NULL,
	[Response] [varchar](1000) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[BlacklistID] [int] NULL,
 CONSTRAINT [PK_BlacklistTraffic] PRIMARY KEY CLUSTERED 
(
	[BlacklistTrafficID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[COM_BulkInsertSubscription]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_BulkInsertSubscription]
	@FullFilePath NVARCHAR(300)
AS 
BEGIN
	DECLARE @SQL NVARCHAR(2000)

	BEGIN TRANSACTION 

	SET @SQL = N'BULK INSERT Subscription FROM @FullFilePath WITH (FIELDTERMINATOR = ''||'', KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	PRINT @SQL 

	EXECUTE sp_executesql @SQL 

	IF (@@ERROR <> 0) 
	BEGIN 
	        ROLLBACK TRANSACTION 
	        RETURN -1 
	END 
	
	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[COM_BulkInsertBlacklistedEmail]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_BulkInsertBlacklistedEmail]
	@FullFilePath NVARCHAR(300)
AS 
BEGIN
	DECLARE @SQL NVARCHAR(500)

	BEGIN TRANSACTION 

	SET @SQL = N'BULK INSERT BlacklistedEmail FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'',KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	PRINT @SQL 

	EXECUTE sp_executesql @SQL 

	IF (@@ERROR <> 0) 
	BEGIN 
	        ROLLBACK TRANSACTION 
	        RETURN -1 
	END 
	
	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[COM_BulkInsertBlacklistDetail]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_BulkInsertBlacklistDetail]
	@FullFilePath NVARCHAR(300)
AS 
BEGIN
	DECLARE @SQL NVARCHAR(500)

	BEGIN TRANSACTION 

	SET @SQL = N'BULK INSERT BlacklistDetail FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'',KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	PRINT @SQL 

	EXECUTE sp_executesql @SQL 

	IF (@@ERROR <> 0) 
	BEGIN 
	        ROLLBACK TRANSACTION 
	        RETURN -1 
	END 
	
	COMMIT TRANSACTION
END
GO
/****** Object:  UserDefinedFunction [dbo].[f_split]    Script Date: 11/06/2020 08:48:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_split]
(
@param nvarchar(max), 
@delimiter char(1)
)
returns @temp table (val nvarchar(max), seq int)
as
begin
set @param += @delimiter

;with a as
(
select cast(1 as bigint) f, charindex(@delimiter, @param) t, 1 seq
union all
select t + 1, charindex(@delimiter, @param, t + 1), seq + 1
from a
where charindex(@delimiter, @param, t + 1) > 0
)
insert @temp
select substring(@param, f, t - f), seq from a
option (maxrecursion 0)
return
end
GO
/****** Object:  Table [dbo].[EmailTraffic]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailTraffic](
	[EmailTrafficID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[Email] [varchar](200) NOT NULL,
	[GroupID] [varchar](100) NULL,
	[Subject] [varchar](2000) NULL,
	[Message] [varchar](max) NULL,
	[NotificationID] [varchar](200) NULL,
	[Via] [varchar](1000) NULL,
	[Status] [varchar](100) NULL,
	[SMTPCode] [varchar](200) NULL,
	[Details] [varchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedOn] [datetime] NULL,
	[SubscriptionID] [int] NULL,
 CONSTRAINT [PK_EmailTraffic] PRIMARY KEY CLUSTERED 
(
	[EmailTrafficID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataRetentionRule]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataRetentionRule](
	[DataRetentionRuleID] [int] NOT NULL,
	[OrganizationID] [int] NULL,
	[TaskType] [varchar](20) NOT NULL,
	[RetentionPeriod] [int] NOT NULL,
	[IsKeepContent] [char](1) NULL,
	[IsKeepRecipient] [char](1) NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[UpdatorID] [int] NOT NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_DataRetentionRule] PRIMARY KEY CLUSTERED 
(
	[DataRetentionRuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_DataRetentionRule] UNIQUE NONCLUSTERED 
(
	[OrganizationID] ASC,
	[TaskType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComponentShare]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComponentShare](
	[ShareID] [int] IDENTITY(1,1) NOT NULL,
	[ComponentType] [nvarchar](50) NOT NULL,
	[ComponentID] [int] NOT NULL,
	[ShareType] [nvarchar](50) NOT NULL,
	[ShareeID] [int] NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[AllowAccess] [char](1) NULL,
	[AllowModify] [char](1) NULL,
	[AllowDelete] [char](1) NULL,
	[AllowSpecial1] [char](1) NULL,
	[AllowSpecial2] [char](1) NULL,
 CONSTRAINT [PK_ShareComponent] PRIMARY KEY CLUSTERED 
(
	[ShareID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Automator]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Automator](
	[AutomatorID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessID] [varchar](255) NOT NULL,
	[ListID] [int] NULL,
	[UserID] [int] NULL,
	[Email] [varchar](200) NULL,
	[FTPPath] [varchar](300) NULL,
	[Status] [varchar](15) NOT NULL,
	[ErrorMessage] [ntext] NULL,
	[ProcessedOn] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[AutomatorType] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Automators] PRIMARY KEY CLUSTERED 
(
	[AutomatorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataRetentionLog]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataRetentionLog](
	[DataRetentionLogID] [int] IDENTITY(1,1) NOT NULL,
	[organizationID] [int] NULL,
	[status] [nvarchar](4000) NULL,
	[ProcessedOn] [datetime] NULL,
	[subscriptionCount] [numeric](18, 0) NULL,
	[listCount] [int] NULL,
	[MTScheduledSubscriptionCount] [numeric](18, 0) NULL,
	[MTTrafficCount] [numeric](18, 0) NULL,
	[MOContentCount] [numeric](18, 0) NULL,
	[MOVerificationMOEntryCount] [numeric](18, 0) NULL,
	[MOTrafficCount] [numeric](18, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[DataRetentionLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataRetentionJob]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataRetentionJob](
	[DataRetentionJobID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessName] [varchar](31) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[StatusID] [int] NOT NULL,
 CONSTRAINT [PK_DataRetentionJob] PRIMARY KEY CLUSTERED 
(
	[DataRetentionJobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataRetentionDetailLog]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataRetentionDetailLog](
	[DataRetentionDetailLogID] [int] IDENTITY(1,1) NOT NULL,
	[DataRetentionJobID] [int] NOT NULL,
	[TaskId] [int] NOT NULL,
	[RetentionTime] [datetime] NOT NULL,
	[LogDetail] [varchar](4000) NOT NULL,
 CONSTRAINT [PK_DataRetentionDetailLog] PRIMARY KEY CLUSTERED 
(
	[DataRetentionDetailLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOSubscription]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOSubscription](
	[MOSubscriptionID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ListID] [int] NOT NULL,
	[MSISDN] [varchar](100) NOT NULL,
	[Status] [char](1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[Data1] [nvarchar](800) NULL,
	[Data2] [nvarchar](320) NULL,
	[Data3] [nvarchar](320) NULL,
	[Data4] [nvarchar](320) NULL,
	[Data5] [nvarchar](320) NULL,
	[Data6] [nvarchar](320) NULL,
	[Data7] [nvarchar](320) NULL,
	[Data8] [nvarchar](320) NULL,
	[Data9] [nvarchar](320) NULL,
	[Data10] [nvarchar](320) NULL,
	[SubscriptionID] [int] NULL,
 CONSTRAINT [PK_MOSubscriptions] PRIMARY KEY CLUSTERED 
(
	[MOSubscriptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MORoute]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MORoute](
	[MORouteID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [varchar](50) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ServiceType] [varchar](15) NOT NULL,
	[ShortCode] [varchar](20) NOT NULL,
	[Keywords] [nvarchar](200) NULL,
	[CarrierID] [varchar](20) NULL,
	[IsNullKeyword] [char](1) NOT NULL,
	[Encoding] [varchar](10) NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[MOOperatorID] [varchar](20) NULL,
	[IsVerification] [char](1) NOT NULL,
	[DestinationQueue] [varchar](500) NOT NULL,
	[VerificationQueue] [varchar](500) NULL,
	[RecordStatus] [char](1) NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_MORoutes] PRIMARY KEY NONCLUSTERED 
(
	[MORouteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOResponse]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOResponse](
	[MOResponseID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[AssetName] [nvarchar](50) NULL,
	[Verification] [bit] NOT NULL,
	[MOTaskType] [varchar](50) NULL,
	[ResponseType] [varchar](50) NULL,
	[ContentType] [varchar](50) NULL,
	[SecondaryKeyword] [nvarchar](50) NULL,
	[KeywordMatchMode] [varchar](50) NULL,
	[XMLAsset] [ntext] NULL,
	[HubAccountID] [int] NOT NULL,
	[RecordStatus] [char](1) NOT NULL,
	[CreatorID] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatorID] [int] NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_MOResponse] PRIMARY KEY NONCLUSTERED 
(
	[MOResponseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOOptInConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOOptInConfig](
	[TaskID] [int] NOT NULL,
	[ListID] [int] NULL,
	[OptInKeyword] [nvarchar](50) NULL,
	[OptOutKeyword] [nvarchar](50) NULL,
	[RecordStatus] [char](1) NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_MOOptInConfig] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOContent]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOContent](
	[ProgramID] [int] NULL,
	[TaskID] [int] NOT NULL,
	[MessageID] [varchar](100) NOT NULL,
	[MSISDN] [varchar](25) NOT NULL,
	[OperatorID] [varchar](25) NULL,
	[MOContent] [nvarchar](500) NOT NULL,
	[ContentType] [varchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_MOContent] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC,
	[MessageID] ASC,
	[CreatedOn] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MO_CompleteCodeMatchCreationConfig]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MO_CompleteCodeMatchCreationConfig]
	@TaskID INT,
	@CodeMatchCreationConfigID INT,
	@CodeActiveStatus CHAR(1),
	@CodeInactiveStatus CHAR(1)
AS
BEGIN
	UPDATE MOCodeMatchCode SET Status = @CodeActiveStatus
	WHERE TaskID = @TaskID
	AND CodeMatchCreationConfigID = @CodeMatchCreationConfigID
	AND Status = @CodeInactiveStatus
END
GO
/****** Object:  StoredProcedure [dbo].[MO_BulkInsertCodeMatchCode]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MO_BulkInsertCodeMatchCode]
	@FullFilePath NVARCHAR(300)
AS 
BEGIN
	DECLARE @SQL NVARCHAR(2000)

	BEGIN TRANSACTION 

	SET @SQL = N'BULK INSERT MOCodeMatchCode FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'', KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	PRINT @SQL 

	EXECUTE sp_executesql @SQL 

	IF (@@ERROR <> 0) 
	BEGIN 
	        ROLLBACK TRANSACTION 
	        RETURN -1 
	END 
	
	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[MO_BulkDeleteCodeMatchCode]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MO_BulkDeleteCodeMatchCode]
	@TaskID INT,
	@FullFilePath NVARCHAR(300)
AS
BEGIN
	BEGIN TRANSACTION

	CREATE TABLE #TempCodes
	(  
	  CODE VARCHAR(100) PRIMARY KEY CLUSTERED
	)  
	DECLARE @SQL NVARCHAR(2000)

	SET @SQL = N'BULK INSERT #TempCodes FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'',KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	EXECUTE sp_executesql @SQL

	DELETE FROM MOCodeMatchCode
	WHERE TaskID = @TaskID
  AND CODE IN (SELECT CODE FROM #TempCodes)

	DROP TABLE #TempCodes

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
	COMMIT TRANSACTION
END
GO
/****** Object:  Table [dbo].[Mail]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Mail](
	[MailID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduledOn] [datetime] NULL,
	[SentOn] [datetime] NULL,
	[Status] [varchar](15) NOT NULL,
	[SendTo] [varchar](500) NOT NULL,
	[SendFrom] [varchar](500) NULL,
	[SendCC] [varchar](500) NULL,
	[MailFormat] [varchar](10) NULL,
	[Subject] [nvarchar](500) NOT NULL,
	[Body] [ntext] NOT NULL,
	[RetryCount] [int] NULL,
	[ErrorMessage] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatorID] [int] NULL,
 CONSTRAINT [PK_Mails] PRIMARY KEY CLUSTERED 
(
	[MailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MO_DeleteTwoStepConfirmationsByTaskID]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[MO_DeleteTwoStepConfirmationsByTaskID]
	@TaskID INT
	
AS
BEGIN
	DELETE FROM TwoStepConfirmations WHERE TaskID = @TaskID
END
GO
/****** Object:  Table [dbo].[HubAccount]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HubAccount](
	[HubAccountID] [int] IDENTITY(1,1) NOT NULL,
	[HubAccountName] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[HubURL] [varchar](500) NOT NULL,
	[HubHash] [varchar](500) NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[OperatorID] [int] NULL,
	[AdditionalProperty1] [nvarchar](500) NULL,
	[AdditionalProperty2] [nvarchar](500) NULL,
	[AdditionalProperty3] [nvarchar](500) NULL,
	[AdditionalProperty4] [nvarchar](500) NULL,
	[AdditionalProperty5] [nvarchar](500) NULL,
 CONSTRAINT [PK_HubAccounts] PRIMARY KEY CLUSTERED 
(
	[HubAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FunctionGroup]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FunctionGroup](
	[FunctionGroupCode] [nvarchar](10) NOT NULL,
	[FunctionGroupName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](300) NULL,
	[Sequence] [int] NULL,
 CONSTRAINT [PK_FunctionGroup] PRIMARY KEY CLUSTERED 
(
	[FunctionGroupCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MTStatusCheckLog]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTStatusCheckLog](
	[MTStatusCheckLogID] [int] IDENTITY(1,1) NOT NULL,
	[AdhocID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[SentOn] [datetime] NOT NULL,
	[ProcessedOn] [datetime] NULL,
	[Status] [varchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](500) NULL,
 CONSTRAINT [PK_MTStatusCheckLog] PRIMARY KEY CLUSTERED 
(
	[MTStatusCheckLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MTScheduleStatusCountReport]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTScheduleStatusCountReport](
	[seqno] [int] NULL,
	[ScheduleDesc] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MTMMSViewHistory]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTMMSViewHistory](
	[MMSViewID] [int] IDENTITY(1,1) NOT NULL,
	[MTMMSID] [int] NOT NULL,
	[AccessIP] [varchar](50) NOT NULL,
	[AccessOn] [datetime] NULL,
 CONSTRAINT [PK_MMSViewID] PRIMARY KEY CLUSTERED 
(
	[MMSViewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MTMMS]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTMMS](
	[MMSID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[GUID] [varchar](100) NOT NULL,
	[AssetXML] [ntext] NULL,
	[HtmlContent] [ntext] NULL,
	[ViewCount] [int] NULL,
	[ViewCountDistinctIP] [int] NULL,
	[RefreshOn] [datetime] NULL,
 CONSTRAINT [PK_MTMMS] PRIMARY KEY CLUSTERED 
(
	[MMSID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MSISDNFormat]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MSISDNFormat](
	[MSISDNFormatID] [int] IDENTITY(1,1) NOT NULL,
	[MSISDNFormatName] [nvarchar](100) NULL,
	[MinLength] [int] NULL,
	[MaxLength] [int] NULL,
	[ValidStartCode] [varchar](10) NULL,
	[InvalidStartCodes] [varchar](500) NULL,
 CONSTRAINT [PK_MSISDNFormats] PRIMARY KEY CLUSTERED 
(
	[MSISDNFormatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOVerificationMOEntry]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOVerificationMOEntry](
	[VerificationEntryID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TaskID] [int] NULL,
	[MessageID] [varchar](50) NULL,
	[MSISDN] [varchar](25) NULL,
	[OriginalKeyword] [nvarchar](50) NULL,
	[OriginalMessage] [nvarchar](1000) NULL,
	[Completed] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_VerificationEntryID] PRIMARY KEY CLUSTERED 
(
	[VerificationEntryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOVerificationConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOVerificationConfig](
	[TaskID] [int] NOT NULL,
	[ConfirmationKeyword] [nvarchar](50) NULL,
	[RejectionKeyword] [nvarchar](50) NULL,
	[RecordStatus] [char](1) NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_MOVerificationConfig] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOValidationContent]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOValidationContent](
	[ProgramID] [int] NULL,
	[TaskID] [int] NOT NULL,
	[MessageID] [varchar](100) NOT NULL,
	[MSISDN] [varchar](25) NOT NULL,
	[OperatorID] [varchar](25) NULL,
	[MOContent] [nvarchar](500) NULL,
	[Status] [varchar](100) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[Data1] [nvarchar](320) NULL,
	[Data2] [nvarchar](320) NULL,
	[Data3] [nvarchar](320) NULL,
	[Data4] [nvarchar](320) NULL,
	[Data5] [nvarchar](320) NULL,
	[Data6] [nvarchar](320) NULL,
	[Data7] [nvarchar](320) NULL,
	[Data8] [nvarchar](320) NULL,
	[Data9] [nvarchar](320) NULL,
	[Data10] [nvarchar](320) NULL,
 CONSTRAINT [PK_MOValidationContent] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC,
	[MessageID] ASC,
	[CreatedOn] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOTraffic]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOTraffic](
	[MOTrafficID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [varchar](50) NULL,
	[MSISDN] [varchar](25) NOT NULL,
	[OriginatingAddress] [varchar](25) NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[OperatorID] [varchar](10) NULL,
	[AccountID] [varchar](25) NULL,
	[MessageID] [varchar](25) NULL,
	[DCS] [varchar](10) NULL,
	[SessionID] [varchar](50) NULL,
	[Keyword] [varchar](50) NULL,
	[ReceivedOn] [datetime] NOT NULL,
	[AMReceivedOn] [datetime] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_MOTraffic] PRIMARY KEY CLUSTERED 
(
	[MOTrafficID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MOTask_DeleteTwoStepConfirmationsByTaskID]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[MOTask_DeleteTwoStepConfirmationsByTaskID]
	@TaskID INT
	
AS
BEGIN
	DELETE FROM TwoStepConfirmations WHERE TaskID = @TaskID
END
GO
/****** Object:  StoredProcedure [dbo].[MT_PrepareScheduledSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_PrepareScheduledSubscriptions]
	@ListID INT,
	@TaskID INT,
	@SubscriptionInactiveStatus CHAR(1),
	@Filter NVARCHAR(2000)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Sql NVARCHAR(4000)

	SET @Sql = 'INSERT INTO MTScheduledSubscription SELECT '
	SET @Sql = @Sql + CAST(@TaskID AS VARCHAR) + ', '				--TaskID
	SET @Sql = @Sql + '0, '											--ScheduleID
	SET @Sql = @Sql + '0, '											--TimeBlockID
	SET @Sql = @Sql + ''''  + @SubscriptionInactiveStatus + ''', '	--Status
	SET @Sql = @Sql + 'GETUTCDATE(), '								--CreatedOn
	SET @Sql = @Sql + 'NULL, '										--ScheduledOn
	SET @Sql = @Sql + 'NULL, '										--StoppedOn
	SET @Sql = @Sql + 'NULL, '										--SentOn
	SET @Sql = @Sql + 'MSISDN, '									--MSISDN
	SET @Sql = @Sql + 'Data1, Data2, Data3, Data4, Data5, '			--Data1-5
	SET @Sql = @Sql + 'Data6, Data7, Data8, Data9, Data10, NULL,NULL,NULL '			--Data6-10
	SET @Sql = @Sql + 'FROM Subscription WITH (NOLOCK, INDEX(IX_Subscriptions_3)) '
	SET @Sql = @Sql + 'WHERE ListID = ' + CAST(@ListID AS VARCHAR)
	IF ((@Filter IS NOT NULL) AND (@Filter <> ''))
	BEGIN
		SET @Sql = @Sql + ' AND (' + @Filter + ')'
	END

	PRINT @Sql
	EXEC (@Sql)

	SELECT @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[MT_GetNextSubscription]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_GetNextSubscription]
	@ListID INT,
	@CurrentSubscriptionID INT,
	@Direction VARCHAR(4),
	@SubscriptionInactiveStatus CHAR(1),
	@Filter NVARCHAR(2000)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Sql NVARCHAR(4000)

	SET @Sql = 'SELECT TOP 1 * FROM Subscription '
	SET @Sql = @Sql + 'WHERE ListID = ' + CAST(@ListID AS VARCHAR) + ' '
	SET @Sql = @Sql + 'AND Status <> ''' + @SubscriptionInactiveStatus + ''' '
	IF (@Direction = 'ASC')
	BEGIN
		SET @Sql = @Sql + 'AND SubscriptionID > ' + CAST(@CurrentSubscriptionID AS VARCHAR) + ' '
	END
	ELSE
	BEGIN
		SET @Sql = @Sql + 'AND SubscriptionID < ' + CAST(@CurrentSubscriptionID AS VARCHAR) + ' '
	END
	IF ((@Filter IS NOT NULL) AND (@Filter <> ''))
	BEGIN
		SET @Sql = @Sql + ' AND ' + @Filter
	END
	
	SET @Sql = @Sql + ' ORDER BY SubscriptionID ' + @Direction
	
	PRINT @Sql
	EXEC (@Sql)

END
GO
/****** Object:  StoredProcedure [dbo].[DEBUG_Deadlock_2]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[DEBUG_Deadlock_2] AS

/* in a second window (another transaction) enter: */
BEGIN TRAN
UPDATE t2 SET i = 99 WHERE i = 9
WAITFOR DELAY '00:00:20'
UPDATE t1 SET i = 11 WHERE i = 1
COMMIT
GO
/****** Object:  StoredProcedure [dbo].[DEBUG_Deadlock_1]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[DEBUG_Deadlock_1] AS

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[t1]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[t1]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[t2]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[t2]

CREATE TABLE t1 (i int);
CREATE TABLE t2 (i int);

INSERT t1 SELECT 1;
INSERT t2 SELECT 9;


/* in one window enter: */
BEGIN TRAN
UPDATE t1 SET i = 11 WHERE i = 1
WAITFOR DELAY '00:01:20'
UPDATE t2 SET i = 99 WHERE i = 9
COMMIT
GO
/****** Object:  Table [dbo].[SystemMessage]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemMessage](
	[SystemMessageID] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Subject] [ntext] NULL,
	[Message] [ntext] NULL,
 CONSTRAINT [PK_SystemMessages] PRIMARY KEY CLUSTERED 
(
	[SystemMessageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SystemConfig](
	[ParamName] [varchar](50) NOT NULL,
	[ParamValue] [varchar](500) NULL,
	[Category] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SystemConfig] PRIMARY KEY CLUSTERED 
(
	[ParamName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubscriptionFilter]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubscriptionFilter](
	[ListID] [int] NOT NULL,
	[MSISDN] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[Data1] [nvarchar](800) NULL,
	[Data2] [nvarchar](320) NULL,
	[Data3] [nvarchar](320) NULL,
	[Data4] [nvarchar](320) NULL,
	[Data5] [nvarchar](320) NULL,
	[Data6] [nvarchar](320) NULL,
	[Data7] [nvarchar](320) NULL,
	[Data8] [nvarchar](320) NULL,
	[Data9] [nvarchar](320) NULL,
	[Data10] [nvarchar](320) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[Subscription_UpdateListSubscriptionsCount]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Subscription_UpdateListSubscriptionsCount]
	@ListID INT
AS
BEGIN
	DECLARE @Count INT
	SELECT @Count = COUNT(*) FROM Subscriptions WHERE ListID = @ListID
	UPDATE Lists SET SubscriptionsCount = @Count WHERE ListID = @ListID
	RETURN @Count
END
GO
/****** Object:  Table [dbo].[user_backup]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[user_backup](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[ApprovalRouteID] [int] NULL,
	[Role] [varchar](4) NOT NULL,
	[UserName] [nvarchar](200) NOT NULL,
	[LoginID] [varchar](25) NOT NULL,
	[Password] [varchar](255) NULL,
	[Timezone] [varchar](50) NOT NULL,
	[Email] [varchar](250) NULL,
	[MobileNumber] [varchar](100) NULL,
	[AccountBalance] [bigint] NULL,
	[LastLoginOn] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[SecurityPolicyXML] [ntext] NULL,
	[TempRetryCount] [int] NULL,
	[TotalRetryCount] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[user_backup] ADD [AccountStatus] [varchar](10) NULL
ALTER TABLE [dbo].[user_backup] ADD [LockedOn] [datetime] NULL
ALTER TABLE [dbo].[user_backup] ADD [ReleaseLockOn] [datetime] NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[user_backup] ADD [PasswordStatus] [char](1) NULL
ALTER TABLE [dbo].[user_backup] ADD [UserProperty] [ntext] NULL
ALTER TABLE [dbo].[user_backup] ADD [RoleID] [int] NOT NULL
ALTER TABLE [dbo].[user_backup] ADD [ReAuth] [char](1) NULL
ALTER TABLE [dbo].[user_backup] ADD [TokenExpiredOn] [datetime] NULL
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[test]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temptable]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[temptable](
	[taskid] [int] NOT NULL,
	[tasktype] [varchar](50) NOT NULL,
	[creatorid] [int] NULL,
	[createdon] [datetime] NULL,
	[hubacctid] [nvarchar](4000) NULL,
	[loginid] [varchar](25) NOT NULL,
	[lastloginon] [datetime] NULL,
	[organizationname] [nvarchar](250) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[temp_table]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_table](
	[id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temp]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[temp](
	[userid] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TaskStatistics]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TaskStatistics](
	[TaskStatisticsID] [int] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NOT NULL,
	[DataName] [nvarchar](1000) NOT NULL,
	[DataValue] [nvarchar](1000) NOT NULL,
	[Group] [varchar](31) NOT NULL,
	[GroupCount] [int] NULL,
	[UpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_TaskStatistics] PRIMARY KEY CLUSTERED 
(
	[TaskStatisticsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoutingConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RoutingConfig](
	[RoutingConfigID] [int] IDENTITY(1,1) NOT NULL,
	[RoutingType] [varchar](2) NULL,
	[ServiceType] [varchar](20) NULL,
	[Queue] [varchar](200) NOT NULL,
	[IsDefault] [char](1) NULL,
	[UserID] [int] NULL,
	[CustomerID] [varchar](20) NULL,
 CONSTRAINT [PK_QueueConfigs] PRIMARY KEY CLUSTERED 
(
	[RoutingConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Role]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NULL,
	[BaseRoleCode] [varchar](2) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [text] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[RGClassifier]    Script Date: 11/06/2020 08:48:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RGClassifier]()
RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN
  RETURN (SELECT CASE ORIGINAL_LOGIN() WHEN N'mm_retention_user'
    THEN N'Group_Data_Retention_Job' ELSE N'default' END);
END
GO
/****** Object:  Table [dbo].[Results]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Results](
	[AppSubID] [varchar](100) NOT NULL,
	[MessageID] [varchar](100) NULL,
	[MSISDN] [varchar](25) NOT NULL,
	[OperatorID] [varchar](25) NULL,
	[MOContent] [varchar](500) NOT NULL,
	[ContentType] [varchar](50) NULL,
	[Created] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MTTask_GetPendingSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MTTask_GetPendingSchedule]
	@PendingStatus VARCHAR(15),
	@SendingStatus VARCHAR(15),
	@ProcessingStatus VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ScheduleID	AS INT
	DECLARE @TaskID	AS INT
	DECLARE @CurrentStatus AS VARCHAR(15)
	SET @ScheduleID = 0 
	SET @TaskID = NULL 

	SELECT TOP 1 @ScheduleID = ScheduleID, @TaskID = TaskID, @CurrentStatus = Status
	FROM Schedules
	WHERE Status = @PendingStatus OR Status = @SendingStatus 
	AND StartTime < GETUTCDATE()
	--AND EndTime > GETDATE()
	ORDER BY ISNULL(ProcessedTime, StartTime) ASC  


	IF (@@ROWCOUNT > 0) 
	BEGIN
		BEGIN TRANSACTION

  	UPDATE Schedules WITH (ROWLOCK)
  	SET Status = @ProcessingStatus,
		ProcessedTime = GETUTCDATE()
  	WHERE ScheduleID = @ScheduleID
		AND Status = @CurrentStatus
		IF (@@ROWCOUNT = 0)
		BEGIN
			SET @ScheduleID = 0
		END

		COMMIT TRANSACTION
 	END

	RETURN @ScheduleID
END
GO
/****** Object:  StoredProcedure [dbo].[MTTask_RefreshSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MTTask_RefreshSchedule]
	@ScheduleID INT,
	@ExpireStatus VARCHAR(15),
	@CancelStatus VARCHAR(15),
	@StopStatus VARCHAR(15),
	@ErrorStatus VARCHAR(15),
	@CompleteStatus VARCHAR(15),
	@PauseStatus VARCHAR(15),
	@SubscriptionPendingStatus VARCHAR(15)

AS
BEGIN
	UPDATE Schedules WITH (ROWLOCK) SET Status = @ExpireStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @PauseStatus
	AND EndTime < GETUTCDATE()

	DECLARE @CurrentScheduleStatus VARCHAR(15)
	SELECT @CurrentScheduleStatus = Status FROM Schedules WHERE ScheduleID = @ScheduleID
	IF ((@CurrentScheduleStatus = @ExpireStatus) OR (@CurrentScheduleStatus = @CancelStatus) OR (@CurrentScheduleStatus = @StopStatus) OR (@CurrentScheduleStatus = @ErrorStatus))
	BEGIN
		UPDATE ScheduledSubscriptions WITH (ROWLOCK) SET @ScheduleID = 0
		WHERE ScheduleID = @ScheduleID AND Status = @SubscriptionPendingStatus
	END
END
GO
/****** Object:  StoredProcedure [dbo].[MTTask_GetScheduledSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MTTask_GetScheduledSubscriptions]
	@ScheduleID INT,
	@BatchSize INT,
	@PendingStatus VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON

	IF ((@BatchSize IS NOT NULL) AND (@BatchSize > 0))
		SET ROWCOUNT @BatchSize
	ELSE
		SET ROWCOUNT 0

	SELECT * FROM ScheduledSubscriptions
	WHERE ScheduleID = @ScheduleID
	AND Status = @PendingStatus
	AND ScheduledOn < GETUTCDATE()
	AND ((StoppedOn IS NULL) OR (StoppedOn > GETUTCDATE()))
	ORDER BY ScheduledOn ASC  

	RETURN @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[MT_GetScheduledSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_GetScheduledSubscriptions]
	@ScheduleID INT,
	@BatchSize INT,
	@PendingStatus VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON

	IF ((@BatchSize IS NOT NULL) AND (@BatchSize > 0))
		SET ROWCOUNT @BatchSize
	ELSE
		SET ROWCOUNT 0

	SELECT * FROM ScheduledSubscriptions
	WHERE ScheduleID = @ScheduleID
	AND Status = @PendingStatus
	AND ScheduledOn < GETUTCDATE()
	AND ((StoppedOn IS NULL) OR (StoppedOn > GETUTCDATE()))
	ORDER BY ScheduledOn ASC  

	RETURN @@ROWCOUNT
END
GO
/****** Object:  Table [dbo].[ShortCode]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShortCode](
	[ShortCodeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[OperatorName] [nvarchar](50) NULL,
	[Description] [nvarchar](500) NULL,
	[EffectOn] [datetime] NULL,
	[ExpireOn] [datetime] NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_ShortCodes] PRIMARY KEY CLUSTERED 
(
	[ShortCodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SendEmail]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
--example : 

exec dbo.SendEmail 
       @from='support@binaryworld.no-ip.info'
       ,@to='abc@hotmail.com'
       ,@subject='<This is subject>'
       ,@body='<This is body>'
       ,@IsHTMLFormat=1
       ,@Attachments='c:\test.htm;c:\test.xml'        

*/
CREATE  Procedure [dbo].[SendEmail]
    @RptID int = null,
    @To      varchar(2048) = null,
    @Body     varchar(8000) = null,
    @Subject   varchar(255) = null,
    @Attachments varchar(1024) = null,
    @Query    varchar(8000) = null,
    @From     varchar(128) = null,
    @CC      varchar(2048) = null,
    @BCC     varchar(2048) = null,
    @IsHTMLFormat Bit = 0, -- HTML format or Plain Text Format [ Default is Text ]
    @SMTPServer  varchar(255) = '10.44.161.53', -- put local network smtp server name here
    @cSendUsing  char(1)    = '2',
    @Port     varchar(3)  = '25',
    @cAuthenticate char(1)    = '0',
    @DSNOptions  varchar(2)  = '0',
    @Timeout   varchar(2)  = '30',
    @SenderName  varchar(128) = 'noreply@sybase.com',
    @ServerName  sysname    = '10.44.162.102',
    @ErrorMessage varchar(1000) OUT
As

/*******************************************************************/
--Name    : SendEmail
--Server   : Generic 
--Description : SQL smtp e-mail using CDOSYS, OLE Automation and a
--       network smtp server; For SQL Servers running on 
--       windows 2000.
--
--Note    : Be sure to set the default for @SMTPServer above to 
--       the company network smtp server or you will have to 
--       pass it in each time. 
--
--Comments  : Getting the network SMTP configured to work properly
--       may require engaging your company network or 
--       server people who deal with the netowrk SMTP server. 
--       Some errors that the stored proc returns relate to 
--       incorrect permissions for the various SQL Servers to 
--       use the SMTP relay server to bouce out going mail. 
--       Without proper permissions the SQL server appears as 
--       a spammer to the local SMTP network server.
--
--Parameters : See the 'Syntax' Print statements below or call the 
--       sp with '?' as the first input.
-- 
--History   : 
/*******************************************************************/

Set nocount on

-- Determine if the user requested syntax.
If @To = '?'
  Begin
   Print 'Syntax for sp_SQLSMTPMail (based on CDOSYS):'
   Print 'Exec master.dbo.sp_SQLSMTPMail'
   Print '   @To     (varchar(2048)) - Recipient e-mail address list separating each with a '';'' '
   Print '                    or a '',''. Use a ''?'' to return the syntax.'
   Print '   @Body    (varchar(8000)) - Text body; use embedded char(13) + char(10)'
   Print '                    for carriage returns. The default is nothing'
   Print '   @Subject   (varchar(255))) - E-mail subject. The default is a message from'
   Print '                    @@servername.'
   Print '   @Attachments (varchar(1024)) - Attachment list separating each with a '';''.'
   Print '                    The default is no attachments.'
   Print '   @Query    (varchar(8000)) - In-line query or a query file path; do not '
   Print '                    use double quotes within the query.'
   Print '   @From    (varchar(128)) - Sender list defaulted to @@ServerName.'
   Print '   @CC     (varchar(2048)) - CC list separating each with a '';'' or a '','''
   Print '                    The default is no CC addresses.'
   Print '   @BCC     (varchar(2048)) - Blind CC list separating each with a '';'' or a '','''
   Print '                    The default is no BCC addresses.'
   Print '   @IsHTMLFormat (Bit) - If 1 then Format of Mail will be HTML Mail otherwise Plain text'
   Print '   @SMTPServer (varchar(255)) - Network smtp server defaulted to your companies network'
   Print '                    smtp server. Set this in the stored proc code.'
   Print '   @cSendUsing  (char(1))    - Specifies the smpt server method, local or network. The'
   Print '                    default is network, a value of ''2''.'
   Print '   @Port    (varchar(3))  - The smtp server communication port defaulted to ''25''.'
   Print '   @cAuthenticate (char(1))    - The smtp server authentication method defaulted to '
   Print '                    anonymous, a value of ''0''.'
   Print '   @DSNOptions (varchar(2))  - The smtp server delivery status defaulted to none,'
   Print '                    a value of ''0''.'
   Print '   @Timeout   (varchar(2))  - The smtp server connection timeout defaulted to 30 seconds.'
   Print '   @SenderName (varchar(128)) - Primary sender name defaulted to @@ServerName.'
   Print '   @ServerName (sysname)    - SQL Server to which the query is directed defaulted'
   Print '                    to @@ServerName.'
   Print ''
   Print ''
   Print 'Example:'
   Print 'sp_SQLSMTPMail ''<user@mycompany.com>'', ''This is a test'', @SMTPServer = <network smtp relay server>'
   Print ''
   Print 'The above example will send an smpt e-mail to <user@mycompany.com> from @@ServerName'
   Print 'with a subject of ''Message from SQL Server <@@ServerName>'' and a'
   Print 'text body of ''This is a test'' using the network smtp server specified.'
   Print 'See the MSDN online library, Messaging and Collaboration, at '
   Print 'http://www.msdn.microsoft.com/library/ for details about CDOSYS.'
   Print 'subheadings: Messaging and Collaboration>Collaboration Data Objects>CDO for Windows 2000>'
   Print 'Reference>Fields>http://schemas.microsoft.com/cdo/configuration/>smtpserver field'
   Print ''
   Print 'Be sure to set the default for @SMTPServer before compiling this stored procedure.'
   Print ''
   Return
  End


-- Declare variables
Declare @iMessageObjId  int
Declare @iHr       int
Declare @iRtn       int
Declare @iFileExists   tinyint
Declare @Cmd      varchar(255)
Declare @QueryOutPath  varchar(50)
Declare @dtDatetime    datetime
Declare @ErrMssg    varchar(255)
Declare @Attachment   varchar(1024)
Declare @iPos       int
Declare @ErrSource   varchar(255)
Declare @ErrDescription varchar(255)
Declare @RetVal int

-- Set local variables.
Set @dtDatetime = getdate()
Set @iHr = 0
Set @RetVal = 0

-- Check for minimum parameters.
If @To is null
  Begin
   Set @ErrMssg = 'You must supply at least 1 recipient.'
   Goto ErrMssg
  End 

-- CDOSYS uses commas to separate recipients. Allow users to use 
-- either a comma or a semi-colon by replacing semi-colons in the 
-- To, CCs and BCCs.
Select @To = Replace(@To, ';', ',')
Select @CC = Replace(@CC, ';', ',')
Select @BCC = Replace(@BCC, ';', ',')

-- Set the default SQL Server to the local SQL Server if one 
-- is not provided to accommodate instances in SQL 2000.
If @ServerName is null
  Set @ServerName = @@servername

-- Set a default "subject" if one is not provided.
If @Subject is null
  Set @Subject = 'Message from SQL Server ' + @ServerName

-- Set a default "from" if one is not provided.
If @From is null
  Set @From = 'SQL-' + Replace(@ServerName,'\','_')

-- Set a default "sender name" if one is not provided.
If @SenderName is null
  Set @SenderName = 'SQL-' + Replace(@ServerName,'\','_')

-- Create the SMTP message object.
EXEC @iHr = sp_OACreate 'CDO.Message', @iMessageObjId OUT
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error creating object CDO.Message.'
   Goto ErrMssg 
  End

-- Set SMTP message object parameters.
-- To
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'To', @To
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message parameter "To".'
   Goto ErrMssg 
  End

-- Subject
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'Subject', @Subject
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message parameter "Subject".'
   Goto ErrMssg 
  End

-- From
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'From', @From
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message parameter "From".'
   Goto ErrMssg   End

-- CC
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'CC', @CC
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message parameter "CC".'
   Goto ErrMssg 
  End

-- BCC
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'BCC', @BCC
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message parameter "BCC".'
   Goto ErrMssg 
  End

-- DSNOptions
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'DSNOptions', @DSNOptions
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message parameter "DSNOptions".'
   Goto ErrMssg 
  End

-- Sender
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'Sender', @SenderName
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message parameter "Sender".'
   Goto ErrMssg 
  End


-- Is there a query to run?
If @Query is not null and @Query <> ''
  Begin
   -- We have a query result to include; temporarily send the output to the 
   -- drive with the most free space. Use xp_fixeddrives to determine this.
   -- If a temp table exists with the following name drop it.
   If (Select object_id('tempdb.dbo.#fixeddrives')) > 0
     Exec ('Drop table #fixeddrives')
   
   -- Create a temp table to work with xp_fixeddrives.
   Create table #fixeddrives(
       Drive char(1) null,
       FreeSpace varchar(15) null)

   -- Get the fixeddrive info.
   Insert into #fixeddrives Exec master.dbo.xp_fixeddrives

   -- Get the drive letter of the drive with the most free space
   -- Note: The OSQL output file name must be unique for each call within the same session.
   --    Apparently OSQL does not release its lock on the first file created until the session ends.
   --    Hence this alleviates a problem with queries from multiple calls in a cursor or other loop.
   Select @QueryOutPath = Drive + ':\TempQueryOut' + 
                ltrim(str(datepart(hh,getdate()))) + 
                ltrim(str(datepart(mi,getdate()))) + 
                ltrim(str(datepart(ss,getdate()))) +
                ltrim(str(datepart(ms,getdate()))) + '.txt'
    from #fixeddrives 
    where FreeSpace = (select max(FreeSpace) from #fixeddrives )
   
   -- Check for a pattern of '\\*\' or '?:\'.
   -- If found assume the query is a file path.
   If Left(@Query, 35) like '\\%\%' or Left(@Query, 5) like '_:\%'
     Begin
      Select @Cmd = 'osql /S' + @ServerName + ' /E /i' + 
              convert(varchar(1024),@Query) +
              ' /o' + @QueryOutPath + ' -n -w5000 '
     End
   Else
     Begin
      Select @Cmd = 'osql /S' + @ServerName + ' /E /Q"' + @Query +
              '" /o' + @QueryOutPath + ' -n -w5000 '
     End

   -- Execute the query
   Exec master.dbo.xp_cmdshell @Cmd, no_output

   -- Add the query results as an attachment if the file was successfully created.
   -- Check to see if the file exists. Use xp_fileexist to determine this.
   -- If a temp table exists with the following name drop it.
   If (Select object_id('tempdb.dbo.#fileexists')) > 0
     Exec ('Drop table #fileexists')
   
   -- Create a temp table to work with xp_fileexist.
   Create table #fileexists(
       FileExists tinyint null,
       FileIsDirectory tinyint null,
       ParentDirectoryExists tinyint null)

   -- Execute xp_fileexist
   Insert into #fileexists exec master.dbo.xp_fileexist @QueryOutPath

   -- Now see if we need to add the file as an attachment
   If (select FileExists from #fileexists) = 1
     Begin
      -- Set a variable for later use to delete the file.
      Select @iFileExists = 1

      -- Add the file path to the attachment variable.
      If @Attachments is null
        Select @Attachments = @QueryOutPath
      Else
        Select @Attachments = @Attachments + '; ' + @QueryOutPath
     End
  End

-- Check for multiple attachments separated by a semi-colon ';'.
If @Attachments is not null
  Begin
   If right(@Attachments,1) <> ';'
     Select @Attachments = @Attachments + '; '
   Select @iPos = CharIndex(';', @Attachments, 1)
   While @iPos > 0
     Begin 
      Select @Attachment = ltrim(rtrim(substring(@Attachments, 1, @iPos -1)))
      Select @Attachments = substring(@Attachments, @iPos + 1, Len(@Attachments)-@iPos)
      EXEC @iHr = sp_OAMethod @iMessageObjId, 'AddAttachment', @iRtn Out, @Attachment
      IF @iHr <> 0 
        Begin
/*         EXEC sp_OAGetErrorInfo @iMessageObjId, @ErrSource Out, @ErrDescription Out 
         Select @Body = @Body + char(13) + char(10) + char(13) + char(10) + 
                  char(13) + char(10) + 'Error adding attachment: ' +
                  char(13) + char(10) + @ErrSource + char(13) + char(10) + 
                  @Attachment*/
           Begin 
            Set @ErrMssg = 'Error adding attachment' 
            Goto ErrMssg 
           End
        End
      Select @iPos = CharIndex(';', @Attachments, 1)
     End
  End


--HTMLBody
if @IsHTMLFormat=1
begin
EXEC @iHr = sp_OASetProperty @iMessageObjId, 'HTMLBody', @Body
   IF @iHr <> 0 
     Begin 
      Set @ErrMssg = 'Error setting Message parameter "BodyFormat".'
      Goto ErrMssg 
     End
end
else
begin
   -- TextBody
   EXEC @iHr = sp_OASetProperty @iMessageObjId, 'TextBody', @Body 
   IF @iHr <> 0 
     Begin 
      Set @ErrMssg = 'Error setting Message parameter "TextBody".'
      Goto ErrMssg 
     End
end

-- Other Message parameters for reference
--EXEC @iHr = sp_OASetProperty @iMessageObjId, 'MimeFormatted', False
--EXEC @iHr = sp_OASetProperty @iMessageObjId, 'AutoGenerateTextBody', False
--EXEC @iHr = sp_OASetProperty @iMessageObjId, 'MDNRequested', True

-- Set SMTP Message configuration property values.
-- Network SMTP Server location
EXEC @iHr = sp_OASetProperty @iMessageObjId, 
'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', 
@SMTPServer
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message configuraton field "smtpserver".'
   Goto ErrMssg 
  End

-- Sendusing
EXEC @iHr = sp_OASetProperty @iMessageObjId, 
'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value',
@cSendUsing
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message configuraton field "sendusing".'
   Goto ErrMssg 
  End

-- SMTPConnectionTimeout
EXEC @iHr = sp_OASetProperty @iMessageObjId, 
'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/SMTPConnectionTimeout").Value',
@Timeout
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message configuraton field "SMTPConnectionTimeout".'
   Goto ErrMssg 
  End

-- SMTPServerPort
EXEC @iHr = sp_OASetProperty @iMessageObjId, 
'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/SMTPServerPort").Value',
@Port
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message configuraton field "SMTPServerPort".'
   Goto ErrMssg 
  End

-- SMTPAuthenticate
EXEC @iHr = sp_OASetProperty @iMessageObjId, 
'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/SMTPAuthenticate").Value',
@cAuthenticate
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error setting Message configuraton field "SMTPAuthenticate".'
   Goto ErrMssg 
  End

-- Other Message Configuration fields for reference
--EXEC @iHr = sp_OASetProperty @iMessageObjId, 
--'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/SMTPUseSSL").Value',True

--EXEC @iHr = sp_OASetProperty @iMessageObjId, 
--'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/LanguageCode").Value','en'

--EXEC @iHr = sp_OASetProperty @iMessageObjId, 
--'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/SendEmailAddress").Value', 'Test User'

--EXEC @iHr = sp_OASetProperty @iMessageObjId, 
--'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/SendUserName").Value',null

--EXEC @iHr = sp_OASetProperty @iMessageObjId, 
--'Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/SendPassword").Value',null

-- Update the Message object fields and configuration fields.
EXEC @iHr = sp_OAMethod @iMessageObjId, 'Configuration.Fields.Update'
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error updating Message configuration fields.'
   Goto ErrMssg 
  End

EXEC @iHr = sp_OAMethod @iMessageObjId, 'Fields.Update'
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error updating Message parameters.'
   Goto ErrMssg 
  End

-- Send the message.
EXEC @iHr = sp_OAMethod @iMessageObjId, 'Send'
IF @iHr <> 0 
  Begin 
   Set @ErrMssg = 'Error Sending e-mail.'
   Goto ErrMssg 
  End
Else 
  Print 'Mail sent.'

Cleanup:
  -- Destroy the object and return.
  EXEC @iHr = sp_OADestroy @iMessageObjId
  --EXEC @iHr = sp_OAStop

  -- Delete the query output file if one exists.
  If @iFileExists = 1
   Begin
     Select @Cmd = 'del ' + @QueryOutPath
     Exec master.dbo.xp_cmdshell @Cmd, no_output
   End
  Print '[SendEmail] ' + @ErrorMessage
  Return @RetVal

ErrMssg:
  Begin
   Print '[SendEmail] ' + @ErrMssg 
   Set @ErrorMessage = @ErrMssg
   Set @RetVal = -1
  If @iHr <> 0 
     Begin
      EXEC sp_OAGetErrorInfo @iMessageObjId, @ErrSource Out, @ErrDescription Out 
      Print @ErrSource
      Print @ErrDescription
      Set @ErrorMessage = @ErrorMessage + ' ' + @ErrSource + ' ' + @ErrDescription      
     End

   -- Determine whether to exist or go to Cleanup.
   If @ErrMssg = 'Error creating object CDO.Message.'
     Return @RetVal
   Else
     Goto Cleanup
  End
GO
/****** Object:  Table [dbo].[Organization]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Organization](
	[OrganizationID] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NULL,
	[OrganizationName] [nvarchar](250) NOT NULL,
	[Description] [ntext] NULL,
	[Timezone] [varchar](50) NULL,
	[Theme] [varchar](20) NULL,
	[Locale] [varchar](10) NULL,
	[MTQueue] [varchar](200) NULL,
	[MOQueue] [varchar](200) NULL,
	[AccountBalance] [bigint] NULL,
	[TotalMT] [bigint] NULL,
	[TotalMO] [bigint] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[SecurityPolicyXML] [ntext] NULL,
	[OrganizationProperties] [ntext] NULL,
 CONSTRAINT [PK_Organizations] PRIMARY KEY CLUSTERED 
(
	[OrganizationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MTTraffic]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTTraffic](
	[MTTrafficID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[MSISDN] [varchar](100) NOT NULL,
	[GroupID] [varchar](100) NULL,
	[Message] [varchar](500) NULL,
	[OrderID] [varchar](100) NULL,
	[Via] [varchar](300) NULL,
	[Status] [varchar](20) NULL,
	[Details] [varchar](1000) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedOn] [datetime] NULL,
	[SubscriptionID] [int] NULL,
 CONSTRAINT [PK_MTTraffic] PRIMARY KEY CLUSTERED 
(
	[MTTrafficID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Program]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Program](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ProgramName] [nvarchar](200) NOT NULL,
	[ProgramDescription] [ntext] NULL,
	[ProgramStatus] [varchar](20) NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_Programs] PRIMARY KEY CLUSTERED 
(
	[ProgramID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MT_RefreshTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_RefreshTask]
	@TaskID INT,
	@ExpireStatus VARCHAR(15),
	@CancelStatus VARCHAR(15),
	@StopStatus VARCHAR(15),
	@ErrorStatus VARCHAR(15),
	@CompleteStatus VARCHAR(15),
	@PauseStatus VARCHAR(15),
	@SubscriptionPendingStatus VARCHAR(15),
	@SubscriptionNewStatus VARCHAR(15)
AS
BEGIN
	DECLARE @ScheduleID INT
	DECLARE @Count INT

	DECLARE _cursor CURSOR
	FOR SELECT ScheduleID
	FROM Schedules
	WHERE TaskID = @TaskID
	OPEN _cursor
	FETCH NEXT FROM _cursor INTO @ScheduleID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC MT_RefreshSchedule @ScheduleID, @ExpireStatus, @CancelStatus, @StopStatus, @ErrorStatus, @CompleteStatus, @PauseStatus, @SubscriptionPendingStatus
		FETCH NEXT FROM _cursor INTO @ScheduleID
	END

	CLOSE _cursor
	DEALLOCATE _cursor

	UPDATE MTTasks SET SubscriptionCount = (SELECT COUNT(*) FROM ScheduledSubscriptions WHERE TaskID = @TaskID)
	WHERE TaskID = @TaskID
	
	SELECT @Count = COUNT(*) FROM ScheduledSubscriptions 
	WHERE TaskID = @TaskID 
	AND ScheduleID = 0
	AND ((Status = @SubscriptionPendingStatus) OR (Status = @SubscriptionNewStatus))

	RETURN @Count
END
GO
/****** Object:  StoredProcedure [dbo].[MTTask_RefreshTaskSchedules]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MTTask_RefreshTaskSchedules]
	@TaskID INT,
	@ExpireStatus VARCHAR(15),
	@PauseStatus VARCHAR(15)
AS
BEGIN
	UPDATE Schedules WITH (ROWLOCK) SET Status = @ExpireStatus
	WHERE TaskID = @TaskID
	AND Status = @PauseStatus
	AND EndTime < GETDATE()

	RETURN @@ROWCOUNT
END
GO
/****** Object:  Table [dbo].[ReportParam]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportParam](
	[ParamName] [varchar](50) NOT NULL,
	[ParamValue] [varchar](500) NULL,
 CONSTRAINT [PK_ReportParams] PRIMARY KEY CLUSTERED 
(
	[ParamName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportType]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportType](
	[ReportTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[Type] [varchar](50) NULL,
 CONSTRAINT [PK_ReportType] PRIMARY KEY CLUSTERED 
(
	[ReportTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportStatus]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportStatus](
	[ReportStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [int] NULL,
	[ComponentID] [int] NULL,
	[ProcessTime] [datetime] NULL,
	[Component] [char](10) NULL,
	[Status] [varchar](50) NULL,
	[Code] [varchar](50) NULL,
	[Details] [nvarchar](3500) NULL,
 CONSTRAINT [PK_ReportStatus] PRIMARY KEY CLUSTERED 
(
	[ReportStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportTypeEmail_backup]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTypeEmail_backup](
	[ReportTypeEmailID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NULL,
	[Recipients] [varchar](1000) NULL,
	[Subject] [varchar](1000) NULL,
	[Body] [varchar](4000) NULL,
	[Contact] [varchar](500) NULL,
	[Compression] [varchar](10) NULL,
	[Attach] [char](1) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ReportFormatDate]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportFormatDate]
	@ReportFormat INT = 120,
	@Original CHAR(1) = 'N',
	@RetVal VARCHAR(100) OUT
AS 
/*******************************************************************/
--Name		: ReportFormatDate
--Module	: Report Util
--Description 	: Format the date value to a specified format
--Input Param	: ReportFormat	- Default to 120 (yyyy-mm-dd hh:mi:ss(24h))
--		  Original	- Y: Do not omit any characters from the date format
--				  N: Space, Underscore, Colon, Dot, Slash will be omitted
--		  RetVal	- The formatted date in string
--Return Value	: N/A
/*******************************************************************/
BEGIN
	DECLARE @DateStr VARCHAR(100)
	
	--default the report format to 120 if the input report format is invalid
	IF (@ReportFormat not in (100, 1, 101, 2, 102, 3, 103, 4, 104, 5, 105, 6, 106, 7, 107, 108, 109, 10, 110, 11, 111, 12, 112, 113, 114, 120, 121, 126))
		SET @ReportFormat = 120
	SELECT @DateStr = CONVERT(VARCHAR(100), GETDATE(), @reportformat)
	
	--Omit any non numeric character
	IF (UPPER(@Original) = 'N')
	BEGIN
		SET @DateStr = REPLACE(@DateStr,' ','')
		SET @DateStr = REPLACE(@DateStr,'-','')
		SET @DateStr = REPLACE(@DateStr,':','')
		SET @DateStr = REPLACE(@DateStr,'.','')
		SET @DateStr = REPLACE(@DateStr,'/','')
	END
	PRINT '[ReportFormatDate] @DateStr=' + @DateStr
	SET @RetVal = @DateStr
END
GO
/****** Object:  Table [dbo].[Report]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Report](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeVariantID] [int] NULL,
	[ReportTypeID] [int] NULL,
	[ReportTypeName] [varchar](100) NULL,
	[Type] [varchar](50) NULL,
	[Test] [char](1) NULL,
	[TestRecipients] [varchar](100) NULL,
	[Status] [varchar](20) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatorID] [int] NULL,
 CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueueConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueueConfig](
	[QueueConfigID] [int] IDENTITY(1,1) NOT NULL,
	[Queue] [varchar](500) NOT NULL,
	[ServiceID] [varchar](10) NOT NULL,
	[Status] [varchar](15) NOT NULL,
 CONSTRAINT [PK_QueueConfigs_1] PRIMARY KEY CLUSTERED 
(
	[QueueConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueueGroup]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueueGroup](
	[QueueGroupID] [int] IDENTITY(1,1) NOT NULL,
	[QueueGroupName] [varchar](500) NOT NULL,
	[QueueGroupThroughPut] [int] NOT NULL,
	[QueueCategory] [nvarchar](50) NULL,
 CONSTRAINT [PK_QueueGroup_1] PRIMARY KEY CLUSTERED 
(
	[QueueGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueueDetails]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueueDetails](
	[QueueDetailID] [int] IDENTITY(1,1) NOT NULL,
	[QueueGroupID] [int] NOT NULL,
	[Queue] [varchar](500) NOT NULL,
	[CustomerID] [varchar](5000) NULL,
	[IsFairQueuing] [char](1) NOT NULL,
	[Status] [varchar](15) NOT NULL,
 CONSTRAINT [PK_QueueDetails_1] PRIMARY KEY CLUSTERED 
(
	[QueueDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_QueueDetails_Queue] UNIQUE NONCLUSTERED 
(
	[Queue] ASC,
	[QueueGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportEmail]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportEmail](
	[reportemailid] [int] IDENTITY(1,1) NOT NULL,
	[reportid] [int] NULL,
	[subject] [varchar](1000) NULL,
	[header] [varchar](1000) NULL,
	[body] [varchar](4000) NULL,
	[compression] [varchar](10) NULL,
 CONSTRAINT [PK_reportemail] PRIMARY KEY CLUSTERED 
(
	[reportemailid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportFile]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportFile](
	[ReportFileID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [int] NULL,
	[Name] [varchar](50) NULL,
	[FileName] [varchar](100) NOT NULL,
	[ReportDir] [varchar](255) NULL,
	[MaxLine] [int] NULL,
	[InLine] [char](1) NULL,
	[RowCnt] [int] NULL,
	[FileURL] [varchar](255) NULL,
	[Unicode] [char](1) NULL,
 CONSTRAINT [PK_ReportFile] PRIMARY KEY CLUSTERED 
(
	[ReportFileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportTypeEmail]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTypeEmail](
	[ReportTypeEmailID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NULL,
	[Recipients] [varchar](1000) NULL,
	[Subject] [varchar](1000) NULL,
	[Body] [varchar](4000) NULL,
	[Contact] [varchar](500) NULL,
	[Compression] [varchar](10) NULL,
	[Attach] [char](1) NULL,
 CONSTRAINT [PK_ReportTypeEmail] PRIMARY KEY CLUSTERED 
(
	[ReportTypeEmailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportTransfer]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTransfer](
	[ReportTransferID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [int] NULL,
	[TransferType] [varchar](20) NULL,
	[Host] [varchar](255) NULL,
	[Path] [varchar](255) NULL,
	[NetworkDomain] [varchar](255) NULL,
	[Logon] [varchar](50) NULL,
	[Pwd] [varchar](50) NULL,
 CONSTRAINT [PK_ReportTransfer] PRIMARY KEY CLUSTERED 
(
	[ReportTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ReportStatusUpdate]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ReportStatusUpdate]
	@ReportID INT,
	@Status VARCHAR(20)
AS
/*******************************************************************/
--Name		: ReportStatusUpdate
--Module	: Report
--Description 	: Update the status in Report table
--Input Param	: ReportID
--		  Status
--Return Value	:  N/A
/*******************************************************************/
BEGIN
	UPDATE	report
	SET 		status = @Status
	WHERE 	reportID = @ReportID
END
GO
/****** Object:  StoredProcedure [dbo].[MTTask_RefreshTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MTTask_RefreshTask]
	@TaskID INT,
	@ExpireStatus VARCHAR(15),
	@CancelStatus VARCHAR(15),
	@StopStatus VARCHAR(15),
	@ErrorStatus VARCHAR(15),
	@CompleteStatus VARCHAR(15),
	@PauseStatus VARCHAR(15),
	@SubscriptionPendingStatus VARCHAR(15),
	@SubscriptionNewStatus VARCHAR(15)
AS
BEGIN
	DECLARE @ScheduleID INT
	DECLARE @Count INT

	DECLARE _cursor CURSOR
	FOR SELECT ScheduleID
	FROM Schedules
	WHERE TaskID = @TaskID
	OPEN _cursor
	FETCH NEXT FROM _cursor INTO @ScheduleID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC MTTask_RefreshSchedule @ScheduleID, @ExpireStatus, @CancelStatus, @StopStatus, @ErrorStatus, @CompleteStatus, @PauseStatus, @SubscriptionPendingStatus
		FETCH NEXT FROM _cursor INTO @ScheduleID
	END

	CLOSE _cursor
	DEALLOCATE _cursor

	UPDATE MTTasks SET SubscriptionCount = (SELECT COUNT(*) FROM ScheduledSubscriptions WHERE TaskID = @TaskID)
	WHERE TaskID = @TaskID
	
	SELECT @Count = COUNT(*) FROM ScheduledSubscriptions 
	WHERE TaskID = @TaskID 
	AND ScheduleID = 0
	AND ((Status = @SubscriptionPendingStatus) OR (Status = @SubscriptionNewStatus))

	RETURN @Count
END
GO
/****** Object:  Table [dbo].[OrganizationLocale]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrganizationLocale](
	[OrganizationLocaleID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[Locale] [nvarchar](200) NOT NULL,
	[isDefault] [char](1) NOT NULL,
	[LocaleID] [nvarchar](200) NOT NULL,
	[FolderID] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_OrganizationLocale] PRIMARY KEY CLUSTERED 
(
	[OrganizationLocaleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrganizationHubAccount]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationHubAccount](
	[OrganizationHubAccountID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[HubAccountID] [int] NOT NULL,
 CONSTRAINT [PK_OrganizationHubAccount] PRIMARY KEY CLUSTERED 
(
	[OrganizationHubAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationShortCode]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationShortCode](
	[OrganizationShortCodeID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[ShortCodeID] [int] NOT NULL,
 CONSTRAINT [PK_OrganizationShortCode] PRIMARY KEY CLUSTERED 
(
	[OrganizationShortCodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SelectMTTraffic]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectMTTraffic]
	@orderid VARCHAR(100),
	@msisdn VARCHAR(100)
AS

SELECT Status 
  FROM MTTraffic (updlock)
  WHERE OrderID=@orderid 
  AND  MSISDN=@msisdn
GO
/****** Object:  StoredProcedure [dbo].[SP_StartRetentionLog]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_StartRetentionLog]
				@sProcessName	varchar(31)
			AS
			BEGIN
				INSERT INTO DataRetentionJob ([ProcessName],[StatusID])
				VALUES(@sProcessName,1)
				return @@Identity
			END
GO
/****** Object:  Table [dbo].[ReportTypeVariant]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTypeVariant](
	[ReportTypeVariantID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NULL,
	[VariantName] [varchar](50) NULL,
	[JobID] [int] NULL,
 CONSTRAINT [PK_ReportTypeVariant] PRIMARY KEY CLUSTERED 
(
	[ReportTypeVariantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportTypeTSQL]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportTypeTSQL](
	[ReportTypeTSQLID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NOT NULL,
	[TSQL] [nvarchar](2000) NULL,
 CONSTRAINT [PK_ReportTypeTSQL] PRIMARY KEY CLUSTERED 
(
	[ReportTypeTSQLID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportTypeTransfer]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTypeTransfer](
	[ReportTypeTransferID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NULL,
	[TransferType] [varchar](20) NULL,
	[Host] [varchar](255) NULL,
	[Path] [varchar](255) NULL,
	[NetworkDomain] [varchar](255) NULL,
	[Logon] [varchar](50) NULL,
	[Pwd] [varchar](50) NULL,
 CONSTRAINT [PK_ReportTypeTransfer] PRIMARY KEY CLUSTERED 
(
	[ReportTypeTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportTypeQuery]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportTypeQuery](
	[ReportTypeQueryID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NULL,
	[Stmt] [nvarchar](3000) NULL,
	[Header] [nvarchar](1000) NULL,
 CONSTRAINT [PK_ReportTypeQuery] PRIMARY KEY CLUSTERED 
(
	[ReportTypeQueryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramID] [int] NULL,
	[TaskType] [varchar](50) NOT NULL,
	[TaskName] [nvarchar](100) NOT NULL,
	[TaskXML] [ntext] NULL,
	[TimeZone] [varchar](50) NULL,
	[Status] [varchar](15) NOT NULL,
	[ErrorMessage] [ntext] NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[RetentionRunOn] [datetime] NULL,
	[RetentionStatus] [varchar](20) NOT NULL,
	[RetentionPeriod] [int] NULL,
	[IsKeepContent] [char](1) NULL,
	[IsKeepRecipient] [char](1) NULL,
	[RetentionRetryCount] [int] NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MT_GetTrafficDetails_bk]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_GetTrafficDetails_bk]
	@TaskID INT,
	@ScheduleID INT,
	@RecordLimit INT = 50
AS
BEGIN

	DECLARE @SUBID INT

	SET NOCOUNT ON

	SET @SUBID = (SELECT TOP 1 SubscriptionID FROM MTTRAFFIC WHERE TaskID = @TaskID)

	SET ROWCOUNT @RecordLimit

	IF @SUBID IS NULL
	BEGIN
		SELECT SubscriptionID, MSISDN, Message, Status, CreatedOn FROM MTTRAFFIC WHERE TaskID = @TaskID
	END
	ELSE
	BEGIN
		SELECT SubscriptionID, MAX(MSISDN) AS MSISDN, MAX(Status) as Status, MAX(CreatedOn) as CreatedOn,
		MAX( CASE seq WHEN 0 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 1 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 2 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 3 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 4 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 5 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 6 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 7 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 8 THEN Message ELSE '' END ) +
		MAX( CASE seq WHEN 9 THEN Message ELSE '' END ) AS Message, COUNT(*) AS MTCount
		FROM ( SELECT p1.SubscriptionID, p1.MSISDN, p1.Status, p1.CreatedOn, p1.Message,
		         ( SELECT COUNT(*) 
		           FROM MTTRAFFIC p2
		           WHERE p2.SubscriptionID = p1.SubscriptionID
		           AND p2.TaskID = @TaskID AND p1.MTTrafficID > p2.MTTrafficID)
		       FROM MTTRAFFIC p1 WHERE p1.TaskID = @TaskID) D (SubscriptionID, MSISDN, Status, CreatedOn, Message, seq)
		GROUP BY SubscriptionID

	END
END
GO
/****** Object:  StoredProcedure [dbo].[MT_GetTrafficDetails]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_GetTrafficDetails]
	@TaskID INT,
	@ScheduleID INT,
	@RecordLimit INT = 50
AS
BEGIN
	SET ROWCOUNT @RecordLimit

	SELECT SubscriptionID, MSISDN, Message, 
	
	CASE 
	WHEN Status = 'ERROR1' THEN 'Failed'
	WHEN Status = 'SUBMITTED' THEN 'No Ack'
	WHEN Status = 'SENT' THEN 'Operator Ack'
	WHEN Status = 'RECEIVED' THEN 'Handset Ack'
	WHEN Status = 'REJECTED' THEN 'Rejected'
	WHEN Status = 'PROCESSED' THEN 'CM Ack'
	ELSE Status
	END as Status, 

	CreatedOn 
	FROM MTTRAFFIC WITH (NOLOCK) 
	WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID
	ORDER BY MSISDN, MTTrafficID
END
GO
/****** Object:  StoredProcedure [dbo].[Email_UpdateFinalStatus]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Email_UpdateFinalStatus]
@TaskId INT,
@NotificationId VARCHAR(500),
@Recipient VARCHAR(500),
@Status VARCHAR(100),
@StatusText VARCHAR(1000),
@SMTPCode VARCHAR(200)
AS
BEGIN
		UPDATE EmailTraffic
		SET [Status] = @Status,
		UpdatedOn= GETUTCDATE(),
		Details = @StatusText,
		SMTPCode = @SMTPCode
		WHERE TaskID = @TaskId 
		AND NotificationID = @NotificationId
		AND Email = @Recipient
END
GO
/****** Object:  StoredProcedure [dbo].[InsertBlacklistTraffic]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertBlacklistTraffic]
            @TaskID INT,
            @To VARCHAR(100),
            @Via VARCHAR(300),
            @Response VARCHAR(100) null,
            @Created DATETIME,
            @BlacklistID INT
            AS
            BEGIN
            INSERT INTO BlacklistTraffic
            VALUES (@TaskID, @To, @Via, @Response, GETUTCDATE(), @BlacklistID)
            END
GO
/****** Object:  Table [dbo].[Function]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Function](
	[FunctionCode] [nvarchar](10) NOT NULL,
	[FunctionGroupCode] [nvarchar](10) NOT NULL,
	[FunctionName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](300) NULL,
	[FunctionPage] [nvarchar](100) NULL,
	[Sequence] [int] NULL,
 CONSTRAINT [PK_Function] PRIMARY KEY CLUSTERED 
(
	[FunctionCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Email_GetEmailTrafficPendingStatus]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Email_GetEmailTrafficPendingStatus]
@TaskId INT,
@CaaSNonFinalStatus VARCHAR(500),
@MaxRecords INT
AS
BEGIN

SELECT DISTINCT TOP (@MaxRecords) NotificationID 
FROM EmailTraffic
WHERE TaskID = @TaskId
AND ISNULL(NotificationID,'') != ''
AND [Status] IN (SELECT VAL FROM dbo.f_split (@CaaSNonFinalStatus,','))

END
GO
/****** Object:  StoredProcedure [dbo].[Email_GetTrafficDetails]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Email_GetTrafficDetails]
@TaskId Numeric(18,0),
@Receipient Varchar(200),
@Status Varchar(200),
@Records INT = 500
AS
BEGIN
SET NOCOUNT ON;
IF (LOWER(@Status) = 'all')
BEGIN
		IF(LEN(@Receipient) > 0)
		BEGIN
				SELECT TOP (@Records) 
				[ScheduleID],
				[Email],
				[CreatedOn],
				[Subject],
				[MESSAGE],
				[STATUS],
				[NotificationID],
				[SMTPCode],
				[Details]
				FROM EmailTraffic WITH(NOLOCK)
				WHERE TaskID = @TaskId
				AND Email LIKE '%'+ @Receipient +'%'
				ORDER BY EmailTrafficID DESC
		END
	ELSE
		BEGIN
		       SELECT TOP (@Records) 
				[ScheduleID],
				[Email],
				[CreatedOn],
				[Subject],
				[MESSAGE],
				[STATUS],
				[NotificationID],
				[SMTPCode],
				[Details]
				FROM EmailTraffic WITH(NOLOCK)
				WHERE TaskID = @TaskId
				ORDER BY EmailTrafficID DESC
		END
		
END

IF (LOWER(@Status) != 'all')
BEGIN
	IF(LEN(@Receipient) > 0)
		BEGIN
				SELECT TOP (@Records) 
				[ScheduleID],
				[Email],
				[CreatedOn],
				[Subject],
				[MESSAGE],
				[STATUS],
				[NotificationID],
				[SMTPCode],
				[Details]
				FROM EmailTraffic
				WHERE TaskID = @TaskId
				AND Email LIKE '%'+ @Receipient +'%'
				AND [Status] IN (SELECT VAL FROM dbo.f_split(@Status,','))
				ORDER BY EmailTrafficID DESC
		END
	ELSE
		BEGIN
		       SELECT TOP (@Records) 
				[ScheduleID],
				[Email],
				[CreatedOn],
				[Subject],
				[MESSAGE],
				[STATUS],
				[NotificationID],
				[SMTPCode],
				[Details]
				FROM EmailTraffic
				WHERE TaskID = @TaskId
				AND [Status] IN (SELECT VAL FROM dbo.f_split(@Status,','))
				ORDER BY EmailTrafficID DESC
		END
		
END

END
GO
/****** Object:  Table [dbo].[ListType]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ListType](
	[ListTypeID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[ListTypeName] [nvarchar](100) NOT NULL,
	[Encoding] [varchar](10) NOT NULL,
	[IsAllowDuplicate] [char](1) NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[ListContentType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ListTypes] PRIMARY KEY CLUSTERED 
(
	[ListTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MISC_GetPendingAutomator]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MISC_GetPendingAutomator]
	@PendingStatus VARCHAR(15),
	@ProcessingStatus VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @AutomatorID	AS INT
	DECLARE @CurrentStatus AS VARCHAR(15)
	SET @AutomatorID = 0 

	SELECT TOP 1 @AutomatorID = AutomatorID, @CurrentStatus = Status
	FROM Automator WITH (ROWLOCK, READPAST)
	WHERE Status = @PendingStatus
	ORDER BY AutomatorID ASC  

	IF (@@ROWCOUNT > 0) 
	BEGIN
		UPDATE Automator WITH (ROWLOCK)
		SET Status = @ProcessingStatus
		WHERE AutomatorID = @AutomatorID
		AND Status = @CurrentStatus
		IF (@@ROWCOUNT = 0)
		BEGIN
			SET @AutomatorID = 0
		END
 	END

	SELECT @AutomatorID
END
GO
/****** Object:  StoredProcedure [dbo].[MO_DeleteMOResponsesByTaskID]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[MO_DeleteMOResponsesByTaskID]
	@TaskID INT,
	@UpdatorID INT,
	@UpdatedOn DATETIME
	
AS
BEGIN
	UPDATE MOResponse
	SET RecordStatus = 'D',
	UpdatorID = @UpdatorID,
	UpdatedOn = @UpdatedOn
	WHERE TaskID = @TaskID
END
GO
/****** Object:  Table [dbo].[DataRetention]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataRetention](
	[DataRetentionID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[IsDataRetention] [varchar](20) NULL,
	[NoOfDays] [int] NULL,
	[IsMessageReplaced] [varchar](20) NULL,
	[ReplacementMessage] [varchar](500) NULL,
	[IsMSISDNReplaced] [varchar](20) NULL,
	[ReplacementMSISDN] [varchar](100) NULL,
	[RecordStatus] [char](1) NULL,
	[CustomerID] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[DataRetentionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApprovalRoute]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApprovalRoute](
	[ApprovalRouteID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[ApprovalRouteName] [nvarchar](200) NOT NULL,
	[DetailXML] [ntext] NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_ApprovalRoutes] PRIMARY KEY CLUSTERED 
(
	[ApprovalRouteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SP_EndRetentionLog]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EndRetentionLog]
			(
				@iRetention_Log_ID	int,
				@iStatus_ID int
			)
			As
			Begin
				UPDATE DataRetentionJob
				SET	EndTime = GETUTCDATE(),
					StatusID = @iStatus_ID
				WHERE DataRetentionJobID = @iRetention_Log_ID
			End
GO
/****** Object:  StoredProcedure [dbo].[SP_Alert_Rention_Job_Failure]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Alert_Rention_Job_Failure]
					(
							@JobName VARCHAR(500),
							@ErrorMsg VARCHAR(4000) = null
					)
					AS
					/*******************************************************************/
					--Name		: Alert_DataRention_Job_Failure
					--Description 	: Send out email when a job fails
					--Input Param	: N/A
					--Return Value	: 0
					/*******************************************************************/
					BEGIN
						DECLARE	@Error INT,
							@Address VARCHAR(100),
							@Subject VARCHAR(1000),
							@Recipients VARCHAR(1000),
							@Body VARCHAR(8000),
							@CRLF VARCHAR(10),
							@MailServer VARCHAR(50),
							@DBName VARCHAR(128),
							@ErrorMessage VARCHAR(4000),
							@RetVal INT,
							@ReportID INT,
							@InstanceID INT


						/*********Initialize variable************/
						SET @CRLF = CHAR(13) + CHAR(10)
						SET @Subject = '[' + db_name() + ' Database] ' + @JobName + ' DB Job stopped with failure'

						SELECT @Recipients = paramvalue 
						FROM SystemConfig 
						WHERE UPPER(paramname) = 'ADMINEMAIL'
						AND CATEGORY = 'DataRetention'
						IF (@@ROWCOUNT = 0)
						BEGIN
							SET @Recipients = 'DL_SYB-365_DB_DEVELOPMENT@exchange.sap.corp'
						END
	
						SELECT @Address = paramvalue 
						FROM SystemConfig
						WHERE UPPER(paramname) = 'SENDEREMAIL'
						AND CATEGORY = 'DataRetention'
						IF (@@ROWCOUNT = 0)
						BEGIN
							SET @Address = 'donotreply@sapmobileservices.com'
						END
	
						SELECT @MailServer = paramvalue 
						FROM SystemConfig
						WHERE UPPER(paramname) = 'SMTPSERVER'
						AND CATEGORY = 'DataRetention'

						SET @DBName = DB_NAME()

						IF @ErrorMsg IS NULL
						BEGIN
							--get the error message
							SELECT	@ErrorMsg = message
							FROM	MSDB.dbo.sysjobhistory
							WHERE	instance_id in (SELECT	MAX(instance_id)
										FROM	MSDB.dbo.sysjobhistory
										WHERE	step_name = @JobName)
						END
						--format the body
						SET @Body = 'Error encountered when executing the following job.' + @CRLF + @CRLF + 
								'Server   : ' + @@SERVERNAME + @CRLF + 
								'Job Name : ' + @JobName + @CRLF + 
								'Error Message : ' + @CRLF + @ErrorMsg
		    
						--send email
						EXEC @RetVal = SENDEMAIL @from = @Address, @to = @Recipients, @subject= @Subject, @body= @Body, @errormessage = @ErrorMessage,
									 @smtpserver = @MailServer, @sendername = @address, @servername = @DBName
						SELECT @Error = @@ERROR

						RETURN @Error

					END
GO
/****** Object:  Table [dbo].[UserAccessConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccessConfig](
	[AccessConfigID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[AccessID] [int] NOT NULL,
	[FeatureIsAccessible] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationID] ASC,
	[AccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewSmsHistory]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewSmsHistory]
AS
SELECT        dbo.MTTraffic.SubscriptionID, MAX(dbo.MTTraffic.MTTrafficID) AS TrafficID, MAX(dbo.MTTraffic.Status) AS Status, COUNT(*) AS MTs, MAX(dbo.MTTraffic.Message) AS Message, MAX(dbo.MTTraffic.CreatedOn) 
                         AS SendTime, MAX(dbo.MTTraffic.UpdatedOn) AS CompleteTime, MAX(dbo.MTTraffic.OrderID) AS OrderID, MAX(dbo.MTTraffic.GroupID) AS TPOA, MAX(dbo.MTTraffic.MSISDN) AS Expr1
FROM            dbo.MTTraffic LEFT OUTER JOIN
                         dbo.Task ON dbo.MTTraffic.TaskID = dbo.Task.TaskID
GROUP BY dbo.MTTraffic.SubscriptionID
GO
/****** Object:  Table [dbo].[ApprovalProcess]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApprovalProcess](
	[ApprovalProcessID] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalObjectID] [int] NOT NULL,
	[ApprovalStatus] [varchar](20) NULL,
	[ApprovalXML] [ntext] NULL,
	[PendingApproverID] [int] NULL,
 CONSTRAINT [PK_ApprovalProcess] PRIMARY KEY CLUSTERED 
(
	[ApprovalProcessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailTask]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailTask](
	[TaskID] [int] NOT NULL,
	[ProcessStartTime] [datetime] NULL,
	[HubURL] [varchar](200) NOT NULL,
	[HubHash] [varchar](200) NOT NULL,
	[CaaSUserID] [varchar](500) NOT NULL,
	[SenderName] [nvarchar](500) NULL,
	[SenderEmail] [nvarchar](500) NULL,
	[ReplyToEmail] [nvarchar](500) NULL,
	[EmailQueue] [varchar](500) NULL,
	[ListID] [int] NOT NULL,
	[BlacklistID] [int] NULL,
	[FilterXML] [ntext] NULL,
	[AssetXML] [ntext] NOT NULL,
	[SafeSendingPeriodXML] [ntext] NULL,
	[SubscriptionCount] [int] NULL,
	[ErrorMessage] [nvarchar](200) NULL,
	[IsNeedConfirmEmail] [char](1) NOT NULL,
	[IsNeedStartEmail] [char](1) NOT NULL,
	[IsNeedEndEmail] [char](1) NOT NULL,
	[IsConfirmEmailSent] [char](1) NULL,
	[IsStartEmailSent] [char](1) NULL,
	[IsEndEmailSent] [char](1) NULL,
	[ScheduleType] [varchar](15) NOT NULL,
	[EmailFairQueueGroup] [nvarchar](100) NULL,
	[SyncStatus] [varchar](200) NOT NULL,
	[SyncOn] [datetime] NULL,
	[InvalidAddressListID] [int] NULL,
 CONSTRAINT [PK_EmailTasks] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ListTypeParameter]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ListTypeParameter](
	[ListTypeParameterID] [int] IDENTITY(1,1) NOT NULL,
	[ListTypeID] [int] NOT NULL,
	[Sequence] [int] NULL,
	[ColumnName] [nvarchar](100) NULL,
	[DataType] [varchar](100) NULL,
	[DataFormat] [varchar](100) NULL,
 CONSTRAINT [PK_ListTypeParameters] PRIMARY KEY CLUSTERED 
(
	[ListTypeParameterID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ListTypeFilter]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListTypeFilter](
	[ListTypeFilterID] [int] IDENTITY(1,1) NOT NULL,
	[ListTypeID] [int] NOT NULL,
	[ListTypeFilterName] [nvarchar](100) NULL,
	[Filter] [ntext] NULL,
 CONSTRAINT [PK_ListFilters] PRIMARY KEY CLUSTERED 
(
	[ListTypeFilterID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[MISC_GetReports]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MISC_GetReports]
	@UserID INT,
	@ReportTypeName VARCHAR(100),
	@Variant VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	SELECT TOP 10 Report.*, ReportFile.FileName, ReportFile.ReportDir
	FROM Report LEFT JOIN ReportFile ON Report.ReportID = ReportFile.ReportID
	LEFT JOIN ReportTypeVariant ON Report.ReportTypeID = ReportTypeVariant.ReportTypeID
	WHERE CreatorID = @UserID
	AND ReportTypeName = @ReportTypeName
	AND VariantName = @Variant
	ORDER BY CreatedOn DESC
END
GO
/****** Object:  StoredProcedure [dbo].[MISC_GetLastReport]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MISC_GetLastReport]
	@UserID INT,
	@ReportTypeName VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON
	SELECT TOP 10 Report.*, ReportFile.FileName, ReportFile.ReportDir
	FROM Report LEFT JOIN ReportFile ON Report.ReportID = ReportFile.ReportID
	WHERE CreatorID = @UserID
	AND ReportTypeName = @ReportTypeName
	ORDER BY CreatedOn DESC
END
GO
/****** Object:  Table [dbo].[MTTask]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTTask](
	[TaskID] [int] NOT NULL,
	[ProcessStartTime] [datetime] NULL,
	[HubURL] [varchar](200) NOT NULL,
	[HubHash] [varchar](200) NOT NULL,
	[MTQueue] [varchar](500) NULL,
	[ListID] [int] NOT NULL,
	[BlacklistID] [int] NULL,
	[FilterXML] [ntext] NULL,
	[AssetXML] [ntext] NOT NULL,
	[SafeSendingPeriodXML] [ntext] NULL,
	[SubscriptionCount] [int] NULL,
	[ErrorMessage] [nvarchar](200) NULL,
	[IsNeedConfirmEmail] [char](1) NOT NULL,
	[IsNeedStartEmail] [char](1) NOT NULL,
	[IsNeedEndEmail] [char](1) NOT NULL,
	[IsConfirmEmailSent] [char](1) NULL,
	[IsStartEmailSent] [char](1) NULL,
	[IsEndEmailSent] [char](1) NULL,
	[ScheduleType] [varchar](15) NOT NULL,
	[MTFairQueueGroup] [nvarchar](100) NULL,
	[TPOA] [nvarchar](100) NULL,
	[TemplateId] [int] NULL,
	[SafeSendingPeriodId] [int] NULL,
 CONSTRAINT [PK_MTTasks] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOTask]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOTask](
	[TaskID] [int] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[ShortCode] [varchar](50) NOT NULL,
	[PrimaryKeyword] [nvarchar](50) NULL,
	[IsNullKeyword] [char](1) NOT NULL,
	[Encoding] [varchar](20) NOT NULL,
	[OperatorID] [varchar](20) NULL,
	[ResponseMTQueue] [varchar](200) NULL,
	[CampaignQuota] [varchar](50) NULL,
	[IsCampaignQuotaReached] [char](1) NULL,
 CONSTRAINT [PK_MOTasks] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[ApprovalRouteID] [int] NULL,
	[Role] [varchar](4) NOT NULL,
	[UserName] [nvarchar](200) NOT NULL,
	[LoginID] [varchar](25) NOT NULL,
	[Password] [varchar](255) NULL,
	[Timezone] [varchar](50) NOT NULL,
	[Email] [varchar](250) NULL,
	[MobileNumber] [varchar](100) NULL,
	[AccountBalance] [bigint] NULL,
	[LastLoginOn] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[SecurityPolicyXML] [ntext] NULL,
	[TempRetryCount] [int] NULL,
	[TotalRetryCount] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[User] ADD [AccountStatus] [varchar](10) NULL
ALTER TABLE [dbo].[User] ADD [LockedOn] [datetime] NULL
ALTER TABLE [dbo].[User] ADD [ReleaseLockOn] [datetime] NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[User] ADD [PasswordStatus] [char](1) NULL
ALTER TABLE [dbo].[User] ADD [UserProperty] [ntext] NULL
ALTER TABLE [dbo].[User] ADD [RoleID] [int] NOT NULL
ALTER TABLE [dbo].[User] ADD [ReAuth] [char](1) NULL
ALTER TABLE [dbo].[User] ADD [TokenExpiredOn] [datetime] NULL
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportTypeVariantParam]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTypeVariantParam](
	[ReportTypeVariantParamID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeVariantID] [int] NULL,
	[ReportTypeTSQLID] [int] NOT NULL,
	[ParamName] [varchar](50) NOT NULL,
	[ParamValue] [nvarchar](2000) NULL,
 CONSTRAINT [PK_ReportTypeTSQLParam] PRIMARY KEY CLUSTERED 
(
	[ReportTypeVariantParamID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportTypeFile]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTypeFile](
	[ReportTypeFileID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [int] NULL,
	[ReportTypeQueryID] [int] NULL,
	[Name] [varchar](1000) NULL,
	[FileName] [varchar](255) NULL,
	[Separator] [char](1) NULL,
	[Header] [char](1) NULL,
	[Delimiter] [char](1) NULL,
	[MaxLine] [int] NULL,
	[InLine] [char](1) NULL,
	[FileURL] [varchar](255) NULL,
	[DtFormat] [varchar](100) NULL,
	[Unicode] [char](1) NULL,
 CONSTRAINT [PK_ReportTypeFile] PRIMARY KEY CLUSTERED 
(
	[ReportTypeFileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SP_Statistics_Task_OnDemand]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Statistics_Task_OnDemand]
@iTaskId INT
AS
BEGIN
SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;
SET XACT_ABORT ON;
SET NoCount ON;

DECLARE @ErrorMessage varchar(4000)

--check retention status should not be completed
IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
   WHERE TASKID = @iTaskId 
         AND (RetentionStatus = 'Completed' 
		 OR RetentionStatus = 'Calculated'))
BEGIN

BEGIN TRY
		BEGIN TRANSACTION Statistics_OnDemand;

	Declare @iNoOfStatus INT,
	@sDataSouce Varchar(30),
	@DataCondition Varchar(100),
	@SqlQuery nvarchar(500),
	@resultCount INT
	
	--for OnDemand campaign will always contain latest statistics.
	DECLARE @StatisticsSchema TABLE(SrNo INT IDENTITY(1,1),DataGroup VARCHAR(20),DataName VARCHAR(25),DataValue INT,DataSource varchar(50),DataCondition Varchar(200));

	--default status
	INSERT INTO @StatisticsSchema
	VALUES('Invalid','BeforeStarted',0,'MOContent','[ContentType] =''BeforeStarted'''),
	('Invalid','AfterEnded',0,'MOContent','[ContentType] =''AfterEnded'''),
	('Verification','Initial',0,'MOContent','[ContentType] =''Initial'''),
	('Verification','Rejection',0,'MOContent','[ContentType] =''Rejection'''),
	('Failure','Unrecognized',0,'MOContent','[ContentType] =''Unrecognized'''),
	('Verification','Confirmation',0,'MOContent','[ContentType] =''Confirmation'''),
	('Success','Success',0,'MOContent','[ContentType] =''Success''')
		
	SET @iNoOfStatus = (SELECT COUNT(1) FROM @StatisticsSchema)

	WHILE(@iNoOfStatus > 0)
	BEGIN

	SET @resultCount = 0;

	SELECT @sDataSouce =DataSource,@DataCondition = DataCondition  
	FROM @StatisticsSchema
	WHERE SrNo = @iNoOfStatus
	
	SET @SqlQuery = 'SELECT @resultCount = COUNT(1) FROM '+ @sDataSouce + ' WITH(NOLOCK) WHERE TASKID = '+ CONVERT(VARCHAR(10),@iTaskId) +'  AND ' + @DataCondition

	EXECUTE sp_executeSQL @SqlQuery, N'@resultCount INT OUTPUT', @resultCount OUTPUT

	UPDATE  @StatisticsSchema
	SET DataValue = @resultCount
	WHERE SrNo = @iNoOfStatus

	SET @iNoOfStatus = @iNoOfStatus -1;

	END

	DELETE FROM TaskStatistics WHERE TaskId = @iTaskId	
	  
	 --insert into statistics table with comma separted values
	INSERT INTO TaskStatistics
	SELECT @iTaskId,Stuff((SELECT ',' + DATANAME
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),Stuff((SELECT ',' + CAST(DataValue AS VARCHAR(20))
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),DATAGROUP,SUM(DataValue),GETUTCDATE()
FROM @StatisticsSchema outerob 
GROUP BY DATAGROUP

COMMIT TRANSACTION Statistics_OnDemand;
			
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
			
			IF @@TRANCOUNT>0
			BEGIN
				ROLLBACK TRANSACTION Statistics_OnDemand
			END
            
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage != '')
			BEGIN
					 RAISERROR (@ErrorMessage, --contain log as well as error details.  
							   16, -- Severity.  
							   1 -- State.  
							   );  
			END

		END
	END
GO
/****** Object:  StoredProcedure [dbo].[SP_Statistics_Task_MOValidation]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Statistics_Task_MOValidation]
@iTaskId INT
AS
BEGIN
SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;
SET XACT_ABORT ON;
SET NoCount ON;

DECLARE @ErrorMessage varchar(4000)

--check retention status should not be completed
IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
   WHERE TASKID = @iTaskId 
         AND (RetentionStatus = 'Completed' 
		 OR RetentionStatus = 'Calculated'))
BEGIN

Declare @iNoOfStatus INT,
@sDataSouce Varchar(30),
@DataCondition Varchar(100),
@SqlQuery nvarchar(500),
@resultCount INT
	
BEGIN TRY
		BEGIN TRANSACTION Statistics_MOValidation;


	--for MOValidation campaign will always contain latest statistics.
	DECLARE @StatisticsSchema TABLE(SrNo INT IDENTITY(1,1),DataGroup VARCHAR(20),DataName VARCHAR(200),DataValue INT,DataSource varchar(50),DataCondition Varchar(200));

	--default status
	INSERT INTO @StatisticsSchema
	VALUES('Success','Success',0,'MOValidationContent','[status] =''Success'''),
	('Invalid','BeforeStarted',0,'MOValidationContent','[status] =''BeforeStarted'''),
	('Invalid','AfterEnded',0,'MOValidationContent','[status] =''AfterEnded''')

	--Dynamic status
	INSERT INTO @StatisticsSchema
	SELECT DISTINCT 'Failure',[STATUS],0,'MOValidationContent','[STATUS] = '''+ [STATUS] +'''' FROM MOValidationContent WITH(NOLOCK)
	WHERE TaskID = @iTaskId AND [STATUS] NOT IN (SELECT DataName FROM @StatisticsSchema)
	
	SET @iNoOfStatus = (SELECT COUNT(1) FROM @StatisticsSchema)

	WHILE(@iNoOfStatus > 0)
	BEGIN

	SET @resultCount = 0;

	SELECT @sDataSouce =DataSource,@DataCondition = DataCondition  
	FROM @StatisticsSchema
	WHERE SrNo = @iNoOfStatus
	
	SET @SqlQuery = 'SELECT @resultCount = COUNT(1) FROM '+ @sDataSouce + ' WITH(NOLOCK) WHERE TASKID = '+ CONVERT(VARCHAR(10),@iTaskId) +'  AND ' + @DataCondition

	EXECUTE sp_executeSQL @SqlQuery, N'@resultCount INT OUTPUT', @resultCount OUTPUT

	UPDATE  @StatisticsSchema
	SET DataValue = @resultCount
	WHERE SrNo = @iNoOfStatus

	SET @iNoOfStatus = @iNoOfStatus -1;

	END

	DELETE FROM TaskStatistics WHERE TaskId = @iTaskId	
	  
	 --insert into statistics table with comma separted values
	INSERT INTO TaskStatistics
	SELECT @iTaskId,Stuff((SELECT ',' + DATANAME
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),Stuff((SELECT ',' + CAST(DataValue AS VARCHAR(20))
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),DATAGROUP,SUM(DataValue),GETUTCDATE()
FROM @StatisticsSchema outerob 
GROUP BY DATAGROUP

COMMIT TRANSACTION Statistics_MOValidation;
			
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
			
			IF @@TRANCOUNT>0
			BEGIN
				ROLLBACK TRANSACTION Statistics_MOValidation
			END
            
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage != '')
			BEGIN
					 RAISERROR (@ErrorMessage, --contain log as well as error details.  
							   16, -- Severity.  
							   1 -- State.  
							   );  
			END

END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Statistics_Task_MOOptIn]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Statistics_Task_MOOptIn]
@iTaskId INT
AS
BEGIN

SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;
SET XACT_ABORT ON;
SET NoCount ON;

DECLARE @ErrorMessage varchar(4000)


--check retention status should not be completed
IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
   WHERE TASKID = @iTaskId 
         AND (RetentionStatus = 'Completed' 
		 OR RetentionStatus = 'Calculated'))
BEGIN


BEGIN TRY
		BEGIN TRANSACTION Statistics_MOOptIn;

Declare @iNoOfStatus INT,
@sDataSouce Varchar(30),
@DataCondition Varchar(100),
@SqlQuery nvarchar(500),
@resultCount INT
	
	--for MOOptIn campaign will always contain latest statistics.
	DECLARE @StatisticsSchema TABLE(SrNo INT IDENTITY(1,1),DataGroup VARCHAR(20),DataName VARCHAR(25),DataValue INT,DataSource varchar(50),DataCondition Varchar(200));

	--default status
	INSERT INTO @StatisticsSchema
	VALUES('Invalid','BeforeStarted',0,'MOContent','[ContentType] =''BeforeStarted'''),
	('Invalid','AfterEnded',0,'MOContent','[ContentType] =''AfterEnded'''),
	('Invalid','OptInAlready',0,'MOContent','[ContentType] =''MOOptedInAlready'''),
	('Invalid','OptOutAlready',0,'MOContent','[ContentType] =''MOOptedOutAlready'''),
	('Failure','OptInUnrecognized',0,'MOContent','[ContentType] =''MOOptInUnrecognized'''),
	('Success','OptIn',0,'MOContent','[ContentType] =''MOOptIn'''),
	('Success','OptOut',0,'MOContent','[ContentType] =''MOOptOut'''),
	('Verification','Initial',0,'MOContent','[ContentType] =''Initial'''),
	('Verification','Rejection',0,'MOContent','[ContentType] =''Rejection'''),
	('Failure','Unrecognized',0,'MOContent','[ContentType] =''Unrecognized'''),
	('Verification','Confirmation',0,'MOContent','[ContentType] =''Confirmation''')
		
	SET @iNoOfStatus = (SELECT COUNT(1) FROM @StatisticsSchema)

	WHILE(@iNoOfStatus > 0)
	BEGIN

	SET @resultCount = 0;

	SELECT @sDataSouce =DataSource,@DataCondition = DataCondition  
	FROM @StatisticsSchema
	WHERE SrNo = @iNoOfStatus
	
	SET @SqlQuery = 'SELECT @resultCount = COUNT(1) FROM '+ @sDataSouce + ' WITH(NOLOCK) WHERE TASKID = '+ CONVERT(VARCHAR(10),@iTaskId) +'  AND ' + @DataCondition

	EXECUTE sp_executeSQL @SqlQuery, N'@resultCount INT OUTPUT', @resultCount OUTPUT

	UPDATE  @StatisticsSchema
	SET DataValue = @resultCount
	WHERE SrNo = @iNoOfStatus

	SET @iNoOfStatus = @iNoOfStatus -1;

	END

	DELETE FROM TaskStatistics WHERE TaskId = @iTaskId	
	  
	 --insert into statistics table with comma separted values
	INSERT INTO TaskStatistics
	SELECT @iTaskId,Stuff((SELECT ',' + DATANAME
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),Stuff((SELECT ',' + CAST(DataValue AS VARCHAR(20))
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),DATAGROUP,SUM(DataValue),GETUTCDATE()
FROM @StatisticsSchema outerob 
GROUP BY DATAGROUP

COMMIT TRANSACTION Statistics_MOOptIn;
			
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
			
			IF @@TRANCOUNT>0
			BEGIN
				ROLLBACK TRANSACTION Statistics_MOOptIn
			END
            
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage != '')
			BEGIN
					 RAISERROR (@ErrorMessage, --contain log as well as error details.  
							   16, -- Severity.  
							   1 -- State.  
							   );  
			END

END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Statistics_Task_Listbased]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Statistics_Task_Listbased]
@iTaskId INT
AS
BEGIN

SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;
SET XACT_ABORT ON;
SET NoCount ON;

DECLARE @ErrorMessage varchar(4000)

--check retention status should not be completed, Calculated
IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
   WHERE TASKID = @iTaskId 
         AND (RetentionStatus = 'Completed' 
		 OR RetentionStatus = 'Calculated'))
BEGIN

BEGIN TRY
		BEGIN TRANSACTION Statistics_Listbased;

Declare @iNoOfStatus INT,
@sDataSouce Varchar(30),
@DataCondition Varchar(100),
@SqlQuery nvarchar(500),
@resultCount INT
	
	--for listbased campaign will always contain latest statistics.
	DECLARE @StatisticsSchema TABLE(SrNo INT IDENTITY(1,1),DataGroup VARCHAR(20),DataName VARCHAR(25),DataValue INT,DataSource varchar(30),DataCondition Varchar(100));

	INSERT INTO @StatisticsSchema
	VALUES('Delivered','HandsetAck',0,'MTScheduledSubscription','[status]=''D'''),
	('Rejected','Rejected',0,'MTScheduledSubscription','[status]=''R'''),
	('Blacklisted','Blacklisted',0,'MTScheduledSubscription','[status]=''B'''),
	('Pending','Scheduled',0,'MTScheduledSubscription','[status]=''P'''),
	('Pending','Submitted',0,'MTScheduledSubscription','[status]=''S'''),
	('Pending','OperatorAck',0,'MTScheduledSubscription','[status]=''O'''),
	('Error','Error',0,'MTScheduledSubscription','[status]=''E''')

	SET @iNoOfStatus = (SELECT COUNT(1) FROM @StatisticsSchema)

	WHILE(@iNoOfStatus > 0)
	BEGIN

	SET @resultCount = 0;

	SELECT @sDataSouce =DataSource,@DataCondition = DataCondition  
	FROM @StatisticsSchema
	WHERE SrNo = @iNoOfStatus
	
	SET @SqlQuery = 'SELECT @resultCount = COUNT(1) FROM '+ @sDataSouce + ' WITH(NOLOCK) WHERE TASKID = '+ CONVERT(VARCHAR(10),@iTaskId) +'  AND ' + @DataCondition

	EXECUTE sp_executeSQL @SqlQuery, N'@resultCount INT OUTPUT', @resultCount OUTPUT

	UPDATE  @StatisticsSchema
	SET DataValue = @resultCount
	WHERE SrNo = @iNoOfStatus

	SET @iNoOfStatus = @iNoOfStatus -1;

	END

	--check task is related to Rich SMS
	IF EXISTS(SELECT 1 FROM MTMMS WITH(NOLOCK) 
    WHERE TASKID = @iTaskId)
		 BEGIN

		 DECLARE @ViewCount INT,
		 @ViewDistinctCount INT

		 SELECT @ViewCount = COUNT(AccessIP) FROM MTMMSViewHistory H WITH(NOLOCK)
		 INNER JOIN MTMMS M WITH(NOLOCK) ON M.MMSID = H.MTMMSID
		 WHERE TaskID = @iTaskId

		 SELECT  @ViewDistinctCount = COUNT(DISTINCT AccessIP) FROM MTMMSViewHistory H WITH(NOLOCK)
		 INNER JOIN MTMMS M WITH(NOLOCK) ON M.MMSID = H.MTMMSID
		 WHERE TaskID = @iTaskId
			
			 INSERT INTO @StatisticsSchema
				VALUES('MMSViewCount','TotalViewCount',@ViewCount,'',''),
				('MMSViewCount','DistinctViewCount',@ViewDistinctCount,'','')

			END
		 
	DELETE FROM TaskStatistics WHERE TaskId = @iTaskId	
	  
	 --insert into statistics table with comma separted values
	INSERT INTO TaskStatistics
	SELECT @iTaskId,Stuff((SELECT ',' + DATANAME
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),Stuff((SELECT ',' + CAST(DataValue AS VARCHAR(20))
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),DATAGROUP,SUM(DataValue),GETUTCDATE()
FROM @StatisticsSchema outerob 
GROUP BY DATAGROUP

COMMIT TRANSACTION Statistics_Listbased;
			
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
			
			IF @@TRANCOUNT>0
			BEGIN
				ROLLBACK TRANSACTION Statistics_Listbased
			END
            
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage != '')
			BEGIN
					 RAISERROR (@ErrorMessage, --contain log as well as error details.  
							   16, -- Severity.  
							   1 -- State.  
							   );  
			END

END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Statistics_Task_Emailbased]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Statistics_Task_Emailbased]
@iTaskId INT
AS
BEGIN
SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;
SET XACT_ABORT ON;
SET NoCount ON;

DECLARE @ErrorMessage varchar(4000)

--check retention status should not be completed
IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
   WHERE TASKID = @iTaskId 
          AND (RetentionStatus = 'Completed' 
		 OR RetentionStatus = 'Calculated'))
BEGIN

BEGIN TRY
		BEGIN TRANSACTION Statistics_EmailBased;

Declare @iNoOfStatus INT,
@sDataSouce Varchar(30),
@DataCondition Varchar(100),
@SqlQuery nvarchar(500),
@resultCount INT
	
	--for emailbased campaign will always contain latest statistics.
	DECLARE @StatisticsSchema TABLE(SrNo INT IDENTITY(1,1),DataGroup VARCHAR(20),DataName VARCHAR(25),DataValue INT,DataSource varchar(30),DataCondition Varchar(100));

	INSERT INTO @StatisticsSchema
	VALUES('Delivered','Delivered',0,'EmailTraffic','[status]=''CH_Received'''),
	('Rejected','SoftBounce',0,'EmailTraffic','[Details]=''SOFT_BOUNCE'''),
	('Rejected','HardBounce',0,'EmailTraffic','[Details]=''HARD_BOUNCE'''),
	('Blacklisted','Blacklisted',0,'MTScheduledSubscription','[status]=''B'''),
	('Pending','Scheduled',0,'MTScheduledSubscription','[status]=''P'''),
	('Pending','Submitted',0,'EmailTraffic','[status]=''CAAS_RECEIVED'''),
	('Error','ChannelError',0,'EmailTraffic','[status]=''CH_ERROR'''),
	('Error','MsgMgrError',0,'EmailTraffic','[status]=''MM_ERROR1'''),
	('Error','CaaSError',0,'EmailTraffic','[status]=''CAAS_ERROR''')

	SET @iNoOfStatus = (SELECT COUNT(1) FROM @StatisticsSchema)

	WHILE(@iNoOfStatus > 0)
	BEGIN

	SET @resultCount = 0;

	SELECT @sDataSouce =DataSource,@DataCondition = DataCondition  
	FROM @StatisticsSchema
	WHERE SrNo = @iNoOfStatus
	
	SET @SqlQuery = 'SELECT @resultCount = COUNT(1) FROM '+ @sDataSouce + ' WITH(NOLOCK) WHERE TASKID = '+ CONVERT(VARCHAR(10),@iTaskId) +'  AND ' + @DataCondition

	EXECUTE sp_executeSQL @SqlQuery, N'@resultCount INT OUTPUT', @resultCount OUTPUT

	UPDATE  @StatisticsSchema
	SET DataValue = @resultCount
	WHERE SrNo = @iNoOfStatus

	SET @iNoOfStatus = @iNoOfStatus -1;

	END

	DELETE FROM TaskStatistics WHERE TaskId = @iTaskId	
	  
	 --insert into statistics table with comma separted values
	INSERT INTO TaskStatistics
	SELECT @iTaskId,Stuff((SELECT ',' + DATANAME
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),Stuff((SELECT ',' + CAST(DataValue AS VARCHAR(20))
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),DATAGROUP,SUM(DataValue),GETUTCDATE()
FROM @StatisticsSchema outerob 
GROUP BY DATAGROUP


COMMIT TRANSACTION Statistics_EmailBased;
			
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
			
			IF @@TRANCOUNT>0
			BEGIN
				ROLLBACK TRANSACTION Statistics_EmailBased
			END
            
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage != '')
			BEGIN
					 RAISERROR (@ErrorMessage, --contain log as well as error details.  
							   16, -- Severity.  
							   1 -- State.  
							   );  
			END
END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Statistics_Task_AdhocBroadcast]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Statistics_Task_AdhocBroadcast]
@iTaskId INT
AS
BEGIN
SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;
SET XACT_ABORT ON;
SET NoCount ON;

Declare @iNoOfStatus INT,
@sDataSouce Varchar(30),
@DataCondition Varchar(100),
@SqlQuery nvarchar(500),
@resultCount INT,
@LastUpdatedOn DATETIME


DECLARE @ErrorMessage varchar(4000)

--check retention status should not be completed
IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
   WHERE TASKID = @iTaskId 
         AND (RetentionStatus = 'Completed' 
		 OR RetentionStatus = 'Calculated'))
BEGIN

BEGIN TRY
		BEGIN TRANSACTION Statistics_AdhocBroadcast;
	
		--for QuickSMS/AdhocBroadcast campaign statistics will be maintained on the basis of last updated date.
	DECLARE @StatisticsSchema TABLE(SrNo INT IDENTITY(1,1),DataGroup VARCHAR(20),DataName VARCHAR(25),DataValue INT,DataSource varchar(50),DataCondition Varchar(200), IsReset bit);
		
		/**Always Runtime Statistics**/
		INSERT INTO @StatisticsSchema
		VALUES('Pending','Scheduled',0,'MTScheduledSubscription','[status]=''P''',1),
			('Pending','Submitted',0,'MTScheduledSubscription','[status]=''S''',1),
			('Pending','OperatorAck',0,'MTScheduledSubscription','[status]=''O''',1)


	IF NOT EXISTS (SELECT TOP 1 1 
	FROM TaskStatistics WITH(NOLOCK) 
	WHERE TaskId = @iTaskId)
	BEGIN
		/**First Check**/
		INSERT INTO @StatisticsSchema
			VALUES('Delivered','HandsetAck',0,'MTScheduledSubscription','[status]=''D''',0),
			('Rejected','Rejected',0,'MTScheduledSubscription','[status]=''R''',0),
			('Blacklisted','Blacklisted',0,'MTScheduledSubscription','[status]=''B''',0),
			('Error','Error',0,'MTScheduledSubscription','[status]=''E''',0)
	END
	ELSE
	BEGIN

		SELECT @LastUpdatedOn = MAX(UpdatedOn) 
		FROM TaskStatistics WITH(NOLOCK) 
		WHERE TaskId = @iTaskId

		/**Already Exists**/
		INSERT INTO @StatisticsSchema
			VALUES('Delivered','HandsetAck',0,'MTScheduledSubscription','[status]=''D'' AND StoppedOn > ''@LastUpdatedOn''',0),
			('Rejected','Rejected',0,'MTScheduledSubscription','[status]=''R'' AND StoppedOn > ''@LastUpdatedOn''',0),
			('Blacklisted','Blacklisted',0,'MTScheduledSubscription','[status]=''B'' AND Createdon > ''@LastUpdatedOn''',0),
			('Error','Error',0,'MTScheduledSubscription','[status]=''E'' AND StoppedOn > ''@LastUpdatedOn''',0)

		--Get the last statistics
		UPDATE @StatisticsSchema
		SET DataValue = lastStatistics.datavalue
		FROM @StatisticsSchema T
		INNER JOIN (SELECT	dataNames.val as dataname,dataValues.val as datavalue
				FROM	TaskStatistics S with (Nolock)
					CROSS APPLY dbo.f_split(S.DataName,',') dataNames
					CROSS APPLY dbo.f_split(S.DataValue, ',') dataValues
				WHERE	S.TASKID = @iTaskId AND dataNames.seq = dataValues.seq
				) AS lastStatistics ON lastStatistics.dataname = T.DataName
		AND IsReset = 0

		END
	
	SET @iNoOfStatus = (SELECT COUNT(1) FROM @StatisticsSchema)
	WHILE(@iNoOfStatus > 0)
	BEGIN

	SET @resultCount = 0;

	SELECT @sDataSouce =DataSource,
	@DataCondition = DataCondition  
	FROM @StatisticsSchema
	WHERE SrNo = @iNoOfStatus
	
	SET @SqlQuery = 'SELECT @resultCount = COUNT(1) FROM '+ @sDataSouce + ' WITH(NOLOCK) WHERE TASKID = '+ CONVERT(VARCHAR(10),@iTaskId) +'  AND ' + @DataCondition
	
	SET @SqlQuery = REPLACE(@SqlQuery,'@LastUpdatedOn',ISNULL(CONVERT(varchar, @LastUpdatedOn, 121),''))
	
	EXECUTE sp_executeSQL @SqlQuery, N'@resultCount INT OUTPUT', @resultCount OUTPUT

	UPDATE  @StatisticsSchema
	SET DataValue = ISNULL(DataValue,0) + @resultCount
	WHERE SrNo = @iNoOfStatus

	SET @iNoOfStatus = @iNoOfStatus -1;

	END

	DELETE FROM TaskStatistics WHERE TaskId = @iTaskId	
	  
	 --insert into statistics table with comma separted values
	INSERT INTO TaskStatistics
	SELECT @iTaskId,Stuff((SELECT ',' + DATANAME
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),Stuff((SELECT ',' + CAST(DataValue AS VARCHAR(20))
            FROM   @StatisticsSchema innerob 
            WHERE  innerob.DATAGROUP = outerob.DATAGROUP 
            FOR xml path ('')), 1, 1, ''),DATAGROUP,SUM(DataValue),GETUTCDATE()
FROM @StatisticsSchema outerob 
GROUP BY DATAGROUP


COMMIT TRANSACTION Statistics_AdhocBroadcast;
			
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
			
			IF @@TRANCOUNT>0
			BEGIN
				ROLLBACK TRANSACTION Statistics_AdhocBroadcast
			END
            
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage != '')
			BEGIN
					 RAISERROR (@ErrorMessage, --contain log as well as error details.  
							   16, -- Severity.  
							   1 -- State.  
							   );  
			END
	END
	

END
GO
/****** Object:  Table [dbo].[Privilege]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Privilege](
	[PrivilegeCode] [nvarchar](20) NOT NULL,
	[FunctionCode] [nvarchar](10) NOT NULL,
	[PrivilegeName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[Sequence] [int] NULL,
 CONSTRAINT [PK_Privilege] PRIMARY KEY CLUSTERED 
(
	[PrivilegeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MTAdhocTask]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTAdhocTask](
	[AdhocID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[ProcessStartTime] [datetime] NULL,
	[HubURL] [varchar](200) NOT NULL,
	[HubHash] [varchar](200) NOT NULL,
	[MTQueue] [varchar](500) NULL,
	[ListID] [int] NULL,
	[BlacklistID] [int] NULL,
	[FilterXML] [ntext] NULL,
	[AssetXML] [ntext] NOT NULL,
	[SafeSendingPeriodXML] [ntext] NULL,
	[SubscriptionCount] [int] NULL,
	[ErrorMessage] [nvarchar](200) NULL,
	[IsNeedConfirmEmail] [char](1) NULL,
	[IsNeedStartEmail] [char](1) NULL,
	[IsNeedEndEmail] [char](1) NULL,
	[IsConfirmEmailSent] [char](1) NULL,
	[IsStartEmailSent] [char](1) NULL,
	[IsEndEmailSent] [char](1) NULL,
	[ScheduleType] [varchar](15) NOT NULL,
	[CountryCode] [varchar](10) NULL,
	[MSISDN] [nvarchar](max) NULL,
	[OriginalMessage] [nvarchar](max) NULL,
	[RecordStatus] [varchar](15) NULL,
	[MTFairQueueGroup] [nvarchar](100) NULL,
	[TPOA] [nvarchar](100) NULL,
	[TemplateId] [int] NULL,
	[SafeSendingPeriodId] [int] NULL,
 CONSTRAINT [PK_MTAdhocTask] PRIMARY KEY CLUSTERED 
(
	[AdhocID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ReportStatusInsert]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportStatusInsert]
	@Component VARCHAR(20),
	@ComponentID INT,
	@Status VARCHAR(50),
	@Code VARCHAR(50),
	@Details NVARCHAR(500)
AS
/*******************************************************************/
--Name		: ReportStatusInsert
--Module	: Report
--Description 	: Insert log into ReportStatus table
--Input Param	: Component	- Module
--		  ComponentID	- Module ID
--		  Status	- Sub Module
--		  Code		- Error/Ok
--		  Details 	- Detailed message
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/
BEGIN
	DECLARE @ReportID INT
	IF (@Component = 'report')
            	SET @ReportID = @ComponentID
        ELSE IF (@Component = 'file')
            	SELECT	@ReportID = ReportID 
		FROM 	reportfile 
		WHERE	reportfileid = @ComponentID
        ELSE IF (@Component = 'email')
	       	SELECT 	@ReportID = ReportID 
		FROM 	reportemail 
		WHERE 	reportemailid = @ComponentID
        ELSE IF (@Component = 'transfer')
		SELECT 	@ReportID = ReportID 
		FROM 	reporttransfer 
		WHERE 	reporttransferid = @ComponentID
	ELSE IF (@Component = 'job')
		SET @ReportID = 0
	ELSE
        	SET @ReportID = NULL

    	INSERT INTO reportstatus (ReportID, ComponentID, Component, processtime, status, code, details)
    	VALUES (@ReportID, @ComponentID, @Component, GETUTCDATE(), @Status, @Code, @Details)

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[ReportInsert]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ReportInsert]
	@ReportTypeVariantID INT,
	@TestRecipients VARCHAR(100) = '',
	@UserID INT
AS
/*******************************************************************************/
--Name		: ReportInsert
--Module	: Report
--Description 	: Procedure that is called by the application to
--		  create a new report request
--Input Param	: ReportTypeVariantID
--		  TestRecipients	- Email address of the test recipient(s) 
--					  if the report is for testing purpose, 
--					  default to blank
--		  UserID		- User which initiate the request
--Return Value	: N/A
/*******************************************************************************/
BEGIN
	DECLARE	@Name VARCHAR(100), 
		@Type VARCHAR(50),
		@Test CHAR(1),
		@ReportID INT,
		@ReportTypeID INT

	IF (@TestRecipients = '' or @TestRecipients is null) 
		SET @Test = 'n'
	ELSE
		SET @Test = 'y'
	
	SELECT 	@ReportTypeID = reporttypevariant.reporttypeid,
		@Name = name,
		@Type = type
	FROM	reporttype, reporttypevariant
	WHERE	reporttypevariantid = @ReportTypeVariantID
	AND	reporttype.reporttypeid = reporttypevariant.reporttypeid
		
	IF (@@ROWCOUNT = 1)
	BEGIN
		INSERT INTO report
		(reporttypeid, reporttypevariantid, reporttypename, type, test, testrecipients, status, createdon, creatorid)
		VALUES
		(@ReportTypeID, @ReportTypeVariantID, @Name, @Type, @Test, @TestRecipients, 'Pending', GETUTCDATE(), @UserID)
		
		SELECT @ReportID = SCOPE_IDENTITY()
	End
	RETURN @ReportID
END
GO
/****** Object:  StoredProcedure [dbo].[ReportEmailInsert]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportEmailInsert]
	@ReportID INT, 
	@ReportTypeVariantID INT, 
	@EmailID INT, 
	@TestRecipients VARCHAR(100)
AS
/*******************************************************************/
--Name		: ReportEmailInsert
--Module	: Report
--Description 	: Send out report via email to the specified recipients
--Input Param	: ReportID
--		  ReportTypeVariantID
--		  EmailID
--		  TestRecipients
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/
BEGIN
	DECLARE	@Error INT,
		@ErrorMsg NVARCHAR(4000),
		@Subject VARCHAR(1000),
		@Recipients VARCHAR(1000),
		@Body VARCHAR(1000),
		@Contact VARCHAR(500),
		@Compression VARCHAR(10),
		@Attach CHAR(1),
		@Admin VARCHAR(100),
		@Address VARCHAR(100),
		@CRLF VARCHAR(10),
		@ParamName VARCHAR(100),
		@ParamValue VARCHAR(1000),
		@BccOption CHAR(1),
		@Header VARCHAR(1000),
		@ReportType VARCHAR(50),
		@ReportEmailID INT,
		@BccEmail VARCHAR(100),
		@Attachment VARCHAR(1024),
		@AttachmentStr VARCHAR(1024),
		@RetVal INT,
		@ErrorMessage NVARCHAR(4000),
		@MailServer VARCHAR(50),
		@DBName VARCHAR(128),
		@Count INT

	/*********Initialize variable************/
	SET @CRLF = CHAR(13) + CHAR(10)
	
        SELECT	@ReportType = type 
	FROM 	report 
	WHERE 	reportid = @ReportID;
	IF (@@ROWCOUNT = 0)
	BEGIN
		Set @ErrorMsg = 'No record found in Report table'
		EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_Init', 'error', @ErrorMsg
		RETURN -1
	END
		
	SELECT @Admin = paramvalue 
	FROM reportparam 
	WHERE UPPER(paramname) = 'ADMINEMAIL'
	IF (@@ROWCOUNT = 0)
	BEGIN
		Set @ErrorMsg = 'ADMIN email not found in ReportParam table'
		EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_Init', 'error', @ErrorMsg
		RETURN -1
	END
	
	SELECT @Address = paramvalue 
	FROM reportparam 
	WHERE UPPER(paramname) = 'SENDEREMAIL'
	IF (@@ROWCOUNT = 0)
	BEGIN
		Set @ErrorMsg = 'Sender email not found in ReportParam table'
		EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_Init', 'error', @ErrorMsg
		RETURN -1
	END
	
	SELECT @BccOption = paramvalue 
	FROM reportparam 
	WHERE UPPER(paramname) = 'BCCOPTION'
	IF (@@ROWCOUNT = 0)
	BEGIN
		Set @ErrorMsg = 'BccOption not found in ReportParam table'
		EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_Init', 'error', @ErrorMsg
		RETURN -1
	END
	
	SELECT @MailServer = paramvalue 
	FROM reportparam 
	WHERE UPPER(paramname) = 'SMTPSERVER'
	IF (@@ROWCOUNT = 0)
	BEGIN
		Set @ErrorMsg = 'SMPT Server not found in ReportParam table'
		EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_Init', 'error', @ErrorMsg
		RETURN -1
	END

	SET @DBName = DB_NAME()

	/*************Obtain the Email details*******************/
	SELECT 	@Subject = subject, 
		@Recipients = recipients, 
		@Body = body, 
		@Contact = contact, 
		@Compression = compression
        FROM reporttypeemail
        WHERE reporttypeemail.reporttypeemailid = @EmailID
	SET @Count = @@ROWCOUNT
	IF (@Count = 1)
	BEGIN
		--replace any parameter field with the pre-configured values
		DECLARE param1_cursor CURSOR
		FOR	SELECT	paramname, paramvalue 
			FROM 	reporttypevariantparam 
			WHERE 	reporttypevariantid = @reporttypevariantID
		OPEN param1_cursor
		FETCH NEXT FROM param1_cursor INTO @ParamName, @ParamValue
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Subject = REPLACE(@Subject , '{' + @ParamName + '}', @ParamValue)
			SET @Body = REPLACE(@Body , '{' + @ParamName + '}', @ParamValue);			
			FETCH NEXT FROM param1_cursor INTO @ParamName, @ParamValue
		END
		CLOSE param1_cursor
		DEALLOCATE param1_cursor
        	
		--format the body
		SET @Body = @Body + @CRLF + @CRLF +
                 			'Please do not respond to this email. If you have any questions or comments you may contact ' + @Contact + '.';

		--if it's for testing, set the recipients to the test recipients email
	        IF (@TestRecipients IS NOT NULL AND @TestRecipients <> '')
		BEGIN	
	            	SET @Recipients = @TestRecipients
			PRINT 'TestRecipients found. ' + @TestRecipients
		END
	        ELSE --else use the preconfigured recipients email
		BEGIN
			PRINT 'No TestRecipients found. ' + @TestRecipients
			--if no recipient email is found, use the admin email addr
			IF (@Recipients IS NULL)
		            	SET @Recipients = @Admin
		END
		SET @Header = 'From: ' + @Address + @CRLF + 'To: ' + @Recipients + @CRLF

		--format the email subject
		IF (@TestRecipients IS NOT NULL AND @TestRecipients <> '')
		BEGIN
			SET @Subject = '[' + UPPER(@ReportType) + ' TEST] ' + @Subject 
			SET @Header = @Header + @CRLF + 'Subject: ' + @Subject
		END
		ELSE
		BEGIN	
			SET @Subject = '[' + UPPER(@reporttype) + '] ' + @subject 
			--insert Bcc email if it's required
			IF (@bccoption = 1)
			BEGIN
				SET @BccEmail = @Admin
				SET @Header = @Header + @CRLF + 'Bcc: ' + @BccEmail + @CRLF + 'Subject: ' + @Subject
			END
			ELSE			
				SET @Header = @Header + @CRLF + 'Subject: ' + @Subject
		END

	        INSERT INTO reportemail (reportID, subject, header, body, compression)
	        VALUES (@ReportID, @Subject, @Header, @Body, @Compression)

		SELECT @ReportEmailID = SCOPE_IDENTITY()
		EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_running', 'ok', NULL

		/******Email Report******/	

		--get the attachment info
		SET @AttachmentStr = ''	
		DECLARE attachment_cursor CURSOR
		FOR 	SELECT 	reportdir + [filename] 
			FROM 	reportfile 
			WHERE 	reportid = @ReportID
		OPEN attachment_cursor
		FETCH NEXT FROM attachment_cursor INTO @Attachment
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @AttachmentStr = @AttachmentStr + ';' + @Attachment
			FETCH NEXT FROM attachment_cursor INTO @Attachment
		END
		CLOSE attachment_cursor
		DEALLOCATE attachment_cursor

		IF LEN(@attachmentstr) > 0
			SET @attachmentstr = SUBSTRING(@attachmentstr, 2, LEN(@attachmentstr))
		PRINT @AttachmentStr
		--send email
		EXEC @RetVal = SENDEMAIL @from = @Address, @to = @Recipients, @bcc = @BccEmail, @subject= @Subject, @attachments = @AttachmentStr, @body= @Body, @errormessage = @ErrorMessage OUT,
					 @smtpserver = @MailServer, @sendername = @address, @servername = @DBName
		SELECT @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			SET @ErrorMsg = 'An error occured while sending email: ' + CAST(@Error AS NVARCHAR(50))
			print @ErrorMsg
			EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_sendemail', 'error', @ErrorMsg
			RETURN -1
		END
		ELSE IF (@retval = -1)
		BEGIN
			EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_sendemail', 'error', @ErrorMessage
			RETURN -1	
		END
		ELSE
			EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_sendemail', 'ok', NULL
		
	End

	EXEC REPORTSTATUSINSERT 'email', @ReportEmailID, 'ReportEmailInsert_complete', 'ok', NULL
	RETURN 0

END
GO
/****** Object:  StoredProcedure [dbo].[ReportAlertJobFailure]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportAlertJobFailure]
AS
/*******************************************************************/
--Name		: ReportAlertJobFailure
--Module	: Report
--Description 	: Send out email when the ReportRun job fails
--Input Param	: N/A
--Return Value	: 0
/*******************************************************************/
BEGIN
	DECLARE	@Error INT,
		@ErrorMsg NVARCHAR(4000),
		@Address VARCHAR(100),
		@Subject VARCHAR(1000),
		@Recipients VARCHAR(1000),
		@Body VARCHAR(8000),
		@CRLF VARCHAR(10),
		@MailServer VARCHAR(50),
		@DBName VARCHAR(128),
		@ErrorMessage VARCHAR(4000),
		@RetVal INT,
		@ReportID INT,
		@InstanceID INT,
		@JobName VARCHAR(20)

	/*********Initialize variable************/
	SET @CRLF = CHAR(13) + CHAR(10)
	SET @JobName = 'ReportRun'
	SET @Subject = '[' + db_name() + ' Database] ' + @JobName + ' DB Job stopped with failure'
	
	/**can't use this method, not accurate, tested that any INVALID TSQL will only be cause an exception to be thrown
	thrown 2-3 minutes later which other reports could have been processed successfully **/
	--SELECT 	@ReportID = MAX(reportID) 
	--FROM 	report
	--WHERE	status <> 'Pending'

	SELECT @Recipients = paramvalue 
	FROM reportparam 
	WHERE UPPER(paramname) = 'ADMINEMAIL'
	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @ErrorMsg = 'ADMIN email not found in ReportParam table'
		EXEC REPORTSTATUSINSERT 'job', @ReportID, 'ReportAlertFailure', 'error', @ErrorMsg
		RETURN -1
	END
	
	SELECT @Address = paramvalue 
	FROM reportparam 
	WHERE UPPER(paramname) = 'SENDEREMAIL'
	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @ErrorMsg = 'Sender email not found in ReportParam table'
		EXEC REPORTSTATUSINSERT 'job', @ReportID, 'ReportAlertFailure', 'error', @ErrorMsg
		RETURN -1
	END
	
	SELECT @MailServer = paramvalue 
	FROM reportparam 
	WHERE UPPER(paramname) = 'SMTPSERVER'
	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @ErrorMsg = 'SMPT Server not found in ReportParam table'
		EXEC REPORTSTATUSINSERT 'job', @ReportID, 'ReportAlertFailure', 'error', @ErrorMsg
		RETURN -1
	END

	SET @DBName = DB_NAME()

	--get the error message
	SELECT	@ErrorMsg = message
	FROM	MSDB.dbo.sysjobhistory
	WHERE	instance_id in (SELECT	MAX(instance_id)
				FROM	MSDB.dbo.sysjobhistory
				WHERE	step_name = @JobName)
	--format the body
	SET @Body = 'Error encountered when executing the following job. The job is currently stopped. Please contact DBA to restart the job.' + @CRLF + @CRLF + 
		    'Server   : ' + @@SERVERNAME + @CRLF + 
		    'Job Name : ' + @JobName + @CRLF + 
		    'Error Message : ' + @CRLF + @ErrorMsg
		    
	--send email
	EXEC @RetVal = SENDEMAIL @from = @Address, @to = @Recipients, @subject= @Subject, @body= @Body, @errormessage = @ErrorMessage,
				 @smtpserver = @MailServer, @sendername = @address, @servername = @DBName
	SELECT @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		SET @ErrorMsg = 'An error occured while sending email: ' + CAST(@Error AS NVARCHAR(50))
		EXEC REPORTSTATUSINSERT 'job', @ReportID, 'ReportAlertFailure', 'error', @ErrorMsg
		RETURN -1
	END
	ELSE IF (@RetVal = -1)
	BEGIN
		EXEC REPORTSTATUSINSERT 'job', @ReportID, 'ReportAlertFailure', 'error', @ErrorMessage
		RETURN -1	
	END
	ELSE
	BEGIN
		SET @ErrorMsg = 'Email alert has been successfully sent to ' + @Recipients
		EXEC REPORTSTATUSINSERT 'job', @ReportID, 'ReportAlertFailure', 'ok', @ErrorMsg		
	END

	RETURN 0

END
GO
/****** Object:  StoredProcedure [dbo].[RemoveInvalidEmails]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:Xoriant        
-- Create date: 06 Apr 20138      
-- Description: To remove given list of email ids from user table  
-- [RemoveInvalidEmails]      
-- =============================================      
CREATE PROCEDURE [dbo].[RemoveInvalidEmails]       
        
AS      
BEGIN      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
 SET ARITHABORT ON     
 SET NOCOUNT ON   
 DECLARE @InvalidEmailData AS TABLE       
 (      
  SR_NO    INT IDENTITY(1,1) PRIMARY KEY,      
  EmailAddress   VARCHAR(100)       
 )      
 DECLARE @NoOfOcuurencesInUserTable AS TABLE       
 (      
  SR_NO    INT IDENTITY(1,1) PRIMARY KEY,      
  UserID   INT      
 )   

 DECLARE @NoOfOcuurencesInReportTypeEmailTable AS TABLE       
 (      
  SR_NO    INT IDENTITY(1,1) PRIMARY KEY,      
  ReportTypeEmailID   INT      
 )     
 

INSERT @InvalidEmailData VALUES 
('trung.thanh.nguyen@citi.com'),
('getsie.sugirtha@iuo.citi.com'),
('anh.ha.kim.tran@citi.com'),
('phoebe.xf.li@citi.com'),
('vicki.zy.gu@citi.com'), 
('ze.jiang.soh@citi.com'), 
('pp68477@imcap.ap.ssmb.com'), 
('sc69640@imcau.au.ssmb.com'), 
('said.thabit.almarjeby@citi.com'),
('ines.alcantara@sap.com'), 
('Ruide.Tan@sc.com'), 
('abby.bd.yu@citi.com'), 
('rc68752@imcap.ap.ssmb.com'), 
('Anandanatarajan.S@citi.com'), 
('joanny.jf.lin@citi.com'), 
('candelaria.diaz@iuo.citi.com'), 
('melissa.orendain@citi.com'), 
('jackie.esteban.agbon@citi.com'), 
('mary.rose.carlos.ramos@citi.com'), 
('emmnauel.rendon.cabugwas@iuo.citi.com'), 
('up68397@imcau.au.ssmb.com'), 
('jackie.esteban.agbon@citi.com'), 
('rp45826@imcap.ap.ssmb.com'), 
('ian.marasigan@citi.com'), 
('sherwin.martinez@citi.com'), 
('au.crop.analytics@imcau.au.ssmb.com'), 
('yuanxia.qu@citi.com'), 
('deepika.c@iuo.citi.com'), 
('telukala.rohithkumarsahu@iuo.citi.com'), 
('muhammad2.imran@citi.com'), 
('bindu.joy@citi.com'), 
('leonardo.hernandez@noexternalmail.hsbc.com>'), 
('Shakunta.Gurav@citi.com'), 
('ngoc.xuan.xuan.le@citi.com'), 
('manoj.kumar.sathiyaseelan@citi.com'), 
('c.bhaskar@iuo.citi.com'), 
('vinoth.kumar1.s@iuo.citi.com'), 
('sahal.a.abdullahi@noexternalmail.hsbc.com>'), 
('jonathan1.chan@citi.com')

DECLARE @i INT      
DECLARE @numRows INT  
DECLARE @paramEmail VARCHAR(50)
DECLARE @j INT 
DECLARE @numInnerRows INT
DECLARE @paramUserId VARCHAR(50)
DECLARE @String VARCHAR(50)

SET  @i = 1
SET @numrows = (SELECT COUNT(*) FROM @InvalidEmailData)

IF @numRows > 0
BEGIN
    WHILE (@i <= (SELECT MAX(SR_NO) FROM @InvalidEmailData ))
		BEGIN
	   
        SET @paramEmail= (SELECT EmailAddress FROM @InvalidEmailData WHERE SR_NO = @i)
		INSERT @NoOfOcuurencesInUserTable SELECT UserID FROM [User] WITH(NOLOCK)  WHERE email like '%' + @paramEmail +'%'

		INSERT @NoOfOcuurencesInReportTypeEmailTable SELECT ReportTypeEmailID FROM ReportTypeEmail WITH(NOLOCK)  WHERE Recipients like '%' + @paramEmail +'%'	 
		
		SET @numInnerRows = (SELECT COUNT(*) FROM @NoOfOcuurencesInUserTable)
		IF @numInnerRows > 0
		BEGIN
			SET  @j = 1
			WHILE (@j <= (SELECT MAX(SR_NO) FROM @NoOfOcuurencesInUserTable ))
				BEGIN

					SET @paramUserId= (SELECT UserID FROM @NoOfOcuurencesInUserTable WHERE SR_NO = @j)
					UPDATE [User] SET email = REPLACE(email, @paramEmail, '') WHERE [User].UserID=@paramUserId			
					UPDATE [User] SET email = REPLACE(email, ',,', ',') WHERE [User].UserID=@paramUserId				
					SET @String = (Select email from [User] WHERE [User].UserID=@paramUserId )
					IF (RIGHT(@String, 1) = ',') BEGIN set @String = LEFT(@String, LEN(@String) - 1) END  
					IF (LEFT(@String, 1) = ',')	 BEGIN set @String = RIGHT(@String, LEN(@String) - 1) END   
					UPDATE [User] SET email = @String WHERE [User].UserID=@paramUserId													
					
						
				SET @j = @j + 1
			END

			DELETE FROM @NoOfOcuurencesInUserTable
		END	
			
		SET @numInnerRows =0
		SET @numInnerRows = (SELECT COUNT(*) FROM @NoOfOcuurencesInReportTypeEmailTable)
		IF @numInnerRows > 0
		BEGIN
			SET  @j = 1
			WHILE (@j <= (SELECT MAX(SR_NO) FROM @NoOfOcuurencesInReportTypeEmailTable ))
				BEGIN

					SET @paramUserId= (SELECT ReportTypeEmailID FROM @NoOfOcuurencesInReportTypeEmailTable WHERE SR_NO = @j)
					UPDATE ReportTypeEmail SET Recipients = REPLACE(Recipients, @paramEmail, '') WHERE ReportTypeEmailID=@paramUserId			
					UPDATE ReportTypeEmail SET Recipients = REPLACE(Recipients, ',,', ',') WHERE ReportTypeEmailID=@paramUserId		
							
					SET @String = (Select Recipients from ReportTypeEmail  WITH(NOLOCK) WHERE ReportTypeEmailID =@paramUserId )
					IF (RIGHT(@String, 1) = ',') BEGIN set @String = LEFT(@String, LEN(@String) - 1) END  
					IF (LEFT(@String, 1) = ',')	 BEGIN set @String = RIGHT(@String, LEN(@String) - 1) END   
					UPDATE ReportTypeEmail SET Recipients = @String WHERE ReportTypeEmailID=@paramUserId													
							
						
				SET @j = @j + 1
			END

			DELETE FROM @NoOfOcuurencesInReportTypeEmailTable
		END		
		
					
		SET @i = @i + 1
	END
END		
		
END
GO
/****** Object:  Table [dbo].[PurchaseHistory]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurchaseHistory](
	[PurchaseID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Mode] [char](1) NOT NULL,
	[HubAccountID] [int] NOT NULL,
	[SMSCount] [bigint] NOT NULL,
	[CurrentBalance] [bigint] NOT NULL,
	[Remark] [nvarchar](max) NULL,
	[MTAdhocID] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_PurchaseHistory] PRIMARY KEY CLUSTERED 
(
	[PurchaseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ReportRunCmdShell]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ReportRunCmdShell]
	@Component VARCHAR(100),
	@ID INT,
	@Cmd NVARCHAR(4000)
AS 
/*******************************************************************/
--Name		: ReportRunCmdShell
--Module	: Report Util
--Description 	: Execute any given command using master.dbo.xp_cmdshell
--		  and capture error thrown, if any
--Input Param	: Component	- Component that calls this procedure (e.g. file, transfer, etc)		
--		  ID		- Component ID
--		  Cmd		- Command to be executed
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/

BEGIN
	DECLARE @Count INT,
		@RetVal INT,
		@CmdShellLog NVARCHAR(4000),
		@Error INT

	/*******Initialize variables*****/
	SET @retval = 0
	PRINT '[ReportRunCmdShell] @cmd = ' + @cmd
	CREATE TABLE #TempLogFile (cmdshelllog VARCHAR(1000))

	/*******Execute command**********/
	INSERT #TempLogFile EXEC @Error = master.dbo.xp_cmdshell @Cmd
	SELECT 	@Count = COUNT(*) 
	FROM 	#TempLogFile
	WHERE 	UPPER(cmdshelllog) LIKE '%ERROR%'

	/*******Log errors, if any*******/
	IF (@Error <> 0 OR @Count > 0)
	BEGIN
		EXEC REPORTSTATUSINSERT @Component, @id, 'shellcmd', 'error', @cmd
		DECLARE error_cursor CURSOR
		FOR 	SELECT	cmdshelllog 
			FROM 	#TempLogFile 
			WHERE 	cmdshelllog IS NOT NULL
		OPEN error_cursor
		FETCH NEXT FROM error_cursor INTO @CmdShellLog
		WHILE @@FETCH_STATUS = 0
		BEGIN	
			EXEC reportstatusinsert @Component, @id, 'shellcmd', 'error', @CmdShellLog
			FETCH NEXT FROM error_cursor INTO  @CmdShellLog
		END
		CLOSE error_cursor
		DEALLOCATE error_cursor
		SET @retval = -1
	END
	PRINT '[ReportRunCmdShell] @RetVal=' + CAST(@RetVal AS VARCHAR(10))
	RETURN @RetVal
END
GO
/****** Object:  StoredProcedure [dbo].[ReportTSQLProcess]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportTSQLProcess]
	@ReportID INT
AS
/*******************************************************************/
--Name		: ReportTSQLProcess
--Module	: Report
--Description 	: Process any TSQL(s) configured in ReportTypeTSQL table
--		  for a given Report
--Input Param	: ReportID
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/
BEGIN
	DECLARE @ReportTypeID INT,
		@TSQL NVARCHAR(4000),
		@ReportTypeTSQLID INT,
		@ParamName VARCHAR(50),
		@ParamValue NVARCHAR(2000),
		@Error INT,
		@ErrorMsg NVARCHAR(4000),
		@ReportTypeVariantID INT

	SELECT 	@ReportTypeVariantID = reporttypevariantid,
		@ReportTypeID = reporttypeid
	FROM	report
	WHERE	reportid = @ReportID
		
	IF (@@ROWCOUNT = 1)
	BEGIN
		/**********Loop through the TSQL configured*************/
		DECLARE tsql_cursor CURSOR
		FOR SELECT reporttypetsqlid, tsql FROM reporttypetsql WHERE reporttypeid = @ReportTypeID ORDER BY reporttypetsqlid
		OPEN tsql_cursor
		FETCH NEXT FROM tsql_cursor INTO @ReportTypeTSQLID, @TSQL
		WHILE @@FETCH_STATUS = 0
		BEGIN			
			EXEC REPORTSTATUSINSERT 'report', @ReportID, 'ReportTSQLProcess_running', 'ok', @TSQL
			
			/**********replace any param name with param value********/
			DECLARE tvariantparam_cursor CURSOR
			FOR 	SELECT 	paramname, paramvalue
				FROM 	reporttypevariantparam 
				WHERE 	reporttypevariantid = @ReportTypeVariantID 
				AND 	reporttypetsqlid = @ReportTypeTSQLID
			OPEN tvariantparam_cursor
			FETCH NEXT FROM tvariantparam_cursor INTO @ParamName, @ParamValue
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @TSQL = REPLACE(@TSQL , '{' + @ParamName + '}', @ParamValue);
				FETCH NEXT FROM tvariantparam_cursor INTO @ParamName, @ParamValue
			END
			CLOSE tvariantparam_cursor
			DEALLOCATE tvariantparam_cursor
			
			/****************execute the TSQL**************************/
			PRINT '[ReportTSQLProcess] @TSQL = ' + @TSQL
			IF (@TSQL IS NOT NULL)
				EXEC @Error = sp_executesql @TSQL --EXEC (@TSQL)
			SELECT @Error = coalesce(nullif(@Error, 0), @@error)
			--SELECT @Error = @@Error
			IF @Error <> 0
			BEGIN
				SET @ErrorMsg = 'An error occurred while executing the plsql block: ' + CONVERT(NVARCHAR(31),@Error) + ' ' + @TSQL
				EXEC REPORTSTATUSINSERT 'report', @ReportID, 'ReportTSQLProcess_complete', 'error', @ErrorMsg
				CLOSE tsql_cursor
				DEALLOCATE tsql_cursor
				RETURN -1
			END

			EXEC REPORTSTATUSINSERT 'report', @ReportID, 'ReportTSQLProcess_complete', 'ok', NULL
			FETCH NEXT FROM tsql_cursor INTO  @ReportTypeTSQLID, @TSQL
		END
		CLOSE tsql_cursor
		DEALLOCATE tsql_cursor
	END
	RETURN 0
END
GO
/****** Object:  Table [dbo].[MTRepeatableScheduleConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTRepeatableScheduleConfig](
	[MTRepeatScheduleConfigID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[RepeatType] [varchar](15) NOT NULL,
	[DetailXML] [ntext] NOT NULL,
	[DataCollectionAdvancePeriod] [int] NOT NULL,
	[SendingTime] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_MTRepeatScheduleConfig] PRIMARY KEY CLUSTERED 
(
	[MTRepeatScheduleConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrganizationPrivilege]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrganizationPrivilege](
	[OrganizationPrivilegeID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[PrivilegeCode] [nvarchar](20) NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_OrganizationPrivilege] PRIMARY KEY CLUSTERED 
(
	[OrganizationPrivilegeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_OrganizationPrivilege_Privilege] UNIQUE NONCLUSTERED 
(
	[OrganizationID] ASC,
	[PrivilegeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PasswordHistory]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PasswordHistory](
	[PasswordHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[NewPassword] [varchar](255) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatorID] [int] NULL,
 CONSTRAINT [PK_PasswordHistories] PRIMARY KEY CLUSTERED 
(
	[PasswordHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SP_Retention_Task_OnDemand]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Retention_Task_OnDemand]
	   @iTask_Id INT,
	   @sOutputLog VARCHAR(2000) OUTPUT
AS     
BEGIN

SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;

SET XACT_ABORT ON;
SET NoCount ON;

SET @sOutputLog =  '@iTask_Id:' + CAST(@iTask_Id AS VARCHAR(10))

DECLARE @iError  int,
       @iRowCount  int,
       @sTempDesc  varchar(4000),
	   @ErrorMessage varchar(4000),
       @sTaskID varchar(100),
       @iTopNRow int,
       @sDetail_Name varchar(31),
	   @rowsRemaining INT,
	   @sTasktype VARCHAR(50),
	   @iRetentionLogID INT = 0,
	   @iOrganizationId INT = 0,
	   @rowsUpdated INT = 0,
	   @iBatchSize INT

	     
	   /*** Set Local Variables ***/
		   Set @sDetail_Name   = OBJECT_NAME(@@PROCID)
		   Set @iError                = 0
		   Set @iRowcount             = 0
		   
		   SELECT @iBatchSize = [ParamValue] 
		   FROM [SystemConfig] WITH(NOLOCK)
		   WHERE [ParamName] = 'BatchSize'
		   AND CATEGORY = 'DataRetention'
           
		   IF(ISNULL(@iBatchSize,0) < 0)
			 BEGIN
				SET @iBatchSize = 100000; --Default batch size
			 END
	
	BEGIN TRY
			
			/*** MAINTAIN STATICSTICS  ***/

		   IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
           WHERE TASKID = @iTask_Id 
           AND RetentionStatus = 'Calculated')
			BEGIN

				EXEC SP_Statistics_Task_OnDemand @iTask_Id;
				
				        UPDATE Task
						SET RetentionRunOn = GETUTCDATE(),
						RetentionStatus = 'Calculated'
						WHERE TaskID = @iTask_Id
						
			    SET @sOutputLog = @sOutputLog +',Statistics calculated';

			END
					
			
		/*** PURGE DATA FROM MOVerificationMOEntry ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
					DELETE TOP (@rowsRemaining)
					FROM MOVerificationMOEntry
					WHERE TaskID = @iTask_Id
				
				/*** Handle log ***/
					SELECT @rowsRemaining= @@RowCount
					SET @sOutputLog = @sOutputLog + ',MOVerificationMOEntry:DeletedRows=' + convert(varchar(31),@rowsRemaining) 
			 		IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
													
			END
			
		/*** PURGE DATA FROM MOContent ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MOContent
				WHERE TaskID = @iTask_Id
 
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
				
			     SET @sOutputLog = @sOutputLog + ',MOContent:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
			END

		/*** PURGE DATA FROM MTTraffic ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MTTraffic
				WHERE SubscriptionID =@iTask_Id 
				AND TaskID = 0

				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount
			    SET @sOutputLog = @sOutputLog + ',MTTraffic:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
					  
			END

		/*** UPDATE RETENTION STATUS ***/
			UPDATE Task
			SET RetentionRunOn = GETUTCDATE(),
			RetentionStatus = 'Completed'
			WHERE TaskID = @iTask_Id

			/*** Handle log ***/
			SELECT  @rowsUpdated= @@RowCount
			BEGIN
				SET @sOutputLog = @sOutputLog + ',RetentionStatus completed:' + convert(varchar(31),@rowsUpdated) 
			END
	
			
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
		
			SET @sOutputLog =  @sOutputLog + ' @ErrorMessage=' + @ErrorMessage
			
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage !='')
		BEGIN
				 RAISERROR (@sOutputLog, -- Message text.  
						   16, -- Severity.  
						   1 -- State.  
						   );  
		END
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Retention_Task_MOValidation]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Retention_Task_MOValidation]
	   @iTask_Id INT,
	   @sOutputLog VARCHAR(2000) OUTPUT
	   
AS     
BEGIN
SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;

SET XACT_ABORT ON;
SET NoCount ON;

SET @sOutputLog =  '@iTask_Id:' + CAST(@iTask_Id AS VARCHAR(10))

DECLARE @iError  int,
       @iRowCount  int,
       @sTempDesc  varchar(4000),
	   @ErrorMessage varchar(4000),
       @sTaskID varchar(100),
       @iTopNRow int,
       @sDetail_Name varchar(31),
	   @rowsRemaining INT,
	   @sTasktype VARCHAR(50),
	   @iRetentionLogID INT = 0,
	   @iOrganizationId INT = 0,
	   @rowsUpdated INT = 0,
	   @iBatchSize INT

	   /*** Set Local Variables ***/
		   Set @sDetail_Name   = OBJECT_NAME(@@PROCID)
		   Set @iError                = 0
		   Set @iRowcount             = 0
		   
		   SELECT @iBatchSize = [ParamValue] 
		   FROM [SystemConfig] WITH(NOLOCK)
		   WHERE [ParamName] = 'BatchSize'
		   AND CATEGORY = 'DataRetention'
           
		   IF(ISNULL(@iBatchSize,0) < 0)
			 BEGIN
				SET @iBatchSize = 100000; --Default batch size
			 END
	
	DECLARE @AuditLogVar TABLE (DetailDescription VARCHAR(4000))
	
	BEGIN TRY
			
		/**Calculate statistics**/

			IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
           WHERE TASKID = @iTask_Id 
           AND RetentionStatus = 'Calculated')
			BEGIN

				EXEC SP_Statistics_Task_MOValidation  @iTask_Id;
				
				        UPDATE Task
						SET RetentionRunOn = GETUTCDATE(),
						RetentionStatus = 'Calculated'
						WHERE TaskID = @iTask_Id
						
				SET @sOutputLog = @sOutputLog +',Statistics calculated';
			END

				
		/*** PURGE DATA FROM MOContent ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MOContent
				WHERE TaskID = @iTask_Id
 
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
				
				SET @sOutputLog = @sOutputLog + ',MOContent:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
					
    		END
			
		/*** PURGE DATA FROM MOValidationContent ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MOValidationContent
				WHERE TaskID = @iTask_Id
 
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
				
				SET @sOutputLog = @sOutputLog + ',MOValidationContent:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
					
    		END

		/*** PURGE DATA FROM MTTraffic ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN

				--VERIFY WHERE CLAUSE
				DELETE TOP (@rowsRemaining)
				FROM MTTraffic
				WHERE SubscriptionID = @iTask_Id 
				AND TaskID = 0
				

				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount
			    
				SET @sOutputLog = @sOutputLog + ',MTTraffic:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
					    
			END

		/*** PURGE DATA FROM MOSubscription ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MOSubscription
				WHERE TaskID = @iTask_Id

				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount
				SET @sOutputLog = @sOutputLog + ',MOSubscription:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
					    
			END
			
		/*** UPDATE RETENTION STATUS ***/
			UPDATE Task
			SET RetentionRunOn = GETUTCDATE(),
			RetentionStatus = 'Completed'
			WHERE TaskID = @iTask_Id

			/*** Handle log ***/
			SELECT  @rowsUpdated= @@RowCount
				BEGIN
						 SET @sOutputLog = @sOutputLog + ',RetentionStatus completed:' + convert(varchar(31),@rowsUpdated) 
			    END
		
					
		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE();
			
 
		SET @sOutputLog =  @sOutputLog + ' @ErrorMessage=' + @ErrorMessage
			
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage !='')
		BEGIN
				 RAISERROR (@sOutputLog, -- Message text.  
						   16, -- Severity.  
						   1 -- State.  
						   );  
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Retention_Task_MOOptIn]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Retention_Task_MOOptIn]
	   @iTask_Id INT,
	   @sOutputLog VARCHAR(2000) OUTPUT
	   
AS     
BEGIN

SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;

SET XACT_ABORT ON;
SET NoCount ON;

SET @sOutputLog =  '@iTask_Id:' + CAST(@iTask_Id AS VARCHAR(10))

DECLARE @iError  int,
       @iRowCount  int,
       @sTempDesc  varchar(4000),
	   @ErrorMessage varchar(4000),
       @sTaskID varchar(100),
       @iTopNRow int,
       @sDetail_Name varchar(31),
	   @rowsRemaining INT,
	   @sTasktype VARCHAR(50),
	   @iRetentionLogID INT = 0,
	   @iOrganizationId INT = 0,
	   @rowsUpdated INT = 0,
	   @iBatchSize INT

	  
	   /*** Set Local Variables ***/
		   Set @sDetail_Name   = OBJECT_NAME(@@PROCID)
		   Set @iError                = 0
		   Set @iRowcount             = 0
		   
		   SELECT @iBatchSize = [ParamValue] 
		   FROM [SystemConfig] WITH(NOLOCK)
		   WHERE [ParamName] = 'BatchSize'
		   AND CATEGORY = 'DataRetention'
           
		   IF(ISNULL(@iBatchSize,0) < 0)
			 BEGIN
				SET @iBatchSize = 100000; --Default batch size
			 END
	
	BEGIN TRY
			
			/*** MAINTAIN STATICSTICS  ***/

		   IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
           WHERE TASKID = @iTask_Id 
           AND RetentionStatus = 'Calculated')
			BEGIN
					EXEC SP_Statistics_Task_MOOptIn @iTask_Id

						UPDATE Task
						SET RetentionRunOn = GETUTCDATE(),
						RetentionStatus = 'Calculated'
						WHERE TaskID = @iTask_Id

					SET @sOutputLog = @sOutputLog +',Statistics calculated';
			END
					  
			
		/*** PURGE DATA FROM MOVerificationMOEntry ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
					DELETE TOP (@rowsRemaining)
					FROM MOVerificationMOEntry
					WHERE TaskID = @iTask_Id
				
				/*** Handle log ***/
				 SELECT @rowsRemaining= @@RowCount
				 SET @sOutputLog = @sOutputLog + ',MOVerificationMOEntry:DeletedRows=' + convert(varchar(31),@rowsRemaining) 
			 				 
				 IF(@rowsRemaining < @iBatchSize)
				 	BEGIN
				 		SET @rowsRemaining = 0;
				 	END
			END
			
		/*** PURGE DATA FROM MOContent ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MOContent
				WHERE TaskID = @iTask_Id
 
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
				 SET @sOutputLog = @sOutputLog + ',MOContent:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
		
    		END

		/*** PURGE DATA FROM MTTraffic ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MTTraffic
				WHERE SubscriptionID = @iTask_Id 
				      AND TaskID = 0
				

				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount
				 SET @sOutputLog = @sOutputLog + ',MTTraffic:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
			END

			UPDATE Task
			SET RetentionRunOn = GETUTCDATE(),
			RetentionStatus = 'Completed'
			WHERE TaskID = @iTask_Id

			/*** Handle log ***/
			SELECT @rowsUpdated= @@RowCount
			BEGIN
					SET @sOutputLog = @sOutputLog + ',RetentionStatus completed:' + convert(varchar(31),@rowsUpdated)
				END
		
		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE();
			
           	SET @sOutputLog =  @sOutputLog + ' @ErrorMessage=' + @ErrorMessage
			
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

	IF(@ErrorMessage !='')
		BEGIN
				 RAISERROR (@sOutputLog, -- Message text.  
						   16, -- Severity.  
						   1 -- State.  
						   );  
		END
END
GO
/****** Object:  Table [dbo].[ReportTypeFileParam]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportTypeFileParam](
	[ReportTypeFileParamID] [int] IDENTITY(1,1) NOT NULL,
	[ReportTypeFileID] [int] NOT NULL,
	[ParamName] [varchar](50) NOT NULL,
	[ParamValue] [nvarchar](2000) NULL,
 CONSTRAINT [PK_ReportTypeStmtParam] PRIMARY KEY CLUSTERED 
(
	[ReportTypeFileParamID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RolePrivilege]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePrivilege](
	[RolePrivilegeID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[PrivilegeCode] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_RolePrivilege] PRIMARY KEY CLUSTERED 
(
	[RolePrivilegeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_RolePrivilege_Privilege] UNIQUE NONCLUSTERED 
(
	[RoleID] ASC,
	[PrivilegeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MTSchedule]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTSchedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[ProcessedTime] [datetime] NULL,
	[TimeBlockInterval] [int] NULL,
	[TimeBlockSize] [int] NULL,
	[AllocatedCount] [int] NULL,
	[ActualAllocatedCount] [int] NULL,
	[ProcessedCount] [int] NULL,
	[ErrorMessage] [nvarchar](500) NULL,
 CONSTRAINT [PK_Schedules] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MT_GetNewTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_GetNewTask]
							@TaskNewStatus VARCHAR(15),
							@TaskProcessingStatus VARCHAR(15),
							@TaskType VARCHAR(50) = 'ListBased'
						AS
						BEGIN
							SET NOCOUNT ON

							DECLARE @ScheduleID AS INT
							DECLARE @TaskID	AS INT
							SET @TaskID = 0

							PRINT 'Retrieving New Unprocessed Task'
							PRINT '------------------------------------------------------------------------------------'
							SELECT TOP 1 @TaskID = Task.TaskID
							FROM MTTask INNER JOIN Task ON MTTask.TaskID = Task.TaskID
							WHERE Task.Status = @TaskNewStatus AND Task.RecordStatus = 'A'
							AND UPPER(TaskType) = UPPER(@TaskType)
							AND ((MTTask.ProcessStartTime IS NULL) OR (MTTask.ProcessStartTime < GETUTCDATE()))
							ORDER BY MTTask.ProcessStartTime ASC  
							IF (@@ROWCOUNT > 0) 
							BEGIN
								PRINT 'Candidate Task Found [TaskID: ' + CAST(@TaskID AS VARCHAR) + ']'

								BEGIN TRANSACTION

								UPDATE Task WITH (ROWLOCK)
								SET Status = @TaskProcessingStatus
								WHERE TaskID = @TaskID AND Status = @TaskNewStatus
								IF (@@ROWCOUNT = 0)
								BEGIN
									PRINT 'Unable to Update Task Status, Record Conflict with other Process.'
									SET @TaskID = 0
								END

								COMMIT TRANSACTION
 							END
							PRINT 'Output [TaskID: ' + CAST(@TaskID AS VARCHAR) + ']'
							PRINT '------------------------------------------------------------------------------------'
							SELECT @TaskID
						END
GO
/****** Object:  StoredProcedure [dbo].[MISC_CreateReport]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MISC_CreateReport]
	@UserID INT,
	@ReportTypeName VARCHAR(100),
	@Sql NVARCHAR(3000),
	@Header NVARCHAR(800),
	@Unicode CHAR(1),
	@Variant NVARCHAR(50),
	@TransferServer VARCHAR(20),
	@TransferPath NVARCHAR(300),
	@TransferUser VARCHAR(10),
	@TransferPassword VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ReportTypeID AS INT
	DECLARE @ReportTypeVariantID AS INT
	DECLARE @ReportTypeQueryID AS INT
	DECLARE @ReportID AS INT
	SET @ReportID = 0
	
	BEGIN TRANSACTION

	INSERT INTO ReportType (Name, Type) VALUES (@ReportTypeName, 'Report')
	SET @ReportTypeID = SCOPE_IDENTITY()

	INSERT INTO ReportTypeQuery (ReportTypeID, Stmt, Header) VALUES (@ReportTypeID, @Sql, @Header)
	SET @ReportTypeQueryID = SCOPE_IDENTITY()

	INSERT INTO ReportTypeVariant (ReportTypeID, VariantName, JobID) VALUES (@ReportTypeID, @Variant, NULL)
	SET @ReportTypeVariantID = SCOPE_IDENTITY() 

	INSERT INTO ReportTypeFile (ReportTypeID, ReportTypeQueryID, Name, FileName, Separator, Header, Delimiter, MaxLine, InLine, FileURL, DtFormat, [Unicode])
	VALUES (@ReportTypeID, @ReportTypeQueryID, @ReportTypeName, @ReportTypeName + CAST(@ReportTypeID AS VARCHAR) + '.csv', 
	',', 'Y', '"', 9999999, 'N', NULL, NULL, @Unicode)

	IF ((@TransferServer IS NOT NULL) AND (@TransferServer <> ''))
	BEGIN
		INSERT INTO ReportTypeTransfer (ReportTypeID, TransferType, Host, Path, NetworkDomain, Logon, Pwd)
		VALUES (@ReportTypeID, 'COPY', @TransferServer, @TransferPath, @TransferServer, @TransferUser, @TransferPassword)
	END
	EXECUTE @ReportID = ReportInsert @ReportTypeVariantID, NULL, @UserID

	COMMIT TRANSACTION

	RETURN @ReportID
END
GO
/****** Object:  StoredProcedure [dbo].[MO_RefreshTasksStatus]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MO_RefreshTasksStatus]
	@UserID INT,
	@NewStatus VARCHAR(15) = 'New',
	@PendingStatus VARCHAR(15) = 'Pending',
	@RunningStatus VARCHAR(15) = 'Running',
	@CompletedStatus VARCHAR(15) = 'Completed'
AS
BEGIN
	SET NOCOUNT ON

	UPDATE Task WITH(ROWLOCK) 
	SET Task.Status = @RunningStatus
	FROM Task INNER JOIN MOTask ON Task.TaskID = MOTask.TaskID
	WHERE (Task.Status = @NewStatus OR Task.Status = @PendingStatus)
	AND ((MOTask.StartTime IS NULL) OR (MOTask.StartTime <= GETUTCDATE()))
	AND ((MOTask.EndTime IS NULL) OR (MOTask.EndTime >= GETUTCDATE()))
	AND Task.CreatorID = @UserID

	UPDATE Task WITH(ROWLOCK) 
	SET Task.Status = @CompletedStatus
	FROM Task INNER JOIN MOTask ON Task.TaskID = MOTask.TaskID
	WHERE (Task.Status = @NewStatus OR Task.Status = @RunningStatus OR Task.Status = @PendingStatus)
	AND ((MOTask.EndTime IS NULL) OR (MOTask.EndTime < GETUTCDATE()))
	AND Task.CreatorID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[Email_GetPendingTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Email_GetPendingTask] 
@TaskRunningStatus varchar(20),
@TaskCompletedStatus varchar(20),
@PendingSyncStatus varchar(20),
@ProcessingSyncStatus varchar(20)
AS
BEGIN

  SET NOCOUNT ON

  DECLARE @TaskID AS int

  SET @TaskID = 0

  PRINT 'Retrieving New Unprocessed Email Task'
  PRINT '------------------------------------------------------------------------------------'

  SELECT TOP 1
    @TaskID = Task.TaskID
  FROM EmailTask
  INNER JOIN Task
    ON EmailTask.TaskID = Task.TaskID
  WHERE Task.Status IN (@TaskRunningStatus, @TaskCompletedStatus)
  AND Task.RecordStatus = 'A'
  AND EmailTask.SyncStatus = @PendingSyncStatus
  AND ((EmailTask.SyncOn IS NULL)
  OR (EmailTask.SyncOn < GETUTCDATE()))
  ORDER BY EmailTask.SyncOn ASC

  IF (@@ROWCOUNT > 0)
  BEGIN
    PRINT 'Candidate Task Found [TaskID: ' + CAST(@TaskID AS varchar) + ']'
    BEGIN TRANSACTION

      UPDATE EmailTask
      SET [SyncStatus] = @ProcessingSyncStatus
      WHERE TaskID = @TaskID
      AND SyncStatus = @PendingSyncStatus

      IF (@@ROWCOUNT = 0)
      BEGIN
        PRINT 'Unable to Update Email Task Sync Status, Record Conflict with other Process.'
        SET @TaskID = 0
      END

    COMMIT TRANSACTION
  END
  PRINT 'Output [TaskID: ' + CAST(@TaskID AS varchar) + ']'
  PRINT '------------------------------------------------------------------------------------'
  SELECT
    @TaskID
END
GO
/****** Object:  Table [dbo].[List]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[List](
	[ListID] [int] IDENTITY(1,1) NOT NULL,
	[ListTypeID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[ListName] [nvarchar](100) NOT NULL,
	[Columns] [varchar](500) NULL,
	[SubscriptionsCount] [int] NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_Subscribers] PRIMARY KEY CLUSTERED 
(
	[ListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[InsertEmailTraffic]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertEmailTraffic]
@AppSubID VARCHAR(100),
@To VARCHAR(100),
@From VARCHAR(100),
@GroupID VARCHAR(100),
@Subject VARCHAR(2000),
@Message VARCHAR(max),
@NotificationId VARCHAR(200),
@Via VARCHAR(1000),
@Status VARCHAR(100),
@Details VARCHAR(max),
@RequestDetails VARCHAR(max),
@ResponseDetails VARCHAR(max),
@Created DATETIME,
@Updated DATETIME,
@SubscriptionID VARCHAR(100) = ''
AS
BEGIN

SET NOCOUNT ON;

	DECLARE @TaskID VARCHAR(100)
	DECLARE @ScheduleID VARCHAR(100)
	DECLARE @SubID VARCHAR(100)

	SET @TaskID = SUBSTRING(@AppSubID, 0, CHARINDEX('_', @AppSubID))
	PRINT @TaskID
	SET @AppSubID = SUBSTRING(@AppSubID, CHARINDEX('_', @AppSubID) + 1, LEN(@AppSubID))
	SET @ScheduleID = SUBSTRING(@AppSubID, 0, CHARINDEX('_', @AppSubID))
	PRINT @ScheduleID
	SET @SubID = SUBSTRING(@AppSubID, CHARINDEX('_', @AppSubID) + 1, LEN(@AppSubID))
	PRINT @SubID

	IF(@SubscriptionID != '')
	BEGIN
		SET @SubID = @SubscriptionID;
	END
	
	INSERT INTO EmailTraffic
	VALUES (@TaskID, @ScheduleID,
	@To, @GroupID,@Subject,@Message, @NotificationId, @Via, @Status,NULL, @Details,GETUTCDATE(), GETUTCDATE(), @SubID)
	
	IF(@TaskID > 0) 
	AND EXISTS(SELECT 1 FROM EmailTask WITH (NOLOCK) 
	WHERE TaskID = @TaskID 
	AND SyncStatus IN ('New','Completed'))
	BEGIN
		    UPDATE EmailTask
			SET SyncStatus = 'Pending',
			SyncOn = DATEADD(minute,2,GETUTCDATE())
			WHERE TaskID = @TaskID
    END
END
GO
/****** Object:  Table [dbo].[Asset]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Asset](
	[AssetID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[AssetName] [nvarchar](100) NULL,
	[AssetType] [varchar](50) NULL,
	[ContentType] [varchar](50) NULL,
	[Category] [varchar](10) NULL,
	[AssetXML] [ntext] NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_Assets] PRIMARY KEY CLUSTERED 
(
	[AssetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApprovalAction]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApprovalAction](
	[ApprovalActionID] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalProcessID] [int] NOT NULL,
	[ApproverID] [int] NOT NULL,
	[Sequence] [int] NOT NULL,
	[ApprovalActionStatus] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ApprovalAction] PRIMARY KEY CLUSTERED 
(
	[ApprovalActionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Blacklist]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Blacklist](
	[BlacklistID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[BlacklistName] [nvarchar](200) NULL,
	[Status] [varchar](15) NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[HubAccountID] [int] NULL,
	[Type] [varchar](50) NOT NULL,
	[BlacklistCount] [int] NULL,
 CONSTRAINT [PK_Blacklists] PRIMARY KEY CLUSTERED 
(
	[BlacklistID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[COM_GetUserProgramsInfo]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_GetUserProgramsInfo]
	@UserID INT,
	@PendingApprovalStatus VARCHAR(15),
	@TaskOnHoldStatus VARCHAR(15),
	@RecordActiveStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ProgramCount INT
	DECLARE @PendingApprovalCount INT
	DECLARE @PendingActionCount INT

	SELECT @ProgramCount = COUNT(*) FROM Program
	WHERE UserID = @UserID
	AND RecordStatus = @RecordActiveStatus

	SELECT @PendingApprovalCount = COUNT(*) FROM Program WHERE ProgramID IN 
	(SELECT Task.ProgramID FROM Task 
	INNER JOIN ApprovalProcess ON Task.TaskID = ApprovalProcess.ApprovalObjectID
	WHERE ApprovalProcess.PendingApproverID IS NOT NULL
	AND ApprovalProcess.PendingApproverID = @UserID
	AND ApprovalProcess.ApprovalStatus = @PendingApprovalStatus
	AND Task.Status = @TaskOnHoldStatus
	AND Task.RecordStatus = @RecordActiveStatus)

	SELECT @PendingActionCount = COUNT(*) FROM Program 
	WHERE UserID = @UserID 
	AND ProgramID IN 
	(SELECT Task.ProgramID FROM Task 
	WHERE Task.Status = @TaskOnHoldStatus
	AND Task.RecordStatus = @RecordActiveStatus)

	SELECT @ProgramCount AS ProgramCount,
	@PendingApprovalCount AS PendingApprovalCount, 
	@PendingActionCount AS PendingActionCount
END
GO
/****** Object:  StoredProcedure [dbo].[COM_GetPendingApprovalPrograms]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_GetPendingApprovalPrograms]
	@ApproverID INT,
	@PendingApprovalStatus VARCHAR(15),
	@TaskOnHoldStatus VARCHAR(15),
	@RecordActiveStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	SELECT * FROM Program WHERE ProgramID IN 
	(SELECT Task.ProgramID FROM Task 
	INNER JOIN ApprovalProcess ON Task.TaskID = ApprovalProcess.ApprovalObjectID
	WHERE ApprovalProcess.PendingApproverID IS NOT NULL
	AND ApprovalProcess.PendingApproverID = @ApproverID
	AND ApprovalProcess.ApprovalStatus = @PendingApprovalStatus
	AND Task.Status = @TaskOnHoldStatus
	AND Task.RecordStatus = @RecordActiveStatus)

END
GO
/****** Object:  StoredProcedure [dbo].[COM_GetPendingActionPrograms]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_GetPendingActionPrograms]
	@UserID INT,
	@PendingApprovalStatus VARCHAR(15),
	@TaskOnHoldStatus VARCHAR(15),
	@RecordActiveStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	SELECT * FROM Program 
	WHERE UserID = @UserID 
	AND ProgramID IN 
	(SELECT Task.ProgramID FROM Task 
	INNER JOIN ApprovalProcess ON Task.TaskID = ApprovalProcess.ApprovalObjectID
	WHERE ApprovalProcess.ApprovalStatus = @PendingApprovalStatus
	AND Task.Status = @TaskOnHoldStatus
	AND Task.RecordStatus = @RecordActiveStatus)

END
GO
/****** Object:  Table [dbo].[UserShortCode]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserShortCode](
	[UserShortCodeID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ShortCodeID] [int] NOT NULL,
 CONSTRAINT [PK_UserShortCode] PRIMARY KEY CLUSTERED 
(
	[UserShortCodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSession]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserSession](
	[UserSessionID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[SessionID] [varchar](50) NOT NULL,
	[AccessIP] [varchar](15) NULL,
	[LoginOn] [datetime] NULL,
	[ExitOn] [datetime] NULL,
	[Status] [varchar](50) NULL,
 CONSTRAINT [PK_UserSession] PRIMARY KEY NONCLUSTERED 
(
	[UserSessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserPrivilege]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserPrivilege](
	[UserPrivilegeID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PrivilegeCode] [nvarchar](20) NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_UserPrivilege] PRIMARY KEY CLUSTERED 
(
	[UserPrivilegeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_UserPrivilege_Privilege] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[PrivilegeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserHubAccount]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserHubAccount](
	[UserID] [int] NOT NULL,
	[HubAccountID] [int] NOT NULL,
	[IsDefault] [char](1) NOT NULL,
 CONSTRAINT [PK_UserHubAccounts] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[HubAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[testtemp]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[testtemp]
as
begin
select * into #testuser from [user]

end
GO
/****** Object:  Table [dbo].[SafeSendingPeriod]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SafeSendingPeriod](
	[SafeSendingPeriodID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[SafeSendingPeriodName] [nvarchar](200) NOT NULL,
	[Timezone] [varchar](50) NOT NULL,
	[IsDefault] [char](1) NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NULL,
 CONSTRAINT [PK_SafeSendingPeriods] PRIMARY KEY CLUSTERED 
(
	[SafeSendingPeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[ViewOrgUser]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewOrgUser]
AS
SELECT        dbo.Organization.OrganizationID, dbo.Organization.OrganizationName, dbo.[User].UserID, dbo.[User].UserName, dbo.[User].RecordStatus, dbo.[User].LastLoginOn, dbo.[User].LoginID, dbo.[User].Email, 
                         dbo.[User].MobileNumber, dbo.[User].AccountStatus, dbo.[User].LockedOn, dbo.[User].CreatedOn, dbo.[User].CreatorID, dbo.[User].Role, dbo.[User].Timezone, dbo.[User].UpdatedOn, dbo.[User].UpdatorID
FROM            dbo.Organization INNER JOIN
                         dbo.[User] WITH (NOLOCK) ON dbo.Organization.OrganizationID = dbo.[User].OrganizationID
GO
/****** Object:  View [dbo].[ViewMTTraffic]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewMTTraffic]
AS
SELECT        dbo.MTTraffic.MTTrafficID, dbo.MTTraffic.TaskID, dbo.Task.TaskName, dbo.[User].UserID, dbo.[User].OrganizationID, dbo.MTTraffic.MSISDN, dbo.MTTraffic.GroupID, dbo.MTTraffic.Message, 
                         dbo.MTTraffic.OrderID, dbo.MTTraffic.Via, dbo.MTTraffic.Status, dbo.MTTraffic.Details, dbo.MTTraffic.CreatedOn, dbo.Task.Status AS TaskStatus, dbo.Task.RecordStatus AS TaskRecordStatus, 
                         dbo.Organization.OrganizationName
FROM            dbo.[User] WITH (NOLOCK) INNER JOIN
                         dbo.MTTraffic WITH (NOLOCK) INNER JOIN
                         dbo.Task WITH (NOLOCK) ON dbo.MTTraffic.TaskID = dbo.Task.TaskID ON dbo.[User].UserID = dbo.Task.CreatorID INNER JOIN
                         dbo.Organization WITH (NOLOCK) ON dbo.[User].OrganizationID = dbo.Organization.OrganizationID
GO
/****** Object:  View [dbo].[ViewMTCampaign]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewMTCampaign]
AS
SELECT        dbo.Task.TaskID, dbo.Task.TaskName, dbo.MTTask.HubURL, REPLACE(REVERSE(SUBSTRING(REVERSE(dbo.MTTask.HubURL), 0, CHARINDEX('/', REVERSE(dbo.MTTask.HubURL)))), '.sms', '') AS MTLogin, 
                         dbo.Task.CreatorID, dbo.Task.Status
FROM            dbo.MTTask INNER JOIN
                         dbo.Task WITH (NOLOCK) ON dbo.MTTask.TaskID = dbo.Task.TaskID
WHERE        (dbo.Task.RecordStatus <> 'D')
GO
/****** Object:  View [dbo].[ViewMOTraffic]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewMOTraffic]
AS
SELECT        dbo.MOContent.MessageID, dbo.MOContent.TaskID, dbo.Task.TaskType, dbo.Task.TaskName, dbo.[User].UserID, dbo.[User].OrganizationID, dbo.MOContent.MSISDN, dbo.MOContent.OperatorID, 
                         dbo.MOContent.MOContent, dbo.MOContent.ContentType AS Status, dbo.Task.Status AS TaskStatus, dbo.Task.RecordStatus AS TaskRecordStatus, dbo.[User].UserName, dbo.MOContent.CreatedOn, 
                         dbo.Organization.OrganizationName
FROM            dbo.MOContent WITH (NOLOCK) INNER JOIN
                         dbo.Task WITH (NOLOCK) ON dbo.MOContent.TaskID = dbo.Task.TaskID INNER JOIN
                         dbo.[User] WITH (NOLOCK) ON dbo.Task.CreatorID = dbo.[User].UserID INNER JOIN
                         dbo.Organization WITH (NOLOCK) ON dbo.[User].OrganizationID = dbo.Organization.OrganizationID
GO
/****** Object:  View [dbo].[ViewUserSession]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewUserSession]
AS
SELECT        dbo.UserSession.UserSessionID, dbo.UserSession.UserID, dbo.[User].UserName, dbo.[User].Role, dbo.[User].LoginID, dbo.[User].Timezone, dbo.[User].Email, dbo.[User].MobileNumber, 
                         dbo.[User].TempRetryCount, dbo.[User].TotalRetryCount, dbo.[User].AccountStatus, dbo.[User].LastLoginOn, dbo.[User].RecordStatus, dbo.UserSession.SessionID, dbo.UserSession.AccessIP, 
                         dbo.UserSession.LoginOn, dbo.UserSession.ExitOn, dbo.UserSession.Status, dbo.[User].OrganizationID
FROM            dbo.UserSession INNER JOIN
                         dbo.[User] ON dbo.UserSession.UserID = dbo.[User].UserID
GO
/****** Object:  View [dbo].[ViewLastMonthMTSummary]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewLastMonthMTSummary]
AS
       WITH T AS
       (
       SELECT N = 1,FORMAT(DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS STARTDATE,FORMAT(DATEADD(DAY,1,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS ENDDATE,YEAR(DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [YEAR], MONTH(DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [MONTH], DATEPART(WEEK, DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [WEEK], DATEPART(DAYOFYEAR, DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [DAY]
       UNION ALL
       SELECT N+1,FORMAT(DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS STARTDATE,FORMAT(DATEADD(DAY,N+1,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS ENDDATE,YEAR(DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [YEAR], MONTH(DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [MONTH], DATEPART(WEEK, DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [WEEK], DATEPART(DAYOFYEAR, DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [DAY]
       FROM T
       WHERE DATEADD(DAY, N+1, DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))) <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)
       )
       SELECT  T.STARTDATE, T.ENDDATE, T.[YEAR], T.[MONTH], T.[WEEK], T.[DAY], ISNULL(MTCOUNT, 0) AS MTCOUNT
       FROM T
       LEFT JOIN 
       (
             SELECT   YEAR(CREATEDON) AS Y,0 AS M, 0 AS W,DATEPART(DAYOFYEAR,CREATEDON) AS D, COUNT(*) AS MTCOUNT
             FROM     VIEWMTTRAFFIC
             WHERE CREATEDON BETWEEN DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)) AND DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)
             GROUP BY YEAR(CREATEDON),DATEPART(DAYOFYEAR,CREATEDON)
       ) S ON T.[YEAR] = S.Y AND T.[DAY] = S.D
GO
/****** Object:  View [dbo].[ViewLastMonthMOSummary]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewLastMonthMOSummary]
AS
	WITH T AS
	(
	SELECT N = 1,FORMAT(DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS STARTDATE,FORMAT(DATEADD(DAY,1,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS ENDDATE,YEAR(DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [YEAR], MONTH(DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [MONTH], DATEPART(WEEK, DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [WEEK], DATEPART(DAYOFYEAR, DATEADD(DAY,0,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [DAY]
	UNION ALL
	SELECT N+1,FORMAT(DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS STARTDATE,FORMAT(DATEADD(DAY,N+1,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))), 'yyyy-MM-dd') AS ENDDATE,YEAR(DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [YEAR], MONTH(DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [MONTH], DATEPART(WEEK, DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [WEEK], DATEPART(DAYOFYEAR, DATEADD(DAY,N,DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)))) AS [DAY]
	FROM T
	WHERE DATEADD(DAY, N+1, DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0))) <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETUTCDATE()), 0)
	)
	SELECT  T.STARTDATE, T.ENDDATE, T.[YEAR], T.[MONTH], T.[WEEK], T.[DAY], ISNULL(MOCOUNT, 0) AS MOCOUNT
	FROM T
	LEFT JOIN 
	(
		SELECT   YEAR(CREATEDON) AS Y,0 AS M, 0 AS W,DATEPART(DAYOFYEAR,CREATEDON) AS D, COUNT(*) AS MOCOUNT
		FROM     VIEWMOTRAFFIC
		GROUP BY YEAR(CREATEDON),DATEPART(DAYOFYEAR,CREATEDON)
	) S ON T.[YEAR] = S.Y AND T.[DAY] = S.D
GO
/****** Object:  Table [dbo].[BlacklistedEmail]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlacklistedEmail](
	[BlacklistID] [int] NOT NULL,
	[EmailAddress] [varchar](200) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[Source] [char](1) NULL,
 CONSTRAINT [PK_BlacklistedEmail] PRIMARY KEY CLUSTERED 
(
	[BlacklistID] ASC,
	[EmailAddress] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BlacklistDetail]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlacklistDetail](
	[BlacklistID] [int] NOT NULL,
	[MSISDN] [varchar](200) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[Source] [char](1) NULL,
	[SynchronizedOn] [datetime] NULL,
 CONSTRAINT [PK_BlacklistDetails] PRIMARY KEY CLUSTERED 
(
	[BlacklistID] ASC,
	[MSISDN] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BlacklistCreationConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlacklistCreationConfig](
	[BlacklistCreationConfigID] [int] IDENTITY(1,1) NOT NULL,
	[BlacklistID] [int] NOT NULL,
	[MSISDNFormatID] [int] NULL,
	[CreationMethod] [varchar](50) NOT NULL,
	[ValidCount] [int] NULL,
	[InvalidCount] [int] NULL,
	[StartedOn] [datetime] NULL,
	[CompletedOn] [datetime] NULL,
	[Status] [varchar](15) NOT NULL,
	[ErrorMessage] [nvarchar](300) NULL,
	[DetailXML] [ntext] NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
 CONSTRAINT [PK_BlacklistCreationConfigs] PRIMARY KEY CLUSTERED 
(
	[BlacklistCreationConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[DEBUG_GetMTSchedules]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[DEBUG_GetMTSchedules]
	@StartTime DATETIME = NULL,
	@EndTime DATETIME = NULL,
	@Status VARCHAR(100) = NULL,
	@Volume INT = 0,
	@Range INT = 50
AS
BEGIN

	SET NOCOUNT ON

	IF (@StartTime IS NULL)
	BEGIN
		SET @StartTime = GETDATE()
	END
	IF (LTRIM(RTRIM(@Status)) = '')
	BEGIN
		SET @Status = NULL
	END

	SET ROWCOUNT @Range

	SELECT * FROM MTSchedule WITH (NOLOCK)
	WHERE StartTime >= @StartTime
	AND ((@EndTime IS NULL) OR (StartTime <= @EndTime))
	AND ((@Volume = 0) OR (AllocatedCount >= @Volume))
	AND ((@Status IS NULL) OR (Status IN (SELECT VALUE FROM Split(@Status, ','))))

END
GO
/****** Object:  Table [dbo].[ListCreationConfig]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ListCreationConfig](
	[ListCreationConfigID] [int] IDENTITY(1,1) NOT NULL,
	[ListID] [int] NOT NULL,
	[MSISDNFormatID] [int] NULL,
	[CreationMethod] [varchar](50) NOT NULL,
	[ValidCount] [bigint] NULL,
	[InvalidCount] [bigint] NULL,
	[StartedOn] [datetime] NULL,
	[CompletedOn] [datetime] NULL,
	[IsClean] [char](1) NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[ErrorMessage] [ntext] NULL,
	[DetailXML] [ntext] NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[ListContentType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ListCreationConfigs] PRIMARY KEY CLUSTERED 
(
	[ListCreationConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[DEBUG_ShowMTTasks]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DEBUG_ShowMTTasks]
AS
BEGIN
	CREATE TABLE #TempData (
		Type INT,
		TaskID INT,
		StartTime DATETIME NULL,
		TaskStatus VARCHAR(12) NULL,
		ScheduleStatus VARCHAR(12) NULL
	)

INSERT INTO #TempData (Type, TaskID, StartTime) 
SELECT 1, MTSchedule.TaskID, MIN(StartTime) AS StartTime FROM MTSchedule WITH (NOLOCK)
WHERE MTSchedule.Status = 'New'
AND MTSchedule.StartTime BETWEEN DATEADD(MINUTE, -30, GETUTCDATE()) AND DATEADD(MINUTE, 30, GETUTCDATE())
GROUP BY MTSchedule.TaskID	

INSERT INTO #TempData (Type, TaskID, StartTime)
SELECT 2, TaskID, NULL FROM Task
WHERE Status = 'Error' 
SELECT * FROM #TempData
END
GO
/****** Object:  StoredProcedure [dbo].[MT_CompleteTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[MT_CompleteTask]
	@TaskID INT,
	@TaskCompletedStatus VARCHAR(15),
	@PauseStatus VARCHAR(15),
	@ProcessingStatus VARCHAR(15),
	@PendingStatus VARCHAR(15),
	@SendingStatus VARCHAR(15),
	@NewStatus VARCHAR(15)
AS
BEGIN
	DECLARE @ErrorCode INT
	SET @ErrorCode = -1
	BEGIN TRANSACTION
	IF (NOT EXISTS(SELECT * FROM MTSchedule WITH (NOLOCK) WHERE TaskID = @TaskID AND (Status = @PauseStatus OR Status = @ProcessingStatus OR Status = @PendingStatus OR Status = @SendingStatus OR Status = @NewStatus)))
	BEGIN
		UPDATE Task WITH (ROWLOCK) SET Status = @TaskCompletedStatus, UpdatedOn = GETUTCDATE() WHERE TaskID = @TaskID
		IF (@@ROWCOUNT > 0)
		BEGIN
			SET @ErrorCode = 0
		END
	END
	COMMIT TRANSACTION
	SELECT @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_PauseSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_PauseSchedule]
	@ScheduleID INT,
	@SchedulePauseStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15)
AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @SchedulePauseStatus
	WHERE ScheduleID = @ScheduleID
	AND ((Status = @ScheduleSendingStatus) OR (Status = @SchedulePendingStatus))
	IF (@@ROWCOUNT > 0)
	BEGIN
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetScheduleError]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetScheduleError]
	@ScheduleID INT,
	@ScheduleErrorStatus VARCHAR(15),
	@ErrorMessage NVARCHAR(500)
AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	--BEGIN TRANSACTION

	UPDATE MTSchedule WITH (ROWLOCK) 
	SET Status = @ScheduleErrorStatus, ErrorMessage = @ErrorMessage
	WHERE ScheduleID = @ScheduleID
	IF (@@ROWCOUNT > 0)
	BEGIN
		SET @ErrorCode = 0
	END

	--COMMIT TRANSACTION

	SELECT @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetScheduleCompleted]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetScheduleCompleted]
	@ScheduleID INT,
	@ScheduleCompletedStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15)
AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleCompletedStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @ScheduleSendingStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		SET @ErrorCode = 0
	END

	RETURN @ErrorCode
END
GO
/****** Object:  Table [dbo].[MTBroadcastHistory]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MTBroadcastHistory](
	[TaskID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[SubscriptionCount] [int] NULL,
	[Blacklisted] [int] NULL,
	[MTCount] [int] NULL,
	[MTSent] [int] NULL,
	[MTFailed] [int] NULL,
	[MTProcessed] [int] NULL,
	[MTNoAck] [int] NULL,
	[MTOperatorAck] [int] NULL,
	[MTHandsetAck] [int] NULL,
	[MTRejected] [int] NULL,
	[MTUndelivered] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_BroadcastHistories] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC,
	[ScheduleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[ReportSaveFile]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportSaveFile]
	@ReportFileID INT,
	@Stmt NVARCHAR(3000),
	@HeaderStmt NVARCHAR(1000),
	@Separator CHAR(1),
	@Header CHAR(1),
	@Delimiter CHAR(1),
	@FileName VARCHAR(100)
AS
/*******************************************************************/
--Name		: ReportSaveFile
--Module	: Report
--Description 	: Export report into CSV format for a given query
--Input Param	: ReportFileID		
--		  Stmt		- Query used to export data
--		  HeaderStmt	- Column header
--		  Separator	- CSV separator character
--		  Header	- Option to include header; Y: Yes; N: No
--		  Delimiter	- Currently not supported
--		  FileName	- CSV filename	
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/
BEGIN
	DECLARE @Error INT,
		@BCPcmd NVARCHAR(4000),
		@ReportDir VARCHAR(255),
		@Cmd VARCHAR(400),
		@DBName VARCHAR(128),
		@Count INT,
		@HeaderFile VARCHAR(255),
		@DataFile VARCHAR(255),
		@ObjFSys INT,
		@FileExist INT,
		@HeaderFileName VARCHAR(255),
		@DataFileName VARCHAR(255)

	/*******************Initialize variables*******************/
	SELECT	@reportdir = paramvalue 
	FROM 	reportparam 
	WHERE 	UPPER(paramname) = 'REPORTDIR'	
	IF (@reportdir IS NULL) 
	BEGIN
		EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportSaveFile', 'error', 'ReportDir is not found in REPORTPARAM table'
		RETURN -1
	END
	SET @DBName = DB_NAME()
	SET @HeaderFileName = 'ReportHeader.csv'
	SET @DataFileName = 'ReportData.csv'
	SET @HeaderFile = @ReportDir + @HeaderFileName
	IF (UPPER(@Header) = 'Y')
	begin
		SET @DataFile = @ReportDir + @DataFileName	--use the temp data file name
	end
	ELSE
	begin
		SET @DataFile = @ReportDir + @FileName		--use the final csv file name
	end
	EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportSaveFile_running', 'ok', NULL

	/************export the header to csv file****************/
	IF (UPPER(@Header) = 'Y')
	BEGIN
		SET @BCPcmd = 'BCP "select ''' + @HeaderStmt + '''" QUERYOUT "'
		SET @BCPcmd = @BCPcmd + @HeaderFile + '" -w -t' + @Separator + ' -T -Slocalhost'
		EXEC @Error = REPORTRUNCMDSHELL 'file', @ReportFileID, @bcpcmd
		IF (@Error < 0)
			RETURN -1
	END

	/**************export the data to csv file****************/
	SET @BCPcmd = 'BCP "' + @Stmt + '" QUERYOUT "'
	SET @BCPcmd = @BCPcmd + @DataFile + '" -w -t' + @Separator + ' -T -Slocalhost'
	EXEC @Error = REPORTRUNCMDSHELL 'file', @ReportFileID, @BCPcmd
	IF (@Error < 0)
		RETURN -1

	/******************join header and data********************/
	IF (UPPER(@Header) = 'Y')
	BEGIN
		EXEC SP_OACREATE 'Scripting.FileSystemObject', @objFSys OUT
		EXEC SP_OAMETHOD @ObjFSys, 'FileExists', @FileExist OUT, @HeaderFile
		IF @FileExist <> 1
		BEGIN
			EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportSaveFile_fileexists','error', 'Header file not found'
			RETURN -1
		END
		EXEC SP_OAMETHOD @objFSys, 'FileExists', @FileExist OUT, @DataFile
		IF @FileExist <> 1
		BEGIN
			EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportSaveFile_fileexists', 'error', 'Data file not found'
			RETURN -1
		END
		EXEC SP_OADESTROY @objFSys 
	
		SET @Cmd = 'COPY ' + @HeaderFile + '+' +@DataFile + ' ' + @ReportDir + @Filename
		EXEC @Error = REPORTRUNCMDSHELL 'file', @ReportFileID, @Cmd
		IF (@Error < 0)
			RETURN -1
		SET @Cmd = 'DEL ' + @HeaderFile
		EXEC @Error = ReportRunCmdShell 'file', @ReportFileID, @Cmd
		IF (@Error < 0)
			RETURN -1
		SET @Cmd = 'DEL ' + @DataFile
		EXEC @Error = ReportRunCmdShell 'file', @ReportFileID, @Cmd
		IF (@Error < 0)
			RETURN -1
	END

	/**********update the reportdir to reportfile table**********/
	UPDATE	reportfile 
	SET 	reportdir = @ReportDir 
	WHERE 	reportfileid = @ReportFileID

	EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportSaveFile_complete', 'ok', NULL

	RETURN 0
END
GO
/****** Object:  Table [dbo].[SafeSendingPeriodDetail]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SafeSendingPeriodDetail](
	[SafeSendingPeriodDetailID] [int] IDENTITY(1,1) NOT NULL,
	[SafeSendingPeriodID] [int] NOT NULL,
	[WeekDay] [int] NOT NULL,
	[StartTime] [char](4) NOT NULL,
	[EndTime] [char](4) NOT NULL,
	[CreatorID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatorID] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_SafeSendingPeriodDetails] PRIMARY KEY CLUSTERED 
(
	[SafeSendingPeriodDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Subscription](
	[SubscriptionID] [int] IDENTITY(1,1) NOT NULL,
	[ListID] [int] NOT NULL,
	[ListCreationConfigID] [int] NULL,
	[MSISDN] [varchar](100) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Source] [char](1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[Data1] [nvarchar](800) NULL,
	[Data2] [nvarchar](320) NULL,
	[Data3] [nvarchar](320) NULL,
	[Data4] [nvarchar](320) NULL,
	[Data5] [nvarchar](320) NULL,
	[Data6] [nvarchar](320) NULL,
	[Data7] [nvarchar](320) NULL,
	[Data8] [nvarchar](320) NULL,
	[Data9] [nvarchar](320) NULL,
	[Data10] [nvarchar](320) NULL,
 CONSTRAINT [PK_Subscriptions] PRIMARY KEY CLUSTERED 
(
	[SubscriptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MTTimeBlock]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTTimeBlock](
	[TimeBlockID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[Status] [varchar](15) NOT NULL,
 CONSTRAINT [PK_TimeBlocks] PRIMARY KEY CLUSTERED 
(
	[TimeBlockID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[Prc_CheckExpiredPurchaseHistory]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Prc_CheckExpiredPurchaseHistory]
@UserID INT
AS
BEGIN

SET NOCOUNT ON

DECLARE @ExpiryResult NVARCHAR(MAX)

--Drop temp table if already exists
IF OBJECT_ID('tempdb..#TempPurchaseHistory') IS NOT NULL
	BEGIN
			DROP TABLE #TempPurchaseHistory
	END

--Temp table to store result of redundancy check
CREATE TABLE #TempPurchaseHistory
        (
                RowID          INT NOT NULL ,
                PurchaseID     INT NOT NULL ,
                UserID         INT NOT NULL ,
                HubAccountID   INT NOT NULL ,
                ExpiryDate     DATETIME NULL,
                CurrentBalance BIGINT NULL
        )

PRINT '-------------------------------------------------------------------------------------'
PRINT 'START : CHECKING EXPIRED PURCHASE HISTORY [UserID: ' + CAST(@UserID AS VARCHAR) + ']';

INSERT INTO #TempPurchaseHistory
SELECT  ROW_NUMBER()Over(ORDER BY PurchaseID ASC),
        PurchaseID,
        UserID,
        HubAccountID,
        ExpiryDate,
        CurrentBalance
FROM    purchaseHistory
WHERE   UserID = @UserID 
		AND PurchaseID IN 
						(SELECT  MAX(PurchaseID) FROM purchaseHistory 
						 WHERE   UserID = @UserID 
						 GROUP BY HubAccountID) 
		AND ExpiryDate  < GETUTCDATE()
		AND ExpiryDate   IS NOT NULL
		AND RecordStatus = 'A' 
	
	PRINT 'RECORDS TO BE EXPIRED FOUND [TOTAEXPIREDRECORDS:' + CAST(@@ROWCOUNT AS VARCHAR) + '][CURRENTDATETIME: ' + CAST(GETUTCDATE() AS VARCHAR) + ']'
	PRINT '-------------------------------------------------------------------------------------'
	--Declare temporary variables	
	DECLARE @TotalRecords INT,
        @RowID        INT,
        @PurchaseID   INT,
        @TempUserID   INT,
        @HubAccountID INT,
        @ExpiryDate   DATETIME,
        @TEMP         NVARCHAR(MAX),
        @TempBalance  BIGINT,
		@ROWCOUNTORID INT

	--MAINTAIN TO IDENTIFY AFFECTED RECORDS AFTER MARKED EXPIRED
	DECLARE @MyTableVar TABLE ( id INT );

SELECT @RowID = 1;

SELECT @TotalRecords = 0;
SELECT @ExpiryResult = '';

SELECT  @TotalRecords = ISNULL(COUNT(PurchaseID),0)
FROM    #TempPurchaseHistory

IF(@TotalRecords > 0) 
	BEGIN 

			SELECT @ExpiryResult = '[EXPIRED PURCHASE DETAILS FOUND [UserID: ' + CAST(@UserID AS VARCHAR) + '] [PURCHASEID :'
			SELECT @ExpiryResult  = COALESCE(@ExpiryResult + ',', '') + CAST(PurchaseID AS VARCHAR)
			FROM    #TempPurchaseHistory
			SELECT  @ExpiryResult =  @ExpiryResult + ']]'

		WHILE(@TotalRecords >= @RowID)
		 BEGIN
			--RESET TEMP VARIABLES
			
			DELETE FROM @MyTableVar;

			SELECT  @TempBalance  = 0,
					@TempUserID   = 0,
					@HubAccountID = 0,
					@PurchaseID   = 0,
					@ROWCOUNTORID = 0;

			--SELECT CONTENT FROM TEMP TABLE FOR PROCESSING

			SELECT  @PurchaseID   = PurchaseID  ,
					@TempUserID   = UserID      ,
					@HubAccountID = HubAccountID,
					@ExpiryDate   = ExpiryDate  ,
					@TempBalance  = CurrentBalance
			FROM    #TempPurchaseHistory
			WHERE   RowID = @RowID 

PRINT '-------------------------------------------------------------------------------------'
PRINT 'START : DATA PROCESSING FOR [PurchaseID: ' + CAST(@PurchaseID AS VARCHAR) + ']
								   [UserID: ' + CAST(@UserID AS VARCHAR) + ']
								   [HubAccountID: ' + CAST(@HubAccountID AS VARCHAR) + ']
								   [ExpiryDate: ' + CAST(@ExpiryDate AS VARCHAR) + ']
								   [CurrentBalance: ' + CAST(@TempBalance AS VARCHAR) + ']' 


			IF(ISNULL(@TempBalance,0) > 0) 
				BEGIN
					INSERT INTO PurchaseHistory
					SELECT  UserID,'E',@HubAccountID,-@TempBalance,0,'Expired',0,StartDate,ExpiryDate,CreatorID,GETUTCDATE(),UpdatorID,GETUTCDATE(),'E'
					FROM    PurchaseHistory
					WHERE   PurchaseID = @PurchaseID 

					SELECT @ROWCOUNTORID = @@IDENTITY;

					PRINT 'EXPIRED RECORD ADDED [PurchaseID:' + CAST(@ROWCOUNTORID AS VARCHAR)+']'
					SELECT @ExpiryResult = @ExpiryResult + '[NEW PURCHASE ENTRY ADDED WITH EXPIRED MODE 
															[New PurchaseID:' + CAST(@ROWCOUNTORID AS VARCHAR)+'] AGAINST [PurchaseID:' + CAST(@PurchaseID AS VARCHAR) + ']]'
				END

			UPDATE PurchaseHistory
			SET     RecordStatus = 'E' 
			OUTPUT INSERTED.purchaseID INTO @MyTableVar
			WHERE   UserID = @UserID 
					AND HubAccountID = @HubAccountID 
					AND PurchaseID  <= @PurchaseID 
					AND RecordStatus = 'A'

			SELECT @ROWCOUNTORID = @@ROWCOUNT;

			SELECT  @TEMP  = COALESCE(@TEMP + ',', '') + CAST(ID AS VARCHAR)
			FROM    @MyTableVar



			SELECT @ExpiryResult = @ExpiryResult + ' [UPDATE EXPIRED STATUS OF PREVIOUS ACTIVE PURCHASE DETAILS 
													 [TotalRecordsUpdated:' + CAST(@ROWCOUNTORID AS VARCHAR) + '] 
													 [Updated PurchaseID:' + CAST(@TEMP AS VARCHAR) + '] AGAINST [PurchaseID:' + CAST(@PurchaseID AS VARCHAR) + ']]' 

            PRINT 'UPDATE EXPIRY OF PREVIOUS ACTIVE PURCHASE DETAILS [TotalRecordsUpdated:' + CAST(@ROWCOUNTORID AS VARCHAR) + '] [PurchaseID:' + CAST(@TEMP AS VARCHAR) + ']' 
			PRINT 'END : DATA PROCESSING FOR [PurchaseID: ' + CAST(@PurchaseID AS VARCHAR) + '][UserID: ' + CAST(@UserID AS VARCHAR) + ']
											 [HubAccountID: ' + CAST(@HubAccountID AS VARCHAR) + '][ExpiryDate: ' + CAST(@ExpiryDate AS VARCHAR) + ']'
			PRINT '-------------------------------------------------------------------------------------'
			SELECT @TEMP = '';

			SELECT @RowID = @RowID + 1;

	END
END
PRINT 'END : CHECKING EXPIRED PURCHASE HISTORY'
PRINT '-------------------------------------------------------------------------------------'

SELECT @ExpiryResult AS ExpiryResult;
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SwitchTaskRepeatSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SwitchTaskRepeatSchedule]
	@TaskID INT,
	@TaskCompletedStatus VARCHAR(15),
	@ScheduleNewStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@DefaultDataCollectionAdvancePeriod INT
AS
BEGIN
	DECLARE @ScheduleID INT
	DECLARE @ProcessStartTime DATETIME
	DECLARE @DataCollectionAdvancePeriod INT

	SELECT TOP 1 @ScheduleID = ScheduleID, @ProcessStartTime = StartTime FROM MTSchedule
	WHERE TaskID = @TaskID 
	AND Status = @ScheduleNewStatus
	ORDER BY StartTime ASC

	BEGIN TRANSACTION

	IF ((@ScheduleID IS NOT NULL) AND (@ScheduleID > 0))
	BEGIN
		SELECT TOP 1 @DataCollectionAdvancePeriod = DataCollectionAdvancePeriod
		FROM MTRepeatScheduleConfig
		WHERE TaskID = @TaskID
		AND RecordStatus = 'A'

		IF ((@DataCollectionAdvancePeriod IS NULL) OR (@DataCollectionAdvancePeriod < @DefaultDataCollectionAdvancePeriod))
		BEGIN
			SET @DataCollectionAdvancePeriod = @DefaultDataCollectionAdvancePeriod
		END

		UPDATE MTTask SET ProcessStartTime = @ProcessStartTime 
		WHERE TaskID = @TaskID
	END
	ELSE
	BEGIN
		UPDATE Task SET Status = @TaskCompletedStatus
		WHERE TaskID = @TaskID
	END

	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SwitchRepeatableSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SwitchRepeatableSchedule]
	@TaskID INT,
	@TaskNewStatus VARCHAR(15),
	@ScheduleNewStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@DefaultDataCollectionAdvancePeriod INT
AS
BEGIN
	DECLARE @ScheduleID INT
	DECLARE @ProcessStartTime DATETIME
	DECLARE @DataCollectionAdvancePeriod INT
	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	SELECT TOP 1 @ScheduleID = ScheduleID, @ProcessStartTime = StartTime FROM MTSchedule
	WHERE TaskID = @TaskID 
	AND Status = @ScheduleNewStatus
	ORDER BY StartTime ASC

	BEGIN TRANSACTION

	IF ((@ScheduleID IS NOT NULL) AND (@ScheduleID > 0))
	BEGIN
		SELECT TOP 1 @DataCollectionAdvancePeriod = DataCollectionAdvancePeriod
		FROM MTRepeatableScheduleConfig
		WHERE TaskID = @TaskID
		AND RecordStatus = 'A'

		IF ((@DataCollectionAdvancePeriod IS NULL) OR (@DataCollectionAdvancePeriod < @DefaultDataCollectionAdvancePeriod))
		BEGIN
			SET @DataCollectionAdvancePeriod = @DefaultDataCollectionAdvancePeriod
		END
		
		UPDATE Task SET Status = @TaskNewStatus
		WHERE TaskID = @TaskID

		UPDATE MTTask SET ProcessStartTime = @ProcessStartTime
		WHERE TaskID = @TaskID

	END

	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[ReportTransferInsert]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportTransferInsert]
	@ReportID INT,
	@ReportTypeTransferID INT
AS
/*******************************************************************/
--Name		: ReportTransferInsert
--Module	: Report
--Description 	: Transfer any file(s) created to a defined location 
--		  ReportTypeTransfer table for a given Report
--Input Param	: ReportID
--		  ReportTypeTransferID
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/
BEGIN
	DECLARE @ReportTransferID INT,
		@Cmd VARCHAR(1000),
		@FileName VARCHAR(255),
		@SourceDir VARCHAR(255),
		@Host VARCHAR(255),
		@Path VARCHAR(255),
		@NetworkDomain VARCHAR(255),
		@Logon VARCHAR(50),
		@Pwd VARCHAR(50),
		@TransferType VARCHAR(20),
		@Error INT,
		@ErrorMsg NVARCHAR(4000)
	
	SELECT 	@TransferType = transfertype,
		@Host = host,
		@Path = path,
		@NetworkDomain = networkdomain,
		@Logon = logon,
		@Pwd = pwd
	FROM reporttypetransfer
	WHERE reporttypetransferid = @ReportTypeTransferID

	IF (@@ROWCOUNT = 1)
	BEGIN
		/********Log the transfer details to report output**********/
		INSERT INTO reporttransfer
		(reportid, transfertype, host, path, networkdomain, logon, pwd)
		VALUES
		(@ReportID, @TransferType, @Host, @Path, @NetworkDomain, @Logon, @Pwd)	
		SELECT @ReportTransferID = SCOPE_IDENTITY()

		EXEC REPORTSTATUSINSERT 'transfer', @ReportTransferID, 'ReportTransferInsert_running', 'ok', NULL	

		/********logon to the remote server**********/
		SET @Cmd = 'NET USE \\' + @Host + ' /USER:' + @NetworkDomain + '\' + @Logon + ' ' + @Pwd
		EXEC @Error = REPORTRUNCMDSHELL 'transfer', @ReportTransferID, @Cmd
		IF (@Error = 0)
			EXEC REPORTSTATUSINSERT 'transfer', @ReportTransferID, 'ReportTransferInsert_logon', 'ok', @Cmd
		ELSE
		BEGIN
			SET @ErrorMsg = 'An error occured while logon'
			EXEC reportstatusinsert 'transfer', @ReportTransferID, 'logon', 'ReportTransferInsert_logon', @ErrorMsg
			RETURN -1
		END

		/********transfer all files**********/
		DECLARE file_cursor CURSOR
		FOR SELECT filename, reportdir FROM reportfile WHERE reportid = @ReportID
		OPEN file_cursor
		FETCH NEXT FROM file_cursor INTO @FileName, @SourceDir
		WHILE @@FETCH_STATUS = 0
		BEGIN	
			SET @cmd = 'COPY ' + @SourceDir + @FileName + ' \\' + @Host + '\' + @Path + @FileName + ' /Y'
			EXEC @Error = REPORTRUNCMDSHELL 'transfer', @ReportTransferID, @Cmd
			IF (@Error = 0)
				EXEC REPORTSTATUSINSERT 'transfer', @ReportTransferID, 'ReportTransferInsert_copy', 'ok', @Cmd
			ELSE
			BEGIN
				SET @ErrorMsg = 'An error occured while copying file'
				EXEC REPORTSTATUSINSERT 'transfer', @ReportTransferID, 'ReportTransferInsert_copy', 'error', @ErrorMsg
				CLOSE file_cursor
				DEALLOCATE file_cursor
				RETURN -1
			END
			FETCH NEXT FROM file_cursor INTO @filename, @sourcedir
		END
		CLOSE file_cursor
		DEALLOCATE file_cursor
	
		/********remove the AD created**********/
		SET @Cmd = 'NET USE \\' + @host + ' /DELETE'
		EXEC @Error = REPORTRUNCMDSHELL 'transfer', @ReportTransferID, @Cmd
		IF (@Error = 0)
			EXEC REPORTSTATUSINSERT 'transfer', @ReportTransferID, 'ReportTransferInsert_delete', 'ok', @Cmd
		ELSE
		BEGIN
			SET @ErrorMsg = 'An error occured while deleting the ad'
			EXEC REPORTSTATUSINSERT 'transfer', @ReportTransferID, 'ReportTransferInsert_delete', 'error', @ErrorMsg
			RETURN -1
		END

		EXEC REPORTSTATUSINSERT 'transfer', @ReportTransferID, 'ReportTransferInsert_complete', 'ok', NULL
	END
    	RETURN 0

END
GO
/****** Object:  StoredProcedure [dbo].[Prc_GetPurchaseHubAccountDetails]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Prc_GetPurchaseHubAccountDetails]
@UserID INT,
@MTCount INT,
@MSISDNCount INT,
@HubAccountID INT
AS
BEGIN
SET NOCOUNT ON;

Declare @TotalAvailableBalance BIGINT;

SELECT @TotalAvailableBalance = 0;

	--Drop temp table if already exists
				IF OBJECT_ID('tempdb..#TempHubAccountDetails') IS NOT NULL
				BEGIN
						DROP TABLE #TempHubAccountDetails
				END

				--Temp table to store result of redundancy check
				CREATE TABLE #TempHubAccountDetails
						(		
								RowID INT NOT NULL,
								HubAccountID INT NOT NULL,
								HubName  nvarchar(100) NOT NULL,
								HubURL   VARCHAR(500) NOT NULL,
								HubHash  VARCHAR(500) NOT NULL,
								BalanceBeforeUse BIGINT NOT NULL,
								BalanceToUse BIGINT NOT NULL,
								BalanceAfterUse BIGINT  NOT NULL
						)



		IF(@HubAccountID > 0)
		BEGIN
		--GET CURRENTBALANCE OF MAX PURCHASE RECORD OF SPECIFIED HUB ACCOUNTID
			SELECT @TotalAvailableBalance =(SELECT CurrentBalance 
												 FROM PurchaseHistory
												 WHERE PurchaseID IN (SELECT MAX(PurchaseID)
																 FROM PurchaseHistory
																 WHERE UserID = @UserID
																 AND HubAccountID = @HubAccountID
																 AND HubAccountID IN (SELECT HubAccountID FROM UserHubAccount WHERE UserID = @UserID)
																 GROUP BY HubAccountID)
																 AND PurchaseHistory.RecordStatus = 'A'
																 AND Startdate < GETUTCDATE()
																 AND (ExpiryDate > GETUTCDATE() 
																      OR ExpiryDate IS NULL))
												  
											
				IF(ISNULL(@TotalAvailableBalance,0) >= @MTCount )
				BEGIN

					INSERT INTO #TempHubAccountDetails
					SELECT ROW_NUMBER() OVER (ORDER BY PurchaseID asc),PurchaseHistory.HubAccountID,HubAccountName,HubURL,HubHash,CurrentBalance,0,0
												 FROM PurchaseHistory
												  INNER JOIN HubAccount ON HubAccount.HubAccountID = PurchaseHistory.HubAccountID
												 WHERE PurchaseID IN (SELECT MAX(PurchaseID)
																 FROM PurchaseHistory
																 WHERE UserID = @UserID
																 AND HubAccountID = @HubAccountID
																 AND HubAccountID IN (SELECT HubAccountID FROM UserHubAccount WHERE UserID = @UserID)
																 GROUP BY HubAccountID)
																 AND PurchaseHistory.RecordStatus = 'A'
																 AND Startdate < GETUTCDATE()
																 AND (ExpiryDate > GETUTCDATE() 
																     OR ExpiryDate IS NULL)
				END
				
		END
		ELSE
		BEGIN

			SELECT @TotalAvailableBalance = (SELECT SUM(CurrentBalance) 
											 FROM PurchaseHistory
											 WHERE PurchaseID IN (SELECT MAX(PurchaseID)
																 FROM PurchaseHistory
																 WHERE UserID = @UserID
																 AND HubAccountID IN (SELECT HubAccountID FROM UserHubAccount WHERE UserID = @UserID)
																 GROUP BY HubAccountID)
																 AND PurchaseHistory.RecordStatus = 'A'
																 AND Startdate < GETUTCDATE()
																 AND (ExpiryDate > GETUTCDATE() 
																      OR ExpiryDate IS NULL))
										 
									

		IF(ISNULL(@TotalAvailableBalance,0) >= @MTCount)
					BEGIN
							INSERT INTO #TempHubAccountDetails
							SELECT ROW_NUMBER() OVER (ORDER BY PurchaseID asc),PurchaseHistory.HubAccountID,HubAccountName,HubURL,HubHash,CurrentBalance,0,0
															 FROM PurchaseHistory
															 INNER JOIN HubAccount ON HubAccount.HubAccountID = PurchaseHistory.HubAccountID
															  WHERE PurchaseID IN (SELECT MAX(PurchaseID)
																 FROM PurchaseHistory
																 WHERE UserID = @UserID
																 AND HubAccountID IN (SELECT HubAccountID FROM UserHubAccount WHERE UserID = @UserID)
																 GROUP BY HubAccountID)
																 AND PurchaseHistory.RecordStatus = 'A'
																 AND Startdate < GETUTCDATE()
																 AND (ExpiryDate > GETUTCDATE() 
																      OR ExpiryDate IS NULL)
																 AND CurrentBalance > 0
																    
														
					END
		END

	IF(ISNULL(@TotalAvailableBalance,0) < @MTCount)
			BEGIN
				PRINT 'Not enough hub account balance available to send SMS. UserID:'+ CAST(@UserID as Varchar(50)) 
						+ ' MTCount:' + CAST(@MTCount as Varchar(50)) 
						+ ' TotalAvailableBalance:' + CAST(@TotalAvailableBalance as Varchar(50))
				RAISERROR (N'Not enough balance available to send sms',16,1)
			END
			ELSE
			BEGIN

		Declare @RemainingCount INT,
			@TotalHubAccount INT,
			@RowID INT,
			@ActualBalance INT,
			@UsedCount INT;

			SELECT @RemainingCount = @MSISDNCount,
			@TotalHubAccount = 0,
			@RowID = 1;

			SELECT @TotalHubAccount = (SELECT COUNT(HubAccountID) FROM #TempHubAccountDetails)

			WHILE (@RemainingCount > 0 
					AND @TotalHubAccount >= @RowID)
			BEGIN
				SELECT @UsedCount = 0,
						@ActualBalance = 0;
				
				SELECT @ActualBalance = BalanceBeforeUse FROM #TempHubAccountDetails
				WHERE RowID = @RowID

				IF(@RemainingCount >= @ActualBalance)
					BEGIN
							SELECT @RemainingCount = @RemainingCount - @ActualBalance 
							SELECT @UsedCount = @ActualBalance;
					END
				ELSE
					BEGIN
							SELECT @UsedCount = @RemainingCount;
							SELECT @RemainingCount = 0;
					END

					UPDATE #TempHubAccountDetails
					SET BalanceToUse = @UsedCount, BalanceAfterUse = BalanceBeforeUse - @UsedCount
					WHERE RowID =@RowID
				
				SELECT @RowID = @RowID + 1;
			END
	END

	DELETE FROM #TempHubAccountDetails WHERE BalanceToUse = 0

	SELECT * FROM #TempHubAccountDetails
		
END
GO
/****** Object:  StoredProcedure [dbo].[Prc_GetHubAccountBalanceAndExpiry]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Prc_GetHubAccountBalanceAndExpiry]
@UserID INT,
@HubAccountID INT,
@Option Varchar(100)
AS
BEGIN

SET NOCOUNT ON;


Declare @TotalAvailableBalance BIGINT,
@ExpiryDate Datetime;

SELECT @TotalAvailableBalance = 0;

IF(UPPER(@Option) = 'ALL')
	BEGIN
		IF(@HubAccountID > 0)
			BEGIN
				    SELECT @TotalAvailableBalance = CurrentBalance,
						   @ExpiryDate = ExpiryDate
						  FROM PurchaseHistory
										 WHERE UserID = @UserID
										  AND RecordStatus = 'A'
    									  AND (ExpiryDate > GETUTCDATE() 
										      OR ExpiryDate IS NULL)
										 AND PurchaseID IN (SELECT MAX(PurchaseID)
										 FROM PurchaseHistory
										 WHERE UserID = @UserID
										 AND HubAccountID = @HubAccountID
										 GROUP BY HubAccountID)
										 

										 
												  
			END
		ELSE
			BEGIN
				 SELECT @TotalAvailableBalance = SUM(CurrentBalance) ,
						@ExpiryDate = MAX(ExpiryDate)
										FROM PurchaseHistory
										 WHERE UserID = @UserID
										  AND RecordStatus = 'A'
    									  AND  (ExpiryDate > GETUTCDATE() 
										      OR ExpiryDate IS NULL)
										 AND PurchaseID IN (SELECT MAX(PurchaseID)
										 FROM PurchaseHistory
										 WHERE UserID = @UserID
										 GROUP BY HubAccountID)
										 
												  
			END
	END

IF(UPPER(@Option) = 'ACTIVE')
	BEGIN
		IF(@HubAccountID > 0)
			BEGIN		
					SELECT @TotalAvailableBalance = CurrentBalance,
						   @ExpiryDate = ExpiryDate
						    FROM PurchaseHistory
										 WHERE UserID = @UserID
										  AND RecordStatus = 'A'
										  AND Startdate < GETUTCDATE()
										  AND  (ExpiryDate > GETUTCDATE() 
										      OR ExpiryDate IS NULL)
										 AND PurchaseID IN (SELECT MAX(PurchaseID)
										 FROM PurchaseHistory
										 WHERE UserID = @UserID
										 AND HubAccountID = @HubAccountID 
										 AND HubAccountID IN (SELECT HubAccountID FROM UserHubAccount WHERE UserID = @UserID)
										 GROUP BY HubAccountID)

												
												  
			END
		ELSE
			BEGIN
			SELECT @TotalAvailableBalance = SUM(CurrentBalance),
						@ExpiryDate = MAX(ExpiryDate)
										 FROM PurchaseHistory
										 WHERE UserID = @UserID
										  AND RecordStatus = 'A'
										  AND Startdate < GETUTCDATE()
										  AND  (ExpiryDate > GETUTCDATE() 
										      OR ExpiryDate IS NULL)
										 AND PurchaseID IN (SELECT MAX(PurchaseID)
										 FROM PurchaseHistory
										 WHERE UserID = @UserID
										 AND HubAccountID IN (SELECT HubAccountID FROM UserHubAccount WHERE UserID = @UserID)
										 GROUP BY HubAccountID)
										 
												  
			END
	END


	SELECT ISNULL(@TotalAvailableBalance,0) AS TotalAvailableBalance, @ExpiryDate AS ExpiryDate

END
GO
/****** Object:  StoredProcedure [dbo].[ReportFileInsert]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ReportFileInsert]
	@ReportID INT,
	@ReportTypeFileID INT
AS
/*******************************************************************/
--Name		: ReportFileInsert
--Module	: Report
--Description 	: Generate the csv file for the given ReportTypeFileID
--Input Param	: ReportID
--		  ReportTypeFileID
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/
BEGIN
	Declare @Error INT,
		@ErrorMsg NVARCHAR(4000),
		@Stmt NVARCHAR(3000),
		@Name VARCHAR(1000),
		@FileName NVARCHAR(255),
		@ReportTypeID INT,
		@Separator CHAR(1),
		@Header CHAR(1),
		@Delimiter CHAR(1),
		@Maxline INT,
		@Inline CHAR(1),
		@ParamName VARCHAR(50),
		@ParamValue NVARCHAR(2000),
		@FileURL VARCHAR(255),
		@ReportFileID INT,
		@DateFormat INT,
		@DateStr VARCHAR(100),
		@HeaderStmt NVARCHAR(1000),
		@RetVal INT,
		@Count INT

	SELECT 	@Stmt = reporttypequery.stmt, 
		@headerstmt = reporttypequery.header,
		@name = reporttypefile.name,
		@FileName = reporttypefile.filename,
		@Separator = reporttypefile.separator,
		@Header = reporttypefile.header,
		@Delimiter = reporttypefile.delimiter,
		@MaxLine = reporttypefile.maxline,	--not supported at the moment
		@FileURL = reporttypefile.fileurl,
		@DateFormat = reporttypefile.dtformat
	FROM	reporttypefile, reporttypequery
	WHERE	reporttypefileid = @ReportTypeFileID
	AND	reporttypefile.reporttypequeryid = reporttypequery.reporttypequeryid
	SET @Count = @@ROWCOUNT

	IF (@Count = 1)
	BEGIN
		--replace paramname with the param value, if any
		DECLARE param1_cursor CURSOR
		FOR	SELECT	paramname, paramvalue 
			FROM	reporttypefileparam, reporttypequery, reporttypefile 
			WHERE	reporttypefile.reporttypefileid = @ReportTypeFileID
			AND 	reporttypequery.reporttypequeryid = reporttypefile.reporttypequeryid
			AND 	reporttypefile.reporttypefileid = reporttypefileparam.reporttypefileid
		OPEN param1_cursor
		FETCH NEXT FROM param1_cursor INTO @ParamName, @ParamValue
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Stmt = REPLACE(@Stmt , '{' + @ParamName + '}', @ParamValue)
			SET @FileName = REPLACE(@FileName , '{' + @ParamName + '}', @ParamValue);			
			FETCH NEXT FROM param1_cursor INTO @ParamName, @ParamValue
		END
		CLOSE param1_cursor
		DEALLOCATE param1_cursor
		
		--to include date into the filename
		IF (@DateFormat IS NOT NULL AND @DateFormat <> '')
		BEGIN
			PRINT '[ReportFileInsert] ReportFormatDate'
			EXEC REPORTFORMATDATE @DateFormat, 'N', @DateStr OUT
			SELECT @Error = @@ERROR
			IF (@Error = 0)
			BEGIN
				IF (CHARINDEX('.',@FileName) >0)
					SET @FileName =  SUBSTRING(@FileName,1,CHARINDEX('.',@FileName)-1) + @dateStr + SUBSTRING(@FileName,CHARINDEX('.',@FileName), len(@FileName))
				ELSE
					SET @FileName = @FileName + @dateStr
			END
			ELSE
			BEGIN
				SET @ErrorMsg = 'An error occurred while constructing the file name: @Error=' + CAST(@Error as NVARCHAR(10))
				EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportFileInsert_FormatDate', 'error', @ErrorMsg
			END
		END

		INSERT INTO reportfile(reportid, name, filename, maxline, inline, fileurl)
		VALUES (@ReportID, @Name, @FileName, @Maxline, @Inline, @FileURL)
	
		SELECT @ReportFileID = SCOPE_IDENTITY()
		EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportFileInsert_running', 'ok', @FileName
	
		--call the REPORTSAVEFILE to export the data into CSV format
		EXEC @RetVal = REPORTSAVEFILE @ReportFileID, @Stmt, @HeaderStmt, @Separator, @Header, @Delimiter, @FileName
		SELECT @Error = @@ERROR
		IF (@Error <> 0) OR (@RetVal < 0)
		BEGIN
			SET @ErrorMsg = 'An error occured while executing ReportSaveFile:' +  CAST(@Error as NVARCHAR(10)) + ' ' + @Stmt
			EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportFileInsert', 'error', @ErrorMsg
			EXEC REPORTSTATUSUPDATE @ReportID, 'Error'
			RETURN -1
		END
		EXEC REPORTSTATUSINSERT 'file', @ReportFileID, 'ReportFileInsert_complete', 'ok', NULL
	END

	RETURN 0

END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetTimeBlockError]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetTimeBlockError]
	@TimeBlockID INT,
	@TimeBlockErrorStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	DECLARE @SubscriptionCount INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION
	PRINT 'Update TimeBlock Status'
	UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockErrorStatus
	WHERE TimeBlockID = @TimeBlockID
	AND Status = @TimeBlockSendingStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Update Subscriptions'
		--SET ROWCOUNT 100
		--SET @SubscriptionCount = 100
		--WHILE (@SubscriptionCount = 100)
		--BEGIN
		--	UPDATE MTScheduledSubscription WITH (ROWLOCK)
		--	SET Status = @SubscriptionUnallocatedStatus,
		--	ScheduleID = 0,
		--	TimeBlockID = 0
		--	WHERE TimeBlockID = @TimeBlockID
		--	AND Status = @SubscriptionPendingStatus
		--END
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetSchedulePaused]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetSchedulePaused]
	@ScheduleID INT,
	@SchedulePausedStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@TimeBlockPausedStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15)
AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @SchedulePausedStatus
	WHERE ScheduleID = @ScheduleID
	AND ((Status = @ScheduleSendingStatus) OR (Status = @SchedulePendingStatus))
	IF (@@ROWCOUNT > 0)
	BEGIN
		UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockPausedStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPendingStatus
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	SELECT @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AddSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_AddSchedule]
	@TaskID INT,
	@StartTime DATETIME,
	@EndTime DATETIME,
	@AllocatedCount INT,
	@SchedulePendingStatus VARCHAR(15)
AS
BEGIN
	DECLARE @ScheduleID INT
	DECLARE @ActualAllocatedCount INT

	INSERT INTO MTSchedule (TaskID, StartTime, EndTime, AllocatedCount, ActualAllocatedCount, Status)
	VALUES (@TaskID, @StartTime, @EndTime, @AllocatedCount, @AllocatedCount, @SchedulePendingStatus)
	SET @ScheduleID = SCOPE_IDENTITY()

	INSERT INTO MTBroadcastHistory (TaskID, ScheduleID, SubscriptionCount, CreatedOn, UpdatedOn)
	VALUES (@TaskID, @ScheduleID, @AllocatedCount, GETUTCDATE(), GETUTCDATE())	

	SELECT @ScheduleID
END
GO
/****** Object:  Table [dbo].[MTScheduledSubscription]    Script Date: 11/06/2020 08:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTScheduledSubscription](
	[ScheduledSubscriptionID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[TimeBlockID] [int] NOT NULL,
	[Status] [char](1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[ScheduledOn] [datetime] NULL,
	[StoppedOn] [datetime] NULL,
	[SentOn] [datetime] NULL,
	[MSISDN] [varchar](100) NOT NULL,
	[Data1] [nvarchar](800) NULL,
	[Data2] [nvarchar](320) NULL,
	[Data3] [nvarchar](320) NULL,
	[Data4] [nvarchar](320) NULL,
	[Data5] [nvarchar](320) NULL,
	[Data6] [nvarchar](320) NULL,
	[Data7] [nvarchar](320) NULL,
	[Data8] [nvarchar](320) NULL,
	[Data9] [nvarchar](320) NULL,
	[Data10] [nvarchar](320) NULL,
	[MTCount] [int] NULL,
	[MTMessage] [nvarchar](max) NULL,
	[MTAdhocID] [int] NULL,
 CONSTRAINT [PK_ScheduledSubscriptions] PRIMARY KEY CLUSTERED 
(
	[ScheduledSubscriptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[MT_GetPendingTimeBlock]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_GetPendingTimeBlock]
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@TimeBlockErrorStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15),
	@TaskType VARCHAR(50) = 'ListBased'
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @TimeBlockID AS INT
	DECLARE @ScheduleID	AS INT
	DECLARE @EndTime AS DATETIME
	SET @TimeBlockID = 0 

	IF(@TaskType = 'ListBased')
	BEGIN

	SELECT TOP 1 @TimeBlockID = TimeBlockID, @ScheduleID = ScheduleID,
	@EndTime = EndTime
	FROM MTTimeBlock WITH (READPAST,ROWLOCK)
	INNER JOIN Task
	ON MTTimeBlock.TaskID = Task.TaskID
	WHERE Task.Status = 'Running'
	AND (UPPER(TaskType) = UPPER(@TaskType) 
	    OR UPPER(TaskType) = UPPER('AdhocBroadcast'))
	AND MTTimeBlock.Status = @TimeBlockPendingStatus
	AND StartTime < GETUTCDATE()
	ORDER BY StartTime ASC  

	END
	ELSE
	BEGIN

	SELECT TOP 1 @TimeBlockID = TimeBlockID, @ScheduleID = ScheduleID,
	@EndTime = EndTime
	FROM MTTimeBlock WITH (READPAST,ROWLOCK)
	INNER JOIN Task
	ON MTTimeBlock.TaskID = Task.TaskID
	WHERE Task.Status = 'Running'
	AND UPPER(TaskType) = UPPER(@TaskType)
	AND MTTimeBlock.Status = @TimeBlockPendingStatus
	AND StartTime < GETUTCDATE()
	ORDER BY StartTime ASC  

	END
	

	IF (@@ROWCOUNT > 0) 
	BEGIN
		UPDATE MTTimeBlock WITH (ROWLOCK)
		SET Status = @TimeBlockSendingStatus
		WHERE TimeBlockID = @TimeBlockID
		AND Status = @TimeBlockPendingStatus
		IF (@@ROWCOUNT > 0)
		BEGIN
			UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleSendingStatus
			WHERE ScheduleID = @ScheduleID
			AND Status = @SchedulePendingStatus
		END
		ELSE
		BEGIN
			SET @TimeBlockID = 0
		END
	END
	PRINT @TimeBlockID
	SELECT @TimeBlockID
	END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetPendingTimeBlockStartTime]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetPendingTimeBlockStartTime]
	@TaskID INT,
	@StartTime DATETIME,
	@TimeBlockPendingStatus VARCHAR (15)
AS
BEGIN

	UPDATE MTTimeBlock WITH (ROWLOCK) 
	SET StartTime = @StartTime
	WHERE TaskID = @TaskID
	AND Status = @TimeBlockPendingStatus

	RETURN @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[MT_CompleteSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_CompleteSchedule]
	@ScheduleID INT,
	@ScheduleCompletedStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15),
	@TimeBlockPauseStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15)
AS
BEGIN
	DECLARE @ErrorCode INT
	SET @ErrorCode = -1
	BEGIN TRANSACTION
	IF (NOT EXISTS(SELECT * FROM MTTimeBlock WITH (NOLOCK) WHERE ScheduleID = @ScheduleID AND (Status = @TimeBlockPauseStatus OR Status = @TimeBlockPendingStatus OR Status = @TimeBlockSendingStatus)))
	BEGIN
		UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleCompletedStatus WHERE ScheduleID = @ScheduleID
		IF (@@ROWCOUNT > 0)
		BEGIN
			SET @ErrorCode = 0
		END
	END
	COMMIT TRANSACTION
	SELECT @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MO_DuplicateMOListData]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MO_DuplicateMOListData]
 @TaskID INT,
 @ListIDs VARCHAR(1000) 
AS
BEGIN

BEGIN TRY
  
  DELETE FROM MOSubscription
  WHERE (TaskID = @TaskID OR [STATUS] = 'D' )

  
  INSERT INTO MOSubscription
  (
  TaskID,
  CreatedOn,
  UpdatedOn,
  Status,
  MSISDN,
  ListID,
  SubscriptionID,
  Data1,Data2,Data3,Data4,Data5,
  Data6,Data7,Data8,Data9,Data10
  )

  SELECT
  @taskId,
  CreatedOn,
  UpdatedOn,
  [Status],
  MSISDN,
  ListID,
  SubscriptionID,
  Data1,Data2,Data3,Data4,Data5,
  Data6,Data7,Data8,Data9,Data10 
  from Subscription xyz 
  where ListID IN (SELECT val FROM dbo.f_split(@listIDs, ','))  
 
  END TRY
  BEGIN CATCH
   
    UPDATE TASK 
    SET [STATUS] = 'Error'
    WHERE TaskID = @TaskID;

	DELETE FROM MOSubscription
	WHERE TaskID=@TaskID;
    
  END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[MISC_CleanListCreationConfig]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MISC_CleanListCreationConfig]
	@ListCreationConfigID INT,
	@ListCreationConfigProcessingStatus VARCHAR(15),
	@ListCreationConfigErrorStatus VARCHAR(15),
	@SubscriptionInactiveStatus CHAR(1)
AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION
	PRINT 'Update List Creation Config Status'
	UPDATE ListCreationConfig WITH (ROWLOCK) 
	SET Status = @ListCreationConfigErrorStatus, IsClean = 'Y'
	WHERE ListCreationConfigID = @ListCreationConfigID
	AND ((Status = @ListCreationConfigProcessingStatus) OR (Status = @ListCreationConfigErrorStatus))
	AND IsClean = 'N'
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Update List Creation Config Status : Success'

		PRINT 'Clean Subscriptions'
		DELETE FROM Subscription WITH (ROWLOCK)
		WHERE ListCreationConfigID = @ListCreationConfigID
		AND Status = @SubscriptionInactiveStatus
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[COM_CopySubscribersToSubscriptionFilter]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[COM_CopySubscribersToSubscriptionFilter]
	@ListID INT
AS
BEGIN
	DELETE FROM SubscriptionFilter WHERE ListID = @ListID

	-- deletes any old data
	DELETE FROM SubscriptionFilter where GETDATE() > DATEADD(hour, 6, createdOn)
	
	INSERT INTO SubscriptionFilter (ListID, MSISDN, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10)
	SELECT ListID, MSISDN, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10
	FROM Subscription
	WHERE ListID = @ListID
END
GO
/****** Object:  StoredProcedure [dbo].[COM_CompleteListCreation]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_CompleteListCreation]
	@ListID INT,
	@ListCreationConfigID INT,
	@SubscriptionActiveStatus CHAR(1),
	@SubscriptionInactiveStatus CHAR(1)
AS
BEGIN
	UPDATE Subscription SET Status = @SubscriptionActiveStatus
	WHERE ListID = @ListID
	AND ListCreationConfigID = @ListCreationConfigID
	AND Status = @SubscriptionInactiveStatus
END
GO
/****** Object:  StoredProcedure [dbo].[COM_BulkInsertSubscription_Temp]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[COM_BulkInsertSubscription_Temp]
	@FullFilePath NVARCHAR(300)
AS 
BEGIN
	DECLARE @SQL NVARCHAR(500)

	BEGIN TRANSACTION 

	SELECT * INTO #subscription FROM subscription WHERE 1=2;

	SET @SQL = N'BULK INSERT #Subscription FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'',KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	PRINT @SQL 

	EXECUTE sp_executesql @SQL 

	IF (@@ERROR <> 0) 
	BEGIN 
	        ROLLBACK TRANSACTION 
	        RETURN -1 
	END 

	INSERT INTO subscription 
	(listid, listcreationconfigid, msisdn, status, source, createdon, updatedon,
	data1, data2, data3, data4, data5, data6, data7, data8, data9, data10)
	SELECT listid, listcreationconfigid, msisdn, status, source, createdon, updatedon,
	data1, data2, data3, data4, data5, data6, data7, data8, data9, data10 FROM #subscription

	IF (@@ERROR <> 0) 
	BEGIN 
	        ROLLBACK TRANSACTION 
	        RETURN -1 
	END 
		
	COMMIT TRANSACTION

END
GO
/****** Object:  StoredProcedure [dbo].[COM_BulkDeleteSubscription]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_BulkDeleteSubscription]
	@ListID INT,
	@FullFilePath NVARCHAR(300)
AS
BEGIN
	BEGIN TRANSACTION

	CREATE TABLE #TempMSISDNs
	(  
	  MSISDN VARCHAR(100) PRIMARY KEY CLUSTERED
	)  
	DECLARE @SQL NVARCHAR(2000)

	SET @SQL = N'BULK INSERT #TempMSISDNs FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'',KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	EXECUTE sp_executesql @SQL

	DELETE FROM Subscription
	WHERE ListID = @ListID
  AND MSISDN IN (SELECT MSISDN FROM #TempMSISDNs)

	DROP TABLE #TempMSISDNs

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[COM_BulkDeleteBlacklistedEmail]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_BulkDeleteBlacklistedEmail]
	@BlacklistID INT,
	@FullFilePath NVARCHAR(500)
AS
BEGIN
	BEGIN TRANSACTION

	CREATE TABLE #TempEmails
	(  
	  Email VARCHAR(200) PRIMARY KEY CLUSTERED
	)  
	DECLARE @SQL NVARCHAR(2000)

	SET @SQL = N'BULK INSERT #TempEmails FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'',KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	EXECUTE sp_executesql @SQL

	DELETE FROM [BlacklistedEmail]
	WHERE BlacklistID = @BlacklistID
    AND [EmailAddress] IN (SELECT Email FROM #TempEmails)

	DROP TABLE #TempEmails

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[COM_BulkDeleteBlacklistDetail]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_BulkDeleteBlacklistDetail]
	@BlacklistID INT,
	@FullFilePath NVARCHAR(500)
AS
BEGIN
	BEGIN TRANSACTION

	CREATE TABLE #TempMSISDNs
	(  
	  MSISDN VARCHAR(200) PRIMARY KEY CLUSTERED
	)  
	DECLARE @SQL NVARCHAR(2000)

	SET @SQL = N'BULK INSERT #TempMSISDNs FROM @FullFilePath WITH (FIELDTERMINATOR = ''|'',KEEPNULLS)' 
	SET @SQL = REPLACE(@SQL,'@FullFilePath','''' + @FullFilePath + '''') 

	EXECUTE sp_executesql @SQL

	DELETE FROM BlacklistDetail
	WHERE BlacklistID = @BlacklistID
  AND MSISDN IN (SELECT MSISDN FROM #TempMSISDNs)

	DROP TABLE #TempMSISDNs

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[COM_AddBlacklistedEmail]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_AddBlacklistedEmail]
						@BlacklistId INT,
						@EmailAddress VARCHAR(200),
						@Source Char(1)
						AS
						BEGIN

						IF NOT EXISTS (SELECT 1 
									   FROM BlacklistedEmail 
									   WHERE BlacklistID = @BlacklistId AND EmailAddress = @EmailAddress)
									   BEGIN
										   INSERT INTO BlacklistedEmail
										   SELECT @BlacklistId,@EmailAddress,GETUTCDATE(),@Source
									   END
						END
GO
/****** Object:  StoredProcedure [dbo].[BK_MT_GetPendingTimeBlock]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BK_MT_GetPendingTimeBlock]
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@TimeBlockErrorStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @TimeBlockID AS INT
	DECLARE @ScheduleID	AS INT
	DECLARE @TaskID	AS INT
	DECLARE @EndTime AS DATETIME
	DECLARE @CurrentStatus AS VARCHAR(15)
	DECLARE @ScheduleStatus AS VARCHAR(15)
	SET @TimeBlockID = 0 
	SET @TaskID = NULL 

	SELECT TOP 1 @TimeBlockID = TimeBlockID, @ScheduleID = ScheduleID, @TaskID = TaskID, 
	@CurrentStatus = Status, @EndTime = EndTime
	FROM MTTimeBlock
	WHERE Status = @TimeBlockPendingStatus
	AND StartTime < GETUTCDATE()
	ORDER BY StartTime ASC  

	IF (@@ROWCOUNT > 0) 
	BEGIN

		IF (EXISTS (SELECT * FROM MTSchedule WHERE TaskID = @TaskID AND @ScheduleID = ScheduleID 
		AND ((Status = @SchedulePendingStatus) OR (Status = @ScheduleSendingStatus))))
		BEGIN
	  		UPDATE MTTimeBlock WITH (ROWLOCK)
		  	SET Status = @TimeBlockSendingStatus
		  	WHERE TaskID = @TaskID
			AND ScheduleID = @ScheduleID
			AND TimeBlockID = @TimeBlockID
			AND Status = @CurrentStatus
			IF (@@ROWCOUNT = 0)
			BEGIN
				SET @TimeBlockID = 0
			END
		END
		ELSE
		BEGIN
		  	UPDATE MTTimeBlock WITH (ROWLOCK)
		  	SET Status = @TimeBlockErrorStatus
	  		WHERE TaskID = @TaskID
			AND ScheduleID = @ScheduleID
			AND TimeBlockID = @TimeBlockID
			AND Status = @CurrentStatus
			SET @TimeBlockID = 0
		END

 	END

	RETURN @TimeBlockID
END
GO
/****** Object:  StoredProcedure [dbo].[COM_UpdateListSubscriptionCount]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_UpdateListSubscriptionCount]
	@ListID INT,
	@ListReadyStatus VARCHAR(15),
	@ListEmptyStatus VARCHAR(15),
	@SubscriptionActiveStatus CHAR(1)
AS
BEGIN
	DECLARE @Count INT
	DECLARE @ListStatus VARCHAR(15)
	SELECT @Count = COUNT(*) FROM Subscription WITH (NOLOCK)
	WHERE ListID = @ListID
	
	SET @ListStatus = @ListReadyStatus
	IF (@Count <= 0)
	BEGIN
		SET @ListStatus = @ListEmptyStatus
	END
	
	UPDATE List WITH (ROWLOCK) SET Status = @ListStatus, SubscriptionsCount = @Count WHERE ListID = @ListID

	RETURN @Count
END
GO
/****** Object:  StoredProcedure [dbo].[COM_UpdateBlackListCount]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[COM_UpdateBlackListCount]
	@ListID INT
AS
BEGIN

	DECLARE @Count INT,
			@ListStatus VARCHAR(15),
			@BlacklistType VARCHAR(20)

	SET @BlacklistType = '';

	SELECT @BlacklistType = [TYPE] 
	FROM Blacklist WITH (NOLOCK)
	WHERE BlacklistID = @ListID

	IF(@BlacklistType != '')
	BEGIN
		IF(@BlacklistType = 'MT')
		BEGIN
			SELECT @Count = COUNT(*) FROM BlacklistDetail WITH (NOLOCK)
			WHERE BlacklistID = @ListID
		END
		ELSE IF(@BlacklistType = 'EMAIL')
		BEGIN
			SELECT @Count = COUNT(*) FROM BlacklistedEmail WITH (NOLOCK)
			WHERE BlacklistID = @ListID
		END
			
		UPDATE Blacklist WITH (ROWLOCK) SET BlacklistCount = @Count WHERE BlacklistID = @ListID

	END
	
	RETURN @Count
END
GO
/****** Object:  StoredProcedure [dbo].[DataRetentionProcedure]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DataRetentionProcedure]
              @organizationID INT,
              @NoOfDays int,
              @isMsgReplaced varchar(20),
              @msg varchar(30),
              @isMsisdnReplaced varchar(20),
              @msisdn varchar(30),
              @DataRetentionID int
       AS
       BEGIN
           SET NOCOUNT ON
              PRINT @organizationID
              PRINT @NoOfDays 
              PRINT @msg 
              PRINT @msisdn 
              PRINT @DataRetentionID
              PRINT @isMsgReplaced
              PRINT @isMsisdnReplaced
			  
			  DECLARE @subscriptionCount NUMERIC(18,0),
					  @listCount INT,
					  @MTScheduledSubscriptionCount NUMERIC(18,0),
					  @MTTrafficCount NUMERIC(18,0),
					  @MOContentCount NUMERIC(18,0),
					  @MOVerificationMOEntryCount NUMERIC(18,0),
					  @MOTrafficCount NUMERIC(18,0),
					  @status varchar(4000)
					  

		BEGIN TRANSACTION


		BEGIN TRY
			
				--Temp table to store MT and MO Task IDs
                  CREATE TABLE #TempMTMOTaskIDs
                     ( 
                     TaskID INT PRIMARY KEY CLUSTERED 
                     ) 
					 INSERT INTO #TempMTMOTaskIDs
						SELECT DISTINCT Task.TaskID FROM Task WITH (NOLOCK)
                                                INNER JOIN [User] on Task.CreatorID=[User].UserID
                                                WHERE [User].OrganizationID=@organizationID 
											
				
				
				-------------------------------------------------------------------------------------------	
				--Temp table to store List IDs
                  CREATE TABLE #TempListIDs
                     ( 
                     ListID INT PRIMARY KEY CLUSTERED 
                     ) 
                     INSERT INTO #TempListIDs 
                     SELECT DISTINCT [List].ListID FROM List WITH (NOLOCK)
                                                INNER JOIN [User] on List.CreatorID=[User].UserID
                                                INNER JOIN [Subscription] on [Subscription].ListID=[List].ListID
												INNER JOIN [ListType] on [ListType].ListTypeID=[List].ListTypeID
                                                WHERE [User].OrganizationID=@organizationID
												AND ListType.ListContentType !='Validation'
												AND DATEADD(DAY,@NoOfDays,Subscription.CreatedOn) <=GETUTCDATE()
												
                     
                  PRINT 'Subscription TABLE'
                     UPDATE Subscription WITH (ROWLOCK)
                     SET MSISDN=CASE WHEN (@isMsisdnReplaced= 'Y') THEN @msisdn ELSE MSISDN END
                     WHERE EXISTS (SELECT #TempListIDs.ListID FROM #TempListIDs
									WHERE [Subscription].ListID = #TempListIDs.ListID)
					 
					 select @subscriptionCount = @@ROWCOUNT

					UPDATE List SET RecordStatus='R' WHERE EXISTS (SELECT #TempListIDs.ListID FROM #TempListIDs
																WHERE [List].ListID = #TempListIDs.ListID)
					
					select @listCount = @@ROWCOUNT
                                                
            --Dropping Temp Table #TempListIDs
                     DROP TABLE #TempListIDs

            
                     
              -------------------------------------------------------------------------------------------
			  
			  							
                     PRINT 'MTScheduledSubscription TABLE'
                     UPDATE MTScheduledSubscription WITH (ROWLOCK)
                     SET MSISDN=CASE WHEN (@isMsisdnReplaced='Y') THEN @msisdn ELSE MSISDN END
                     WHERE MTScheduledSubscription.Status NOT IN ('N','P') 
					 AND EXISTS
                     (SELECT DISTINCT [#TempMTMOTaskIDs].TaskID FROM #TempMTMOTaskIDs WITH (NOLOCK)
                                                WHERE MTScheduledSubscription.TaskID=[#TempMTMOTaskIDs].TaskID
                                                AND DATEADD(DAY,@NoOfDays,[MTScheduledSubscription].CreatedOn) <=GETUTCDATE()
												AND (MTScheduledSubscription.Status='S' OR MTScheduledSubscription.Status='X')) 
            
                     select @MTScheduledSubscriptionCount = @@ROWCOUNT
					 
					 
              -------------------------------------------------------------------------------------------
                         PRINT 'MTTraffic TABLE'
                         UPDATE MTTraffic WITH (ROWLOCK)
                           SET MSISDN=CASE WHEN (@isMsisdnReplaced='Y') THEN @msisdn ELSE MSISDN END,
                           [Message]=CASE WHEN (@isMsgReplaced='Y') THEN @msg ELSE [Message] END 
                           WHERE EXISTS
                         (SELECT DISTINCT [#TempMTMOTaskIDs].TaskID FROM #TempMTMOTaskIDs WITH (NOLOCK)
                                                WHERE MTTraffic.TaskID=#TempMTMOTaskIDs.TaskID
                                                AND DATEADD(DAY,@NoOfDays,MTTraffic.CreatedOn) <=GETUTCDATE())
						
							select @MTTrafficCount = @@ROWCOUNT
                
                           
              -------------------------------------------------------------------------------------------
			  
						     
                           PRINT 'MOContent TABLE'
                         UPDATE MOContent WITH (ROWLOCK)
                           SET MSISDN=CASE WHEN (@isMsisdnReplaced='Y') THEN @msisdn ELSE MSISDN END,
                           MOContent=CASE WHEN (@isMsgReplaced='Y') THEN @msg ELSE MOContent END  
                           WHERE EXISTS
                         (SELECT DISTINCT [#TempMTMOTaskIDs].TaskID FROM #TempMTMOTaskIDs WITH (NOLOCK)
                                                WHERE MOContent.TaskID=[#TempMTMOTaskIDs].TaskID
                                                AND DATEADD(DAY,@NoOfDays,[MOContent].CreatedOn) <=GETUTCDATE())
               
                           select @MOContentCount = @@ROWCOUNT
						   
						   
         -------------------------------------------------------------------------------------------                                                    
                      
                         PRINT 'MOVerificationMOEntry TABLE'
                         UPDATE MOVerificationMOEntry WITH (ROWLOCK)
                           SET MSISDN=CASE WHEN (@isMsisdnReplaced='Y') THEN @msisdn ELSE MSISDN END,
                           OriginalMessage=CASE WHEN (@isMsgReplaced='Y') THEN @msg ELSE OriginalMessage END   
                           WHERE EXISTS
                         (SELECT DISTINCT [#TempMTMOTaskIDs].TaskID FROM #TempMTMOTaskIDs WITH (NOLOCK)
                                                WHERE MOVerificationMOEntry.TaskID=[#TempMTMOTaskIDs].TaskID
                                                AND DATEADD(DAY,@NoOfDays,[MOVerificationMOEntry].CreatedOn) <=GETUTCDATE())
                           
                           select @MOVerificationMOEntryCount = @@ROWCOUNT
						   
						   
              -------------------------------------------------------------------------------------------
              
                     PRINT 'MOTraffic TABLE'
                     IF (@DataRetentionID <> 0)
                     BEGIN
					 
								CREATE TABLE #CustomerIDs
									 ( 
									 CustomerID VARCHAR(100) PRIMARY KEY CLUSTERED 
									 ) 

								DECLARE @CustXML XML

								select @CustXML = (select  CAST(
									REPLACE(CAST(CustomerID AS VARCHAR(MAX)), '<?xml version="1.0" encoding="utf-16"?>', '')
								  AS XML) from DataRetention where DataRetentionID=@DataRetentionID)

								INSERT INTO #CustomerIDs 
									SELECT T.item.value('.', 'VARCHAR(100)')
								FROM @CustXML.nodes('CToolLoginIDHubAccountLists/CToolLoginIDHubAccountList/CToolLoginIDHubAccount/CToolLoginID') AS T(item);

                                  UPDATE MOTraffic WITH (ROWLOCK)
                                  SET MSISDN=CASE WHEN (@isMsisdnReplaced='Y') THEN @msisdn ELSE MSISDN END,
                                  [Message]=CASE WHEN (@isMsgReplaced='Y') THEN @msg ELSE [Message] END
                                  WHERE CustomerID in (select CustomerID from #CustomerIDs)
                     
								DROP TABLE #CustomerIDs
								
								select @MOTrafficCount = @@ROWCOUNT
								
                           
                     END
			--Dropping Temp Table #TempMTMOTaskIDs
                     DROP TABLE #TempMTMOTaskIDs
	
		select @status='SUCCESS'
		COMMIT TRANSACTION
		
	END TRY

	BEGIN CATCH
		  
		  --select @status='ERROR'
		  
		  DECLARE @Errseverity INT

		SELECT @status = 'ERROR: ' +Error_message(),@ErrSeverity = Error_severity()
		  IF (@@TRANCOUNT > 0)
			BEGIN
				ROLLBACK TRANSACTION
			END
			
			 select @subscriptionCount =0,
					@listCount =0,
					@MTScheduledSubscriptionCount =0,
					@MTTrafficCount =0,
					@MOContentCount =0,
					@MOVerificationMOEntryCount =0,
					@MOTrafficCount =0
		   
	END CATCH
	   ---Insert Data in LOG table
	   INSERT INTO [dbo].[DataRetentionLog]
           ([organizationID]
           ,[status]
           ,[subscriptionCount]
           ,[listCount]
           ,[MTScheduledSubscriptionCount]
           ,[MTTrafficCount]
           ,[MOContentCount]
           ,[MOVerificationMOEntryCount]
           ,[MOTrafficCount])
		VALUES (@organizationID,
				@status,
				@subscriptionCount
				,@listCount
				,@MTScheduledSubscriptionCount
				,@MTTrafficCount
				,@MOContentCount
				,@MOVerificationMOEntryCount
				,@MOTrafficCount)
	   
	END
GO
/****** Object:  StoredProcedure [dbo].[Email_GetEmailBasedTaskInfo]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Email_GetEmailBasedTaskInfo]
						@TaskID INT,
						@SubscriptionInactiveStatus CHAR(1),
						@SubscriptionUnallocatedStatus CHAR(1),
						@SubscriptionPendingStatus CHAR(1),
						@SubscriptionSentStatus CHAR(1),
						@SubscriptionBlacklistedStatus CHAR(1),
						@SubscriptionErrorStatus CHAR(1)
					AS
					BEGIN
						SET NOCOUNT ON

						DECLARE @TotalCount INT
						DECLARE @PendingCount INT
						DECLARE @SentCount INT
						DECLARE @UnallocatedCount INT
						DECLARE @BlacklistCount INT
						DECLARE @ErrorCount INT

						SELECT @TotalCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
						WHERE TaskID = @TaskID 
						AND Status <> @SubscriptionInactiveStatus

						SELECT @UnallocatedCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
						WHERE TaskID = @TaskID 
						AND Status = @SubscriptionUnallocatedStatus

						SELECT @PendingCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
						WHERE TaskID = @TaskID 
						AND Status = @SubscriptionPendingStatus

						SELECT @SentCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
						WHERE TaskID = @TaskID 
						AND Status = @SubscriptionSentStatus

						SELECT @BlacklistCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
						WHERE TaskID = @TaskID 
						AND Status = @SubscriptionBlacklistedStatus

						SELECT @ErrorCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
						WHERE TaskID = @TaskID 
						AND Status = @SubscriptionErrorStatus

						SELECT EmailTask.*, 
						Task.TaskName, Task.Status, Task.Timezone, 
						ApprovalProcess.ApprovalStatus, ApprovalProcess.ApprovalXML, ApprovalProcess.PendingApproverID, 
						List.ListName, ListType.ListTypeName, Blacklist.BlacklistName,
						@TotalCount AS TotalCount, @UnallocatedCount AS UnallocatedCount,
						@PendingCount AS PendingCount, @SentCount AS SentCount, 
						@BlacklistCount AS BlacklistCount, @ErrorCount AS ErrorCount
						FROM EmailTask WITH (NOLOCK)
						INNER JOIN Task ON EmailTask.TaskID = Task.TaskID
						LEFT JOIN ApprovalProcess ON ApprovalProcess.ApprovalObjectID = EmailTask.TaskID
						LEFT JOIN List ON EmailTask.ListID = List.ListID
						LEFT JOIN ListType ON List.ListTypeID = ListType.ListTypeID 
						LEFT JOIN Blacklist ON EmailTask.BlacklistID = Blacklist.BlacklistID
						WHERE EmailTask.TaskID = @TaskID
					END
GO
/****** Object:  StoredProcedure [dbo].[Email_ApplyBlacklistToSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Email_ApplyBlacklistToSubscriptions]
  @TaskID INT,
  @ScheduleID INT,
  @BlacklistID INT,
  @SubscriptionBlacklistedStatus CHAR(1)
AS

BEGIN

	UPDATE MTScheduledSubscription WITH (ROWLOCK)
	SET Status = @SubscriptionBlacklistedStatus
	WHERE TaskID = @TaskID 
	AND ((@ScheduleID = 0) OR (ScheduleID = @ScheduleID))
	AND MSISDN IN (SELECT EmailAddress FROM BlacklistedEmail WHERE BlacklistID = @BlacklistID)

	SELECT @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[DEBUG_ShowMTTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[DEBUG_ShowMTTask]
	@TaskID INT
AS
BEGIN
	SELECT * FROM Task WITH (NOLOCK) WHERE TaskID = @TaskID
	SELECT * FROM MTTask WITH (NOLOCK) WHERE TaskID = @TaskID
	SELECT * FROM MTSchedule WITH (NOLOCK) WHERE TaskID = @TaskID
	SELECT * FROM MTTimeBlock WITH (NOLOCK) WHERE TaskID = @TaskID
	SELECT * FROM MTScheduledSubscription WITH (NOLOCK) WHERE TaskID = @TaskID
END
GO
/****** Object:  StoredProcedure [dbo].[DEBUG_RestartMTTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[DEBUG_RestartMTTask]
	@TaskID INT
AS
BEGIN
	UPDATE Task SET Status = 'Running' WHERE TaskID = @TaskID
	UPDATE MTTask SET ProcessStartTime = GETUTCDATE() WHERE TaskID = @TaskID
	UPDATE MTSchedule SET Status = 'Pending', AllocatedCount = 0, ActualAllocatedCount = 0, ProcessedCount = 0 WHERE TaskID = @TaskID
	UPDATE MTTimeBlock SET Status = 'Pending' WHERE TaskID = @TaskID
	DELETE FROM MTBroadcastHistory WHERE TaskID = @TaskID
	UPDATE MTScheduledSubscription SET Status = 'P', SentOn = NULL WHERE TaskID = @TaskID
	--UPDATE MTScheduledSubscription SET Status = 'I', ScheduleID = 0, TimeBlockID = 0 WHERE TaskID = @TaskID
	PRINT 'Task Reset'
END
GO
/****** Object:  StoredProcedure [dbo].[DEBUG_ResetMTTask]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[DEBUG_ResetMTTask]
	@TaskID INT
AS
BEGIN
	UPDATE Task SET Status = 'New' WHERE TaskID = @TaskID
	UPDATE MTTask SET ProcessStartTime = GETUTCDATE() WHERE TaskID = @TaskID
	UPDATE MTSchedule SET Status = 'New', AllocatedCount = 0, ActualAllocatedCount = 0, ProcessedCount = 0 WHERE TaskID = @TaskID
	DELETE FROM MTTimeBlock WHERE TaskID = @TaskID
	DELETE FROM MTBroadcastHistory WHERE TaskID = @TaskID
	DELETE FROM MTScheduledSubscription WHERE TaskID = @TaskID
	--UPDATE MTScheduledSubscription SET Status = 'P', ScheduleID = 0, TimeBlockID = 0 WHERE TaskID = @TaskID
	PRINT 'Task Reset'
END
GO
/****** Object:  StoredProcedure [dbo].[InsertMTTraffic]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertMTTraffic]
@AppSubID VARCHAR(100),
@To VARCHAR(100),
@From VARCHAR(100),
@Class VARCHAR(200),
@GroupID VARCHAR(100),
@Message VARCHAR(500),
@OrderID VARCHAR(100),
@Via VARCHAR(300),
@Status VARCHAR(100),
@Details VARCHAR(1000),
@Created DATETIME,
@Updated DATETIME,
@SubscriptionID VARCHAR(100) = ''

AS
BEGIN

SET DEADLOCK_PRIORITY -7;
SET LOCK_TIMEOUT 10000; --10 Seconds
SET XACT_ABORT ON;


	DECLARE @TaskID VARCHAR(100)
	DECLARE @ScheduleID VARCHAR(100)
	DECLARE @SubID VARCHAR(100),
	@MTScheduledSubscriptionID INT

	SET @TaskID = SUBSTRING(@AppSubID, 0, CHARINDEX('_', @AppSubID))
	PRINT @TaskID
	SET @AppSubID = SUBSTRING(@AppSubID, CHARINDEX('_', @AppSubID) + 1, LEN(@AppSubID))
	SET @ScheduleID = SUBSTRING(@AppSubID, 0, CHARINDEX('_', @AppSubID))
	PRINT @ScheduleID
	SET @SubID = SUBSTRING(@AppSubID, CHARINDEX('_', @AppSubID) + 1, LEN(@AppSubID))
	PRINT @SubID

	IF(@SubscriptionID != '')
	BEGIN
		SET @SubID = @SubscriptionID;
	END

		INSERT INTO MTTraffic
		VALUES (@TaskID, @ScheduleID,
		@To, @GroupID, @Message, @OrderID, @Via, @Status, @Details, GETUTCDATE(), GETUTCDATE(), @SubID)

		
	 SET @MTScheduledSubscriptionID = Cast(@SubID as numeric(18,0))

	 IF(@MTScheduledSubscriptionID > 0 
     AND @TaskID > 0) 
	  BEGIN 

	  SET @Status = Substring(@status,1,1)
	  IF(@Status = 'E')
	  BEGIN
	                  UPDATE MTScheduledSubscription
					  SET    [status] = (CASE WHEN [STATUS] = 'E' THEN [STATUS] ELSE  @Status END),
					  StoppedOn = GETUTCDATE()
					  WHERE ScheduledSubscriptionID =  @MTScheduledSubscriptionID
					  AND [STATUS] ! = @Status
	  END
		 
	  END

  SET DEADLOCK_PRIORITY NORMAL;
  SET LOCK_TIMEOUT -1;

END
GO
/****** Object:  StoredProcedure [dbo].[Email_RefreshBroadcastHistory]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Email_RefreshBroadcastHistory]
	@TaskID INT,
	@BlacklistedStatus CHAR(1),
	@SubmittedStatus VARCHAR(20),
	@ReceivedStatus VARCHAR(20),
	@RejectStatus VARCHAR(20),
	@FailedStatus VARCHAR(200),
	@HardBounceStatus VARCHAR(20),
	@SoftBounce VARCHAR(20)
AS
BEGIN

SET NOCOUNT ON;

	DECLARE @BlacklistedCount INT
	DECLARE @ProcessedCount INT
	DECLARE @SubmittedCount INT
	DECLARE @NoAckCount INT
	DECLARE @OpAckCount INT
	DECLARE @HandSetAckCount INT
	DECLARE @RejectCount INT
	DECLARE @FailCount INT

	SELECT @BlacklistedCount = count(*) FROM MTScheduledSubscription WITH (NOLOCK) WHERE TaskID = @TaskID AND [Status] = @BlacklistedStatus
	SELECT @ProcessedCount = count(*) FROM EmailTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND [Status] = @ReceivedStatus
	SELECT @SubmittedCount = count(*) FROM EmailTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND [Status] = @SubmittedStatus
	SELECT @OpAckCount = count(*) FROM EmailTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND  Details = @HardBounceStatus
	SELECT @NoAckCount = count(*) FROM EmailTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND Details = @SoftBounce
	SELECT @RejectCount = count(*) FROM EmailTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND [Status] = @RejectStatus
	SELECT @FailCount = count(*) FROM EmailTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND [Status] IN (select val from dbo.f_split(@FailedStatus,','));

	UPDATE MTBroadcastHistory
	SET MTCount = @SubmittedCount, --caas_received
	MTSent = @ProcessedCount,--ch_sent
	Blacklisted = @BlacklistedCount,
	MTFailed = @FailCount, --CAAS_ERROR,MM_ERROR1,MM_ERROR2,CH_ERROR,CAAS_REJECTED
	MTNoAck = @NoAckCount, --soft_bounce
	MTOperatorAck = @OpAckCount, --hard_bounce
	MTRejected = @RejectCount,--ch_rejected
	MTUndelivered = 0,
	UpdatedOn = GETUTCDATE()
	WHERE TaskID = @TaskID

END
GO
/****** Object:  StoredProcedure [dbo].[MT_CleanSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_CleanSchedule]
	@ScheduleID INT,
	@ExpireStatus VARCHAR(15),
	@PauseStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)

AS
BEGIN
	BEGIN TRANSACTION
	
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ExpireStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @PauseStatus
	AND EndTime < GETUTCDATE()

	IF (@@ROWCOUNT > 0)
	BEGIN
		UPDATE MTScheduledSubscription WITH (ROWLOCK) 
		SET @ScheduleID = 0, TimeBlockID = 0, Status = @SubscriptionUnallocatedStatus
		WHERE ScheduleID = @ScheduleID AND Status = @SubscriptionPendingStatus
	END

	COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [dbo].[MT_CancelSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[MT_CancelSchedule]
	@ScheduleID INT,
	@ScheduleCancelStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)
AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION
	PRINT 'Update Schedule Status'
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleCancelStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePendingStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Update Schedule Status : Success'
		PRINT 'Delete TimeBlocks'
		DELETE FROM MTTimeBlock 
		WHERE ScheduleID = @ScheduleID
		PRINT 'Delete TimeBlocks : Success'

		PRINT 'Update Subscriptions'
		UPDATE MTScheduledSubscription 
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		PRINT 'Update Subscriptions : Success'
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

END
GO
/****** Object:  StoredProcedure [dbo].[MT_ApplyBlacklistToSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_ApplyBlacklistToSubscriptions]
  @TaskID INT,
  @ScheduleID INT,
  @BlacklistID INT,
  @SubscriptionBlacklistedStatus CHAR(1)
AS

BEGIN

	UPDATE MTScheduledSubscription WITH (ROWLOCK)
	SET Status = @SubscriptionBlacklistedStatus
	WHERE TaskID = @TaskID 
	AND ((@ScheduleID = 0) OR (ScheduleID = @ScheduleID))
	AND MSISDN IN (SELECT MSISDN FROM BlacklistDetail WHERE BlacklistID = @BlacklistID)

	SELECT @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AllocateTimeBlockSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_AllocateTimeBlockSubscriptions]
	@TaskID INT,
	@ScheduleID INT,
	@StartTime DATETIME,
	@EndTime DATETIME,
	@MaxTimeBlockSize INT,
	@AllocateCount INT,
	@TimeBlockPendingStatus VARCHAR(15),
	@SubscriptionOriginalStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @CurrentAllocatedCount INT
	DECLARE @TotalAllocatedCount INT
	DECLARE @RemainCount INT
	DECLARE @ErrorCount INT
	DECLARE @TimeBlockID INT
	DECLARE @TimeBlockSize INT
	DECLARE @IsInExternalTransaction BIT

	SET @IsInExternalTransaction = 0
	IF (@@TRANCOUNT > 0)
	BEGIN
		SET @IsInExternalTransaction = 1
	END

	IF (@IsInExternalTransaction = 0)
	BEGIN
		--BEGIN TRANSACTION
		PRINT 'NO Transaction Start'
	END

	SET @TotalAllocatedCount = 0


	SELECT @RemainCount = COUNT(*) FROM MTScheduledSubscription 
	WHERE TaskID = @TaskID 
	AND ScheduleID = 0 
	AND TimeBlockID = 0 
	AND Status = @SubscriptionOriginalStatus

	IF ((@AllocateCount IS NOT NULL) AND (@RemainCount > @AllocateCount))
	BEGIN
		SET @RemainCount = @AllocateCount
	END

	IF (@RemainCount = 0)
	BEGIN
		INSERT INTO MTTimeBlock VALUES (@TaskID, @ScheduleID, @StartTime, @EndTime, @TimeBlockPendingStatus)
	END
	ELSE
	BEGIN
		WHILE (@RemainCount > 0)
		BEGIN
			INSERT INTO MTTimeBlock VALUES (@TaskID, @ScheduleID, @StartTime, @EndTime, @TimeBlockPendingStatus)
			SET @TimeBlockID = @@IDENTITY
			
			SET @TimeBlockSize = @MaxTimeBlockSize
			IF (@RemainCount < @MaxTimeBlockSize)
			BEGIN
				SET @TimeBlockSize = @RemainCount
			END

			SET ROWCOUNT @TimeBlockSize
			UPDATE MTScheduledSubscription WITH (ROWLOCK) SET ScheduleID = @ScheduleID, TimeBlockID = @TimeBlockID, Status = @SubscriptionPendingStatus, ScheduledOn = @StartTime
			WHERE TaskID = @TaskID  
			AND ScheduleID = 0
			AND TimeBlockID = 0
			AND Status = @SubscriptionOriginalStatus
			SET @CurrentAllocatedCount = @@ROWCOUNT
			IF (@CurrentAllocatedCount <= 0)
			BEGIN
				PRINT 'Subscriptions are less than expected'
				SET @RemainCount = 0
			END
			ELSE
			BEGIN
				SET @TotalAllocatedCount = @TotalAllocatedCount + @CurrentAllocatedCount
				SET @RemainCount = @RemainCount - @CurrentAllocatedCount
			END
			PRINT 'Created TimeBlock [ID: ' + CAST(@TimeBlockID AS VARCHAR) + '] [Start: ' + CAST(@StartTime AS VARCHAR) + '] [Allocate: ' + CAST(@CurrentAllocatedCount AS VARCHAR) + ']'
		END
	END

	IF (@IsInExternalTransaction = 0)
	BEGIN
		SET @IsInExternalTransaction = 0
		--COMMIT TRANSACTION
		PRINT 'No Transaction End'
	END
	PRINT 'Total Allocated: ' + CAST(@TotalAllocatedCount AS VARCHAR)
	RETURN @TotalAllocatedCount
END
GO
/****** Object:  StoredProcedure [dbo].[MT_ResumeSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_ResumeSchedule]
	@ScheduleID INT,
	@ScheduleSendingStatus VARCHAR(15),
	@ScheduleExpireStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@SchedulePauseStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockPauseStatus VARCHAR(15),
	@TimeBlockExpiredStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)
AS
BEGIN
	
	DECLARE @ErrorCode INT
	SET @ErrorCode = -1
	BEGIN TRANSACTION

	--Schedule Already Started
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleSendingStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePauseStatus
	AND StartTime <= GETUTCDATE()
	AND ((EndTime IS NULL) OR EndTime >= GETUTCDATE())
	IF (@@ROWCOUNT > 0)
	BEGIN
		UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockPendingStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPauseStatus
		SET @ErrorCode = 0
	END

	--Schedule Expired
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleExpireStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePauseStatus
	AND ((EndTime IS NOT NULL) AND (EndTime < GETUTCDATE()))
	IF (@@ROWCOUNT > 0)
	BEGIN
		UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockExpiredStatus
		WHERE ScheduleID = @ScheduleID
		AND ((Status = @TimeBlockPauseStatus) OR (Status = @TimeBlockPendingStatus))

		UPDATE MTScheduledSubscription WITH (ROWLOCK) 
		SET Status = @SubscriptionUnallocatedStatus, ScheduleID = 0, TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		SET @ErrorCode = 0
	END

	--Schedule not Started
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @SchedulePendingStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePauseStatus
	AND StartTime > GETUTCDATE()
	IF (@@ROWCOUNT > 0)
	BEGIN
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_RefreshBroadcastHistory]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_RefreshBroadcastHistory]
	@TaskID INT,
	@ScheduleID INT,
	@BlacklistedStatus CHAR(1),
	@NoAckStatus VARCHAR(15),
	@OpAckStatus VARCHAR(15),
	@HandSetAckStatus VARCHAR(15),
	@RejectStatus VARCHAR(15),
	@FailStatus VARCHAR(15)
		
AS

BEGIN
	DECLARE @BlacklistedCount INT
	DECLARE @ProcessedCount INT
	DECLARE @NoAckCount INT
	DECLARE @OpAckCount INT
	DECLARE @HandSetAckCount INT
	DECLARE @RejectCount INT
	DECLARE @FailCount INT

	SELECT @BlacklistedCount = count(*) FROM MTScheduledSubscription WITH (NOLOCK) WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID AND Status = @BlacklistedStatus
	SELECT @ProcessedCount = count(*) FROM MTTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID
	SELECT @NoAckCount = count(*) FROM MTTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID AND Status = @NoAckStatus
	SELECT @OpAckCount = count(*) FROM MTTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID AND Status = @OpAckStatus
	SELECT @HandSetAckCount = count(*) FROM MTTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID AND Status = @HandSetAckStatus
	SELECT @RejectCount = count(*) FROM MTTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID AND Status = @RejectStatus
	SELECT @FailCount = count(*) FROM MTTraffic WITH (NOLOCK) WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID AND Status = @FailStatus

	UPDATE MTBroadcastHistory
	SET MTCount = @ProcessedCount, 
	MTSent = @ProcessedCount,
	Blacklisted = @BlacklistedCount,
	MTFailed = @FailCount,
	MTProcessed = @ProcessedCount,
	MTNoAck = @NoAckCount,
	MTOperatorAck = @OpAckCount,
	MTHandSetAck = @HandSetAckCount,
	MTRejected = @RejectCount,
	MTUndelivered = 0,
	UpdatedOn = GETUTCDATE()
	WHERE TaskID = @TaskID AND ScheduleID = @ScheduleID

END
GO
/****** Object:  StoredProcedure [dbo].[MT_GetTimeBlockSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_GetTimeBlockSubscriptions]
	@TimeBlockID INT,
	@SubscriptionStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	SELECT * FROM MTScheduledSubscription
	WHERE TimeBlockID = @TimeBlockID
	AND Status = @SubscriptionStatus
	AND StoppedOn IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[MT_GetListBasedTaskInfo]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_GetListBasedTaskInfo]
	@TaskID INT,
	@SubscriptionInactiveStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionSentStatus CHAR(1),
	@SubscriptionBlacklistedStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @TotalCount INT = 0
	DECLARE @PendingCount INT = 0
	DECLARE @SentCount INT = 0
	DECLARE @UnallocatedCount INT = 0
	DECLARE @BlacklistCount INT = 0
	DECLARE @ErrorCount INT = 0

	SELECT @TotalCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
	WHERE TaskID = @TaskID 
	AND Status <> @SubscriptionInactiveStatus

	SELECT @UnallocatedCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
	WHERE TaskID = @TaskID 
	AND Status = @SubscriptionUnallocatedStatus

	SELECT @PendingCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
	WHERE TaskID = @TaskID 
	AND Status = @SubscriptionPendingStatus

	SELECT @SentCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
	WHERE TaskID = @TaskID 
	AND [Status] IN ('S','E','D','R','O') -- SUM OF SUBMITTED,ERROR,DELIVERED,REJECTED,OPERATOR ACK(SENT).

	SELECT @BlacklistCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
	WHERE TaskID = @TaskID 
	AND [Status] = @SubscriptionBlacklistedStatus

	SELECT @ErrorCount = COUNT(*) FROM MTScheduledSubscription WITH (NOLOCK)
	WHERE TaskID = @TaskID 
	AND Status = @SubscriptionErrorStatus

	SELECT MTTask.*, 
	Task.TaskName, Task.Status, Task.Timezone, 
	ApprovalProcess.ApprovalStatus, ApprovalProcess.ApprovalXML, ApprovalProcess.PendingApproverID, 
	List.ListName, ListType.ListTypeName, Blacklist.BlacklistName,
	@TotalCount AS TotalCount, @UnallocatedCount AS UnallocatedCount,
	@PendingCount AS PendingCount, @SentCount AS SentCount, 
	@BlacklistCount AS BlacklistCount, 0 AS ErrorCount,Task.RetentionStatus,Task.RetentionRunOn,Task.RetentionRunOn,Task.RetentionPeriod
	FROM MTTask WITH (NOLOCK)
	INNER JOIN Task ON MTTask.TaskID = Task.TaskID
	LEFT JOIN ApprovalProcess ON ApprovalProcess.ApprovalObjectID = MTTask.TaskID
	LEFT JOIN List ON MTTask.ListID = List.ListID
	LEFT JOIN ListType ON List.ListTypeID = ListType.ListTypeID 
	LEFT JOIN Blacklist ON MTTask.BlacklistID = Blacklist.BlacklistID
	WHERE MTTask.TaskID = @TaskID
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AllocateAdhocTimeBlockSubscriptions]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_AllocateAdhocTimeBlockSubscriptions]
	@TaskID INT,
	@ScheduleID INT,
	@MTAdhocID INT,
	@StartTime DATETIME,
	@EndTime DATETIME,
	@MaxTimeBlockSize INT,
	@AllocateCount INT,
	@TimeBlockPendingStatus VARCHAR(15),
	@SubscriptionOriginalStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @CurrentAllocatedCount INT
	DECLARE @TotalAllocatedCount INT
	DECLARE @RemainCount INT
	DECLARE @ErrorCount INT
	DECLARE @TimeBlockID INT
	DECLARE @TimeBlockSize INT
	DECLARE @IsInExternalTransaction BIT

	SET @IsInExternalTransaction = 0
	IF (@@TRANCOUNT > 0)
	BEGIN
		SET @IsInExternalTransaction = 1
	END

	IF (@IsInExternalTransaction = 0)
	BEGIN
		--BEGIN TRANSACTION
		PRINT 'NO Transaction Start'
	END

	SET @TotalAllocatedCount = 0


	SELECT @RemainCount = COUNT(*) FROM MTScheduledSubscription 
	WHERE TaskID = @TaskID 
	AND ISNULL(MTAdhocID,0) = @MTAdhocID
	AND ScheduleID = 0 
	AND TimeBlockID = 0
	AND Status = @SubscriptionOriginalStatus

	IF ((@AllocateCount IS NOT NULL) AND (@RemainCount > @AllocateCount))
	BEGIN
		SET @RemainCount = @AllocateCount
	END

	IF (@RemainCount = 0)
	BEGIN
		INSERT INTO MTTimeBlock VALUES (@TaskID, @ScheduleID, @StartTime, @EndTime, @TimeBlockPendingStatus)
	END
	ELSE
	BEGIN
		WHILE (@RemainCount > 0)
		BEGIN
			INSERT INTO MTTimeBlock VALUES (@TaskID, @ScheduleID, @StartTime, @EndTime, @TimeBlockPendingStatus)
			SET @TimeBlockID = @@IDENTITY
			
			SET @TimeBlockSize = @MaxTimeBlockSize
			IF (@RemainCount < @MaxTimeBlockSize)
			BEGIN
				SET @TimeBlockSize = @RemainCount
			END

			SET ROWCOUNT @TimeBlockSize
			UPDATE MTScheduledSubscription WITH (ROWLOCK) SET ScheduleID = @ScheduleID, TimeBlockID = @TimeBlockID, Status = @SubscriptionPendingStatus, ScheduledOn = @StartTime
			WHERE TaskID = @TaskID  
			AND ISNULL(MTAdhocID,0) = @MTAdhocID
			AND ScheduleID = 0
			AND TimeBlockID = 0
			AND Status = @SubscriptionOriginalStatus
			SET @CurrentAllocatedCount = @@ROWCOUNT
			IF (@CurrentAllocatedCount <= 0)
			BEGIN
				PRINT 'Subscriptions are less than expected'
				SET @RemainCount = 0
			END
			ELSE
			BEGIN
				SET @TotalAllocatedCount = @TotalAllocatedCount + @CurrentAllocatedCount
				SET @RemainCount = @RemainCount - @CurrentAllocatedCount
			END
			PRINT 'Created TimeBlock [ID: ' + CAST(@TimeBlockID AS VARCHAR) + '] [Start: ' + CAST(@StartTime AS VARCHAR) + '] [Allocate: ' + CAST(@CurrentAllocatedCount AS VARCHAR) + ']'
		END
	END

	IF (@IsInExternalTransaction = 0)
	BEGIN
		SET @IsInExternalTransaction = 0
		--COMMIT TRANSACTION
		PRINT 'No Transaction End'
	END
	PRINT 'Total Allocated: ' + CAST(@TotalAllocatedCount AS VARCHAR)
	RETURN @TotalAllocatedCount
END
GO
/****** Object:  StoredProcedure [dbo].[Prc_RefundAgainstFailedSubscription]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Prc_RefundAgainstFailedSubscription]
@ProcessMTAfterMinutes INT,
@statusToRefund VARCHAR(200)
AS
BEGIN
SET NOCOUNT ON

                DECLARE @CurrentUTCTime DATETIME

                SELECT @CurrentUTCTime = GETUTCDATE();
        	
				DECLARE @RefundStatus TABLE (StatusRefund VARCHAR(200))

                INSERT INTO @RefundStatus
                SELECT  LTRIM(RTRIM(UPPER(val)))
                FROM    [DBO].f_Split(@statusToRefund, ',') 

							
				PRINT 'START: REFUND PROCESSING FOR [MTSTATUS: ' + @statusToRefund + '] [EXECUTED ON TIME:' + CAST(@CurrentUTCTime AS VARCHAR) + ']' 
				PRINT '-----------------------------------------------------------------------------------------'
                        --Drop temp table if already exists
                        IF OBJECT_ID('tempdb..#TempMTStatusCheckLog') IS NOT NULL 
							BEGIN
								DROP TABLE #TempMTStatusCheckLog 								
							END

							--Temp table to store adhoc taskid of current organazationID
							CREATE TABLE #TempMTStatusCheckLog
									(
											RowID INT IDENTITY(1,1) NOT NULL,
											[MTStatusCheckLogID] [INT] NOT NULL,
											[AdhocID] [INT] NOT NULL,
											[ScheduleID] [INT] NOT NULL,
											[SentOn] [DATETIME] NOT NULL
									)

						INSERT INTO #TempMTStatusCheckLog
						SELECT  [MTStatusCheckLogID],
								[AdhocID],
								[ScheduleID],
								[SentOn]
						FROM    [MTStatusCheckLog]
						WHERE   DATEADD(MINUTE,@ProcessMTAfterMinutes,SentOn) < @CurrentUTCTime 
								AND [status] = 'New' 
		
						DECLARE @TotalRecords INT,
								@RowID INT,
								@AdhocID INT,
								@ScheduleID INT,
								@SentOn DATETIME,
								@ExpriryDate DATETIME,
								@IsContinue INT,
								@MTStatusCheckLogID INT,
								@FiledCount INT,
								@HubAccountID INT,
								@UserID INT,
								@RecordStatus CHAR(1)

				SELECT @RowID = 1;

				SELECT @TotalRecords = 0;

				SELECT  @TotalRecords = (SELECT COUNT([AdhocID]) 
										 FROM #TempMTStatusCheckLog) 


				IF(@TotalRecords > 0) 
					BEGIN 
							PRINT '-----------------------------------------------------------------------------------------' 
							PRINT 'NEW RECORDS FOUND FOR PROCESSING  [NOOFRECORDS: ' + CAST(@TotalRecords AS VARCHAR) + ']'
					END 

				WHILE (@TotalRecords >= @RowID)
					BEGIN

						SELECT @IsContinue = 0;

						PRINT '-----------------------------------------------------------------------------------------'

						SELECT  @AdhocID = AdhocID,
								@ScheduleID = ScheduleID,
								@SentOn = SentOn,
								@MTStatusCheckLogID = MTStatusCheckLogID
						FROM    #TempMTStatusCheckLog
						WHERE RowID = @RowID  

						PRINT 'START: PROCESSING FOR [MTADHOCID: ' + CAST(@AdhocID AS VARCHAR) + '] 
													 [SCHEDULEID: ' + CAST(@ScheduleID AS VARCHAR) + ']
													 [MTSTATUSCHECKLOGID: ' + CAST(@MTStatusCheckLogID AS VARCHAR) + ']
													 [MTSENTON: ' + CAST(@SentOn AS VARCHAR) + ']' 

						BEGIN TRY
								IF(@AdhocID > 0)
									BEGIN 
											IF(@ScheduleID > 0) 
													BEGIN 
															IF EXISTS(SELECT  1
																	  FROM    MTSchedule
							                                          WHERE   ScheduleID = @ScheduleID 
																	  AND UPPER([Status]) NOT IN ('NEW','PENDING','PROCESSING','SENDING')) 
																		BEGIN
																			SELECT @IsContinue = 1; --SCHEDULE SHOULD BE COMPLETE BEFORE PROCESSING.
																		END
																	ELSE
																		BEGIN
																			PRINT 'SCHEDULE IS NOT COMPLETED [SCHEDULEID: ' + CAST(@ScheduleID AS VARCHAR) + '] 
																				   SO, WILL PROCESS AFTER COMPLETION.'
																		END
													END
												ELSE
													BEGIN
															SELECT @IsContinue = 1; --IF SCHEDULED ID = 0 (FOR SENT NOW CASE)
													END 

											IF(@IsContinue = 1)
													BEGIN

															UPDATE [MTStatusCheckLog]
															SET [status] = 'Processing'
															WHERE MTStatusCheckLogID = @MTStatusCheckLogID
     
															PRINT 'UPDATE [MTSTATUSCHECKLOG] STATUS TO PROCESSING'

															SELECT  @FiledCount = COUNT(ScheduledSubscriptionID)
															FROM    MTScheduledSubscription WITH(NOLOCK)
															WHERE   MTadhocID = @AdhocID 
															AND LTRIM(RTRIM(UPPER([STATUS]))) IN (SELECT StatusRefund FROM @RefundStatus) 
				
															IF(ISNULL(@FiledCount,0) > 0) 
																BEGIN 
																	PRINT 'NO OF FAILED SUBSCRIPTIONS : [' + CAST(@FiledCount AS VARCHAR) + ']' 
					
																	IF EXISTS(SELECT  1
																	FROM    PurchaseHistory
																	WHERE   ISNULL(MTAdhocID,0) = @AdhocID 
																	AND  MODE = 'U') 
																		BEGIN

																			SELECT  @HubAccountID = HubAccountID ,
																					@UserID = UserID,
																					@ExpriryDate = ExpiryDate,
																					@RecordStatus = RecordStatus
																			FROM    PurchaseHistory
																			WHERE   ISNULL(MTAdhocID,0) = @AdhocID 
																			AND MODE = 'U'
             
										PRINT 'PURCHASE HUB ACCOUND DETAILS FOUND [HubAccountID: ' + CAST(@HubAccountID AS VARCHAR) + ']
										[UserID: ' + CAST(@UserID AS VARCHAR) + ']
										[ExpriryDate: ' + CAST(@ExpriryDate AS VARCHAR) + ']
										[RecordStatus: ' + CAST(@RecordStatus AS VARCHAR) + ']'


										--IF HUBACCOUNT IS EXPIRED REFUND AGAINST ACTIVE HUBACCOUNT PURCHASE FOR THAT USER
										IF ((@ExpriryDate < GETUTCDATE() 
										OR @RecordStatus <> 'A'))
										BEGIN 
												PRINT 'PURCHASE HUB ACCOUNT IS EXPIRED OR EXPIRY DATE IS NULL, CHECKING ACTIVE HUB ACCOUNT'

													IF NOT EXISTS(SELECT 1 FROM PurchaseHistory 
														           WHERE PurchaseID = (SELECT  MAX(PurchaseID)
															       FROM    PurchaseHistory
															       WHERE    UserID = @UserID
															        AND HubAccountID = @HubAccountID)
																	AND ExpiryDate IS NULL)
																	BEGIN

																	SELECT  @HubAccountID = 0;
						
									     							SELECT TOP 1 @HubAccountID = HubAccountID																		
																		FROM    PurchaseHistory
																		WHERE   PurchaseID IN
																				(
																				SELECT  MAX(PurchaseID)
																				FROM    PurchaseHistory
																				WHERE    UserID = @UserID
																				GROUP BY HubAccountID)
																				AND (ExpiryDate > GETUTCDATE() OR ExpiryDate IS NULL)
																				AND RecordStatus = 'A'

																	 IF(ISNULL(@HubAccountID,0)<= 0)
																				   BEGIN
																						SELECT  @HubAccountID = 0
																				   END

																	END
												
										END 
											IF(@HubAccountID > 0
												AND @UserID > 0)
											BEGIN
													INSERT INTO PurchaseHistory
													SELECT  UserID,
															'R',
															@HubAccountID,
															@FiledCount,0,
															'Refund against failed MT subscriptions',
															@AdhocID,
															StartDate,
															ExpiryDate,
															CreatorID,
															GETUTCDATE(),
															UpdatorID,
															GETUTCDATE(),
															RecordStatus
													FROM    PurchaseHistory
													WHERE   PurchaseID =
															(
															SELECT  MAX(PurchaseID)
															FROM    PurchaseHistory
															WHERE   UserID = @UserID AND
																	HubAccountID = @HubAccountID)
													        AND RecordStatus = 'A'

												   PRINT 'REFUND COMPLETED SUCCESSFULLY [HubAccountID: ' + CAST(@HubAccountID AS VARCHAR) + ']'
											END
											ELSE
											BEGIN
													PRINT 'NO ACTIVE PURCHASE HUB ACCOUNT FOUND TO REFUND';
											END
									END
							END
					END 
			ELSE 
					BEGIN 
						PRINT 'NO FAILED SUBSCRIPTIONS FOUND';
					END

										UPDATE [MTStatusCheckLog]
										SET [status] = 'Completed',ProcessedOn = GETUTCDATE()
										WHERE MTStatusCheckLogID = @MTStatusCheckLogID
										PRINT 'UPDATE [MTSTATUSCHECKLOG] STATUS TO COMPLETED';

					
									END
						END TRY
						BEGIN CATCH
							BEGIN 
 										UPDATE [MTStatusCheckLog]
										SET [status] = 'Failed',ProcessedOn = GETUTCDATE(), ErrorMessage = ERROR_MESSAGE()
										WHERE MTStatusCheckLogID = @MTStatusCheckLogID

										PRINT 'FAILED TO REFUND [ERROR: ' + ERROR_MESSAGE() + ']'
     
							END
						END CATCH

						PRINT 'END: PROCESSING FOR [MTADHOCID: ' + CAST(@AdhocID AS VARCHAR) + '] 
												   [SCHEDULEID: ' + CAST(@ScheduleID AS VARCHAR) + ']
												   [MTSTATUSCHECKLOGID: ' + CAST(@MTStatusCheckLogID AS VARCHAR) + ']
												   [MTSENTON: ' + CAST(@SentOn AS VARCHAR) + ']';				

						SELECT  @RowID = @RowID + 1
					END 

				PRINT '-----------------------------------------------------------------------------------------' 
				PRINT 'END: REFUND PROCESSING FOR [MTSTATUS: ' + @statusToRefund + '] [EXECUTED ON TIME:' + CAST(@CurrentUTCTime AS VARCHAR) + ']'
END
GO
/****** Object:  StoredProcedure [dbo].[Prc_RedundancyCheck]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Prc_RedundancyCheck]
@OrganizationID    INT,
@MSISDNs            NVARCHAR(MAX),
@ScheduledTime      DATETIME,
@RedundancyDuration INT
AS
BEGIN

SET NOCOUNT ON
    
	DECLARE @PreviousUTCDateTime DATETIME,
					@NextUTCDateTime DATETIME

               --Drop temp table if already exists
				IF OBJECT_ID('tempdb..#TempTaskID') IS NOT NULL
				BEGIN
						DROP TABLE #TempTaskID
				END

				--Temp table to store adhoc taskid of current organazationID
				CREATE TABLE #TempTaskID
						(
								TaskID INT PRIMARY KEY CLUSTERED
						)

				--Drop temp table if already exists
				IF OBJECT_ID('tempdb..#TempMSISDN') IS NOT NULL
				BEGIN
						DROP TABLE #TempMSISDN
				END


				--Temp table to store adhoc taskid of current organazationID
				CREATE TABLE #TempMSISDN
						(
								MSISDN NVARCHAR(500)
						)


				--Drop temp table if already exists
				IF OBJECT_ID('tempdb..#TempRedundancyResult') IS NOT NULL
				BEGIN
						DROP TABLE #TempRedundancyResult
				END


				--Temp table to store result of redundancy check
				CREATE TABLE #TempRedundancyResult
						(
								ScheduledSubscriptionID INT NOT NULL,
								MSISDN                  NVARCHAR(500) NOT NULL,
								SentOn                  DATETIME NULL,
								ErrorType               NVARCHAR(100) NOT NULL
						)


				--store msisdns in temp table
				INSERT INTO #TempMSISDN
				SELECT val FROM dbo.f_split(@MSISDNs, ',')

	
				--Get all adhoc campaign taskIDs
				INSERT INTO #TempTaskID
				SELECT  TaskID
				FROM    Task WITH (NOLOCK)
						INNER JOIN [USER] ON UserID = Task.CreatorID
				WHERE   TaskType = 'AdhocBroadcast'
						AND OrganizationID = @OrganizationID
						AND [Status] = 'Running'
				
				--Set required time conditions
				SELECT @PreviousUTCDateTime = DATEADD(dd, - @RedundancyDuration, @ScheduledTime)
				SELECT @NextUTCDateTime = DATEADD(dd, @RedundancyDuration, @ScheduledTime)
			
			Print @ScheduledTime
			Print @PreviousUTCDateTime
			Print @NextUTCDateTime

				--Condition 1 - Check already sent MSISDNS
				INSERT INTO #TempRedundancyResult
				SELECT  MAX(ScheduledSubscriptionID),
						MTScheduledSubscription.MSISDN,
						MAX(SentOn),
						'PreSent'
						FROM    MTScheduledSubscription WITH (NOLOCK)
						INNER JOIN #TempTaskID ON #TempTaskID.TaskID = MTScheduledSubscription.TaskID
						INNER JOIN #TempMSISDN ON #TempMSISDN.MSISDN = MTScheduledSubscription.MSISDN
				WHERE   SentOn >= @PreviousUTCDateTime
						AND SentOn <= @ScheduledTime
						GROUP BY MTScheduledSubscription.MSISDN
						

				--DELETE FROM temp table if condition 1 is satisfied
				DELETE
				FROM    #TempMSISDN
				WHERE   MSISDN IN
						(SELECT MSISDN FROM #TempRedundancyResult)

	IF EXISTS
	(SELECT 1 
	 FROM #TempMSISDN 
	 GROUP BY MSISDN 
	 HAVING COUNT(MSISDN) > 0)
	BEGIN

        --Condition 2 - Check already scheduled MSISDNS
        INSERT INTO #TempRedundancyResult
        SELECT  ScheduledSubscriptionID ,
                MTScheduledSubscription.MSISDN,
                ScheduledOn                   ,
                'PreScheduled'
        FROM    MTScheduledSubscription WITH (NOLOCK)
                INNER JOIN #TempTaskID ON #TempTaskID.TaskID = MTScheduledSubscription.TaskID
                INNER JOIN MTTimeBlock WITH (NOLOCK) ON MTTimeBlock.TaskID = MTScheduledSubscription.TaskID
                INNER JOIN #TempMSISDN ON #TempMSISDN.MSISDN = MTScheduledSubscription.MSISDN
        WHERE   ISNULL(SentOn,0) = 0
                AND MTScheduledSubscription.TimeBlockID = MTTimeBlock.TimeBlockID
                AND MTScheduledSubscription.MSISDN NOT IN (SELECT MSISDN FROM #TempRedundancyResult)
                AND
                (
                        MTScheduledSubscription.[Status]    = 'P'
                        OR MTScheduledSubscription.[Status] = 'I'
         )
                AND StartTime >= @PreviousUTCDateTime
                AND StartTime <= @ScheduledTime


        ----DELETE FROM temp table if condition 2 is satisfied
        DELETE
        FROM    #TempMSISDN
        WHERE   MSISDN IN
                (SELECT MSISDN FROM #TempRedundancyResult)

        ------Condition 3 - Check scheduled MSISDNS in future
        IF EXISTS
        (SELECT 1 
		 FROM #TempMSISDN 
		 GROUP BY MSISDN 
		 HAVING COUNT(MSISDN) > 0)
        BEGIN

                INSERT INTO #TempRedundancyResult
                SELECT  ScheduledSubscriptionID ,
                        MTScheduledSubscription.MSISDN,
                        ScheduledOn,
                        'NextScheduled'
                FROM    MTScheduledSubscription WITH (NOLOCK)
                        INNER JOIN #TempTaskID ON #TempTaskID.TaskID = MTScheduledSubscription.TaskID
                        INNER JOIN MTTimeBlock WITH (NOLOCK) ON MTTimeBlock.TaskID = MTScheduledSubscription.TaskID
                        INNER JOIN #TempMSISDN ON #TempMSISDN.MSISDN = MTScheduledSubscription.MSISDN
                WHERE   ISNULL(SentOn,0) = 0
                        AND MTScheduledSubscription.TimeBlockID = MTTimeBlock.TimeBlockID
                        AND MTScheduledSubscription.MSISDN NOT IN (SELECT MSISDN FROM #TempRedundancyResult)
                        AND
                        (
                                MTScheduledSubscription.[Status]    = 'P'
                                OR MTScheduledSubscription.[Status] = 'I'
                        )
                        AND StartTime >= @ScheduledTime
                        AND StartTime <= @NextUTCDateTime



        END
END


					SELECT ScheduledSubscriptionID ,
								MSISDN,
								SentOn,
								ErrorType
					FROM    #TempRedundancyResult

END
GO
/****** Object:  StoredProcedure [dbo].[Prc_CancelScheduledSubscription]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Prc_CancelScheduledSubscription]
@ScheduledSubScriptionID NVARCHAR(MAX),
@IsPurchaseHistoryApplied BIT,
@CancelStatus Char(1)
AS
BEGIN
 	DECLARE @RowCount INT

		DECLARE @CancelledSubscription TABLE (ScheduledSubID INT)

		INSERT INTO @CancelledSubscription
        SELECT  LTRIM(RTRIM(UPPER(val)))
        FROM [DBO].f_Split(@ScheduledSubScriptionID, ',') 

		PRINT 'Cancelled subscription request found [ScheduledSubscriptionID:' + CAST(@ScheduledSubScriptionID AS VARCHAR) + ']'

		UPDATE MTScheduledSubscription
		SET [Status] = @CancelStatus,
		StoppedOn = GETUTCDATE()
		FROM MTScheduledSubscription
		INNER JOIN @CancelledSubscription ON ScheduledSubID = MTScheduledSubscription.ScheduledSubscriptionID
		AND [Status] = 'P'

		SELECT @RowCount = @@ROWCOUNT

		PRINT 'ROWCOUNT:' + CAST(@RowCount AS VARCHAR)

IF(@RowCount > 0)
		BEGIN

			PRINT 'Subscriptions successfully cancelled'

			--Drop temp table if already exists

                        IF OBJECT_ID('tempdb..#TempRefundAgainstCancel') IS NOT NULL 
							BEGIN
								DROP TABLE #TempRefundAgainstCancel 								
							END

							--Temp table to store adhoc taskid of current organazationID
							CREATE TABLE #TempRefundAgainstCancel
									(
											RowID INT IDENTITY(1,1) NOT NULL,
											MTAdhocID [INT] NOT NULL,
											MTCount [INT] NOT NULL
									)

				INSERT INTO #TempRefundAgainstCancel
				SELECT MTAdhocID, SUM(MTCount) FROM MTScheduledSubscription
				INNER JOIN @CancelledSubscription ON ScheduledSubID = MTScheduledSubscription.ScheduledSubscriptionID
				AND [Status] = 'C' AND EXISTS (SELECT 1 FROM MTStatusCheckLog where  AdhocID = MTScheduledSubscription.MTAdhocID)
				GROUP BY MTAdhocID

				
				DECLARE @TotalRecords INT,
								@RowID INT,
								@ScheduleID INT,
								@MTAdhocID INT,
								@MTCount INT,
								@SentOn DATETIME,
								@ExpriryDate DATETIME,
								@MTStatusCheckLogID INT,
								@HubAccountID INT,
								@UserID INT,
								@RecordStatus CHAR(1)

			SELECT @RowID = 1;

			SELECT @TotalRecords = COUNT(*) FROM #TempRefundAgainstCancel

			IF(ISNULL(@TotalRecords,0) > 0)
			BEGIN
					PRINT 'PURCHASE HUB BALANCE USAGE FOUND [TOTAL MTADHOC:' + CAST(@MTAdhocID AS VARCHAR) + ']'
			END

			WHILE @TotalRecords >= @RowID
			BEGIN

			SELECT @MTAdhocID = 0,
				   @MTCount = 0,
				   @HubAccountID = 0,
				   @UserID = 0

			SELECT @MTAdhocID = MTAdhocID , @MTCount = MTCount
			FROM #TempRefundAgainstCancel
			WHERE RowID = @RowID

			PRINT '----------------------------------------------------------------------------------------------------------------------'

			PRINT 'REFUND PROCESS START FOR  [MTAdhocID: ' + CAST(@MTAdhocID AS VARCHAR) + '][MTCount: ' + CAST(@MTCount AS VARCHAR) + ']'

			SELECT  @HubAccountID = HubAccountID,
					@UserID = UserID,
					@ExpriryDate = ExpiryDate,
					@RecordStatus = RecordStatus
					FROM    PurchaseHistory
					WHERE   ISNULL(MTAdhocID,0) = @MTAdhocID 
					AND MODE = 'U'

			PRINT 'PURCHASE HUB ACCOUND DETAILS FOUND 
			       [HubAccountID: ' + CAST(@HubAccountID AS VARCHAR) + ']
				   [UserID: ' + CAST(@UserID AS VARCHAR) + ']
				   [ExpriryDate: ' + CAST(@ExpriryDate AS VARCHAR) + ']
				   [RecordStatus: ' + CAST(@RecordStatus AS VARCHAR) + ']'


			--IF HUBACCOUNT IS EXPIRED REFUND AGAINST ACTIVE HUBACCOUNT PURCHASE FOR THAT USER
									IF ((@ExpriryDate < GETUTCDATE() 
										OR @RecordStatus <> 'A'))
										BEGIN 

												PRINT 'PURCHASE HUB ACCOUNT IS EXPIRED OR EXPIRY DATE IS NULL, CHECKING ACTIVE HUB ACCOUNT'

												IF NOT EXISTS(SELECT 1 FROM PurchaseHistory 
														           WHERE PurchaseID = (SELECT  MAX(PurchaseID)
															       FROM    PurchaseHistory
															       WHERE    UserID = @UserID
															        AND HubAccountID = @HubAccountID)
																	AND ExpiryDate IS NULL)
																	BEGIN

																	   SELECT  @HubAccountID = 0;
						
																	    SELECT TOP 1 @HubAccountID = HubAccountID																		
																		FROM    PurchaseHistory
																		WHERE   PurchaseID IN
																				(
																				SELECT  MAX(PurchaseID)
																				FROM    PurchaseHistory
																				WHERE    UserID = @UserID
																				GROUP BY HubAccountID)
																				AND (ExpiryDate > GETUTCDATE() 
																				OR ExpiryDate IS NULL)
																				AND RecordStatus = 'A'

																		IF(ISNULL(@HubAccountID,0)<= 0)
																				   BEGIN
																						SELECT  @HubAccountID = 0
																				   END

																	END

										END 
											IF(@HubAccountID > 0
												AND @UserID > 0)
											BEGIN
													INSERT INTO PurchaseHistory
													SELECT  UserID,
															'R',
															@HubAccountID,
															@MTCount,
															0,
															'Refund against cancelled MT subscription',
															@MTAdhocID,
															StartDate,
															ExpiryDate,
															CreatorID,
															GETUTCDATE(),
															UpdatorID,
															GETUTCDATE(),
															RecordStatus
													FROM    PurchaseHistory
													WHERE   PurchaseID =
															(
															SELECT  MAX(PurchaseID)
															FROM    PurchaseHistory
															WHERE   UserID = @UserID AND
																	HubAccountID = @HubAccountID)
													        AND RecordStatus = 'A'

												   PRINT 'REFUND COMPLETED SUCCESSFULLY AGAINST CANCELLED SUBSCRIPTION [HubAccountID: ' + CAST(@HubAccountID AS VARCHAR) + ']'
											END
										ELSE
											BEGIN
													PRINT 'NO ACTIVE PURCHASE HUB ACCOUNT FOUND TO REFUND';
											END
			
			
			PRINT 'REFUND PROCESS END FOR  [MTAdhocID: ' + CAST(@MTAdhocID AS VARCHAR) + '][MTCount: ' + CAST(@MTCount AS VARCHAR) + ']'

			PRINT '----------------------------------------------------------------------------------------------------------------------'

			SELECT @RowID = @RowID + 1;
			END
		END
	ELSE
		BEGIN
				RAISERROR (N'Cancel scheduled subscription failed, Subscription may be submitted or already cancelled.',16,1)
		END
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetScheduleExpired]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetScheduleExpired]
	@ScheduleID INT,
	@ScheduleExpiredStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15),
	@SchedulePausedStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@TimeBlockPausedStatus VARCHAR(15),
	@TimeBlockExpiredStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleExpiredStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @ScheduleSendingStatus
	AND ((EndTime IS NOT NULL) AND (EndTime < GETUTCDATE()))
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Expired While Sending'
		UPDATE MTTimeBlock SET Status = @TimeBlockExpiredStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPendingStatus

		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		AND TimeBlockID NOT IN 
		(SELECT TimeBlockID FROM MTTimeBlock 
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockSendingStatus)
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @TimeBlockExpiredStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePausedStatus
	AND ((EndTime IS NOT NULL) AND (EndTime < GETUTCDATE()))
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Expired While Paused'
		UPDATE MTTimeBlock SET Status = @TimeBlockExpiredStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPausedStatus

		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleExpiredStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePendingStatus
	AND ((EndTime IS NOT NULL) AND (EndTime < GETUTCDATE()))
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Expired While Pending'
		UPDATE MTTimeBlock SET Status = @TimeBlockExpiredStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPausedStatus

		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	_EXIT:

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_StopSchedule]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_StopSchedule]
	@ScheduleID INT,
	@ScheduleStopStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15),
	@SchedulePauseStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@TimeBlockCancelledStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION
	PRINT 'Update Schedule Status'
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleStopStatus
	WHERE ScheduleID = @ScheduleID
	AND ((Status = @ScheduleSendingStatus) OR (Status = @SchedulePauseStatus))
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Update Schedule Status : Success'
		PRINT 'Cancel TimeBlocks'
		UPDATE MTTimeBlock SET Status = @TimeBlockCancelledStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPendingStatus
		PRINT 'Cancel TimeBlocks : Success'

		PRINT 'Update Subscriptions'
		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		AND TimeBlockID NOT IN 
		(SELECT TimeBlockID FROM MTTimeBlock 
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockSendingStatus)
		PRINT 'Update Subscriptions : Success'
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetTimeBlockExpired]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetTimeBlockExpired]
	@TimeBlockID INT,
	@TimeBlockExpiredStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	DECLARE @UpdateCount INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION
	PRINT 'Update TimeBlock Status'
	UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockExpiredStatus
	WHERE TimeBlockID = @TimeBlockID
	AND Status = @TimeBlockSendingStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Update Subscriptions'
		SET ROWCOUNT 100
		SET @UpdateCount = 100
		WHILE (@UpdateCount = 100)
		BEGIN
			UPDATE MTScheduledSubscription WITH (ROWLOCK)
			SET Status = @SubscriptionUnallocatedStatus,
			ScheduleID = 0,
			TimeBlockID = 0
			WHERE TimeBlockID = @TimeBlockID
			AND Status = @SubscriptionPendingStatus
			SET @UpdateCount = @@ROWCOUNT
		END
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetTimeBlockCompleted_2]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[MT_SetTimeBlockCompleted_2]
	@TimeBlockID INT,
	@TimeBlockCompletedStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionSentStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	DECLARE @SubscriptionCount INT
	SET @ErrorCode = -1

	PRINT 'Update TimeBlock Status'
	UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockCompletedStatus
	WHERE TimeBlockID = @TimeBlockID
	AND Status = @TimeBlockSendingStatus
		
	PRINT 'Update Subscriptions'
	
	UPDATE MTScheduledSubscription WITH (ROWLOCK)
	SET Status = @SubscriptionSentStatus, SentOn = GETUTCDATE()
	WHERE TimeBlockID = @TimeBlockID
	AND Status = @SubscriptionPendingStatus 
	
	UPDATE MTSchedule WITH (ROWLOCK) SET ProcessedCount = ISNULL(ProcessedCount, 0) + @SubscriptionCount
	WHERE ScheduleID = (SELECT TOP 1 ScheduleID FROM MTTimeBlock WHERE TimeBlockID = @TimeBlockID)
	SET @ErrorCode = 0

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetTimeBlockCompleted_1]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetTimeBlockCompleted_1]
	@TimeBlockID INT,
	@TimeBlockCompletedStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionSentStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	DECLARE @SubscriptionCount INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION
	PRINT 'Update TimeBlock Status'
	UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockCompletedStatus
	WHERE TimeBlockID = @TimeBlockID
	AND Status = @TimeBlockSendingStatus
	
	SET @SubscriptionCount = @@ROWCOUNT
	
	IF (@SubscriptionCount > 0)
	BEGIN
		PRINT 'Update Subscriptions'
		
		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionSentStatus, SentOn = GETUTCDATE()
		WHERE TimeBlockID = @TimeBlockID
		AND Status = @SubscriptionPendingStatus
		
		UPDATE MTSchedule WITH (ROWLOCK) SET ProcessedCount = ISNULL(ProcessedCount, 0) + @SubscriptionCount
		WHERE ScheduleID = (SELECT TOP 1 ScheduleID FROM MTTimeBlock WHERE TimeBlockID = @TimeBlockID)
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	RETURN @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetTimeBlockCompleted]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetTimeBlockCompleted]
	@TimeBlockID INT,
	@TimeBlockCompletedStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionSentStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	DECLARE @UpdateCount INT
	DECLARE @SubscriptionCount INT
	DECLARE @SentOnDateTime DATETIME

	SET @ErrorCode = -1

	SET @SentOnDateTime = GETUTCDATE()

	BEGIN TRANSACTION
	PRINT 'Update TimeBlock Status'
	UPDATE MTTimeBlock SET Status = @TimeBlockCompletedStatus
	WHERE TimeBlockID = @TimeBlockID
	AND Status = @TimeBlockSendingStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Update Subscriptions'
		SET @SubscriptionCount = 0
		SET ROWCOUNT 100
		SET @UpdateCount = 100
		WHILE (@UpdateCount = 100)
		BEGIN
			UPDATE MTScheduledSubscription 
			SET Status = @SubscriptionSentStatus, SentOn = @SentOnDateTime
			WHERE TimeBlockID = @TimeBlockID
			AND Status = @SubscriptionPendingStatus
			SET @UpdateCount = @@ROWCOUNT
		END

		SELECT @SubscriptionCount = COUNT(ScheduledSubscriptionId) 
		FROM MTScheduledSubscription WITH (NOLOCK)
		WHERE TimeBlockID = @TimeBlockID
		AND [Status] != 'B'

		UPDATE MTSchedule SET ProcessedCount = ISNULL(ProcessedCount,0) + ISNULL(@SubscriptionCount,0)
		WHERE ScheduleID = (SELECT TOP 1 ScheduleID FROM MTTimeBlock WITH(NOLOCK) WHERE TimeBlockID = @TimeBlockID)
		SET @ErrorCode = 0
	END

	COMMIT TRANSACTION

	SELECT @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetScheduleStopped]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetScheduleStopped]
	@ScheduleID INT,
	@ScheduleStoppedStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@ScheduleSendingStatus VARCHAR(15),
	@SchedulePausedStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockSendingStatus VARCHAR(15),
	@TimeBlockPausedStatus VARCHAR(15),
	@TimeBlockCancelledStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)

AS
BEGIN

	DECLARE @ErrorCode INT
	SET @ErrorCode = -1

	BEGIN TRANSACTION

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleStoppedStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @ScheduleSendingStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Stop While Sending'
		UPDATE MTTimeBlock SET Status = @TimeBlockCancelledStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPendingStatus

		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		AND TimeBlockID NOT IN 
		(SELECT TimeBlockID FROM MTTimeBlock 
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockSendingStatus)
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleStoppedStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePausedStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Stop While Paused'
		UPDATE MTTimeBlock SET Status = @TimeBlockCancelledStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPausedStatus

		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleStoppedStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePendingStatus
	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT 'Stop While Pending'
		UPDATE MTTimeBlock SET Status = @TimeBlockCancelledStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPendingStatus  --@TimeBlockPausedStatus

		UPDATE MTScheduledSubscription WITH (ROWLOCK)
		SET Status = @SubscriptionUnallocatedStatus,
		ScheduleID = 0,
		TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	_EXIT:

	COMMIT TRANSACTION

	SELECT @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[MT_SetSchedulePending]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MT_SetSchedulePending]
	@ScheduleID INT,
	@ScheduleSendingStatus VARCHAR(15),
	@ScheduleExpireStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@SchedulePausedStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@TimeBlockPauseStatus VARCHAR(15),
	@TimeBlockExpiredStatus VARCHAR(15),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1)
AS
BEGIN
	
	DECLARE @ErrorCode INT
	SET @ErrorCode = -1
	BEGIN TRANSACTION

	--Schedule Already Started
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleSendingStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePausedStatus
	AND StartTime <= GETUTCDATE()
	AND ((EndTime IS NULL) OR EndTime >= GETUTCDATE())
	IF (@@ROWCOUNT > 0)
	BEGIN
		UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockPendingStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPauseStatus
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	--Schedule Expired
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @ScheduleExpireStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePausedStatus
	AND ((EndTime IS NOT NULL) AND (EndTime < GETUTCDATE()))
	IF (@@ROWCOUNT > 0)
	BEGIN
		UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockExpiredStatus
		WHERE ScheduleID = @ScheduleID
		AND ((Status = @TimeBlockPauseStatus) OR (Status = @TimeBlockPendingStatus))

		UPDATE MTScheduledSubscription WITH (ROWLOCK) 
		SET Status = @SubscriptionUnallocatedStatus, ScheduleID = 0, TimeBlockID = 0
		WHERE ScheduleID = @ScheduleID
		AND Status = @SubscriptionPendingStatus
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	--Schedule not Started
	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @SchedulePendingStatus
	WHERE ScheduleID = @ScheduleID
	AND Status = @SchedulePausedStatus
	AND StartTime > GETUTCDATE()
	IF (@@ROWCOUNT > 0)
	BEGIN
		UPDATE MTTimeBlock WITH (ROWLOCK) SET Status = @TimeBlockPendingStatus
		WHERE ScheduleID = @ScheduleID
		AND Status = @TimeBlockPauseStatus
		SET @ErrorCode = 0
		GOTO _EXIT
	END

	_EXIT:

	COMMIT TRANSACTION

	SELECT @ErrorCode
END
GO
/****** Object:  StoredProcedure [dbo].[Prc_GetAdhocHistorySummaries]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Prc_GetAdhocHistorySummaries]
						@TaskID NUMERIC(18,0),
						@StartDate DateTime = NULL,
						@EndDate DateTime = NULL,
						@msisdn NVARCHAR(100) = '',
						@Status NVARCHAR(100) = 'All'
						AS
						BEGIN

						IF(@msisdn = '' 
						   AND ISNULL(@StartDate,0) = 0 
						   AND ISNULL(@EndDate,0) = 0
						   AND @Status='All')
						   BEGIN

						    SELECT TOP(500) ScheduledSubscriptionID AS 'SubscriptionID',
															   MTAdhocID,
															   MSISDN,
															   TaskID,
															   [Status],
															   CreatedOn,
															   ISNULL(SentOn,ScheduledOn) as 'SentOn',
															   MTMessage AS 'Message',
															   StoppedOn AS 'CompletedOn',
															   ISNULL(MTCount,1) as  'MTCount'
														FROM MTScheduledSubscription WITH (NOLOCK)
														WHERE TaskID = @TaskID
														ORDER BY ScheduledSubscriptionID DESC

						   END
						  ELSE
						   BEGIN

						      SELECT TOP(500) ScheduledSubscriptionID AS 'SubscriptionID',
															   MTAdhocID,
															   MSISDN,
															   TaskID,
															   [Status],
															   CreatedOn,
															   ISNULL(SentOn,ScheduledOn) as 'SentOn',
															   MTMessage AS 'Message',
															   StoppedOn AS 'CompletedOn',
															   ISNULL(MTCount,1) as  'MTCount'
														FROM MTScheduledSubscription WITH (NOLOCK)
														WHERE TaskID = @TaskID
														AND (ISNULL(@msisdn,'0') = '0' OR MSISDN LIKE '%' + @msisdn + '%')
														AND (ISNULL(@StartDate,0) = 0 OR CreatedOn >= @StartDate)
														AND (ISNULL(@EndDate,0) = 0 OR CreatedOn <= @EndDate)
														AND (@Status = 'All' OR [status] = @Status)
														ORDER BY ScheduledSubscriptionID DESC
						   END
	
							 
	

						END
GO
/****** Object:  StoredProcedure [dbo].[ReportStart]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ReportStart]
	@ReportID INT
AS
/*******************************************************************/
--Name		: ReportStart
--Module	: Report
--Description 	: Process the report request for the given ReportID
--Input Param	: ReportID
--Return Value	:  0 - Successful
--		  -1 - Failed
/*******************************************************************/

BEGIN
	DECLARE @RetVal INT,
		@EmailID INT,
		@FileID INT,
		@ReportMailID INT,
		@ReportFileID INT,
		@TransferID INT,
		@ReportTransferID INT,
		@ReportCount INT,
		@ReportType VARCHAR(50),
		@ErrorStatus VARCHAR(200),
		@TestRecipients VARCHAR(100),
		@UserID INT,
		@ReportTypeVariantID INT,
		@RowCount INT,
		@Error INT

	SET @ErrorStatus = 'Error'

	SELECT 	@TestRecipients = TestRecipients,
		@UserID = CreatorID,
		@ReportTypeVariantID = reporttypevariantid
	FROM	report
	WHERE	reportid = @ReportID
	SET @RowCount = @@ROWCOUNT

	IF (@RowCount = 1)
	BEGIN
		EXEC REPORTSTATUSINSERT 'report', @reportid, 'ReportStart_running', 'ok', NULL
	
		--process TSQL if any
		EXEC @Error = REPORTTSQLPROCESS @ReportID
		IF (@Error < 0) 
		BEGIN
			EXEC REPORTSTATUSUPDATE @ReportID, @ErrorStatus
			RETURN -1
		END
		
		--create the file
		DECLARE file_cursor CURSOR
		FOR	SELECT	reporttypefileid  
			FROM 	reporttypevariant, reporttypefile 
			WHERE 	reporttypevariantid = @reporttypevariantid 
			AND 	reporttypevariant.reporttypeid = reporttypefile.reporttypeid 
			ORDER BY reporttypefileid
		OPEN file_cursor
		FETCH NEXT FROM file_cursor INTO @FileID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC @ReportFileID = REPORTFILEINSERT @ReportID, @FileID
			IF (@ReportFileID < 0)
			BEGIN
				EXEC REPORTSTATUSUPDATE @ReportID, @ErrorStatus
				CLOSE file_cursor
				DEALLOCATE file_cursor
				RETURN -1
			END
			FETCH NEXT FROM file_cursor INTO @FileID
		END
		CLOSE file_cursor
		DEALLOCATE file_cursor
	
		--send email
		SELECT @EmailID = reporttypeemailid
		FROM reporttypeemail, reporttypevariant
		WHERE ReportTypeVariantID = @ReportTypeVariantID
		AND reporttypeemail.reporttypeid = reporttypevariant.reporttypeid
		
		IF (@emailid IS NOT NULL)
		BEGIN
			EXEC @ReportMailID = REPORTEMAILINSERT @ReportID, @ReportTypeVariantID, @EmailID, @TestRecipients
			IF (@ReportMailID < 0)
			BEGIN
				EXEC REPORTSTATUSUPDATE @ReportID, @ErrorStatus
				RETURN -1
			END
		END
	
		--transfer the file
		DECLARE transfer_cursor CURSOR
		FOR SELECT reporttypetransferid  FROM reporttypevariant, reporttypetransfer WHERE reporttypevariantid = @reporttypevariantid AND reporttypevariant.reporttypeid = reporttypetransfer.reporttypeid ORDER BY reporttypetransferid
		OPEN transfer_cursor
		FETCH NEXT FROM transfer_cursor INTO @TransferID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC @ReportTransferID = REPORTTRANSFERINSERT @ReportID, @TransferID
			IF (@ReportTransferID < 0)
			BEGIN
				EXEC REPORTSTATUSUPDATE @ReportID, @ErrorStatus
				CLOSE transfer_cursor
				DEALLOCATE transfer_cursor
				RETURN -1
			END
			FETCH NEXT FROM transfer_cursor INTO @TransferID
		END
		CLOSE transfer_cursor
		DEALLOCATE transfer_cursor
		
		EXEC REPORTSTATUSINSERT 'report', @reportid, 'ReportStart_complete', 'ok', NULL
	END
	EXEC REPORTSTATUSUPDATE @reportid, 'Completed'
	RETURN @ReportID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateMTTraffic]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateMTTraffic]
  @status  VARCHAR(100), 
  @details VARCHAR(1000), 
  @updated DATETIME, 
  @orderid VARCHAR(100), 
  @msisdn  VARCHAR(100) 
AS 
BEGIN
	
SET DEADLOCK_PRIORITY -8;
SET LOCK_TIMEOUT 10000;  --10 Seconds
SET XACT_ABORT ON;

DECLARE @iRowCount int 

DECLARE @MTScheduledSubscriptionID INT, 
    @TaskID INT,
    @MTCount INT; 

DECLARE @TaskDetails TABLE ( iTaskId int, iSubscriptionID int );

		  --print @@error 
			  UPDATE MTTraffic
			  SET    [status]=@status, 
					 details=@details, 
					 updatedon = GETUTCDATE()
			  OUTPUT INSERTED.TaskID,inserted.SubscriptionID INTO @TaskDetails 
			  WHERE  orderid=@orderid 
			  AND    msisdn=@msisdn 

			  set @iRowCount = @@ROWCOUNT

  SET @MTScheduledSubscriptionID = 0; 
  SET @TaskID = 0; 
  SET @MTCount = 0;

  SELECT @MTScheduledSubscriptionID = iSubscriptionID,
         @TaskID = iTaskId 
  FROM   @TaskDetails

  DELETE FROM @TaskDetails
  
  IF(@MTScheduledSubscriptionID > 0 
     AND @TaskID > 0) 
  BEGIN 
			SELECT @status = (CASE 
					WHEN @status = 'RECEIVED' THEN 'D'
					WHEN @status = 'SENT' THEN 'O'
					ELSE Substring(@status,1,1)
				 END)

			
				  UPDATE MTScheduledSubscription
					  SET    [status] = @status, 
							 stoppedon = Getutcdate()
					  WHERE ScheduledSubscriptionID = @MTScheduledSubscriptionID 
							AND [status] != @status
							AND ([Status] != 'R' AND [Status] != 'E')

  END 
 
  SELECT @iRowCount

  SET DEADLOCK_PRIORITY NORMAL;
  SET LOCK_TIMEOUT -1;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Retention_Task_Listbased]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Retention_Task_Listbased]
	   @iTask_Id INT,
	   @sOutputLog VARCHAR(2000) OUTPUT
	     
AS     
BEGIN

SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;

SET XACT_ABORT ON;
SET NoCount ON;

SET @sOutputLog =  '@iTask_Id:' + CAST(@iTask_Id AS VARCHAR(10))

DECLARE @iError  int,
       @iRowCount  int,
       @sTempDesc  varchar(4000),
	   @ErrorMessage varchar(4000),
       @sTaskID varchar(100),
       @iTopNRow int,
       @sDetail_Name varchar(31),
	   @rowsRemaining INT,
	   @sTasktype VARCHAR(50),
	   @iRetentionLogID INT = 0,
	   @iOrganizationId INT = 0,
	   @rowsUpdated INT = 0,
	   @iBatchSize INT

	   /*** Set Local Variables ***/
		   Set @sDetail_Name   = OBJECT_NAME(@@PROCID)
		   Set @iError                = 0
		   Set @iRowcount             = 0
		 		   
		   SELECT @iBatchSize = [ParamValue] 
		   FROM [SystemConfig] WITH(NOLOCK)
		   WHERE [ParamName] = 'BatchSize'
		   AND CATEGORY = 'DataRetention'
           
		   IF(ISNULL(@iBatchSize,0) < 0)
			 BEGIN
				SET @iBatchSize = 100000; --Default batch size
			 END
	
	 BEGIN TRY
			
		/*** MAINTAIN STATICSTICS  ***/

		IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
           WHERE TASKID = @iTask_Id 
           AND RetentionStatus = 'Calculated')
			BEGIN
					EXEC SP_Statistics_Task_Listbased @iTask_Id

						UPDATE Task
						SET RetentionRunOn = GETUTCDATE(),
						RetentionStatus = 'Calculated'
						WHERE TaskID = @iTask_Id

					SET @sOutputLog = @sOutputLog +',Statistics calculated';
			END
				
		/*** PURGE DATA FROM MTScheduledSubscription ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
					DELETE TOP (@rowsRemaining)
					FROM MTScheduledSubscription
					WHERE TaskID = @iTask_Id

				    /*** Handle log ***/
					SELECT @rowsRemaining= @@RowCount

					SET @sOutputLog = @sOutputLog + ',MTScheduledSubscription:DeletedRows=' + convert(varchar(31),@rowsRemaining) 
			 		
					IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
								
						
			END
			
		/*** PURGE DATA FROM MTTimeBlock ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MTTimeBlock
				WHERE TaskID = @iTask_Id
 
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
				
				SET @sOutputLog = @sOutputLog + ',MTTimeBlock:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
					
    		END

		/*** PURGE DATA FROM MTTraffic ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MTTraffic
				WHERE TaskID = @iTask_Id

				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount

				SET @sOutputLog = @sOutputLog + ',MTTraffic:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
			END
		
		/*** PURGE DATA FROM MTMMSViewHistory ***/
		SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
				
				DELETE TOP (@rowsRemaining)
				FROM MTMMSViewHistory
				WHERE MTMMSID = (SELECT MMSID FROM MTMMS WITH(NOLOCK) WHERE TaskID = @iTask_Id)
			
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
				
				SET @sOutputLog = @sOutputLog + ',MTMMSViewHistory:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
					
			END

		/*** UPDATE RETENTION STATUS ***/
			UPDATE Task
			SET RetentionRunOn = GETUTCDATE(),
			RetentionStatus = 'Completed'
			WHERE TaskID = @iTask_Id

			/*** Handle log ***/
				SELECT  @rowsUpdated= @@RowCount
					BEGIN
					      SET @sOutputLog = @sOutputLog + ',RetentionStatus completed:' + convert(varchar(31),@rowsUpdated) 
				    END
					
		END TRY
		BEGIN CATCH

			SELECT @ErrorMessage = ERROR_MESSAGE();
						            
			SET @sOutputLog =  @sOutputLog + ' @ErrorMessage=' + @ErrorMessage
					
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1

		IF(@ErrorMessage != '')
			BEGIN
					 RAISERROR (@sOutputLog, --contain log as well as error details.  
							   16, -- Severity.  
							   1 -- State.  
							   );  
			END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Retention_Task_Emailbased]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Retention_Task_Emailbased]
	   @iTask_Id INT,
	   @sOutputLog VARCHAR(2000) OUTPUT
AS     
BEGIN

SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;

SET XACT_ABORT ON;
SET NoCount ON;

SET @sOutputLog =  '@iTask_Id:' + CAST(@iTask_Id AS VARCHAR(10))

DECLARE @iError  int,
       @iRowCount  int,
       @sTempDesc  varchar(4000),
	   @ErrorMessage varchar(4000),
       @sTaskID varchar(100),
       @iTopNRow int,
       @sDetail_Name varchar(31),
	   @rowsRemaining INT,
	   @sTasktype VARCHAR(50),
	   @iRetentionLogID INT = 0,
	   @iOrganizationId INT = 0,
	   @rowsUpdated INT = 0,
	   @iBatchSize INT

	  /*** Set Local Variables ***/
		   Set @sDetail_Name   = OBJECT_NAME(@@PROCID)
		   Set @iError                = 0
		   Set @iRowcount             = 0
		   
		   SELECT @iBatchSize = [ParamValue] 
		   FROM [SystemConfig] WITH(NOLOCK)
		   WHERE [ParamName] = 'BatchSize'
		   AND CATEGORY = 'DataRetention'
           
		   IF(ISNULL(@iBatchSize,0) < 0)
			 BEGIN
				SET @iBatchSize = 100000; --Default batch size
			 END
	
	 BEGIN TRY

	    /*** MAINTAIN STATICSTICS  ***/
		IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
           WHERE TASKID = @iTask_Id 
           AND RetentionStatus = 'Calculated')
			BEGIN
					EXEC SP_Statistics_Task_Emailbased @iTask_Id

						UPDATE Task
						SET RetentionRunOn = GETUTCDATE(),
						RetentionStatus = 'Calculated'
						WHERE TaskID = @iTask_Id

					SET @sOutputLog = @sOutputLog +',Statistics calculated';
			END
			
		/*** PURGE DATA FROM MTScheduledSubscription ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
					DELETE TOP (@rowsRemaining)
					FROM MTScheduledSubscription
					WHERE TaskID = @iTask_Id
				
				/*** Handle log ***/
					SELECT @rowsRemaining= @@RowCount
					SET @sOutputLog = @sOutputLog + ',MTScheduledSubscription:DeletedRows=' + convert(varchar(31),@rowsRemaining) 
					
					IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
						
						
			END
			
		/*** PURGE DATA FROM MTTimeBlock ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM MTTimeBlock
				WHERE TaskID = @iTask_Id
 
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
						SET @sOutputLog = @sOutputLog + ',MTTimeBlock:DeletedRows=' + convert(varchar(31),@rowsRemaining) 
						IF(@rowsRemaining < @iBatchSize)
							BEGIN
								SET @rowsRemaining = 0;
							END
				END

		/*** PURGE DATA FROM EmailTraffic ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
				DELETE TOP (@rowsRemaining)
				FROM EmailTraffic
				WHERE TaskID = @iTask_Id

				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount
					SET @sOutputLog = @sOutputLog + ',EmailTraffic:DeletedRows=' + convert(varchar(31),@rowsRemaining) 
					IF(@rowsRemaining < @iBatchSize)
					BEGIN
						SET @rowsRemaining = 0;
					END
			END
			
		/*** UPDATE RETENTION STATUS ***/
			UPDATE Task
			SET RetentionRunOn = GETUTCDATE(),
			RetentionStatus = 'Completed'
			WHERE TaskID = @iTask_Id

			/*** Handle log ***/
			SELECT  @rowsUpdated= @@RowCount
			 BEGIN
				SET @sOutputLog = @sOutputLog + ',RetentionStatus completed:' + convert(varchar(31),@rowsUpdated) 
		     END
			 							
		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE();
			            
		SET @sOutputLog =  @sOutputLog + ' @ErrorMessage=' + @ErrorMessage
			
		END CATCH

		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1
	
		IF(@ErrorMessage !='')
		BEGIN
				 RAISERROR (@sOutputLog, -- Message text.  
						   16, -- Severity.  
						   1 -- State.  
						   );  
		END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Retention_Task_AdhocBroadcast]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Retention_Task_AdhocBroadcast]
	   @iTask_Id INT,
	   @sOutputLog VARCHAR(2000) OUTPUT
AS     
BEGIN

SET DEADLOCK_PRIORITY -9;
SET LOCK_TIMEOUT 20000;

SET XACT_ABORT ON;
SET NoCount ON;

SET @sOutputLog =  '@iTask_Id:' + CAST(@iTask_Id AS VARCHAR(10))

DECLARE @iError  int,
       @iRowCount  int,
       @sTempDesc  varchar(4000),
	   @ErrorMessage varchar(4000),
       @sTaskID varchar(100),
       @iTopNRow int,
       @sDetail_Name varchar(31),
	   @rowsRemaining INT,
	   @sTasktype VARCHAR(50),
	   @iRetentionLogID INT = 0,
	   @iOrganizationId INT = 0,
	   @rowsUpdated INT = 0,
	   @iBatchSize INT,
	   @bIsRunningCampaign BIT,
	   @sTaskStatus VARCHAR(50),
	   @sRecordStatus CHAR(1),
	   @dDelDate Datetime,
	   @iRetentionPeriod int,
	   @sStatusTobeUpdated Varchar(20)
	   
	   /*** Set Local Variables ***/
		   Set @sDetail_Name   = OBJECT_NAME(@@PROCID)
		   Set @iError                = 0
		   Set @iRowcount             = 0
		   set @bIsRunningCampaign = 0 /**Default considered as false**/
		   
		   SELECT @iBatchSize = [ParamValue] 
		   FROM [SystemConfig] WITH(NOLOCK)
		   WHERE [ParamName] = 'BatchSize'
		   AND CATEGORY = 'DataRetention'
           
		   IF(ISNULL(@iBatchSize,0) < 0)
			 BEGIN
				SET @iBatchSize = 100000; --Default batch size
			 END
			
		SELECT @sTaskStatus = T.[STATUS],
			@sRecordStatus = T.RecordStatus,
			@sTaskType = T.TASKTYPE,
			@iOrganizationId = U.OrganizationId,
			@iRetentionPeriod = ISNULL(T.RetentionPeriod,0)
			FROM TASK T WITH (NOLOCK)
			INNER JOIN [USER] U WITH (NOLOCK) ON U.USERID = T.CreatorID
			WHERE TASKID = @iTask_Id
			 
		IF(@sRecordStatus = 'S')
			BEGIN
				SET @sTaskType = 'QuickSMS'
			END
		
		IF(@sTaskStatus = 'Running')
			BEGIN

			IF(@iRetentionPeriod = 0)
			BEGIN
					/**check custom rule for organizationId**/
		 		IF EXISTS (SELECT 1 FROM DataRetentionRule WITH (NOLOCK)
					WHERE TASKTYPE = @sTaskType
					AND ISNULL(OrganizationID,0) = @iOrganizationId
					AND RecordStatus = 'A')
					BEGIN
						SELECT @iRetentionPeriod = ISNULL(RETENTIONPERIOD,0)
						FROM DataRetentionRule WITH (NOLOCK)
						WHERE TASKTYPE = @sTaskType
						AND ISNULL(OrganizationID,0) = @iOrganizationId
						AND RecordStatus = 'A'
					END
				 ELSE
					BEGIN
						/**Get global rule**/
						SELECT @iRetentionPeriod = ISNULL(RETENTIONPERIOD,0) 
						FROM DataRetentionRule WITH (NOLOCK)
						WHERE TASKTYPE = @sTaskType
						AND RecordStatus = 'S'
					END
			END
			
			SET @bIsRunningCampaign = 1;
		 
		
		END

    BEGIN TRY
			
			IF(@bIsRunningCampaign = 1 
			AND ISNULL(@iRetentionPeriod,0) <= 0)
			BEGIN

				 SET @sOutputLog = @sOutputLog + ',@errormessage = Retention period not defined for  @iTask_Id= '+ CAST(@iTask_Id AS VARCHAR(20)) + ' @sTaskType= '+ ISNULL(@sTaskType,'') +'';

				 RAISERROR (@sOutputLog, -- Message text.  
								   16, -- Severity.  
								   1 -- State.  
								   );  
			END
			ELSE
			BEGIN
				SET @dDelDate = DATEADD(DAY, -1*@iRetentionPeriod, GETUTCDATE())
			END

			/**This log only for adhocbroadcast/quicksms as retentionperiod might have selected from dataretentionrule table**/
			SET @sOutputLog = @sOutputLog + ',Retention Parameters initializing @sTaskType = ' + isnull(@sTaskType,'') 
			                    + ',@sRecordStatus = ' + CAST(@sRecordStatus AS VARCHAR(10)) + ', @bIsRunningCampaign=' + CAST(@bIsRunningCampaign AS CHAR(1)) 
								+ '@sTaskStatus=' + CAST(@sTaskStatus AS VARCHAR(20)) + ',@iOrganizationId='+ CAST(isnull(@iOrganizationId,0) AS VARCHAR(20)) 
								+ '@iRetentionPeriod=' + CAST(ISNULL(@iRetentionPeriod,0) AS VARCHAR(10))+
							    + ' ,@dDelDate = '+ CONVERT(VARCHAR(100), ISNULL(@dDelDate,'')) +''


			
			/*** MAINTAIN STATICSTICS  ***/
		   IF NOT EXISTS(SELECT 1 FROM TASK WITH(NOLOCK) 
           WHERE TASKID = @iTask_Id 
           AND RetentionStatus = 'Calculated')
			BEGIN
				EXEC SP_Statistics_Task_AdhocBroadcast @iTask_Id;
				SET @sOutputLog = @sOutputLog +',Statistics calculated';
			END
			
		/*** PURGE DATA FROM MTScheduledSubscription ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
				IF(@bIsRunningCampaign = 0)
					BEGIN
						DELETE TOP (@rowsRemaining)
						FROM MTScheduledSubscription
						WHERE TaskID = @iTask_Id
					END
					ELSE
					BEGIN
						DELETE TOP (@rowsRemaining)
						FROM MTScheduledSubscription
						WHERE TaskID = @iTask_Id
						AND sentOn < @dDelDate
					END

				/*** Handle log ***/
							SELECT @rowsRemaining= @@RowCount
			 			
							SET @sOutputLog = @sOutputLog + ',MTScheduledSubscription:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

							IF(@rowsRemaining < @iBatchSize)
								BEGIN
									SET @rowsRemaining = 0;
								END
								
						
			END

		/*** PURGE DATA FROM MTTimeBlock ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN

				IF(@bIsRunningCampaign = 0)
					BEGIN
						DELETE TOP (@rowsRemaining)
						FROM MTTimeBlock
						WHERE TaskID = @iTask_Id
					END
					ELSE
					BEGIN
						DELETE TOP (@rowsRemaining)
						FROM MTTimeBlock
						WHERE TaskID = @iTask_Id
						AND [STATUS] IN ('Completed','Error')
						AND StartTime < @dDelDate
					END
				
 
				/*** Handle log ***/
				SELECT @rowsRemaining= @@RowCount
			
					    SET @sOutputLog = @sOutputLog + ',MTTimeblock:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

					    IF(@rowsRemaining < @iBatchSize)
							BEGIN
								SET @rowsRemaining = 0;
							END
					
    		END

		/*** PURGE DATA FROM MTTraffic ***/
			SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
		
					IF(@bIsRunningCampaign = 0)
					BEGIN
						DELETE TOP (@rowsRemaining)
						FROM MTTraffic
						WHERE TaskID = @iTask_Id
					END
					ELSE
					BEGIN
					    DELETE TOP (@rowsRemaining)
						FROM MTTraffic
						WHERE TaskID = @iTask_Id
						AND UPDATEDON < @dDelDate
					END

				

				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount
				IF @rowsRemaining = 0 
					
				SET @sOutputLog = @sOutputLog + ',MTTraffic:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

				IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
					    
			END
		
		/*** PURGE DATA FROM MTAdhocTask ***/
		SET @rowsRemaining = @iBatchSize;
			WHILE @rowsRemaining > 0
			BEGIN
			
			       IF(@bIsRunningCampaign = 0)
					BEGIN
						DELETE TOP (@rowsRemaining)
						FROM MTAdhocTask
						WHERE TaskID = @iTask_Id
					END
					ELSE
					BEGIN
						DELETE TOP (@rowsRemaining)
						FROM MTAdhocTask
						WHERE TaskID = @iTask_Id
						AND ProcessStartTime < @dDelDate
					END
		
			
				/*** Handle log ***/
				SELECT  @rowsRemaining= @@RowCount
			
			  SET @sOutputLog = @sOutputLog + ',MTAdhocTask:DeletedRows=' + convert(varchar(31),@rowsRemaining) 

			 IF(@rowsRemaining < @iBatchSize)
				BEGIN
					SET @rowsRemaining = 0;
				END
					    
			END
			
			/**If not quick sms or running campaign**/
				IF(@bIsRunningCampaign = 0)
				BEGIN
					SET @sStatusTobeUpdated = 'Completed'
				END
				ELSE
				BEGIN
					SET @sStatusTobeUpdated = 'Pending'
				END
			
			   /*** UPDATE RETENTION STATUS ***/
				UPDATE Task
				SET RetentionRunOn = GETUTCDATE(),
				RetentionStatus = @sStatusTobeUpdated
				WHERE TaskID = @iTask_Id

				/*** Handle log ***/
				SELECT  @rowsUpdated= @@RowCount
				SET @sOutputLog = @sOutputLog + ',RetentionStatus updated to @sStatusTobeUpdated='+ @sStatusTobeUpdated + ',@rowsUpdated:' + convert(varchar(31),@rowsUpdated) 
	
		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE();
			            
			SET @sOutputLog = @sOutputLog + 'Error_Detected : @ErrorMessage=' + @ErrorMessage
			
		END CATCH
		SET DEADLOCK_PRIORITY NORMAL;
		SET LOCK_TIMEOUT -1; --Default value of lock_timout is -1
		
		IF(@ErrorMessage !='')
		BEGIN
				 RAISERROR (@sOutputLog, -- Message text.  
						   16, -- Severity.  
						   1 -- State.  
						   );  
		END
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Retention_Run]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[SP_Retention_Run]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE 
	@iRC         int,
	@iRetentionLogID   int,
	@iError        int,
	@iRowsToProcess     int,
	@sDetail_Name varchar(500),
    @ErrorMessage NVARCHAR(4000),
	@sTempDesc VARCHAR(2000),
	@iTaskID INT,
	@sTaskType VARCHAR(50),
	@sRecordStatus CHAR(1),
	@iRowNumber INT,
	@iProcessRetention INT,
	@sOutputLog VARCHAR(2000),
	@iMaxRetryCount INT,
	@iMaxRetentionCount INT,
	@iProcessedCount INT
	
	SET @ErrorMessage = '';
	SET @iRC = -1
	SET @iProcessRetention = 1;
	SET @iProcessedCount = 0;
	SET @iMaxRetentionCount = 0;

	SET @sDetail_Name	= OBJECT_NAME(@@PROCID)
	
	EXEC @iRetentionLogID = [SP_StartRetentionLog] 'Retention Start'

	SELECT @iMaxRetryCount = [ParamValue] 
	FROM SystemConfig WITH(NOLOCK)
	WHERE [ParamName]  = 'MaxRetryCount'
	AND CATEGORY = 'DataRetention'

	IF(@iMaxRetryCount <= 0)
	BEGIN
		SET @iMaxRetryCount = 3; --Default max retry count
	END
	
	SELECT @iMaxRetentionCount = [ParamValue] 
	FROM SystemConfig WITH(NOLOCK)
	WHERE [ParamName]  = 'MaxRetentionCount'
	AND CATEGORY = 'DataRetention'

	
	/**step 1 scan through all Task**/

		/**scan list based task**/
				UPDATE Task Set RetentionStatus = 'Ready' 
				WHERE TaskType = 'ListBased'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND ([Status] = 'Completed' OR [Status] = 'Error')
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), UpdatedOn) < GETUTCDATE()
				 
 		/**scan email based task**/
				UPDATE Task Set RetentionStatus = 'Ready' 
				WHERE TaskType = 'EmailBased'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND ([Status] = 'Completed' OR [Status] = 'Error')
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), UpdatedOn) < GETUTCDATE()

		/**scan MOOptIn task for status Completed or error**/
				UPDATE T Set RetentionStatus = 'Ready' 
				FROM Task T JOIN MOTask M ON T.TaskID = M.TaskID
				WHERE TaskType = 'MOOptIn'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND ([Status] = 'Completed' OR [Status] = 'Error')
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), M.EndTime) < GETUTCDATE()

		/**scan MOOptIn task for Stopped**/
				UPDATE Task	SET RetentionStatus = 'Ready' 
				WHERE TaskType = 'MOOptIn'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND [Status] = 'Stopped'
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), UpdatedOn) < GETUTCDATE()

		/**scan OnDemand task for status Completed or error**/
				UPDATE T Set RetentionStatus = 'Ready' 
				FROM Task T JOIN MOTask M ON T.TaskID = M.TaskID
				WHERE TaskType = 'OnDemand'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND ([Status] = 'Completed' OR [Status] = 'Error')
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), M.EndTime) < GETUTCDATE()

		/**scan OnDemand task for Stopped**/
				UPDATE Task
				SET RetentionStatus = 'Ready' 
				WHERE TaskType = 'OnDemand'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND [Status] = 'Stopped'
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), UpdatedOn) < GETUTCDATE()

		/**scan MOValidation task for status Completed or error**/
				UPDATE T Set RetentionStatus = 'Ready' 
				FROM Task T JOIN MOTask M ON T.TaskID = M.TaskID
				WHERE TaskType = 'MOValidation'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND ([Status] = 'Completed' OR [Status] = 'Error')
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), M.EndTime) < GETUTCDATE()

		/**scan MOValidation task for Stopped**/
				UPDATE Task	SET RetentionStatus = 'Ready' 
				WHERE TaskType = 'MOValidation'
				AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				AND [Status] = 'Stopped'
				AND DATEADD(DAY, ISNULL(RetentionPeriod,0), UpdatedOn) < GETUTCDATE()

		/**scan Quick SMS task**/
				UPDATE Task 
				Set RetentionStatus = 'Ready' 
				WHERE TaskType = 'AdhocBroadcast'
				AND RecordStatus = 'S'

		/**scan adhoc broadcast**/
				--UPDATE Task 
				--Set RetentionStatus = 'Ready' 
				--WHERE TaskType = 'AdhocBroadcast'
				--AND ISNULL(RetentionStatus,'Pending') = 'Pending'
				--AND ([Status] = 'Completed' OR [Status] = 'Error')
				--AND DATEADD(DAY, ISNULL(RetentionPeriod,0), UpdatedOn) < GETUTCDATE()

	  /** step 2 process ready task**/
	  	WHILE (@iProcessRetention = 1)
				BEGIN
							--Reset
							SET @iTaskID = 0;
							SET @sTaskType = '';
							SET @sOutputLog = '';
							SET @sTempDesc = '';

							--Get top 1 ready record
							SELECT TOP 1 @iTaskID = TASKID, 
							@sTaskType = [TASKTYPE]
							FROM TASK WITH(NOLOCK)
							WHERE (ISNULL(RetentionStatus,'') = 'Ready' 
							OR ISNULL(RetentionStatus,'') = 'Calculated') --MM 5.16.0
							AND ISNULL(RetentionRetryCount,0) < @iMaxRetryCount
							ORDER BY RetentionRunOn

							--exit if no records found to be processsed
							IF(@iTaskID = 0)
							BEGIN
								SET @iProcessRetention = 0;
								BREAK;
							END
							
							   --call retention procedure as per task type
								BEGIN TRY
																				
								IF(@sTaskType = 'ListBased')
								BEGIN
									EXEC SP_RETENTION_TASK_LISTBASED @iTaskID, @sOutputLog OUTPUT
								END

								IF(@sTaskType = 'EmailBased')
								BEGIN
									EXEC SP_RETENTION_TASK_EMAILBASED @iTaskID, @sOutputLog OUTPUT
								END
								
								IF(@sTaskType = 'MOOptIn')
								BEGIN
									EXEC SP_RETENTION_TASK_MOOptIn @iTaskID, @sOutputLog OUTPUT
								END

								IF(@sTaskType = 'OnDemand')
								BEGIN
									EXEC SP_RETENTION_TASK_OnDemand @iTaskID, @sOutputLog OUTPUT
								END

								IF(@sTaskType = 'MOValidation')
								BEGIN
									EXEC SP_RETENTION_TASK_MOValidation @iTaskID, @sOutputLog OUTPUT
								END

								/**common procedure could be called for quick sms and adhocbroadcast **/
								IF(@sTaskType = 'AdhocBroadcast') /**Quick SMS**/
								BEGIN
									EXEC SP_RETENTION_TASK_AdhocBroadcast @iTaskID, @sOutputLog OUTPUT
								END

						END TRY
						BEGIN CATCH
							SELECT   @ErrorMessage = ERROR_MESSAGE()

							SET @sTempDesc = 'Error_Detected :@iTaskID = '+ CONVERT(varchar,@iTaskID) +' @ErrorMessage=' + @ErrorMessage
							
							--on error update the retention time and retry count
								UPDATE TASK
								SET RetentionRetryCount = ISNULL(RetentionRetryCount,0) + 1,
								RetentionRunOn = GETUTCDATE()
								FROM TASK
								WHERE TaskID = @iTaskID

						END CATCH

							SET @iProcessedCount = @iProcessedCount + 1;

							SET @sTempDesc = @sTempDesc + @sOutputLog
							INSERT INTO DataRetentionDetailLog ([DataRetentionJobID],[TaskId],[RetentionTime],[LogDetail])
							VALUES (@iRetentionLogID,@iTaskID,GETUTCDATE(),@sTempDesc)

							IF(@iMaxRetentionCount > 0 
							AND @iProcessedCount >= @iMaxRetentionCount)
							BEGIN
								SET @iProcessRetention = 0;
								BREAK;
							END

						END
	
		IF(@ErrorMessage != '')
				BEGIN
					SET @sTempDesc = 'Retention job failed for one of the task. Please check the retention log for more details.@iRetentionLogID='+ CAST(@iRetentionLogID AS VARCHAR(10));
					SET @sDetail_Name = OBJECT_NAME(@@PROCID)
					GOTO AlertFailure;
				END

	EXEC SP_ENDRetentionLog  @iRetentionLogID, 2

	return 0

AlertFailure:
	exec SP_ENDRetentionLog  @iRetentionLogID, 3
	exec [SP_Alert_Rention_Job_Failure] @sDetail_Name, @sTempDesc
	return 0

END /* SP_Retention_Run */
GO
/****** Object:  StoredProcedure [dbo].[ReportRun]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ReportRun]
AS
/*******************************************************************/
--Name		: ReportRun
--Module	: Report
--Description 	: Entry Point
--		  Procedure that is called by the DB scheduled job to
--		  kick start the reporting process
--Important Note: This can only be executed one at a time
--Input Param	: N/A
--Return Value	: N/A
/*******************************************************************/
BEGIN
	DECLARE	@ReportID INT,
		@Count INT,
		@LoopFlag VARCHAR(10),
		@DelayLength CHAR(8),
		@Error INT,
		@ReportEnabled CHAR(1)

	/**********Initialize variables**************/
	SET @LoopFlag = 'TRUE'
	SELECT	@DelayLength = paramvalue 
	FROM 	reportparam 
	WHERE 	UPPER(paramname) = 'REPORTPROCESSINGINTERVAL'
	IF (ISDATE('2000-01-01 ' + @delaylength + '.000') = 0)
	BEGIN
		SET @delaylength = '00:00:15' --setting it to 15 seconds if the default value is not found
	END

	/**********Process any pending request(s)********/
	While (@loopflag = 'TRUE')
	BEGIN
		SELECT	@reportEnabled = paramvalue
		from	reportparam
		where	upper(paramname) = 'REPORTENABLED'
		IF (@reportEnabled = '0')
			break

		SELECT	TOP 1 @reportID = reportid 
		FROM 	report 
		WHERE 	status = 'Pending' 
		ORDER BY reportid

		UPDATE	report
		SET 	status = 'Processing'
		WHERE 	reportid = @reportID
		AND 	status = 'Pending'

		SET @Count = @@ROWCOUNT
			
		IF (@Count = 1)
		BEGIN
			EXEC @reportID = REPORTSTART @reportID
		END
		--if no more pending request, sleep for x seconds
		SELECT	@Count = COUNT(*) 
		FROM 	report 
		WHERE 	status = 'Pending'
		IF (@Count = 0)
		BEGIN
			--to set any requests which are still in 'Processing' status to 'Error' status
			UPDATE report
			SET    status = 'Error'
			WHERE  status = 'Processing'
			WAITFOR DELAY @delaylength
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AllocateAdhocTaskSubscriptionsAllAtOnce]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_AllocateAdhocTaskSubscriptionsAllAtOnce]
	@TaskID INT,
	@ScheduleID INT,
	@AdhocID INT,
	@MaxTimeBlockSize INT,
	@ScheduleNewStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@SubscriptionInactiveStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON


	DECLARE @StartTime DATETIME
	DECLARE @ErrorCount INT
	DECLARE @FinalAllocatedCount INT

	PRINT 'Start Allocating Task [ID: ' + CAST(@TaskID AS VARCHAR) + '] [Type: AllAtOnce] [Task Type:Adhoc] [MTAdhocID: '+ CAST(@AdhocID AS VARCHAR) + ']'

	SELECT TOP 1 @ScheduleID = ScheduleID, @StartTime = StartTime
	FROM MTSchedule
	WHERE TaskID = @TaskID
	AND Status = @ScheduleNewStatus
	AND ScheduleID = @ScheduleID
	ORDER BY StartTime ASC
	IF ((@ScheduleID IS NULL) OR (@ScheduleID <= 0))
	BEGIN
		PRINT 'Error: No Schedule Found'
		RETURN -1
	END
	BEGIN TRANSACTION
	PRINT 'External Transaction Started'
	PRINT 'Processing Schedule [ID: ' + CAST(@ScheduleID AS VARCHAR) + '] [Allocated: ALL]'
	PRINT '------------------------------------------------------------------------------------'

	EXEC @FinalAllocatedCount = MT_AllocateAdhocTimeBlockSubscriptions @TaskID, @ScheduleID, @AdhocID, @StartTime, NULL, @MaxTimeBlockSize, NULL, @TimeBlockPendingStatus, @SubscriptionInactiveStatus, @SubscriptionPendingStatus, @SubscriptionErrorStatus

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @SchedulePendingStatus, ActualAllocatedCount = @FinalAllocatedCount
	WHERE TaskID = @TaskID 
	AND ScheduleID = @ScheduleID
	AND Status = @ScheduleNewStatus
	PRINT 'Schedule Status Updated [Status: ' + @SchedulePendingStatus + ']'

	UPDATE MTScheduledSubscription WITH (ROWLOCK) SET Status = @SubscriptionErrorStatus
	WHERE TaskID = @TaskID 
	AND ISNULL(MTAdhocID,0) = @AdhocID
	AND ScheduleID = 0 
	AND TimeBlockID = 0
	AND ScheduledOn = NULL
	AND Status = @SubscriptionInactiveStatus
	SET @ErrorCount = @@ROWCOUNT
	PRINT 'Remain Subscription Mark as Error [Count: ' + CAST(@ErrorCount AS VARCHAR) + ']'

	PRINT '------------------------------------------------------------------------------------'
	COMMIT TRANSACTION
	PRINT 'External Transaction Committed'
	PRINT 'Task Allocated'
	RETURN @ErrorCount
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AllocateTaskSubscriptionsRepeatable]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_AllocateTaskSubscriptionsRepeatable]
	@TaskID INT,
	@MaxTimeBlockSize INT,
	@ScheduleNewStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@SubscriptionInactiveStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ScheduleID INT
	DECLARE @StartTime DATETIME
	DECLARE @ErrorCount INT
	DECLARE @FinalAllocatedCount INT

	PRINT 'Start Allocating Task [ID: ' + CAST(@TaskID AS VARCHAR) + '] [Type: Repeatable]'
	SELECT TOP 1 @ScheduleID = ScheduleID, @StartTime = StartTime
	FROM MTSchedule
	WHERE TaskID = @TaskID
	AND Status = @ScheduleNewStatus
	ORDER BY StartTime ASC

	IF ((@ScheduleID IS NULL) OR (@ScheduleID <= 0))
	BEGIN
		PRINT 'Error: No Schedule Found'
		RETURN -1
	END

	BEGIN TRANSACTION
	PRINT 'External Transaction Started'
	PRINT 'Processing Schedule [ID: ' + CAST(@ScheduleID AS VARCHAR) + '] [Allocated: ALL]'
	PRINT '------------------------------------------------------------------------------------'

	EXEC @FinalAllocatedCount = MT_AllocateTimeBlockSubscriptions @TaskID, @ScheduleID, @StartTime, NULL, @MaxTimeBlockSize, NULL, @TimeBlockPendingStatus, @SubscriptionInactiveStatus, @SubscriptionPendingStatus, @SubscriptionErrorStatus

	UPDATE MTSchedule SET Status = @SchedulePendingStatus, ActualAllocatedCount = @FinalAllocatedCount
	WHERE TaskID = @TaskID 
	AND ScheduleID = @ScheduleID
	AND Status = @ScheduleNewStatus
	PRINT 'Schedule Status Updated [Status: ' + @SchedulePendingStatus + ']'

	UPDATE MTScheduledSubscription SET Status = @SubscriptionErrorStatus
	WHERE TaskID = @TaskID 
	AND ScheduleID = 0 
	AND TimeBlockID = 0
	AND Status = @SubscriptionInactiveStatus
	SET @ErrorCount = @@ROWCOUNT
	PRINT 'Remain Subscription Mark as Error [Count: ' + CAST(@ErrorCount AS VARCHAR) + ']'

	INSERT INTO MTBroadcastHistory (TaskID, ScheduleID, SubscriptionCount, CreatedOn, UpdatedOn)
	VALUES (@TaskID, @ScheduleID, @FinalAllocatedCount, GETUTCDATE(), GETUTCDATE())	
	PRINT 'Schedule BroadcastHistory Created'
	PRINT '------------------------------------------------------------------------------------'
	COMMIT TRANSACTION
	PRINT 'External Transaction Committed'
	PRINT 'Task Allocated'
	RETURN @ErrorCount
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AllocateTaskSubscriptionsByWindow]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[MT_AllocateTaskSubscriptionsByWindow]
	@TaskID INT,
	@MaxTimeBlockSize INT,
	@ScheduleNewStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@SubscriptionInactiveStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ScheduleID INT
	DECLARE @StartTime DATETIME
	DECLARE @EndTime DATETIME
	DECLARE @RemainCount INT
	DECLARE @Interval INT
	DECLARE @SendingRate INT
	DECLARE @AllocatedCount INT
	DECLARE @ActualAllocatedCount INT
	DECLARE @TotalAllocatedCount INT
	DECLARE @IntervalSize INT
	DECLARE @TimeBlockSize INT
	DECLARE @UnallocatedCount INT

	PRINT 'Start Allocating Task [ID: ' + CAST(@TaskID AS VARCHAR) + '] [Type: ByWindow]'
	BEGIN TRANSACTION
	PRINT 'External Transaction Started'
	WHILE (EXISTS(SELECT * FROM MTSchedule WHERE TaskID = @TaskID AND Status = @ScheduleNewStatus))
	BEGIN
		SELECT TOP 1 @ScheduleID = ScheduleID, @StartTime = StartTime, @EndTime = EndTime, 
		@Interval = TimeBlockInterval, @IntervalSize = TimeBlockSize, @AllocatedCount = AllocatedCount 
		FROM MTSchedule 
		WHERE TaskID = @TaskID 
		AND Status = @ScheduleNewStatus
		ORDER BY StartTime ASC

		SELECT @UnallocatedCount = COUNT(*) FROM MTScheduledSubscription 
		WHERE TaskID = @TaskID
		AND ScheduleID = 0
		AND TimeBlockID = 0
		AND Status = @SubscriptionInactiveStatus
		IF ((@AllocatedCount IS NULL) OR (@AllocatedCount = 0) OR (@AllocatedCount > @UnallocatedCount))
		BEGIN
			SET @AllocatedCount = @UnallocatedCount
		END
		SET @TotalAllocatedCount = 0
		PRINT 'Processing Schedule [ID: ' + CAST(@ScheduleID AS VARCHAR) + '] [Allocated: ' + CAST(@AllocatedCount AS VARCHAR) +'] [IntervalSize: ' + CAST(@IntervalSize AS VARCHAR) + ']'
		PRINT '------------------------------------------------------------------------------------'
		SELECT @RemainCount = @AllocatedCount
		WHILE (@RemainCount > 0)
		BEGIN
			SET @TimeBlockSize = @IntervalSize
			IF (@RemainCount < @IntervalSize)
			BEGIN
				SET @TimeBlockSize = @RemainCount
			END
			EXEC @ActualAllocatedCount = MT_AllocateTimeBlockSubscriptions @TaskID, @ScheduleID, @StartTime, @EndTime, @MaxTimeBlockSize, @TimeBlockSize, @TimeBlockPendingStatus, @SubscriptionInactiveStatus, @SubscriptionPendingStatus, @SubscriptionErrorStatus
			IF (@ActualAllocatedCount <= 0)
			BEGIN
				PRINT 'Allocated TimeBlock is Empty'
				SET @RemainCount = 0
			END
			ELSE
			BEGIN
				SET @StartTime = DATEADD(minute, @Interval, @StartTime)
				SET @RemainCount = @RemainCount - @ActualAllocatedCount
				SET @TotalAllocatedCount = @TotalAllocatedCount + @ActualAllocatedCount
			END
		END
		UPDATE MTSchedule SET Status = @SchedulePendingStatus, ActualAllocatedCount = @TotalAllocatedCount 
		WHERE ScheduleID = @ScheduleID

		PRINT 'Schedule Status Updated [Status: ' + @SchedulePendingStatus + ']'
		INSERT INTO MTBroadcastHistory (TaskID, ScheduleID, SubscriptionCount, CreatedOn, UpdatedOn)
		VALUES (@TaskID, @ScheduleID, @TotalAllocatedCount, GETUTCDATE(), GETUTCDATE())	
		PRINT 'Schedule BroadcastHistory Created'
		PRINT '------------------------------------------------------------------------------------'
	END

	UPDATE MTScheduledSubscription WITH (ROWLOCK) SET Status = @SubscriptionUnallocatedStatus
	WHERE TaskID = @TaskID
	AND ScheduleID = 0
	AND TimeBlockID = 0
	AND Status = @SubscriptionInactiveStatus
	PRINT 'Remain Subscription Mark as Unallocated [Count: ' + CAST(@@ROWCOUNT AS VARCHAR) + ']'
	COMMIT TRANSACTION
	PRINT 'External Transaction Committed'
	PRINT 'Task Allocated'
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AllocateTaskSubscriptionsByBlock]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_AllocateTaskSubscriptionsByBlock]
	@TaskID INT,
	@MaxTimeBlockSize INT,
	@ScheduleNewStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@SubscriptionInactiveStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionUnallocatedStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ScheduleID INT
	DECLARE @StartTime DATETIME
	DECLARE @EndTime DATETIME
	DECLARE @RemainCount INT
	DECLARE @Interval INT
	DECLARE @AllocatedCount INT
	DECLARE @ActualAllocatedCount INT
	DECLARE @TotalAllocatedCount INT
	DECLARE @IntervalSize INT
	DECLARE @TimeBlockSize INT
	DECLARE @UnallocatedCount INT

	PRINT 'Start Allocating Task [ID: ' + CAST(@TaskID AS VARCHAR) + '] [Type: ByBlock]'
	BEGIN TRANSACTION
	PRINT 'External Transaction Started'
	WHILE (EXISTS(SELECT * FROM MTSchedule WHERE TaskID = @TaskID AND Status = @ScheduleNewStatus))
	BEGIN
		SELECT TOP 1 @ScheduleID = ScheduleID, @StartTime = StartTime, @EndTime = EndTime, 
		@Interval = TimeBlockInterval, @IntervalSize = TimeBlockSize, @AllocatedCount = AllocatedCount 
		FROM MTSchedule 
		WHERE TaskID = @TaskID 
		AND Status = @ScheduleNewStatus
		ORDER BY StartTime ASC

		SELECT @UnallocatedCount = COUNT(*) FROM MTScheduledSubscription 
		WHERE TaskID = @TaskID
		AND ScheduleID = 0
		AND TimeBlockID = 0
		AND Status = @SubscriptionInactiveStatus
		IF ((@AllocatedCount IS NULL) OR (@AllocatedCount = 0) OR (@AllocatedCount > @UnallocatedCount))
		BEGIN
			SET @AllocatedCount = @UnallocatedCount
		END

		SET @TotalAllocatedCount = 0
		PRINT 'Processing Schedule [ID: ' + CAST(@ScheduleID AS VARCHAR) + '] [Allocated: ' + CAST(@AllocatedCount AS VARCHAR) +'] [IntervalSize: ' + CAST(@IntervalSize AS VARCHAR) + ']'
		PRINT '------------------------------------------------------------------------------------'
		SELECT @RemainCount = @AllocatedCount
		WHILE (@RemainCount > 0)
		BEGIN
			SET @TimeBlockSize = @IntervalSize
			IF (@RemainCount < @IntervalSize)
			BEGIN
				SET @TimeBlockSize = @RemainCount
			END
			EXEC @ActualAllocatedCount = MT_AllocateTimeBlockSubscriptions @TaskID, @ScheduleID, @StartTime, NULL, @MaxTimeBlockSize, @TimeBlockSize, @TimeBlockPendingStatus, @SubscriptionInactiveStatus, @SubscriptionPendingStatus, @SubscriptionErrorStatus
			IF (@ActualAllocatedCount <= 0)
			BEGIN
				SET @RemainCount = 0
			END
			ELSE
			BEGIN
				SET @StartTime = DATEADD(minute, @Interval, @StartTime)
				SET @RemainCount = @RemainCount - @ActualAllocatedCount
				SET @TotalAllocatedCount = @TotalAllocatedCount + @ActualAllocatedCount
			END
		END
		UPDATE MTSchedule SET Status = @SchedulePendingStatus, ActualAllocatedCount = @TotalAllocatedCount
		WHERE ScheduleID = @ScheduleID

		PRINT 'Schedule Status Updated [Status: ' + @SchedulePendingStatus + ']'
		INSERT INTO MTBroadcastHistory (TaskID, ScheduleID, SubscriptionCount, CreatedOn, UpdatedOn)
		VALUES (@TaskID, @ScheduleID, @TotalAllocatedCount, GETUTCDATE(), GETUTCDATE())	
		PRINT 'Schedule BroadcastHistory Created'
		PRINT '------------------------------------------------------------------------------------'
	END

	UPDATE MTScheduledSubscription SET Status = @SubscriptionUnallocatedStatus
	WHERE TaskID = @TaskID
	AND ScheduleID = 0
	AND TimeBlockID = 0
	AND Status = @SubscriptionInactiveStatus
	PRINT 'Remain Subscription Mark as Unallocated [Count: ' + CAST(@@ROWCOUNT AS VARCHAR) + ']'
	COMMIT TRANSACTION
	PRINT 'External Transaction Committed'
	PRINT 'Task Allocated'
END
GO
/****** Object:  StoredProcedure [dbo].[MT_AllocateTaskSubscriptionsAllAtOnce]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[MT_AllocateTaskSubscriptionsAllAtOnce]
	@TaskID INT,
	@MaxTimeBlockSize INT,
	@ScheduleNewStatus VARCHAR(15),
	@SchedulePendingStatus VARCHAR(15),
	@TimeBlockPendingStatus VARCHAR(15),
	@SubscriptionInactiveStatus CHAR(1),
	@SubscriptionPendingStatus CHAR(1),
	@SubscriptionErrorStatus CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ScheduleID INT
	DECLARE @StartTime DATETIME
	DECLARE @ErrorCount INT
	DECLARE @FinalAllocatedCount INT

	PRINT 'Start Allocating Task [ID: ' + CAST(@TaskID AS VARCHAR) + '] [Type: AllAtOnce]'
	SELECT TOP 1 @ScheduleID = ScheduleID, @StartTime = StartTime
	FROM MTSchedule
	WHERE TaskID = @TaskID
	AND Status = @ScheduleNewStatus
	ORDER BY StartTime ASC
	IF ((@ScheduleID IS NULL) OR (@ScheduleID <= 0))
	BEGIN
		PRINT 'Error: No Schedule Found'
		RETURN -1
	END
	BEGIN TRANSACTION
	PRINT 'External Transaction Started'
	PRINT 'Processing Schedule [ID: ' + CAST(@ScheduleID AS VARCHAR) + '] [Allocated: ALL]'
	PRINT '------------------------------------------------------------------------------------'

	EXEC @FinalAllocatedCount = MT_AllocateTimeBlockSubscriptions @TaskID, @ScheduleID, @StartTime, NULL, @MaxTimeBlockSize, NULL, @TimeBlockPendingStatus, @SubscriptionInactiveStatus, @SubscriptionPendingStatus, @SubscriptionErrorStatus

	UPDATE MTSchedule WITH (ROWLOCK) SET Status = @SchedulePendingStatus, ActualAllocatedCount = @FinalAllocatedCount
	WHERE TaskID = @TaskID 
	AND ScheduleID = @ScheduleID
	AND Status = @ScheduleNewStatus
	PRINT 'Schedule Status Updated [Status: ' + @SchedulePendingStatus + ']'

	UPDATE MTScheduledSubscription WITH (ROWLOCK) SET Status = @SubscriptionErrorStatus
	WHERE TaskID = @TaskID 
	AND ScheduleID = 0 
	AND TimeBlockID = 0
	AND ScheduledOn = NULL
	AND Status = @SubscriptionInactiveStatus
	SET @ErrorCount = @@ROWCOUNT
	PRINT 'Remain Subscription Mark as Error [Count: ' + CAST(@ErrorCount AS VARCHAR) + ']'

	INSERT INTO MTBroadcastHistory (TaskID, ScheduleID, SubscriptionCount, CreatedOn, UpdatedOn)
	VALUES (@TaskID, @ScheduleID, @FinalAllocatedCount, GETUTCDATE(), GETUTCDATE())	
	PRINT 'Schedule BroadcastHistory Created'
	PRINT '------------------------------------------------------------------------------------'
	COMMIT TRANSACTION
	PRINT 'External Transaction Committed'
	PRINT 'Task Allocated'
	RETURN @ErrorCount
END
GO
/****** Object:  StoredProcedure [dbo].[InvokeDataRetention]    Script Date: 11/06/2020 08:48:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InvokeDataRetention]
       AS
       BEGIN
              DECLARE @organizationID INT
              DECLARE @NoOfDays int
              DECLARE @isMsgReplaced varchar(20)
              DECLARE @msg varchar(30)
              DECLARE @isMsisdnReplaced varchar(20)
              DECLARE @msisdn varchar(30)
              DECLARE @DataRetentionID int

              DECLARE CUR_DataRetention CURSOR FOR
              SELECT DataRetentionID,OrganizationID,NoOfDays,IsMessageReplaced,ReplacementMessage,IsMSISDNReplaced,ReplacementMSISDN
              FROM DataRetention WITH (NOLOCK)
              where IsDataRetention='Y' and (IsMessageReplaced='Y' or IsMSISDNReplaced='Y') and NoOfDays > 0
              OPEN CUR_DataRetention
              FETCH NEXT FROM CUR_DataRetention INTO @DataRetentionID,@organizationID,@NoOfDays,@isMsgReplaced,@msg,@isMsisdnReplaced,@msisdn
              WHILE @@FETCH_STATUS=0
              BEGIN
                  PRINT 'organizationID:'+CONVERT(CHAR, @organizationID) 
                     PRINT 'NoOfDays:'+ CONVERT(CHAR,@NoOfDays) 
                     PRINT 'isMsgReplaced:'+ CONVERT(CHAR,@isMsgReplaced)
                     PRINT 'msg:'+@msg
                     PRINT 'isMsisdnReplaced:'+CONVERT(CHAR,@isMsisdnReplaced)
                     PRINT 'msisdn:'+@msisdn
                     --PRINT 'DataRetentionID:'+@DataRetentionID
                         IF (@@ERROR <> 0)
                           BEGIN
                                  PRINT 'Error :'+CONVERT(CHAR,@@ERROR)
                           END
                           ELSE
                           BEGIN
                              PRINT 'Success'
                            EXEC [DataRetentionProcedure] @organizationID,@NoOfDays,@isMsgReplaced,@msg,@isMsisdnReplaced,@msisdn,@DataRetentionID 
                END
              
              FETCH NEXT FROM CUR_DataRetention INTO @DataRetentionID, @organizationID,@NoOfDays,@isMsgReplaced,@msg,@isMsisdnReplaced,@msisdn
              END
              CLOSE CUR_DataRetention
              DEALLOCATE CUR_DataRetention

       END
GO
/****** Object:  Default [DF_Assets_RecordStatus]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Asset] ADD  CONSTRAINT [DF_Assets_RecordStatus]  DEFAULT ('A') FOR [RecordStatus]
GO
/****** Object:  Default [DF_Automator_AutomatorType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Automator] ADD  CONSTRAINT [DF_Automator_AutomatorType]  DEFAULT ('MT') FOR [AutomatorType]
GO
/****** Object:  Default [DF__Blacklist__Type__542C7691]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Blacklist] ADD  DEFAULT ('MT') FOR [Type]
GO
/****** Object:  Default [DF_DataRetentionDetailLog]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[DataRetentionDetailLog] ADD  CONSTRAINT [DF_DataRetentionDetailLog]  DEFAULT (getdate()) FOR [RetentionTime]
GO
/****** Object:  Default [DF_DataRetentionJob_StartTime]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[DataRetentionJob] ADD  CONSTRAINT [DF_DataRetentionJob_StartTime]  DEFAULT (getutcdate()) FOR [StartTime]
GO
/****** Object:  Default [DF_DataRetentionLog_ProcessedOn]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[DataRetentionLog] ADD  CONSTRAINT [DF_DataRetentionLog_ProcessedOn]  DEFAULT (getutcdate()) FOR [ProcessedOn]
GO
/****** Object:  Default [DF_DataRetentionRule_UpdatedOn]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[DataRetentionRule] ADD  CONSTRAINT [DF_DataRetentionRule_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
/****** Object:  Default [DF_DataRetentionRule_RecordStatus]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[DataRetentionRule] ADD  CONSTRAINT [DF_DataRetentionRule_RecordStatus]  DEFAULT ('S') FOR [RecordStatus]
GO
/****** Object:  Default [DF_EmailTasks_HubURL]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTasks_HubURL]  DEFAULT ('Empty') FOR [HubURL]
GO
/****** Object:  Default [DF_EmailTasks_HubHash]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTasks_HubHash]  DEFAULT ('Empty') FOR [HubHash]
GO
/****** Object:  Default [DF_EmailTasks_ListID]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTasks_ListID]  DEFAULT ((-1)) FOR [ListID]
GO
/****** Object:  Default [DF_EmailTasks_Asset]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTasks_Asset]  DEFAULT (N'Empty') FOR [AssetXML]
GO
/****** Object:  Default [DF_EmailTasks_SubscriptionCount]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTasks_SubscriptionCount]  DEFAULT ((-1)) FOR [SubscriptionCount]
GO
/****** Object:  Default [DF_EmailTask_IsNeedConfirmEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTask_IsNeedConfirmEmail]  DEFAULT ('N') FOR [IsNeedConfirmEmail]
GO
/****** Object:  Default [DF_EmailTask_IsNeedStartEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTask_IsNeedStartEmail]  DEFAULT ('N') FOR [IsNeedStartEmail]
GO
/****** Object:  Default [DF_EmailTask_IsNeedEndEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTask_IsNeedEndEmail]  DEFAULT ('N') FOR [IsNeedEndEmail]
GO
/****** Object:  Default [DF_EmailTask_IsConfirmEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTask_IsConfirmEmailSent]  DEFAULT ('N') FOR [IsConfirmEmailSent]
GO
/****** Object:  Default [DF_EmailTask_IsStartEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTask_IsStartEmailSent]  DEFAULT ('N') FOR [IsStartEmailSent]
GO
/****** Object:  Default [DF_EmailTask_IsEndEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTask_IsEndEmailSent]  DEFAULT ('N') FOR [IsEndEmailSent]
GO
/****** Object:  Default [DF_EmailTasks_ScheduleType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [DF_EmailTasks_ScheduleType]  DEFAULT ((1)) FOR [ScheduleType]
GO
/****** Object:  Default [Def_EmailTask_FairQueueGroup]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask] ADD  CONSTRAINT [Def_EmailTask_FairQueueGroup]  DEFAULT ('EMAIL') FOR [EmailFairQueueGroup]
GO
/****** Object:  Default [DF_ListCreationConfig_IsClean]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListCreationConfig] ADD  CONSTRAINT [DF_ListCreationConfig_IsClean]  DEFAULT ('N') FOR [IsClean]
GO
/****** Object:  Default [DF_ListCreationConfig_ListContentType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListCreationConfig] ADD  CONSTRAINT [DF_ListCreationConfig_ListContentType]  DEFAULT ('Subscriber') FOR [ListContentType]
GO
/****** Object:  Default [DF_ListTypes_IsAllowDuplicate]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListType] ADD  CONSTRAINT [DF_ListTypes_IsAllowDuplicate]  DEFAULT ('N') FOR [IsAllowDuplicate]
GO
/****** Object:  Default [DF_ListTypes_ListContentType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListType] ADD  CONSTRAINT [DF_ListTypes_ListContentType]  DEFAULT ('Subscriber') FOR [ListContentType]
GO
/****** Object:  Default [DF_MOResponse_TwoStepConfirmation]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MOResponse] ADD  CONSTRAINT [DF_MOResponse_TwoStepConfirmation]  DEFAULT (0) FOR [Verification]
GO
/****** Object:  Default [DF_MOSubscription_Status]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MOSubscription] ADD  CONSTRAINT [DF_MOSubscription_Status]  DEFAULT ('N') FOR [Status]
GO
/****** Object:  Default [DF_MOSubscriptions_CreatedOn]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MOSubscription] ADD  CONSTRAINT [DF_MOSubscriptions_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_MOTask_CampaignQuota]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MOTask] ADD  CONSTRAINT [DF_MOTask_CampaignQuota]  DEFAULT ('N') FOR [IsCampaignQuotaReached]
GO
/****** Object:  Default [DF_MTAdhocTasks_HubURL]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTasks_HubURL]  DEFAULT ('Empty') FOR [HubURL]
GO
/****** Object:  Default [DF_MTAdhocTasks_HubHash]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTasks_HubHash]  DEFAULT ('Empty') FOR [HubHash]
GO
/****** Object:  Default [DF_MTAdhocTasks_ListID]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTasks_ListID]  DEFAULT ((-1)) FOR [ListID]
GO
/****** Object:  Default [DF_MTAdhocTasks_Asset]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTasks_Asset]  DEFAULT (N'Empty') FOR [AssetXML]
GO
/****** Object:  Default [DF_MTAdhocTasks_SubscriptionCount]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTasks_SubscriptionCount]  DEFAULT ((-1)) FOR [SubscriptionCount]
GO
/****** Object:  Default [DF_MTAdhocTask_IsNeedConfirmEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTask_IsNeedConfirmEmail]  DEFAULT ('N') FOR [IsNeedConfirmEmail]
GO
/****** Object:  Default [DF_MTAdhocTask_IsNeedStartEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTask_IsNeedStartEmail]  DEFAULT ('N') FOR [IsNeedStartEmail]
GO
/****** Object:  Default [DF_MTAdhocTask_IsNeedEndEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTask_IsNeedEndEmail]  DEFAULT ('N') FOR [IsNeedEndEmail]
GO
/****** Object:  Default [DF_MTAdhocTask_IsConfirmEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTask_IsConfirmEmailSent]  DEFAULT ('N') FOR [IsConfirmEmailSent]
GO
/****** Object:  Default [DF_MTAdhocTask_IsStartEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTask_IsStartEmailSent]  DEFAULT ('N') FOR [IsStartEmailSent]
GO
/****** Object:  Default [DF_MTAdhocTask_IsEndEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTask_IsEndEmailSent]  DEFAULT ('N') FOR [IsEndEmailSent]
GO
/****** Object:  Default [DF_MTAdhocTasks_ScheduleType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [DF_MTAdhocTasks_ScheduleType]  DEFAULT ((1)) FOR [ScheduleType]
GO
/****** Object:  Default [Def_MTAdhocTask_FairQueueGroup]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask] ADD  CONSTRAINT [Def_MTAdhocTask_FairQueueGroup]  DEFAULT ('NORMAL') FOR [MTFairQueueGroup]
GO
/****** Object:  Default [DF_MTTasks_HubURL]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTasks_HubURL]  DEFAULT ('Empty') FOR [HubURL]
GO
/****** Object:  Default [DF_MTTasks_HubHash]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTasks_HubHash]  DEFAULT ('Empty') FOR [HubHash]
GO
/****** Object:  Default [DF_MTTasks_ListID]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTasks_ListID]  DEFAULT ((-1)) FOR [ListID]
GO
/****** Object:  Default [DF_MTTasks_Asset]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTasks_Asset]  DEFAULT (N'Empty') FOR [AssetXML]
GO
/****** Object:  Default [DF_MTTasks_SubscriptionCount]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTasks_SubscriptionCount]  DEFAULT ((-1)) FOR [SubscriptionCount]
GO
/****** Object:  Default [DF_MTTask_IsNeedConfirmEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTask_IsNeedConfirmEmail]  DEFAULT ('N') FOR [IsNeedConfirmEmail]
GO
/****** Object:  Default [DF_MTTask_IsNeedStartEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTask_IsNeedStartEmail]  DEFAULT ('N') FOR [IsNeedStartEmail]
GO
/****** Object:  Default [DF_MTTask_IsNeedEndEmail]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTask_IsNeedEndEmail]  DEFAULT ('N') FOR [IsNeedEndEmail]
GO
/****** Object:  Default [DF_MTTask_IsConfirmEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTask_IsConfirmEmailSent]  DEFAULT ('N') FOR [IsConfirmEmailSent]
GO
/****** Object:  Default [DF_MTTask_IsStartEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTask_IsStartEmailSent]  DEFAULT ('N') FOR [IsStartEmailSent]
GO
/****** Object:  Default [DF_MTTask_IsEndEmailSent]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTask_IsEndEmailSent]  DEFAULT ('N') FOR [IsEndEmailSent]
GO
/****** Object:  Default [DF_MTTasks_ScheduleType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [DF_MTTasks_ScheduleType]  DEFAULT (1) FOR [ScheduleType]
GO
/****** Object:  Default [Def_MTTask_FairQueueGroup]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask] ADD  CONSTRAINT [Def_MTTask_FairQueueGroup]  DEFAULT ('NORMAL') FOR [MTFairQueueGroup]
GO
/****** Object:  Default [DF_Program_ProgramName]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Program] ADD  CONSTRAINT [DF_Program_ProgramName]  DEFAULT ('') FOR [ProgramName]
GO
/****** Object:  Default [DF_Programs_RecordStatus]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Program] ADD  CONSTRAINT [DF_Programs_RecordStatus]  DEFAULT ('A') FOR [RecordStatus]
GO
/****** Object:  Default [DF_PurchaseHistory_MTAdhocID]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[PurchaseHistory] ADD  CONSTRAINT [DF_PurchaseHistory_MTAdhocID]  DEFAULT ((0)) FOR [MTAdhocID]
GO
/****** Object:  Default [DF_ReportTypeEmail_attach]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeEmail] ADD  CONSTRAINT [DF_ReportTypeEmail_attach]  DEFAULT ('Y') FOR [Attach]
GO
/****** Object:  Default [DF_ReportTypeFile_Unicode]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeFile] ADD  CONSTRAINT [DF_ReportTypeFile_Unicode]  DEFAULT ('N') FOR [Unicode]
GO
/****** Object:  Default [DF_Subscription_Status]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_Status]  DEFAULT ('N') FOR [Status]
GO
/****** Object:  Default [DF_Subscriptions_Source]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscriptions_Source]  DEFAULT ('F') FOR [Source]
GO
/****** Object:  Default [DF_Subscriptions_CreatedOn]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscriptions_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_SubscriptionFilters_CreatedOn]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[SubscriptionFilter] ADD  CONSTRAINT [DF_SubscriptionFilters_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_Task_RetentionStatus]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Task] ADD  CONSTRAINT [DF_Task_RetentionStatus]  DEFAULT ('Pending') FOR [RetentionStatus]
GO
/****** Object:  Default [DF_TaskStatistics_UpdatedOn]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[TaskStatistics] ADD  CONSTRAINT [DF_TaskStatistics_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
/****** Object:  ForeignKey [FK_ApprovalAction_ApprovalProcess]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ApprovalAction]  WITH NOCHECK ADD  CONSTRAINT [FK_ApprovalAction_ApprovalProcess] FOREIGN KEY([ApprovalProcessID])
REFERENCES [dbo].[ApprovalProcess] ([ApprovalProcessID])
GO
ALTER TABLE [dbo].[ApprovalAction] CHECK CONSTRAINT [FK_ApprovalAction_ApprovalProcess]
GO
/****** Object:  ForeignKey [FK_ApprovalProcess_Task]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ApprovalProcess]  WITH CHECK ADD  CONSTRAINT [FK_ApprovalProcess_Task] FOREIGN KEY([ApprovalObjectID])
REFERENCES [dbo].[Task] ([TaskID])
GO
ALTER TABLE [dbo].[ApprovalProcess] CHECK CONSTRAINT [FK_ApprovalProcess_Task]
GO
/****** Object:  ForeignKey [FK_ApprovalRoutes_Organizations]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ApprovalRoute]  WITH CHECK ADD  CONSTRAINT [FK_ApprovalRoutes_Organizations] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
ALTER TABLE [dbo].[ApprovalRoute] CHECK CONSTRAINT [FK_ApprovalRoutes_Organizations]
GO
/****** Object:  ForeignKey [FK_Assets_Users]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Asset]  WITH CHECK ADD  CONSTRAINT [FK_Assets_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Assets_Users]
GO
/****** Object:  ForeignKey [FK_Blacklists_HubAccount]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Blacklist]  WITH CHECK ADD  CONSTRAINT [FK_Blacklists_HubAccount] FOREIGN KEY([HubAccountID])
REFERENCES [dbo].[HubAccount] ([HubAccountID])
GO
ALTER TABLE [dbo].[Blacklist] CHECK CONSTRAINT [FK_Blacklists_HubAccount]
GO
/****** Object:  ForeignKey [FK_Blacklists_Users]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Blacklist]  WITH CHECK ADD  CONSTRAINT [FK_Blacklists_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Blacklist] CHECK CONSTRAINT [FK_Blacklists_Users]
GO
/****** Object:  ForeignKey [FK_BlacklistCreationConfigs_Blacklists]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[BlacklistCreationConfig]  WITH CHECK ADD  CONSTRAINT [FK_BlacklistCreationConfigs_Blacklists] FOREIGN KEY([BlacklistID])
REFERENCES [dbo].[Blacklist] ([BlacklistID])
GO
ALTER TABLE [dbo].[BlacklistCreationConfig] CHECK CONSTRAINT [FK_BlacklistCreationConfigs_Blacklists]
GO
/****** Object:  ForeignKey [FK_BlacklistDetails_Blacklists]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[BlacklistDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_BlacklistDetails_Blacklists] FOREIGN KEY([BlacklistID])
REFERENCES [dbo].[Blacklist] ([BlacklistID])
GO
ALTER TABLE [dbo].[BlacklistDetail] CHECK CONSTRAINT [FK_BlacklistDetails_Blacklists]
GO
/****** Object:  ForeignKey [FK_BlacklistedEmail_Blacklists]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[BlacklistedEmail]  WITH NOCHECK ADD  CONSTRAINT [FK_BlacklistedEmail_Blacklists] FOREIGN KEY([BlacklistID])
REFERENCES [dbo].[Blacklist] ([BlacklistID])
GO
ALTER TABLE [dbo].[BlacklistedEmail] CHECK CONSTRAINT [FK_BlacklistedEmail_Blacklists]
GO
/****** Object:  ForeignKey [fk_OrganizationID]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[DataRetention]  WITH CHECK ADD  CONSTRAINT [fk_OrganizationID] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
ALTER TABLE [dbo].[DataRetention] CHECK CONSTRAINT [fk_OrganizationID]
GO
/****** Object:  ForeignKey [FK_EmailTask_Task]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[EmailTask]  WITH CHECK ADD  CONSTRAINT [FK_EmailTask_Task] FOREIGN KEY([TaskID])
REFERENCES [dbo].[Task] ([TaskID])
GO
ALTER TABLE [dbo].[EmailTask] CHECK CONSTRAINT [FK_EmailTask_Task]
GO
/****** Object:  ForeignKey [FK_Function_FunctionGroup]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Function]  WITH CHECK ADD  CONSTRAINT [FK_Function_FunctionGroup] FOREIGN KEY([FunctionGroupCode])
REFERENCES [dbo].[FunctionGroup] ([FunctionGroupCode])
GO
ALTER TABLE [dbo].[Function] CHECK CONSTRAINT [FK_Function_FunctionGroup]
GO
/****** Object:  ForeignKey [FK_Lists_ListTypes]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[List]  WITH CHECK ADD  CONSTRAINT [FK_Lists_ListTypes] FOREIGN KEY([ListTypeID])
REFERENCES [dbo].[ListType] ([ListTypeID])
GO
ALTER TABLE [dbo].[List] CHECK CONSTRAINT [FK_Lists_ListTypes]
GO
/****** Object:  ForeignKey [FK_Lists_Users]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[List]  WITH CHECK ADD  CONSTRAINT [FK_Lists_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[List] CHECK CONSTRAINT [FK_Lists_Users]
GO
/****** Object:  ForeignKey [FK_ListCreationConfigs_Lists]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListCreationConfig]  WITH CHECK ADD  CONSTRAINT [FK_ListCreationConfigs_Lists] FOREIGN KEY([ListID])
REFERENCES [dbo].[List] ([ListID])
GO
ALTER TABLE [dbo].[ListCreationConfig] CHECK CONSTRAINT [FK_ListCreationConfigs_Lists]
GO
/****** Object:  ForeignKey [FK_ListTypes_Organizations]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListType]  WITH CHECK ADD  CONSTRAINT [FK_ListTypes_Organizations] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
ALTER TABLE [dbo].[ListType] CHECK CONSTRAINT [FK_ListTypes_Organizations]
GO
/****** Object:  ForeignKey [FK_ListTypeFilters_ListTypes]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListTypeFilter]  WITH CHECK ADD  CONSTRAINT [FK_ListTypeFilters_ListTypes] FOREIGN KEY([ListTypeID])
REFERENCES [dbo].[ListType] ([ListTypeID])
GO
ALTER TABLE [dbo].[ListTypeFilter] CHECK CONSTRAINT [FK_ListTypeFilters_ListTypes]
GO
/****** Object:  ForeignKey [FK_ListTypeParameters_ListTypes]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ListTypeParameter]  WITH CHECK ADD  CONSTRAINT [FK_ListTypeParameters_ListTypes] FOREIGN KEY([ListTypeID])
REFERENCES [dbo].[ListType] ([ListTypeID])
GO
ALTER TABLE [dbo].[ListTypeParameter] CHECK CONSTRAINT [FK_ListTypeParameters_ListTypes]
GO
/****** Object:  ForeignKey [FK_MOTask_Task]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MOTask]  WITH CHECK ADD  CONSTRAINT [FK_MOTask_Task] FOREIGN KEY([TaskID])
REFERENCES [dbo].[Task] ([TaskID])
GO
ALTER TABLE [dbo].[MOTask] CHECK CONSTRAINT [FK_MOTask_Task]
GO
/****** Object:  ForeignKey [FK_MTAdhocTask_Task]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTAdhocTask]  WITH CHECK ADD  CONSTRAINT [FK_MTAdhocTask_Task] FOREIGN KEY([TaskID])
REFERENCES [dbo].[Task] ([TaskID])
GO
ALTER TABLE [dbo].[MTAdhocTask] CHECK CONSTRAINT [FK_MTAdhocTask_Task]
GO
/****** Object:  ForeignKey [FK_BroadcastHistories_MTTasks]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTBroadcastHistory]  WITH CHECK ADD  CONSTRAINT [FK_BroadcastHistories_MTTasks] FOREIGN KEY([TaskID])
REFERENCES [dbo].[MTTask] ([TaskID])
GO
ALTER TABLE [dbo].[MTBroadcastHistory] CHECK CONSTRAINT [FK_BroadcastHistories_MTTasks]
GO
/****** Object:  ForeignKey [FK_BroadcastHistories_Schedules]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTBroadcastHistory]  WITH CHECK ADD  CONSTRAINT [FK_BroadcastHistories_Schedules] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[MTSchedule] ([ScheduleID])
GO
ALTER TABLE [dbo].[MTBroadcastHistory] CHECK CONSTRAINT [FK_BroadcastHistories_Schedules]
GO
/****** Object:  ForeignKey [FK_MTRepeatScheduleConfig_MTTask]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTRepeatableScheduleConfig]  WITH CHECK ADD  CONSTRAINT [FK_MTRepeatScheduleConfig_MTTask] FOREIGN KEY([TaskID])
REFERENCES [dbo].[MTTask] ([TaskID])
GO
ALTER TABLE [dbo].[MTRepeatableScheduleConfig] CHECK CONSTRAINT [FK_MTRepeatScheduleConfig_MTTask]
GO
/****** Object:  ForeignKey [FK_Schedules_Tasks]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedules_Tasks] FOREIGN KEY([TaskID])
REFERENCES [dbo].[MTTask] ([TaskID])
GO
ALTER TABLE [dbo].[MTSchedule] CHECK CONSTRAINT [FK_Schedules_Tasks]
GO
/****** Object:  ForeignKey [FK_ScheduledSubscriptions_MTTasks]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTScheduledSubscription]  WITH CHECK ADD  CONSTRAINT [FK_ScheduledSubscriptions_MTTasks] FOREIGN KEY([TaskID])
REFERENCES [dbo].[MTTask] ([TaskID])
GO
ALTER TABLE [dbo].[MTScheduledSubscription] CHECK CONSTRAINT [FK_ScheduledSubscriptions_MTTasks]
GO
/****** Object:  ForeignKey [FK_ScheduledSubscriptions_Schedules]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTScheduledSubscription]  WITH NOCHECK ADD  CONSTRAINT [FK_ScheduledSubscriptions_Schedules] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[MTSchedule] ([ScheduleID])
GO
ALTER TABLE [dbo].[MTScheduledSubscription] NOCHECK CONSTRAINT [FK_ScheduledSubscriptions_Schedules]
GO
/****** Object:  ForeignKey [FK_ScheduledSubscriptions_TimeBlocks]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTScheduledSubscription]  WITH NOCHECK ADD  CONSTRAINT [FK_ScheduledSubscriptions_TimeBlocks] FOREIGN KEY([TimeBlockID])
REFERENCES [dbo].[MTTimeBlock] ([TimeBlockID])
GO
ALTER TABLE [dbo].[MTScheduledSubscription] NOCHECK CONSTRAINT [FK_ScheduledSubscriptions_TimeBlocks]
GO
/****** Object:  ForeignKey [FK_MTTask_Task]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTask]  WITH CHECK ADD  CONSTRAINT [FK_MTTask_Task] FOREIGN KEY([TaskID])
REFERENCES [dbo].[Task] ([TaskID])
GO
ALTER TABLE [dbo].[MTTask] CHECK CONSTRAINT [FK_MTTask_Task]
GO
/****** Object:  ForeignKey [FK_MTTimeBlock_Task]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTimeBlock]  WITH CHECK ADD  CONSTRAINT [FK_MTTimeBlock_Task] FOREIGN KEY([TaskID])
REFERENCES [dbo].[Task] ([TaskID])
GO
ALTER TABLE [dbo].[MTTimeBlock] CHECK CONSTRAINT [FK_MTTimeBlock_Task]
GO
/****** Object:  ForeignKey [FK_TimeBlocks_Schedules]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[MTTimeBlock]  WITH NOCHECK ADD  CONSTRAINT [FK_TimeBlocks_Schedules] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[MTSchedule] ([ScheduleID])
GO
ALTER TABLE [dbo].[MTTimeBlock] NOCHECK CONSTRAINT [FK_TimeBlocks_Schedules]
GO
/****** Object:  ForeignKey [FK_OrganizationHubAccounts_HubAccounts]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[OrganizationHubAccount]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationHubAccounts_HubAccounts] FOREIGN KEY([HubAccountID])
REFERENCES [dbo].[HubAccount] ([HubAccountID])
GO
ALTER TABLE [dbo].[OrganizationHubAccount] CHECK CONSTRAINT [FK_OrganizationHubAccounts_HubAccounts]
GO
/****** Object:  ForeignKey [FK_OrganizationHubAccounts_Organizations]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[OrganizationHubAccount]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationHubAccounts_Organizations] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
ALTER TABLE [dbo].[OrganizationHubAccount] CHECK CONSTRAINT [FK_OrganizationHubAccounts_Organizations]
GO
/****** Object:  ForeignKey [FK_OrganizationLocale_OrgID]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[OrganizationLocale]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationLocale_OrgID] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
ALTER TABLE [dbo].[OrganizationLocale] CHECK CONSTRAINT [FK_OrganizationLocale_OrgID]
GO
/****** Object:  ForeignKey [FK_OrganizationPrivilege_Privilege]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[OrganizationPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationPrivilege_Privilege] FOREIGN KEY([PrivilegeCode])
REFERENCES [dbo].[Privilege] ([PrivilegeCode])
GO
ALTER TABLE [dbo].[OrganizationPrivilege] CHECK CONSTRAINT [FK_OrganizationPrivilege_Privilege]
GO
/****** Object:  ForeignKey [FK_OrganizationShortCodes_Organizations]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[OrganizationShortCode]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationShortCodes_Organizations] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
ALTER TABLE [dbo].[OrganizationShortCode] CHECK CONSTRAINT [FK_OrganizationShortCodes_Organizations]
GO
/****** Object:  ForeignKey [FK_OrganizationShortCodes_ShortCodes]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[OrganizationShortCode]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationShortCodes_ShortCodes] FOREIGN KEY([ShortCodeID])
REFERENCES [dbo].[ShortCode] ([ShortCodeID])
GO
ALTER TABLE [dbo].[OrganizationShortCode] CHECK CONSTRAINT [FK_OrganizationShortCodes_ShortCodes]
GO
/****** Object:  ForeignKey [FK_PasswordHistories_Users]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[PasswordHistory]  WITH CHECK ADD  CONSTRAINT [FK_PasswordHistories_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[PasswordHistory] CHECK CONSTRAINT [FK_PasswordHistories_Users]
GO
/****** Object:  ForeignKey [FK_Privilege_Function]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Privilege]  WITH CHECK ADD  CONSTRAINT [FK_Privilege_Function] FOREIGN KEY([FunctionCode])
REFERENCES [dbo].[Function] ([FunctionCode])
GO
ALTER TABLE [dbo].[Privilege] CHECK CONSTRAINT [FK_Privilege_Function]
GO
/****** Object:  ForeignKey [FK_PurchaseHistory_HubAccount]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[PurchaseHistory]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseHistory_HubAccount] FOREIGN KEY([HubAccountID])
REFERENCES [dbo].[HubAccount] ([HubAccountID])
GO
ALTER TABLE [dbo].[PurchaseHistory] CHECK CONSTRAINT [FK_PurchaseHistory_HubAccount]
GO
/****** Object:  ForeignKey [FK_PurchaseHistory_User]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[PurchaseHistory]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseHistory_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[PurchaseHistory] CHECK CONSTRAINT [FK_PurchaseHistory_User]
GO
/****** Object:  ForeignKey [FK_QueueGroup_QueueDetails]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[QueueDetails]  WITH CHECK ADD  CONSTRAINT [FK_QueueGroup_QueueDetails] FOREIGN KEY([QueueGroupID])
REFERENCES [dbo].[QueueGroup] ([QueueGroupID])
GO
ALTER TABLE [dbo].[QueueDetails] CHECK CONSTRAINT [FK_QueueGroup_QueueDetails]
GO
/****** Object:  ForeignKey [FK_reportemail_Report]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportEmail]  WITH CHECK ADD  CONSTRAINT [FK_reportemail_Report] FOREIGN KEY([reportid])
REFERENCES [dbo].[Report] ([ReportID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportEmail] CHECK CONSTRAINT [FK_reportemail_Report]
GO
/****** Object:  ForeignKey [FK_ReportFile_Report]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportFile]  WITH CHECK ADD  CONSTRAINT [FK_ReportFile_Report] FOREIGN KEY([ReportID])
REFERENCES [dbo].[Report] ([ReportID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportFile] CHECK CONSTRAINT [FK_ReportFile_Report]
GO
/****** Object:  ForeignKey [FK_ReportTransfer_Report]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTransfer]  WITH CHECK ADD  CONSTRAINT [FK_ReportTransfer_Report] FOREIGN KEY([ReportID])
REFERENCES [dbo].[Report] ([ReportID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTransfer] CHECK CONSTRAINT [FK_ReportTransfer_Report]
GO
/****** Object:  ForeignKey [FK_ReportTypeEmail_ReportType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeEmail]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeEmail_ReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[ReportType] ([ReportTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeEmail] CHECK CONSTRAINT [FK_ReportTypeEmail_ReportType]
GO
/****** Object:  ForeignKey [FK_ReportTypeFile_ReportType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeFile]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeFile_ReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[ReportType] ([ReportTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeFile] CHECK CONSTRAINT [FK_ReportTypeFile_ReportType]
GO
/****** Object:  ForeignKey [FK_ReportTypeFile_ReportTypeQuery]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeFile]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeFile_ReportTypeQuery] FOREIGN KEY([ReportTypeQueryID])
REFERENCES [dbo].[ReportTypeQuery] ([ReportTypeQueryID])
GO
ALTER TABLE [dbo].[ReportTypeFile] CHECK CONSTRAINT [FK_ReportTypeFile_ReportTypeQuery]
GO
/****** Object:  ForeignKey [FK_ReportTypeFileParam_ReportTypeFile]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeFileParam]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeFileParam_ReportTypeFile] FOREIGN KEY([ReportTypeFileID])
REFERENCES [dbo].[ReportTypeFile] ([ReportTypeFileID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeFileParam] CHECK CONSTRAINT [FK_ReportTypeFileParam_ReportTypeFile]
GO
/****** Object:  ForeignKey [FK_ReportTypeQuery_ReportType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeQuery]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeQuery_ReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[ReportType] ([ReportTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeQuery] CHECK CONSTRAINT [FK_ReportTypeQuery_ReportType]
GO
/****** Object:  ForeignKey [FK_ReportTypeTransfer_ReportType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeTransfer]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeTransfer_ReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[ReportType] ([ReportTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeTransfer] CHECK CONSTRAINT [FK_ReportTypeTransfer_ReportType]
GO
/****** Object:  ForeignKey [FK_ReportTypeTSQL_ReportType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeTSQL]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeTSQL_ReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[ReportType] ([ReportTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeTSQL] CHECK CONSTRAINT [FK_ReportTypeTSQL_ReportType]
GO
/****** Object:  ForeignKey [FK_ReportTypeVariant_ReportType]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeVariant]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeVariant_ReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[ReportType] ([ReportTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeVariant] CHECK CONSTRAINT [FK_ReportTypeVariant_ReportType]
GO
/****** Object:  ForeignKey [FK_ReportTypeVariantParam_ReportTypeTSQL]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeVariantParam]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeVariantParam_ReportTypeTSQL] FOREIGN KEY([ReportTypeTSQLID])
REFERENCES [dbo].[ReportTypeTSQL] ([ReportTypeTSQLID])
GO
ALTER TABLE [dbo].[ReportTypeVariantParam] CHECK CONSTRAINT [FK_ReportTypeVariantParam_ReportTypeTSQL]
GO
/****** Object:  ForeignKey [FK_ReportTypeVariantParam_ReportTypeVariant]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[ReportTypeVariantParam]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeVariantParam_ReportTypeVariant] FOREIGN KEY([ReportTypeVariantID])
REFERENCES [dbo].[ReportTypeVariant] ([ReportTypeVariantID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReportTypeVariantParam] CHECK CONSTRAINT [FK_ReportTypeVariantParam_ReportTypeVariant]
GO
/****** Object:  ForeignKey [FK_RolePrivilege_Privilege]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[RolePrivilege]  WITH CHECK ADD  CONSTRAINT [FK_RolePrivilege_Privilege] FOREIGN KEY([PrivilegeCode])
REFERENCES [dbo].[Privilege] ([PrivilegeCode])
GO
ALTER TABLE [dbo].[RolePrivilege] CHECK CONSTRAINT [FK_RolePrivilege_Privilege]
GO
/****** Object:  ForeignKey [FK_RolePrivilege_Role]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[RolePrivilege]  WITH CHECK ADD  CONSTRAINT [FK_RolePrivilege_Role] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[RolePrivilege] CHECK CONSTRAINT [FK_RolePrivilege_Role]
GO
/****** Object:  ForeignKey [FK_SafeSendingPeriods_Users]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[SafeSendingPeriod]  WITH CHECK ADD  CONSTRAINT [FK_SafeSendingPeriods_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[SafeSendingPeriod] CHECK CONSTRAINT [FK_SafeSendingPeriods_Users]
GO
/****** Object:  ForeignKey [FK_SafeSendingPeriodDetails_SafeSendingPeriods]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[SafeSendingPeriodDetail]  WITH CHECK ADD  CONSTRAINT [FK_SafeSendingPeriodDetails_SafeSendingPeriods] FOREIGN KEY([SafeSendingPeriodID])
REFERENCES [dbo].[SafeSendingPeriod] ([SafeSendingPeriodID])
GO
ALTER TABLE [dbo].[SafeSendingPeriodDetail] CHECK CONSTRAINT [FK_SafeSendingPeriodDetails_SafeSendingPeriods]
GO
/****** Object:  ForeignKey [FK_Subscriptions_Lists]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Subscription]  WITH NOCHECK ADD  CONSTRAINT [FK_Subscriptions_Lists] FOREIGN KEY([ListID])
REFERENCES [dbo].[List] ([ListID])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK_Subscriptions_Lists]
GO
/****** Object:  ForeignKey [FK_Task_Program]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[Task]  WITH NOCHECK ADD  CONSTRAINT [FK_Task_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ProgramID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[Task] NOCHECK CONSTRAINT [FK_Task_Program]
GO
/****** Object:  ForeignKey [FK_User_Role]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Role] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Role]
GO
/****** Object:  ForeignKey [FK_Users_ApprovalRoutes]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_Users_ApprovalRoutes] FOREIGN KEY([ApprovalRouteID])
REFERENCES [dbo].[ApprovalRoute] ([ApprovalRouteID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_Users_ApprovalRoutes]
GO
/****** Object:  ForeignKey [FK_Users_Organizations]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_Users_Organizations] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_Users_Organizations]
GO
/****** Object:  ForeignKey [FK__UserAcces__Acces__7D98A078]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserAccessConfig]  WITH CHECK ADD FOREIGN KEY([AccessID])
REFERENCES [dbo].[UserAccessFeature] ([AccessID])
GO
/****** Object:  ForeignKey [FK__UserAcces__Organ__7E8CC4B1]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserAccessConfig]  WITH CHECK ADD FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([OrganizationID])
GO
/****** Object:  ForeignKey [FK_UserHubAccounts_HubAccounts]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserHubAccount]  WITH CHECK ADD  CONSTRAINT [FK_UserHubAccounts_HubAccounts] FOREIGN KEY([HubAccountID])
REFERENCES [dbo].[HubAccount] ([HubAccountID])
GO
ALTER TABLE [dbo].[UserHubAccount] CHECK CONSTRAINT [FK_UserHubAccounts_HubAccounts]
GO
/****** Object:  ForeignKey [FK_UserHubAccounts_Users]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserHubAccount]  WITH CHECK ADD  CONSTRAINT [FK_UserHubAccounts_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserHubAccount] CHECK CONSTRAINT [FK_UserHubAccounts_Users]
GO
/****** Object:  ForeignKey [FK_UserPrivilege_Privilege]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_UserPrivilege_Privilege] FOREIGN KEY([PrivilegeCode])
REFERENCES [dbo].[Privilege] ([PrivilegeCode])
GO
ALTER TABLE [dbo].[UserPrivilege] CHECK CONSTRAINT [FK_UserPrivilege_Privilege]
GO
/****** Object:  ForeignKey [FK_UserSession_User]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserSession]  WITH NOCHECK ADD  CONSTRAINT [FK_UserSession_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserSession] CHECK CONSTRAINT [FK_UserSession_User]
GO
/****** Object:  ForeignKey [FK_UserShortCodes_ShortCodes]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserShortCode]  WITH CHECK ADD  CONSTRAINT [FK_UserShortCodes_ShortCodes] FOREIGN KEY([ShortCodeID])
REFERENCES [dbo].[ShortCode] ([ShortCodeID])
GO
ALTER TABLE [dbo].[UserShortCode] CHECK CONSTRAINT [FK_UserShortCodes_ShortCodes]
GO
/****** Object:  ForeignKey [FK_UserShortCodes_Users]    Script Date: 11/06/2020 08:48:35 ******/
ALTER TABLE [dbo].[UserShortCode]  WITH CHECK ADD  CONSTRAINT [FK_UserShortCodes_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserShortCode] CHECK CONSTRAINT [FK_UserShortCodes_Users]
GO
