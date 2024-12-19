ALTER TABLE dbo.AppIcons
ALTER COLUMN Base64 nvarchar(MAX);

UPDATE dbo.AppUserList
SET Date = CONVERT(varchar(10), CONVERT(datetime, Date, 103), 120)
WHERE ISDATE(Date) = 1;

ALTER TABLE dbo.AppUserList
ALTER COLUMN Date datetime;

SELECT Date
FROM dbo.AppUserList
WHERE TRY_CONVERT(datetime, Date, 103) IS NULL;

ALTER TABLE dbo.AppUserList
ALTER COLUMN Date datetime USING TRY_CONVERT(datetime, Date, 103);

ALTER TABLE dbo.AppUserList
ADD TempDate datetime;

UPDATE dbo.AppUserList
SET TempDate = TRY_CONVERT(datetime, Date, 103)
WHERE TRY_CONVERT(datetime, Date, 103) IS NOT NULL;

ALTER TABLE dbo.AppUserList
DROP COLUMN Date;

EXEC sp_rename 'dbo.AppUserList.TempDate', 'Date', 'COLUMN';

SELECT *
FROM dbo.AppUserList;
