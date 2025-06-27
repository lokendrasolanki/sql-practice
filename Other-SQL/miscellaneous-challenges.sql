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



