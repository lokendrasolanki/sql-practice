drop table if exists src_dest_distance;
CREATE TABLE src_dest_distance (
    source      VARCHAR(20),
    destination VARCHAR(20),
    distance    INT
);

INSERT INTO src_dest_distance (source, destination, distance) VALUES
('Bangalore', 'Hyderbad', 400),
('Hyderbad', 'Bangalore', 400),
('Mumbai', 'Delhi', 400),
('Delhi', 'Mumbai', 400),
('Chennai', 'Pune', 400),
('Pune', 'Chennai', 400);

with cte as (
select *, row_number() over() from src_dest_distance
)
select c1.source, c1.destination, c1.distance from cte c1 join cte c2 
ON
c1.source = c2.destination
AND
c2.source = c1.destination
AND
c1>c2;


---Ungroup the given input data.
drop table if exists travel_items;
CREATE TABLE travel_items (
    id          int,
    item_name   varchar(50),
    total_count int
);

INSERT INTO travel_items (id, item_name, total_count) VALUES
(1, 'Water Bottle', 2),
(2, 'Tent', 1),
(3, 'Apple', 4);

with RECURSIVE cte as (
SELECT id, item_name, total_count, 1 as level
    FROM   travel_items
	
    UNION ALL
	
    SELECT c.id, c.item_name, c.total_count - 1, level+1 as level
    FROM   CTE c join travel_items t USING(item_name, id)
    WHERE  c.total_count > 1
)
SELECT   id, item_name
FROM     CTE
ORDER BY 1;

SELECT 
    id,
    item_name
FROM 
    travel_items,
    generate_series(1, total_count);

/*
There are a total of 10 IPL teams.

Write a SQL query such that each team plays with every team only once.

Write a SQL query such that each team plays with every team twice.
*/

drop table if exists teams;
	CREATE TABLE teams (
    team_code VARCHAR(10),
    team_name VARCHAR(40)
);

INSERT INTO teams (team_code, team_name) VALUES
('RCB', 'Royal Challengers Bangalore'),
('MI', 'Mumbai Indians'),
('CSK', 'Chennai Super Kings'),
('DC', 'Delhi Capitals'),
('RR', 'Rajasthan Royals'),
('SRH', 'Sunrisers Hyderbad'),
('PBKS', 'Punjab Kings'),
('KKR', 'Kolkata Knight Riders'),
('GT', 'Gujarat Titans'),
('LSG', 'Lucknow Super Giants');

with teams as (
select *, row_number() over() rn from teams)
select t1.team_code, t2.team_code from teams t1
Join teams t2 on t1.rn>t2.rn;

with teams as (
select *, row_number() over() rn from teams)
select t1.team_code, t2.team_code from teams t1
Join teams t2 on t1.rn<>t2.rn;

/*
Find the hierarchy of employees under a given manager named "Asha".
*/
DROP table if exists emp_details;
CREATE TABLE emp_details (
    id           int PRIMARY KEY,
    name         varchar(100),
    manager_id   int,
    salary       int,
    designation  varchar(100)
);

INSERT INTO emp_details (id, name, manager_id, salary, designation) VALUES
(1,  'Shripadh', NULL, 10000, 'CEO'),
(2,  'Satya', 5, 1400, 'Software Engineer'),
(3,  'Jia', 5, 500, 'Data Analyst'),
(4,  'David', 5, 1800, 'Data Scientist'),
(5,  'Michael', 7, 3000, 'Manager'),
(6,  'Arvind', 7, 2400, 'Architect'),
(7,  'Asha', 1, 4200, 'CTO'),
(8,  'Maryam', 1, 3500, 'Manager'),
(9,  'Reshma', 8, 2000, 'Business Analyst'),
(10, 'Akshay', 8, 2500, 'Java Developer');

with RECURSIVE cte as (
select * from emp_details where name = 'Asha'
UNION ALL
select e.* from emp_details e join cte c
 on e.manager_id = c.id
)
select * from cte;

/*

*/

CREATE TABLE notifications (
    notification_id INTEGER PRIMARY KEY,
    product_id VARCHAR(50),
    delivered_at TIMESTAMP
);

INSERT INTO notifications (notification_id, product_id, delivered_at) VALUES
(1, 'p1', '2024-01-01 08:00:00'),
(2, 'p2', '2024-01-01 10:30:00'),
(3, 'p3', '2024-01-01 11:30:00');

CREATE TABLE purchases (
    user_id INT,
    product_id VARCHAR(50),
    purchase_timestamp TIMESTAMP
);
INSERT INTO purchases (user_id, product_id, purchase_timestamp) VALUES
(1, 'p1', '2024-01-01 09:00:00'),
(2, 'p2', '2024-01-01 09:00:00'),
(3, 'p2', '2024-01-01 09:30:00'),
(3, 'p1', '2024-01-01 10:20:00'),
(4, 'p2', '2024-01-01 10:40:00'),
(1, 'p2', '2024-01-01 10:50:00'),
(5, 'p2', '2024-01-01 11:45:00'),
(2, 'p3', '2024-01-01 11:45:00'),
(2, 'p3', '2024-01-01 12:30:00'),
(3, 'p3', '2024-01-01 14:30:00');

With cte as (
select *, LEAST(delivered_at + INTERVAL '2 hours', lead(delivered_at) OVER( order by  delivered_at)) as effective_notification_time from notifications)
select c.notification_id, 
count(CASE WHEN c.product_id = p.product_id THEN 1 END) same_product_purchases,
count(CASE WHEN c.product_id != p.product_id THEN 1 END) different_product_purchases
from cte c join purchases p
on p.purchase_timestamp BETWEEN  c.delivered_at and  c.effective_notification_time
group by c.notification_id
ORDER By c.notification_id;

/*
In your organization, each employee has a fixed joining salary recorded at the time they start. Over time, employees may receive one or more promotions, each offering a certain percentage increase to their current salary.

 

You're given two datasets:

employees :  contains each employee’s name and joining salary.

promotions:  lists all promotions that have occurred, including the promotion date and the percent increase granted during that promotion.

Your task is to write a SQL query to compute the current salary of every employee by applying each of their promotions increase round to 2 decimal places.
If an employee has no promotions, their current salary remains equal to the joining salary. Order the result by emp id.
*/

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    joining_salary INT NOT NULL
);

INSERT INTO employees (id, name, joining_salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 70000),
(4, 'David', 55000),
(5, 'Eva', 65000),
(6, 'Frank', 48000),
(7, 'Grace', 72000),
(8, 'Henry', 51000);

-- Create Table Script
CREATE TABLE employee_promotions (
    emp_id INT,
    promotion_date DATE,
    percent_increase INT
);

-- Insert Data Script
INSERT INTO employee_promotions (emp_id, promotion_date, percent_increase) VALUES
(1, '2021-01-15', 10),
(1, '2022-03-20', 20),
(2, '2023-01-01', 5),
(2, '2024-01-01', 10),
(3, '2022-05-10', 5),
(3, '2023-07-01', 10),
(3, '2024-10-10', 5),
(4, '2021-09-21', 15),
(4, '2022-09-25', 15),
(4, '2023-09-01', 15),
(4, '2024-09-30', 15),
(5, '2023-02-01', 10),
(5, '2023-12-01', 10),
(6, '2022-06-15', 5),
(6, '2023-11-11', 10),
(7, '2022-01-01', 7);
	
WITH promotion_multipliers AS (
    SELECT 
        emp_id,
		
        promotion_date,
        (1 + percent_increase / 100.0) AS multiplier,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY promotion_date) AS promotion_order
    FROM employee_promotions
),
cumulative_promotions AS (
    SELECT 
        emp_id,
        EXP(SUM(LN(multiplier))) AS total_multiplier
    FROM promotion_multipliers
    GROUP BY emp_id, multiplier
)
SELECT 
    e.id ,
    e.name,
    e.joining_salary as initial_salary,
    -- COALESCE(cp.total_multiplier, 1.0) AS total_multiplier,
    ROUND(e.joining_salary * COALESCE(cp.total_multiplier, 1.0), 2) AS current_salary
FROM employees e
LEFT JOIN cumulative_promotions cp ON e.id = cp.emp_id
ORDER BY e.id;



CREATE TABLE t1 (
    emp_id INT
);

-- Insert Data Script
INSERT INTO t1 (emp_id) VALUES
(1),
(1),
(1),
(2),
(null),
(null);


CREATE TABLE t2 (
    emp_id INT
);

-- Insert Data Script
INSERT INTO t2 (emp_id) VALUES
(1),
(1),
(0),
(null);


select * from t1 inner join t2 -- 6 record 3*2
on t1.emp_id = t2.emp_id;

select * from t1 Left join t2 -- 9 matching -6 + nonmatchin 3
on t1.emp_id = t2.emp_id;

select * from t1 left outer join t2 -- 
on t1.emp_id = t2.emp_id;

select * from t1 Right join t2 --8
on t1.emp_id = t2.emp_id;

select * from t1 Right outer join t2
on t1.emp_id = t2.emp_id;

select * from t1 full join t2
on t1.emp_id = t2.emp_id;

select * from t1 CROSS join t2; -- 24 record 6*4 


----



CREATE TABLE player_game_data (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT
);
INSERT INTO player_game_data (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-03-02', 1),
(3, 1, '2016-01-02', 10),
(3, 4, '2016-01-03', 15);

---sol - 1 
with cte_min as(
select player_id, (min(event_date) + INTERVAL '1 day')::date min_date from player_game_data
group by player_id
), join_cte as (
select p.player_id
from player_game_data p
JOIN cte_min c
on p.player_id = c.player_id
where c.min_date = p.event_date
order by p.player_id
)

SELECT Round(count(distinct j.player_id )*1.0/count(distinct c.player_id ),2) from cte_min c
LEFT JOIN join_cte j
on j.player_id = c.player_id;


CREATE TABLE ids (
    id INTEGER
);
INSERT INTO ids (id) VALUES
(1),
(2),
(2),
(3),
(3),
(3),
(4),
(5),
(5);

WITH cte AS (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS rn
    FROM ids
)
DELETE FROM ids
WHERE id IN (
    SELECT id FROM cte WHERE rn > 1
)
AND ctid NOT IN (
    SELECT MIN(ctid)
    FROM ids
    GROUP BY id
);
select *,ctid from ids;


/*
OP:
101	"Delhi"	"Indore"	4
102	"Mumbai"	"Ahmedabad"	3
103	"Chennai"	"Kolkata"	5
*/
CREATE TABLE routes (
    id INT,
    source VARCHAR(50),
    dest VARCHAR(50)
);

-- Route 1: Delhi → Agra → Gwalior → Bhopal → Indore
INSERT INTO routes (id, source, dest) VALUES
(101, 'Delhi', 'Agra'),
(101, 'Agra', 'Gwalior'),
(101, 'Gwalior', 'Bhopal'),
(101, 'Bhopal', 'Indore');

-- Route 2: Mumbai → Surat → Vadodara → Ahmedabad
INSERT INTO routes (id, source, dest) VALUES
(102, 'Mumbai', 'Surat'),
(102, 'Surat', 'Vadodara'),
(102, 'Vadodara', 'Ahmedabad');

-- Route 3: Chennai → Nellore → Vijayawada → Visakhapatnam → Bhubaneswar → Kolkata
INSERT INTO routes (id, source, dest) VALUES
(103, 'Chennai', 'Nellore'),
(103, 'Nellore', 'Vijayawada'),
(103, 'Vijayawada', 'Visakhapatnam'),
(103, 'Visakhapatnam', 'Bhubaneswar'),
(103, 'Bhubaneswar', 'Kolkata');

with cnt_cte as (
select id, count(*) cnt from routes group by id
),cte as (
select *, lag(dest) over( partition by id) prev_dest, lead(source) over( partition by id) next_source from routes), result as(
select id, 
min(case when prev_dest is null then source  end),
min(case when next_source is null then dest  end)
from cte where prev_dest is null or next_source is null
group by id)
select r.*, c.cnt from result r join cnt_cte c
on r.id = c.id;

with cnt_cte as (
select id, count(*) cnt from routes group by id
),source as (
select id, source from routes where (id, source) not in (
select id, dest from routes
)), dest as (
select id, dest from routes where (id, dest) not in (
select id, source from routes
))
select s.*, d.dest, c.cnt from source s join dest d 
on s.id  = d.id
join cnt_cte c on s.id = c.id;

