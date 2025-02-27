/*
 write a sql query to find team-name,no-of-match,
no-of-win and no-bf-lost count
*/

create table cricket_match
(match_id int,team1 Varchar(20),team2 Varchar(20),result Varchar(20));

INSERT INTO cricket_match values(1,'ENG','NZ','NZ');
INSERT INTO cricket_match values(2,'PAK','NED','PAK');
INSERT INTO cricket_match values(3,'AFG','BAN','BAN');
INSERT INTO cricket_match values(4,'SA','SL','SA');
INSERT INTO cricket_match values(5,'AUS','IND','AUS');
INSERT INTO cricket_match values(6,'NZ','NED','NZ');
INSERT INTO cricket_match values(7,'ENG','BAN','ENG');
INSERT INTO cricket_match values(8,'SL','PAK','PAK');
INSERT INTO cricket_match values(9,'AFG','IND','IND');
INSERT INTO cricket_match values(10,'SA','AUS','SA');
INSERT INTO cricket_match values(11,'BAN','NZ','BAN');
INSERT INTO cricket_match values(12,'PAK','IND','IND');
INSERT INTO cricket_match values(13,'SA','IND','DRAW');

-- SOL-1:
with cte as (
select team1 as team
from cricket_match
UNION 
select team2 as team
from cricket_match
),
 match_cte as(
select * from cricket_match cm
join cte c
on c.team=cm.team1 or
 c.team=cm.team2 
 where cm.result!='DRAW')
 select team,count(*) total_match, sum(case when team=result then 1 else 0 end) total_win,
  sum(case when team!=result then 1 else 0 end) total_loss
 from match_cte
 group by team

-- sol:2-

with cte as (
select team1 as team, case when team1=result then 1 else 0 end no_of_wins
from cricket_match where result!='DRAW'
UNION all
select team2 as team, case when team2=result then 1 else 0 end no_of_wins
from cricket_match where result!='DRAW'
)
select team, count(team) total_match, sum(case when no_of_wins=1 then 1 else 0 end) total_win,
  sum(case when no_of_wins=0 then 1 else 0 end) total_loss
from cte group by team

/*
Given the details of the Amazon customer, specifically focusing on the 'product_spend' table, which contains information about customer purchases, the products they bought, and how much they spent.

You need to find the top two highest-selling products within each category based on total spending. 
*/
CREATE TABLE ProductSpend (
    category VARCHAR(50),
    product VARCHAR(100),
    user_id INT,
    spend DECIMAL(10, 2)
);

INSERT INTO ProductSpend (category, product, user_id, spend) VALUES
('appliance', 'refrigerator', 165, 26.00),
('appliance', 'refrigerator', 123, 3.00),
('appliance', 'washing machine', 123, 19.80),
('electronics', 'vacuum', 178, 5.00),
('electronics', 'wireless headset', 156, 7.00),
('electronics', 'vacuum', 145, 15.00),
('electronics', 'laptop', 114, 999.99),
('fashion', 'dress', 117, 49.99),
('groceries', 'milk', 243, 2.99),
('groceries', 'bread', 645, 1.99),
('home', 'furniture', 276, 599.99),
('home', 'decor', 456, 29.99);

with cte as (
select category, product, sum(spend) total_spend from ProductSpend group by category, product),
rank_cat as(
select * , Dense_rank() over(partition by category order by total_spend desc) rnk from cte)
select category, product, total_spend from rank_cat where rnk<3

/*
# You are given a dataset of user activity logs. Each log entry contains a user_id, timestamp, and activity_type. The dataset has duplicate entries, and some entries are missing values.
# 1. Drop Duplicate the dataset.
# 2 Handle any missing values appropriately.
# 3 Determine the top 3 most frequent activity_type for each user_id.
# 4 Calculate the time spent by each user on each activity_type
*/

-- Create the user_activity table
CREATE TABLE user_activity (
    user_id VARCHAR(255),
    timestamp TIMESTAMP,
    action VARCHAR(255)
);
truncate table user_activity;
-- Insert the data
INSERT INTO user_activity (user_id, timestamp, action)
VALUES
    ('U1', '2024-12-30 10:00:00', 'LOGIN'),
    ('U1', '2024-12-30 10:05:00', 'BROWSE'),
    ('U1', '2024-12-30 10:20:00', 'LOGOUT'),
    ('U2', '2024-12-30 11:00:00', 'LOGIN'),
    ('U2', '2024-12-30 11:15:00', 'BROWSE'),
    ('U2', '2024-12-30 11:30:00', 'LOGOUT'),
	('U1', '2024-11-30 09:00:00', 'LOGIN'),
    ('U1', '2024-11-30 09:05:00', 'BROWSE'),
    ('U1', '2024-11-30 09:20:00', 'LOGOUT'),
    ('U1', '2024-12-30 10:20:00', 'LOGOUT'),  -- Duplicate entry will be ignored
    (NULL, '2024-12-30 12:00:00', 'LOGIN'),  -- Missing user_id will be inserted as is
    ('U3', NULL, 'LOGOUT');             -- Missing timestamp will be inserted as is

-- SOl-1
-- 1. Drop Duplicate the dataset.
with cte as(
select *, 
row_number() over(partition by user_id, timestamp, action ) rn 
from user_activity)
select * from cte  where rn= 1;

-- SOl-2:
-- 2 Handle any missing values appropriately.
select * from user_activity where 
user_id is not null 
and  timestamp is not null  
and action is not null;

-- SOL-3
-- 3. Determine the top 3 most frequent activity_type for each user_id
with cte as(
select *, 
row_number() over(partition by user_id, timestamp, action ) rn 
from user_activity),
clean_cte as(
select user_id, action, count(*) as frequent_activity
from cte  where rn= 1 and user_id is not null 
and  timestamp is not null  
and action is not null
group by user_id, action
)
select * from (
select *, rank() over(partition by user_id order by frequent_activity desc) rnk from clean_cte ) c 
where c.rnk<=3

-- SOL-4
-- 4 Calculate the time spent by each user on each activity_type
with cte as(
select *, 
row_number() over(partition by user_id, timestamp, action ) rn 
from user_activity),
clean_cte as(
select user_id, timestamp, action ,date(timestamp) date
from cte  where rn= 1 and user_id is not null 
and  timestamp is not null  
and action is not null
), final_cte as (
select *, lead(timestamp) over(partition by user_id, date order by user_id, date) next_time from clean_cte )

select user_id, action, next_time-timestamp time_spent from final_cte

/*
Part 1: Find the top 3 highest-paid employees in 
              each department.
Part 2: Find the average salary of employees hired 
               in the last 5 years.
Part 3: Find the employees whose salry is less than 
               the average salary of employees hired in 
               the last 5 years.
*/
-- Query to create table:
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    DateHired DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert data
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Sales');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, DateHired) VALUES
(1, 'Alice', 'Smith', 1, 50000, '2020-01-15'),
(2, 'Bob', 'Johnson', 1, 60000, '2018-03-22'),
(3, 'Charlie', 'Williams', 2, 70000, '2019-07-30'),
(4, 'David', 'Brown', 2, 80000, '2017-11-11'),
(5, 'Eve', 'Davis', 3, 90000, '2021-02-25'),
(6, 'Frank', 'Miller', 3, 55000, '2020-09-10'),
(7, 'Grace', 'Wilson', 2, 75000, '2016-04-05'),
(8, 'Henry', 'Moore', 1, 65000, '2022-06-17');

-- Part 1: Find the top 3 highest-paid employees in each department

with cte as(
Select *, dense_rank() over(partition by d.DepartmentID order by e.salary desc ) rnk from employees e 
join Departments d
on e.DepartmentID = d.DepartmentID
)
Select firstname, lastname, DepartmentName, salary from cte where rnk<4

-- Part 2: Find the average salary of employees hired in the last 5 years.

select avg(salary) from employees where date_part('year', DateHired) >=2019

-- Part 3: Find the employees whose salry is less
-- than the average salary of employees hired in  the last 5 years.

with cte as(
select avg(salary) avg_sal from employees where date_part('year', DateHired) >=2019
)
select * from employees e 
cross join cte c 
where c.avg_sal > e.salary

/*
We need to have separate record for each and every Customer.
*/

-- Create Table Script
CREATE TABLE IF NOT EXISTS country_user (
    Names text,
    Country text
);

-- Insert Script
INSERT INTO country_user (Names, Country)
VALUES ('John,Smith', 'Canada'), ('Mike,David', 'USA');

select country, unnest(string_to_array(Names,',')) from country_user;

/*
We need to find total numbers of 50s and 100s for palyers.
*/


-- Create the players table
CREATE TABLE players (
    player TEXT,
    runs INTEGER,
    "50s/100s" TEXT
);

-- Insert data into the players table
INSERT INTO players (player, runs, "50s/100s") VALUES
('Sachin-IND', 18694, '93/49'),
('Ricky-AUS', 11274, '66/31'),
('Lara-WI', 10222, '45/21'),
('Rahul-IND', 10355, '95/11'),
('Jhonty-SA', 7051, '43/5'),
('Hayden-AUS', 8722, '67/19');

-- Create the countries table
CREATE TABLE countries (
    SRT TEXT,
    country TEXT
);

-- Insert data into the countries table
INSERT INTO countries (SRT, country) VALUES
('IND', 'India'),
('AUS', 'Australia'),
('WI', 'WestIndies'),
('SA', 'SouthAfrica');

with players_cte as(
select *, split_part(player,'-', 1) as player_name,  
split_part(player,'-', 2) as SRT,
split_part("50s/100s",'/', 2) as century,
split_part("50s/100s",'/', 1) as fifty
from players)

select player_name, c.country, runs, (cast(century as int) + cast(fifty as int)) as total from players_cte p
join countries c
on c.SRT = p.SRT


/*
MEESHO - 

MEESHO HACKERRANK ONLINE SOL TEST

find how many products falls into customer budget along with list of products
--In case of clash choose the less costly product

*/

create table products
(
product_id varchar(20) ,
cost int
);
insert into products values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget values (100,400),(200,800),(300,1500);

-- SOL - 
with product as (
select *, sum(cost) over(order by cost) running_sum from products
)
select customer_id, budget, 
STRING_AGG(p.product_id, ', ') list_of_products, 
count(customer_id) no_of_products from customer_budget c
left join product p
on p.running_sum<=c.budget
group by customer_id, budget
order by customer_id

/*
we need to segregate first name , middle name and last name from the customer name. 
*/

create table customer_names  (customer_name varchar(30));
insert into customer_names values ('Lokendra Singh')
,('Lokendra Singh Solanki')
,('Michael'); 

with cte as (
select *, string_to_array(customer_name, ' ') as names from customer_names)
select 
names[1]  as  first_name,
names[2] as secound_name,
names[3]  as last_name 
from cte

--- Q1: Delete duplicate data --- 

drop table if exists cars;
create table cars
(
	model_id		int primary key,
	model_name		varchar(100),
	color			varchar(100),
	brand			varchar(100)
);
insert into cars values(1,'Leaf', 'Black', 'Nissan');
insert into cars values(2,'Leaf', 'Black', 'Nissan');
insert into cars values(3,'Model S', 'Black', 'Tesla');
insert into cars values(4,'Model X', 'White', 'Tesla');
insert into cars values(5,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(6,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(7,'Ioniq 6', 'White', 'Hyundai');

-- SOL-1
select * from cars where model_id not in (
select min(model_id) from cars
group by model_name, brand

);

-- SOL-2
select * from cars where model_id in (
select min(model_id) from cars
group by model_name, brand
having count(1)>1
);

-- SOL-3
select * from cars where model_id in (
select model_id from (select *,
Row_number() over(partition by model_name, brand order by model_id desc) rn
from cars
) where rn=1
);

--- Q2: Display highest and lowest salary --- in each department

drop table if exists employee;
create table employee
(
	id 			int primary key GENERATED ALWAYS AS IDENTITY,
	name 		varchar(100),
	dept 		varchar(100),
	salary 		int
);
insert into employee values(default, 'Alexander', 'Admin', 6500);
insert into employee values(default, 'Leo', 'Finance', 7000);
insert into employee values(default, 'Robin', 'IT', 2000);
insert into employee values(default, 'Ali', 'IT', 4000);
insert into employee values(default, 'Maria', 'IT', 6000);
insert into employee values(default, 'Alice', 'Admin', 5000);
insert into employee values(default, 'Sebastian', 'HR', 3000);
insert into employee values(default, 'Emma', 'Finance', 4000);
insert into employee values(default, 'John', 'HR', 4500);
insert into employee values(default, 'Kabir', 'IT', 8000);

-- SOL-
select *, 
max(salary) over(partition by dept order by salary desc) highest_salary,
min(salary) over(partition by dept order by salary desc 
range between unbounded preceding and unbounded following ) lowest_salary 
from employee;

--- Q3 : Find actual distance --- 

drop table if exists car_travels;
create table car_travels
(
    cars                    varchar(40),
    days                    varchar(10),
    cumulative_distance     int
);
insert into car_travels values ('Car1', 'Day1', 50);
insert into car_travels values ('Car1', 'Day2', 100);
insert into car_travels values ('Car1', 'Day3', 200);
insert into car_travels values ('Car2', 'Day1', 0);
insert into car_travels values ('Car3', 'Day1', 0);
insert into car_travels values ('Car3', 'Day2', 50);
insert into car_travels values ('Car3', 'Day3', 50);
insert into car_travels values ('Car3', 'Day4', 100);

with cte as(
select *, lag(cumulative_distance,1,0) over(partition by cars order by days ) distance from car_travels
)
select * , cumulative_distance-distance from cte
;

--- Q4 : Convert the given input to expected output --- 

drop table src_dest_distance;
create table src_dest_distance
(
    source          varchar(20),
    destination     varchar(20),
    distance        int
);
insert into src_dest_distance values ('Bangalore', 'Hyderbad', 400);
insert into src_dest_distance values ('Hyderbad', 'Bangalore', 400);
insert into src_dest_distance values ('Mumbai', 'Delhi', 400);
insert into src_dest_distance values ('Delhi', 'Mumbai', 400);
insert into src_dest_distance values ('Chennai', 'Pune', 400);
insert into src_dest_distance values ('Pune', 'Chennai', 400);

WITH
	CTE AS (
		SELECT
			*,
			ROW_NUMBER() OVER () RN
		FROM
			SRC_DEST_DISTANCE
	)
SELECT
	S.SOURCE,
	S.DESTINATION,
	S.DISTANCE
FROM
	CTE S
	JOIN CTE S1 ON S.RN > S1.RN
WHERE
	S.SOURCE = S1.DESTINATION
	AND S.DESTINATION = S1.SOURCE;


--- Q5 : Ungroup the given input data --- 

drop table if exists travel_items;
create table travel_items
(
	id              int,
	item_name       varchar(50),
	total_count     int
);
insert into travel_items values (1, 'Water Bottle', 2);
insert into travel_items values (2, 'Tent', 1);
insert into travel_items values (3, 'Apple', 4);

--SOL-
with RECURSIVE cte as(
select id, item_name, total_count,  1 as level
from travel_items
UNION ALL
select c.id, c.item_name, c.total_count - 1,  2 as level
from cte c 
inner join travel_items t
on c.id = t.id and c.item_name = t.item_name
where c.total_count>1
)
select * from cte;

--- Q6 : make schedule for a teams in IPL Matches --- 

drop table if exists teams;
create table teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');

-- SOL 1- if each team play other team only once
with matches as(
select *, row_number() over() as rn from teams
)
select * from matches t 
 join matches t1 
on t.rn<t1.rn;

-- SOL 1- if each team play other team twice
with matches as(
select *, row_number() over() as rn from teams
)
select * from matches t 
 join matches t1 
on t.rn<>t1.rn;

--- Q8: Find the hierarchy --- 

drop TABLE IF EXISTS emp_details;
CREATE TABLE emp_details
    (
        id           int PRIMARY KEY,
        name         varchar(100),
        manager_id   int,
        salary       int,
        designation  varchar(100)
    );
INSERT INTO emp_details VALUES (1,  'Shripadh', NULL, 10000, 'CEO');
INSERT INTO emp_details VALUES (2,  'Satya', 5, 1400, 'Software Engineer');
INSERT INTO emp_details VALUES (3,  'Jia', 5, 500, 'Data Analyst');
INSERT INTO emp_details VALUES (4,  'David', 5, 1800, 'Data Scientist');
INSERT INTO emp_details VALUES (5,  'Michael', 7, 3000, 'Manager');
INSERT INTO emp_details VALUES (6,  'Arvind', 7, 2400, 'Architect');
INSERT INTO emp_details VALUES (7,  'Asha', 1, 4200, 'CTO');
INSERT INTO emp_details VALUES (8,  'Maryam', 1, 3500, 'Manager');
INSERT INTO emp_details VALUES (9,  'Reshma', 8, 2000, 'Business Analyst');
INSERT INTO emp_details VALUES (10, 'Akshay', 8, 2500, 'Java Developer');

with recursive  cte as (
select * from emp_details where name ='Asha'
union all
select e.* from  emp_details e 
Inner join 
cte c
on 
c.id=e.manager_id
)
select * from cte



--- Q9: Find difference in average sales --- 

drop table Sales_order;
create table Sales_order
(
    order_number        bigserial primary key,
    quantity_ordered    int check (quantity_ordered > 0),
    price_each          float,
    sales               float,
    order_date          date,
    status              varchar(15),
    qtr_id              int check (qtr_id between 1 and 4),
    month_id            int check (month_id between 1 and 12),
    year_id             int,
    Product             varchar(20) ,
    customer            varchar(20) ,
    deal_size           varchar(10) check (deal_size in ('Small', 'Medium', 'Large'))
);
alter table Sales_order add constraint chk_ord_sts
check (status in ('Cancelled', 'Disputed', 'In Process', 'On Hold', 'Resolved', 'Shipped'));




insert into sales_order values (DEFAULT,'30','95.7','2871',to_date('2/24/2003','mm/dd/yyyy'),'Shipped','1','2','2003','S10_1678','C1','Small');
insert into sales_order values (DEFAULT,'34','81.35','2765.9',to_date('05/07/2003','mm/dd/yyyy'),'Shipped','2','5','2003','S10_1678','C2','Small');
insert into sales_order values (DEFAULT,'41','94.74','3884.34',to_date('07/01/2003','mm/dd/yyyy'),'Shipped','3','7','2003','S10_1678','C3','Medium');
insert into sales_order values (DEFAULT,'45','83.26','3746.7',to_date('8/25/2003','mm/dd/yyyy'),'Shipped','3','8','2003','S10_1678','C4','Medium');
insert into sales_order values (DEFAULT,'49','100','5205.27',to_date('10/10/2003','mm/dd/yyyy'),'Shipped','4','10','2003','S10_1678','C5','Medium');
insert into sales_order values (DEFAULT,'36','96.66','3479.76',to_date('10/28/2003','mm/dd/yyyy'),'Shipped','4','10','2003','S10_1678','C6','Medium');
insert into sales_order values (DEFAULT,'29','86.13','2497.77',to_date('11/11/2003','mm/dd/yyyy'),'Shipped','4','11','2003','S10_1678','C7','Small');
insert into sales_order values (DEFAULT,'48','100','5512.32',to_date('11/18/2003','mm/dd/yyyy'),'Shipped','4','11','2003','S10_1678','C8','Medium');
insert into sales_order values (DEFAULT,'22','98.57','2168.54',to_date('12/01/2003','mm/dd/yyyy'),'Shipped','4','12','2003','S10_1678','C9','Small');
insert into sales_order values (DEFAULT,'41','100','4708.44',to_date('1/15/2004','mm/dd/yyyy'),'Shipped','1','1','2004','S10_1678','C10','Medium');
insert into sales_order values (DEFAULT,'37','100','3965.66',to_date('2/20/2004','mm/dd/yyyy'),'Shipped','1','2','2004','S10_1678','C11','Medium');
insert into sales_order values (DEFAULT,'23','100','2333.12',to_date('04/05/2004','mm/dd/yyyy'),'Shipped','2','4','2004','S10_1678','C12','Small');
insert into sales_order values (DEFAULT,'28','100','3188.64',to_date('5/18/2004','mm/dd/yyyy'),'Shipped','2','5','2004','S10_1678','C13','Medium');
insert into sales_order values (DEFAULT,'34','100','3676.76',to_date('6/28/2004','mm/dd/yyyy'),'Shipped','2','6','2004','S10_1678','C14','Medium');
insert into sales_order values (DEFAULT,'45','92.83','4177.35',to_date('7/23/2004','mm/dd/yyyy'),'Shipped','3','7','2004','S10_1678','C15','Medium');
insert into sales_order values (DEFAULT,'36','100','4099.68',to_date('8/27/2004','mm/dd/yyyy'),'Shipped','3','8','2004','S10_1678','C16','Medium');
insert into sales_order values (DEFAULT,'23','100','2597.39',to_date('9/30/2004','mm/dd/yyyy'),'Shipped','3','9','2004','S10_1678','C17','Small');
insert into sales_order values (DEFAULT,'41','100','4394.38',to_date('10/15/2004','mm/dd/yyyy'),'Shipped','4','10','2004','S10_1678','C18','Medium');
insert into sales_order values (DEFAULT,'46','94.74','4358.04',to_date('11/02/2004','mm/dd/yyyy'),'Shipped','4','11','2004','S10_1678','C19','Medium');
insert into sales_order values (DEFAULT,'42','100','4396.14',to_date('11/15/2004','mm/dd/yyyy'),'Shipped','4','11','2004','S10_1678','C1','Medium');
insert into sales_order values (DEFAULT,'41','100','7737.93',to_date('11/24/2004','mm/dd/yyyy'),'Shipped','4','11','2004','S10_1678','C20','Large');
insert into sales_order values (DEFAULT,'20','72.55','1451',to_date('12/17/2004','mm/dd/yyyy'),'Shipped','4','12','2004','S10_1678','C21','Small');
insert into sales_order values (DEFAULT,'21','34.91','733.11',to_date('02/03/2005','mm/dd/yyyy'),'Shipped','1','2','2005','S10_1678','C15','Small');
insert into sales_order values (DEFAULT,'42','76.36','3207.12',to_date('03/03/2005','mm/dd/yyyy'),'Shipped','1','3','2005','S10_1678','C22','Medium');
insert into sales_order values (DEFAULT,'24','100','2434.56',to_date('04/08/2005','mm/dd/yyyy'),'Shipped','2','4','2005','S10_1678','C23','Small');
insert into sales_order values (DEFAULT,'66','100','7516.08',to_date('5/13/2005','mm/dd/yyyy'),'Disputed','2','5','2005','S10_1678','C24','Large');
insert into sales_order values (DEFAULT,'26','100','5404.62',to_date('1/29/2003','mm/dd/yyyy'),'Shipped','1','1','2003','S10_1949','C18','Medium');
insert into sales_order values (DEFAULT,'29','100','7209.11',to_date('3/24/2003','mm/dd/yyyy'),'Shipped','1','3','2003','S10_1949','C25','Large');
insert into sales_order values (DEFAULT,'38','100','7329.06',to_date('5/28/2003','mm/dd/yyyy'),'Shipped','2','5','2003','S10_1949','C26','Large');
insert into sales_order values (DEFAULT,'37','100','7374.1',to_date('7/24/2003','mm/dd/yyyy'),'Shipped','3','7','2003','S10_1949','C6','Large');
insert into sales_order values (DEFAULT,'45','100','10993.5',to_date('9/19/2003','mm/dd/yyyy'),'Shipped','3','9','2003','S10_1949','C27','Large');
insert into sales_order values (DEFAULT,'21','100','4860.24',to_date('10/20/2003','mm/dd/yyyy'),'Shipped','4','10','2003','S10_1949','C28','Medium');
insert into sales_order values (DEFAULT,'34','100','8014.82',to_date('11/06/2003','mm/dd/yyyy'),'Shipped','4','11','2003','S10_1949','C29','Large');
insert into sales_order values (DEFAULT,'23','100','5372.57',to_date('11/13/2003','mm/dd/yyyy'),'Shipped','4','11','2003','S10_1949','C30','Medium');
insert into sales_order values (DEFAULT,'42','100','7290.36',to_date('11/25/2003','mm/dd/yyyy'),'Shipped','4','11','2003','S10_1949','C31','Large');
insert into sales_order values (DEFAULT,'47','100','9064.89',to_date('12/05/2003','mm/dd/yyyy'),'Shipped','4','12','2003','S10_1949','C32','Large');
insert into sales_order values (DEFAULT,'35','100','6075.3',to_date('1/29/2004','mm/dd/yyyy'),'Shipped','1','1','2004','S10_1949','C33','Medium');

with cte2003 as (
select month_id, year_id, to_char(order_date,'MON') mon, avg(sales) avg_sales
from sales_order
where year_id= 2003
group by month_id, year_id, to_char(order_date,'MON'))
,cte2004 as (
select month_id, year_id,to_char(order_date,'MON') mon, avg(sales) avg_sales
from sales_order
where year_id= 2004
group by month_id, year_id, to_char(order_date,'MON') )

select c1.month_id,c1.mon,  c1.avg_sales-c2.avg_sales diff from cte2003 c1 
INNER join 
cte2004 c2
on c1.month_id =c2.month_id
order by c1.mon 
/*
--- Q10: Pizza Delivery Status ---
A pizza company is taking orders from customers, and each pizza ordered is added to their database as a separate order.
Each order has an associated status, "CREATED or SUBMITTED or DELIVERED'. 								
An order's Final_ Status is calculated based on status as follows:						
	1. When all orders for a customer have a status of DELIVERED, that customer's order has a Final_Status of COMPLETED.				
	2. If a customer has some orders that are not DELIVERED and some orders that are DELIVERED, the Final_ Status is IN PROGRESS.					
	3. If all of a customer's orders are SUBMITTED, the Final_Status is AWAITING PROGRESS.						
	4. Otherwise, the Final Status is AWAITING SUBMISSION.
	
Write a query to report the customer_name and Final_Status of each customer's arder. Order the results by customer								
name.								
*/
drop table if exists cust_orders;
create table cust_orders
(
cust_name   varchar(50),
order_id    varchar(10),
status      varchar(50)
);

insert into cust_orders values ('John', 'J1', 'DELIVERED');
insert into cust_orders values ('John', 'J2', 'DELIVERED');
insert into cust_orders values ('David', 'D1', 'SUBMITTED');
insert into cust_orders values ('David', 'D2', 'DELIVERED'); -- This record is missing in question
insert into cust_orders values ('David', 'D3', 'CREATED');
insert into cust_orders values ('Smith', 'S1', 'SUBMITTED');
insert into cust_orders values ('Krish', 'K1', 'CREATED');

SELECT
	CUST_NAME,
	'COMPLETED' AS STATUS
FROM
	CUST_ORDERS C
WHERE
	C.STATUS = 'DELIVERED'
	AND NOT EXISTS (
		SELECT
			1
		FROM
			CUST_ORDERS C2
		WHERE
			C.CUST_NAME = C2.CUST_NAME
			AND C2.STATUS IN ('SUBMITTED', 'CREATED')
	)
UNION
SELECT
	CUST_NAME,
	'IN PROGRESS' AS STATUS
FROM
	CUST_ORDERS C
WHERE
	C.STATUS = 'DELIVERED'
	AND EXISTS (
		SELECT
			1
		FROM
			CUST_ORDERS C2
		WHERE
			C.CUST_NAME = C2.CUST_NAME
			AND C2.STATUS IN ('SUBMITTED', 'CREATED')
	)
UNION
SELECT
	CUST_NAME,
	'AWAITING PROGRESS' AS STATUS
FROM
	CUST_ORDERS C
WHERE
	C.STATUS = 'SUBMITTED'
	AND EXISTS (
		SELECT
			1
		FROM
			CUST_ORDERS C2
		WHERE
			C.CUST_NAME = C2.CUST_NAME
			AND C2.STATUS IN ('DELIVERED', 'CREATED')
	)
UNION
SELECT DISTINCT
	CUST_NAME AS CUSTOMER_NAME,
	'AWAITING SUBMISSION' AS STATUS
FROM
	CUST_ORDERS D
WHERE
	D.STATUS = 'CREATED'
	AND NOT EXISTS (
		SELECT
			1
		FROM
			CUST_ORDERS D2
		WHERE
			D2.CUST_NAME = D.CUST_NAME
			AND D2.STATUS IN ('DELIVERED', 'SUBMITTED')
	);


--We need to find origin and final destination details. 

CREATE TABLE Flights (cust_id INT, flight_id VARCHAR(10), origin VARCHAR(50), destination VARCHAR(50));

-- Insert data into the table
INSERT INTO Flights (cust_id, flight_id, origin, destination)
VALUES (1, 'SG1234', 'Delhi', 'Hyderabad'), (1, 'SG3476', 'Kochi', 'Mangalore'), (1, '69876', 'Hyderabad', 'Kochi'), (2, '68749', 'Mumbai', 'Varanasi'), (2, 'SG5723', 'Varanasi', 'Delhi');

with cte as (
select f.cust_id, f.origin from Flights f
left  join 
Flights f1
on f.cust_id = f1.cust_id
and f.origin = f1.destination 
where f1.flight_id is null),
cte1 as(select f.cust_id, f.destination from Flights f
left  join 
Flights f1
on f.cust_id = f1.cust_id
and f.destination = f1.origin
where f1.flight_id is null) 
select c.cust_id, c.origin, c1.destination 
from cte c 
inner join cte1 c1 
on c.cust_id=c1.cust_id
order by c.cust_id;

-- Find the missing weeks in a table
CREATE TABLE sls_tbl (pid INT, sls_dt DATE, sls_amt INT );

-- Insert data into the table
INSERT INTO sls_tbl (pid, sls_dt, sls_amt)
VALUES (201, '2024-07-11', 140), (201, '2024-07-18', 160), (201, '2024-07-25', 150), (201, '2024-08-01', 180), (201, '2024-08-15', 170), (201, '2024-08-29', 130);

select * from sls_tbl;

with cte as(
 SELECT 
 generate_series(
        start_date::date,
		end_date::date,
        '1 week'::interval
    )::date AS week_start
FROM (
    SELECT min(sls_dt) AS start_date, max(sls_dt) AS end_date
   from sls_tbl
) AS date_range)
select c.week_start from cte c
left join sls_tbl s
on c.week_start = s.sls_dt
where s.sls_dt is null;

-- split columna ans create column b as op
CREATE TABLE testtbl (cola VARCHAR(10));

-- Insert data into the table
INSERT INTO testtbl (cola)
VALUES ('1,2'), ('3'), ('4');

with cte as (
select unnest(string_to_array(cola,',')) colb from testtbl)
select c2.colb cola, c1.colb colb from cte c1
cross join cte c2
where c1.colb< c2.colb
order by c2.colb;

--Find events with 3 or more consecutive years for each pid
CREATE TABLE events ( pid INT, year INT ) ;
-- Insert data into the table 
INSERT INTO events VALUES (1, 2019), (1, 2020), (1, 2021), (2, 2022), (2, 2021),(3, 2019), (3, 2021), (3, 2022);

with cte as(
select *, year - ROW_NUMBER() over(partition by pid)  as next_year from events
order by pid)
select pid from cte 
group by pid, next_year
having count(*)>=3
/*
Given us 2 tables, identify the no of records returned using different type of SQL Joins.
*/
create table table1(id int);
insert into table1 values (1), (1),(2),(null),(null);

create table table2(id int);
insert into table2 values (1),(3),(null);

--Inner Join - 2
select * from table1 
inner join
table2
on
table1.id = table2.id

--Left Join - 5
select * from table1 
LEFT JOIN
table2
on
table1.id = table2.id

--RIGHT JOIN - 4
select * from table1 
RIGHT JOIN
table2
on
table1.id = table2.id

--FULL JOIN - 7
select * from table1 
FULL JOIN
table2
on
table1.id = table2.id

--CROSS JOIN - 15
select * from table1 
CROSS JOIN
table2

/*
Given us Student table, find out the total marks of top 2 subjects based on marks.
*/

create table students(sname varchar(50), sid varchar(50), marks int);

insert into students values('A','X',75),('A','Y',75),('A','Z',80),('B','X',90),('B','Y',91),('B','Z',75);

with cte as (
select *, Row_number() over(partition by sname order by marks desc) rn from students)
select sname, sum(marks)
from cte
where rn <=2
group by sname;

/*
Given us Employees table, find out the max ID from Employees excluding duplicates.
*/
create table employees_id (id int);

insert into employees_id values (2),(5),(6),(6),(7),(8),(8);

select max(id) from employees_id
group by id
having count(*)=1
order by id desc
limit 1;
/*
*/
create table tablea (empid int, empname varchar(50), salary int);
create table tableb (empid int, empname varchar(50), salary int);

insert into tablea values(1,'AA',1000),(2,'BB',300);
insert into tableb values(2,'BB',400),(3,'CC',100);

with cte as(
select * from tablea
union
select * from tableb),
cte1 as(
select *, 
row_number() over(partition by empid order by salary ) rn from cte)
select empid, empname, salary from cte1 where rn=1






