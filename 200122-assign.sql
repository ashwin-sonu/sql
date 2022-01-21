USE PUBS
SELECT * FROM titles
SELECT * FROM publishers

-------VIEWS--------
CREATE VIEW pub.vwtitleview
AS
SELECT title, au_ord, au_lname, price, ytd_sales, pub_id,pubdate
FROM authors A, titles T, titleauthor TA
WHERE A.au_id = TA.au_id
   AND  TA.title_id=T.title_id 
--DROP VIEW pub.titleview

ALTER VIEW pub.vwTitleByPub
AS
SELECT title_id,title,notes, type,price,pubdate,pub_name,city,state,country
from titles T JOIN publishers P
ON T.pub_id=P.pub_id

 
SELECT * FROM pub.vwTitleByPub 
select * from titles 
--update view--
UPDATE pub.vwTitleByPub
SET title='The Gourmet Microwave' WHERE title_id='MC3021'
--insert and delete into  views--
CREATE VIEW pub.vwTitle
AS
SELECT title_id,title,notes, type,price,pubdate
from titles 

SELECT * FROM PUB.vwTitle
select * from titles 
INSERT INTO pub.vwTitle(title_id,title,type) values('A1','BOHEMAN','MUSIC')
DELETE FROM pub.vwTitle WHERE title='BOHEMAN'

----INDEXED VIEWS--
ALTER VIEW pub.ivwTitle
WITH SCHEMABINDING
AS
SELECT title,pub_id, notes, type,price,pubdate
from dbo.titles 

SELECT * from pub.ivwTitle

ALTER VIEW  dbo.ivwPUB
WITH SCHEMABINDING
AS
SELECT pub_id,COUNT(title) AS 'TOTAL TITLES'
from dbo.titles
GROUP BY pub_id



SELECT * from pub.ivwPUB

ALTER VIEW  dbo.ivwPUB
WITH SCHEMABINDING
AS
SELECT pub_id,COUNT_BIG(*) AS 'TOTAL TITLES'
from dbo.titles
GROUP BY pub_id


CREATE UNIQUE CLUSTERED INDEX  UIX_vsTotalTitles
on dbo.ivwPUB(pub_id)
SELECT * from dbo.ivwPUB

------derived tables---
SELECT * FROM titles
SELECT * FROM publishers
CREATE VIEW pub.vwTitleByPubNEW
AS
SELECT T.pub_id,pub_name,COUNT_BIG(*) AS TOTAL_TITLES
from  publishers P JOIN titles T 
ON P.pub_id= T.pub_id
GROUP BY T.pub_id,pub_name

SELECT pub_name,TOTAL_TITLES from pub.vwTitleByPubNEW

--DERIVED TABLES USING TEMP TABLE--
SELECT T.pub_id,pub_name,COUNT_BIG(*) AS TOTAL_TITLES
INTO #TEMPTOTALTITLES
from  publishers P JOIN titles T 
ON P.pub_id= T.pub_id
GROUP BY T.pub_id,pub_name

SELECT pub_name,TOTAL_TITLES FROM #TEMPTOTALTITLES
DROP TABLE #TEMPTOTALTITLES
--DERIVED TABLES USING DERIVED TABLES--
SELECT pub_name,NO_OF_TITLES from
(SELECT T.pub_id,pub_name,COUNT_BIG(*) AS NO_OF_TITLES
from  publishers P JOIN titles T 
ON P.pub_id= T.pub_id
GROUP BY T.pub_id,pub_name)
TOTALTITLES
--USING CTE--
WITH TOTALTITLES( pub_id,pub_name,NO_OF_TITLES) 
AS
(SELECT T.pub_id,pub_name,COUNT_BIG(*) AS NO_OF_TITLES
from  publishers P JOIN titles T 
ON P.pub_id= T.pub_id
GROUP BY T.pub_id,pub_name
)
Select * from TOTALTITLES 

SELECT *FROM titles

WITH TITLESNEW(id,name,NUMBER) 
AS
(SELECT pub_id,pub_name,COUNT_BIG(*) AS NO_OF_TITLES
from  publishers P 
GROUP BY pub_name,pub_id
)
Select title_id,title,name from titles T JOIN TITLESNEW TN
ON T.pub_id=TN.id
ORDER BY T.title_id
--updateable CTE---
SELECT * FROM PUBLISHERS
WITH TITLENEW(id,name,title) 
AS
(SELECT P.pub_id,pub_name,title
from  publishers P join titles T
on P.pub_id=T.pub_id
)

UPDATE TITLENEW SET name='New Moon Books'WHERE id='0736'




