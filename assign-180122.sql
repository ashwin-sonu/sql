use  pubs

select * from publishers

Create procedure spgetplace
as
begin
select city ,state,country from publishers
end

exec spgetplace
select * from authors
--procedure with input parameters
alter procedure spgetspecificauthor
@state nvarchar(10),
@contract int 
as
Begin 
--specify columns
select * from authors where state = @state and contract = @contract
order by au_fname

END

exec spgetspecificauthor @state='CA',@contract=1
drop procedure spgetspecificauthor

-----procedure with output parameters
create procedure uspgetspecifictitles
@type nvarchar(10),
@titlecount int output 
as
Begin 
select @titlecount = count('title') from titles where type = @type 


END

declare @titletotal int
exec uspgetspecifictitles @type='business',@titlecount= @titletotal output
print @titletotal



select * from titles
----------stored procedures with return values
create procedure uspreturnspecifictitles
@type nvarchar(10)
as
Begin 
return(select  count('title') from titles where type = @type) 
END
declare @titletotal int
exec @titletotal= uspreturnspecifictitles @type='business'
print @titletotal

alter procedure uspgettitlename
@Id nvarchar(10),
@title nvarchar(20) output
as
Begin 
select  @title= title  from titles where title_id =@Id
END
declare @title nvarchar(20)
exec uspgettitlename @Id='BU1032',@title=@title output
print 'book title ='+@title
-------------------------Functions-------------------------
------Scalar Udf
Select *from titles
create function calcbookage(@pubdate date)
returns int 
as 
begin
declare @bkage int
set @bkage = DATEDIFF (YEAR,@pubdate,GETDATE())-
             case
			 when (MONTH(@pubdate)>MONTH(GETDATE())) or
			 (MONTH(@pubdate)=MONTH(GETDATE()))and DAY(@pubdate)>DAY(GETDATE())
			 then 1
			 else 0
			 end
return @bkage
end

select dbo.calcbookage('1991-06-12') as bookAge

select title_id,title,dbo.calcbookage(pubdate)as bookAge from titles 
where dbo.calcbookage(pubdate)>10
----------SP as function-------
create procedure uspcalcbookage
@pubdate date

as 
begin
declare @bkage int
set @bkage = DATEDIFF (YEAR,@pubdate,GETDATE())-
             case
			 when (MONTH(@pubdate)>MONTH(GETDATE())) or
			 (MONTH(@pubdate)=MONTH(GETDATE()))and DAY(@pubdate)>DAY(GETDATE())
			 then 1
			 else 0
			 end
select @bkage
end
exec uspcalcbookage @pubdate='1991/06/12'
----------------------table valued functions---------------
------inline table valued functions
create function fn_titlesbytype(@type nvarchar(20))
returns table
as 
Return(Select * from titles where type=@type) 

select * from fn_titlesbytype('business') B 
join publishers p
on p.pub_id=b.pub_id
order by title_id

 update fn_titlesbytype('business') set title='You Can Combat Computer Stress!!!' where title_id='BU2075'

-----------------------multi-statement table valued functions---------------
 alter  function fn_gettitles()
 returns @table table (id nvarchar(8), name nvarchar(100),publishedDate Date)
 as
 begin
 Insert into @table
 select title_id, title,cast(pubdate as date) from titles
 return
 END

 select * from dbo.fn_gettitles()
 select *from titles WHERE type = 'business'
 ----------------------subqueries-------------------------
 --non corelated sub query
 select * from titleauthor
 select *from publishers
 select *from sales

 SELECT * 
   FROM titles 
   WHERE title_id  IN (SELECT distinct ta.title_id
         FROM titleauthor ta)
		 order by title_id

------co-related sub query 
 SELECT * 
   FROM titles 
   WHERE title_id  not IN (SELECT distinct ta.title_id
         FROM titleauthor ta
         WHERE type = 'business') 
		 

select title,
(select sum(qty) from sales where title_id= titles.title_id) as Quantity_Sold
from titles order by title
-----------------------





