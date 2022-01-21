Create table sam.StudentSource
(
 ID int primary key,
 Name nvarchar(20)
)


Insert into sam.StudentSource values (1, 'Mike')
Insert into sam.StudentSource values (2, 'Sara')


Create table sam.StudentTarget
(
 ID int primary key,
 Name nvarchar(20)
)


Insert into sam.StudentTarget values (1, 'Mike M')
Insert into sam.StudentTarget values (3, 'John')


select * from sam.StudentSource
SELECT * FROM sam.StudentTarget
--------------------MERGE ------------------------
MERGE INTO sam.StudentTarget AS ST
USING sam.StudentSource AS SS
ON ST.ID=SS.ID
WHEN MATCHED THEN
  UPDATE SET ST.NAME=SS.NAME
WHEN NOT MATCHED BY TARGET THEN 
 INSERT VALUES (SS.ID,SS.Name);
--WHEN NOT MATCHED  BY SOURCE THEN
--DELETE;
 
----------TRANSACTIONS---------------
BEGIN TRANSACTION
UPDATE sam.StudentTarget SET NAME='JOHNNY BOY'
WHERE ID=3
COMMIT TRANSACTION
SELECT * FROM sam.StudentTarget

--TRANSACTION USING TRY AND CATCH--
BEGIN TRY
BEGIN TRANSACTION
UPDATE sam.StudentSource SET NAME='Sarah J Parker'
WHERE ID=2
UPDATE sam.StudentTarget SET NAME='JOHNNY BOY is a good boy s name  '
WHERE ID=3

COMMIT TRANSACTION
PRINT 'TRANSACTION COMMITTED'
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT 'TRANSACTION ROLLBACK'
END CATCH
SELECT * FROM sam.StudentTarget
--TRANSACTION USING SP
ALTER PROCEDURE sam.uspTransaction
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION
UPDATE sam.StudentSource SET NAME='Sarah J Parker'
WHERE ID=2
UPDATE sam.StudentTarget SET NAME='JOHNNY BOY   '
WHERE ID=3

COMMIT TRANSACTION
PRINT 'TRANSACTION COMMITTED'
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT 'TRANSACTION ROLLBACK'
END CATCH
END

EXEC  sam.uspTransaction
SELECT * FROM sam.StudentTarget
SELECT * FROM sam.StudentSource

----------------CROSS JOINS---------------
USE pubs
SELECT Title_id,title,pubdate,type,pub_name,city,country 
from titles T CROSS JOIN PUBLISHERS P
ORDER BY title_id