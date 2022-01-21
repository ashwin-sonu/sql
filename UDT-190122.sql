USE pubs
------TEMPORARY TABLES-----
--LOCAL TEMPORARY TABLES
CREATE TABLE #PersonDetails
(Id INT,
  Name NVARCHAR(20))

  INSERT INTO #PersonDetails VALUES(1,'JOHN')
  INSERT INTO #PersonDetails VALUES(2,'MIKE')
  INSERT INTO #PersonDetails VALUES(3,'DAN')

  SELECT * FROM #PersonDetails 
  --to check if temp table is created 
  SELECT name FROM tempdb..sysobjects
  WHERE name LIKE '#PersonDetails%'

----------GLOBAL TEMPORARY VARIABLE----
CREATE TABLE ##PersonDetails
(Id INT,
  Name NVARCHAR(20))

  INSERT INTO ##PersonDetails VALUES(1,'JOHN')
  INSERT INTO ##PersonDetails VALUES(2,'MIKE')
  INSERT INTO ##PersonDetails VALUES(3,'DAN')

  SELECT * FROM ##PersonDetails 
  ----------UDDT-------------

  CREATE TYPE pub.PNO FROM NVARCHAR(20)
alter PROCEDURE pub.uspEMPTABLE
AS
BEGIN
  CREATE TABLE pub.EmpDet(
  empid int not null,
  empname nvarchar(20),
  empno pub.PNO)
END
  SELECT * FROM pub.EmpDet 

EXEC pub.uspEMPTABLE
  INSERT INTO pub.EmpDet VALUES(1,'JOHN','567891234')


  DROP TABLE pub.EmpDet

  create type pub.USD from decimal(9,2)
--system view of data types
SELECT * FROM sys.types 
WHERE is_user_defined='true'

declare @price pub.USD;
set @price=6.687;
print @price
--------user defined table types------
CREATE TYPE pub.EmpType AS TABLE
(ID INT PRIMARY KEY,
 NAME NVARCHAR(20),
 AGE INT,
 NUMBER pub.PNO
 )
--DROP TYPE pub.EmpType
DECLARE @EMP pub.EmpType;
INSERT INTO @EMP VALUES (1,'SAM',25,'234567891'),
 (2,'SAMMY',30,'234677891') ,
(3,'DAN',29,'564567891') ,
 (4,'MANNY',45,'2674567891') ,
 (5,'JOHN',55,'784567891') 
UPDATE @EMP SET NUMBER='9497459557'WHERE NAME='SAM'
SELECT * FROM @EMP 
-----TABLE TYPE PASSED AS I/P PARAMETER TO SP-----
CREATE TABLE pub.EMPS(ID INT PRIMARY KEY,
 NAME NVARCHAR(20),
 AGE INT,
 NUMBER pub.PNO
)
--DROP TABLE EMPS
SELECT * FROM pub.EMPS
CREATE TYPE pub.EmpTypeNEW AS TABLE
(ID INT PRIMARY KEY,
 NAME NVARCHAR(20),
 AGE INT,
 NUMBER pub.PNO
 )

ALTER PROCEDURE pub.uspinsertemp
@EMPTable pub.EmpTypeNEW READONLY
AS
BEGIN
    INSERT INTO pub.EMPS
	SELECT * FROM @EMPTable
 
END

DECLARE @EMPTBLTYPE pub.EmpTypeNEW
 INSERT INTO @EMPTBLTYPE VALUES (1,'JOHN',23,'123456789'),
 (2,'JOHN',33,'123456789'),
 (3,'SAM',43,'433456789'),
 (4,'PAM',25,'673456789'),
 (5,'DAN',29,'893456789')
EXEC pub.uspinsertemp @EMPTBLTYPE

SELECT * FROM pub.EMPS

--
