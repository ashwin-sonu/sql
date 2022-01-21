USE master

  SELECT * FROM ##PersonDetails 
---------create temp table using SP
CREATE PROCEDURE uspCreateLocalTempTable
AS
BEGIN
CREATE TABLE #PersonDetails
(Id INT,
  Name NVARCHAR(20))

  INSERT INTO #PersonDetails VALUES(1,'JOHN')
  INSERT INTO #PersonDetails VALUES(2,'MIKE')
  INSERT INTO #PersonDetails VALUES(3,'DAN')

  SELECT * FROM #PersonDetails 
END
EXEC uspCreateLocalTempTable

SELECT * FROM #PersonDetails


 