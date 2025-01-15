-- 1. Modifica del tipo di colonna Base64 in dbo.AppIcons
ALTER TABLE dbo.AppIcons
ALTER COLUMN Base64 nvarchar(MAX);

-- 2. Aggiunta di una colonna temporanea TempDate per la conversione delle date
ALTER TABLE dbo.AppUserList
ADD TempDate datetime;

-- 3. Popolamento della colonna temporanea con valori validi convertiti in datetime
-- Se la conversione fallisce, si può settare NULL o una data predefinita (ad esempio, '1900-01-01')
UPDATE dbo.AppUserList
SET TempDate = CASE 
                   WHEN TRY_CONVERT(datetime, Date, 103) IS NOT NULL THEN TRY_CONVERT(datetime, Date, 103)
                   ELSE NULL -- Oppure '1900-01-01' per valore predefinito
               END;

-- 4. Verifica di eventuali valori non convertibili (per eventuale debug)
SELECT Date
FROM dbo.AppUserList
WHERE TRY_CONVERT(datetime, Date, 103) IS NULL;

-- 5. Rimuove la colonna originale Date dopo la conversione
ALTER TABLE dbo.AppUserList
DROP COLUMN Date;

-- 6. Rinomina la colonna temporanea TempDate in Date
EXEC sp_rename 'dbo.AppUserList.TempDate', 'Date', 'COLUMN';

-- 7. Verifica finale dei dati nella tabella
SELECT *
FROM dbo.AppUserList;
