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

