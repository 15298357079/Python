--=============================================================--
-- SQL Training Code
--Modified by Cara
--Date: August 15, 2018
--=============================================================--

----account: acn1itsql90


/*****begin slide 3******/
if object_id('tempdb.dbo.#employee') is not null drop table #employee

-- Creating Employee table
Create table #Employee 
(employee_ID int not null identity(1,1),
 employee_name varchar(200) null,
 hire_date date null)

select * from #Employee

insert into #employee(employee_name,hire_date)
values
('Jay Ollom','6/1/2000'),
('Tibarek Ejamo','4/30/2014'),
('David Barry','8/30/2006')

select * from #employee

drop table #employee_2
select * into #employee_2 from #employee where employee_id<>1;
select * from #employee_2

/*****end slide 3******/



-- Creating Employee_Position table
if object_id('tempdb.dbo.#Employee_Position') is not null  drop table #Employee_Position

Create table #Employee_Position
(employee_ID int not null ,
employee_position varchar(200) null,  
position_start_date date null)

insert into #Employee_Position(employee_ID,employee_position,position_start_date)
values
(1,'Sr Developer','6/1/2008'),
(1,'Technical Lead','6/1/2010'),
(2,'Developer 2','4/30/2012')

select * from #Employee_Position

-- Creating Employee_leave table
if object_id('tempdb.dbo.#Employee_leave') is not null  drop table #Employee_leave

Create table #Employee_leave
(employee_ID int not null ,
leave_type varchar(200) null,
leave_hrs float null default 0)

insert into #Employee_leave(employee_ID,leave_type,leave_hrs)
values
(1,'Vacation',20),
(1,'Sick',15.5),
(1,'Insanity',3),
(2,'Vacation',13),
(2,'Maternity',7),
(2,'Sick',5.7),
(3,'Hangover',3),
(3,'Vacation',32)

select * from #Employee_leave


-- Creating Other_Employee table
if object_id('tempdb.dbo.#Other_Employee') is not null  drop table #Other_Employee
Create table #Other_Employee 
(employee_ID int not null identity(1,1),
employee_name varchar(200) null,
hire_date date null)

insert into #Other_Employee(employee_name,hire_date)
values
('Donald Duck','6/1/2000'),
('Jimmy Neutron','4/30/2012')

select * from #Other_Employee

/*** Example Select ***/


/*****begin slide 4-7******/
select employee_id, employee_name
from #employee

select employee_id, employee_name
from #employee
where employee_id = 1

select employee_id, employee_name
from #employee
where lower(employee_name) like 'david%'

/*****end slide 4-7******/



/*****begin slide 8-13******/

/***  Joining Tables ***/
select e.employee_id, e.employee_name, ep.employee_position, ep.position_start_date
from #employee e
	join #employee_position ep
	on e.employee_id = ep.employee_id
select * from #employee
select * from #employee_position


select e.employee_id as e_id, ep.employee_id as ep_id,
e.employee_name, ep.employee_position, ep.position_start_date
from #employee e
	right join #employee_position ep
	on e.employee_id = ep.employee_id
--where ep.employee_id is not null


select e.employee_id, e.employee_name, ep.employee_position, ep.position_start_date
from #employee e
	full join #employee_position ep
	on e.employee_id = ep.employee_id
where e.employee_id is  null 
or ep.employee_id is null

select * from #employee
select * from #employee_position



select e.employee_name, ep.employee_position, ep.position_start_date
from #employee e
	cross join #employee_position ep  -- This is limited use

/*****end slide 8-13******/


/*****begin slide 14-18******/
/*** Operators ***/
Select employee_id,employee_name
from #employee
where employee_ID = 1

Select employee_id,employee_name
from #employee
where employee_ID <> 1

Select employee_id,employee_name
from #employee
where employee_ID > 2

Select employee_id,employee_name
from #employee
where employee_ID in (1,3)


Select employee_id,employee_name
from #employee
where employee_ID not in (1,3)
	--and employee_name = 'David Barry'

Select employee_id,employee_name
from #employee
where employee_ID in (1)
	or employee_name = 'David Barry'

/*****end slide 14-18******/


/*****begin slide 19-20******/
-- Order by
select *
from #employee
order by hire_date desc

--case when
select employee_name as e_name,
	case when hire_date > '1/1/2012'  then 'New Hire'
		 else 'Not New Hire'
		 end as employee_status
from #employee

/*****end slide 19-20******/







select datediff(month,'1990-1-31','1990-2-1') as months

select dateadd(year, 1, getdate()) as prior_mon

select getdate() as today


/*** Some Functions ***/
-- Convert
select convert(varchar(30),getdate(),102) now
-- 101 US	format mm/dd/yyyy
-- 102 ANSI format yy-mm-dd

select getdate(),cast(getdate() as date) now
-- Cast
select '5 + 2 = '+ cast(5+2 as nvarchar(10)) as fomula


-- IsNull
select isNull(null,null) as replace

-- coalesce
select coalesce(null,1,2,null) as rep1,
		coalesce(null,null,'Hello') as rep2

-- row_number (rank is similar)
select * from #employee_Position;

select *, 
row_number() over(partition by employee_id order by Position_start_date) as Row_Number
from #employee_Position

/*** Aggregate Functions ***/
select * from  #employee_leave
select employee_id, max(leave_hrs) as most_hours
from #employee_leave
group by employee_id

select min(leave_hrs) as lease_hours
from #Employee_leave
where leave_hrs > 5


select employee_id, sum(leave_hrs) as tot_hours
from #Employee_leave
group by employee_id
having sum(leave_hrs) > 30


select  count(*) as total_count,
	 count(distinct employee_id) as unique_count,
	 count(*)-count(distinct employee_id) as dups
from #employee_leave



/** Sub Queries ***/
select employee_id, max(leave_hrs) as max_hrs
from #Employee_leave
group by employee_ID

select * from #Employee_leave

select el.*,tmp.max_hrs from #Employee_leave el
join (select employee_id, max(leave_hrs) as max_hrs
		from #Employee_leave
		group by employee_ID) tmp
on el.employee_ID = tmp.employee_id
and el.leave_hrs = tmp.max_hrs


select * 
from #employee 
where Employee_id not in 
(select employee_id from #Employee_Position)







/*****begin slide 21-23******/
/*** Union ***/
select employee_id , employee_name
from #employee
where employee_id in( 1,3)
union all
select employee_id, employee_name
from #employee
where employee_id = 3

/*** Insert/Update/Delete Values ***/
insert into #employee(employee_name, hire_date)
values ('Mickey Mouse','3/17/2014')

select * from #employee;

insert into #Employee(employee_name,hire_date)
select Employee_name, hire_date
from #Other_Employee

Update #employee
set employee_name = 'Loren Ollom'
where employee_name = 'Jay Ollom'

update #employee
set employee_name = oe.employee_name
from #employee e
 join #Other_Employee oe
 on e.employee_ID = oe.employee_ID
 where e.employee_name <> oe.employee_name

 select * from #employee
 select * from #Other_Employee

 delete #employee
 where employee_ID = 1

 delete #employee
 from #Employee e
	left join #Employee_Position ep
	on e.employee_ID=ep.employee_ID
where ep.employee_ID is null

/*****end slide 21-23******/



/*** Creating Tables ***/
select e.employee_name, ep.employee_position, ep.position_start_date
into #employees_with_positions
from #employee e
	join #Employee_Position ep
	on e.employee_ID=ep.employee_id

select * from #employees_with_positions


/*** For cleaning table ***/
drop table #Employee,#Employee_leave,#Employee_Position,#Other_Employee


--transaction(ID, Orderdate), discount(ID,orderdate, product), fullprice(ID,orderdate, product)
