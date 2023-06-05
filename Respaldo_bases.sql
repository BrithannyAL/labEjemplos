--Respaldo completo
BACKUP DATABASE [test] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\test.bak' 
WITH NOFORMAT, 
NOINIT,  
NAME = N'test-Full Database Backup', 
SKIP, 
NOREWIND, 
NOUNLOAD,  
STATS = 10
