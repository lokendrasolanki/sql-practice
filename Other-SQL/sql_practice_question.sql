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

