USE [master]
BACKUP LOG [test] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\test_LogBackup.bak' 
WITH NOFORMAT, 
NOINIT,  
NAME = N'test_LogBackup', 
NOSKIP, 
NOREWIND, 
NOUNLOAD,  
NORECOVERY ,  
STATS = 5
go
RESTORE DATABASE [test] 
FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\test.bak' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 5
