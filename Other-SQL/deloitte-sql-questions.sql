/*
1. Find Employees with Salary Greater Than Location Average
Problem statement:

Find employees whose salary is greater than the average salary of their respective location.
*/
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT,
    salary DECIMAL(10, 2),
    location VARCHAR(50)
);

INSERT INTO Employee VALUES
(1, 'Alice', NULL, 50000, 'New York'),
(2, 'Bob', 1, 55000, 'New York'),
(3, 'Charlie', 1, 60000, 'California'),
(4, 'David', 3, 45000, 'California'),
(5, 'Eva', 2, 52000, 'Texas'),
(6, 'Frank', 1, 62000, 'New York'),
(7, 'Grace', 3, 47000, 'California'),
(8, 'Henry', 4, 58000, 'California'),
(9, 'Isabella', 5, 51000, 'Texas'),
(10, 'Jack', 6, 48000, 'Texas'),
(11, 'Karen', 2, 53000, 'New York'),
(12, 'Leo', 4, 49500, 'California'),
(13, 'Mia', 5, 62000, 'Texas'),
(14, 'Nathan', 3, 55000, 'California'),
(15, 'Olivia', 2, 54000, 'Texas'),
(16, 'Paul', 1, 57000, 'New York'),
(17, 'Quincy', 6, 65000, 'New York'),
(18, 'Rachel', 1, 46000, 'California'),
(19, 'Sophia', 3, 62000, 'California'),
(20, 'Tom', 4, 47000, 'Texas');

with cte as( 
select emp_id, emp_name, salary,   avg(salary) over(partition by location) avg_sal from Employee )

select emp_id, emp_name from cte where salary>avg_sal
order by emp_id;

/*
Find riders who have taken at least one trip each day for the last 10 days.
*/

CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    driver_id INT,
    rider_id INT,
    trip_start_timestamp TIMESTAMP
);

INSERT INTO trips VALUES
(1, 101, 201, '2024-10-12 09:00:00'),
(2, 102, 202, '2024-10-13 10:30:00'),
(3, 101, 201, '2024-10-14 14:00:00'),
(4, 102, 202, '2024-10-15 15:45:00'),
(5, 101, 201, '2024-10-16 09:30:00'),
(6, 101, 201, '2024-10-17 12:30:00'),
(7, 103, 203, '2024-10-18 08:00:00'),
(8, 104, 204, '2024-10-19 09:15:00'),
(9, 101, 201, '2024-10-20 11:00:00'),
(10, 105, 206, '2024-10-21 12:45:00'),
(11, 102, 202, '2024-10-18 10:30:00'),
(12, 103, 203, '2024-10-19 13:15:00'),
(13, 104, 204, '2024-10-20 14:45:00'),
(14, 105, 210, '2024-10-21 16:00:00'),
(15, 101, 201, '2024-10-13 18:30:00'),
(16, 101, 201, '2024-10-15 07:45:00'),
(17, 101, 201, '2024-10-18 09:00:00'),
(18, 101, 201, '2024-10-19 10:30:00'),
(19, 101, 201, '2024-10-20 12:00:00'),
(20, 101, 201, '2024-10-21 13:45:00');

SELECT   rider_id, COUNT(distinct trip_start_timestamp) as trip_count
FROM     trips
WHERE    '2024-10-21 13:45:00' - trip_start_timestamp <= INTERVAL '10 DAY'
GROUP BY 1
HAVING   COUNT(distinct trip_start_timestamp) >= 10;

/*
Find the percentage of successful payments for each driver.
*/
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    driver_id INT,
    fare_amount DECIMAL(10, 2),
    driver_rating INT,
    start_time TIMESTAMP
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    ride_id INT,
    payment_status VARCHAR(20)
);

INSERT INTO rides VALUES
(1, 101, 100.00, 5, '2024-10-01 09:00:00'),
(2, 102, 150.00, 4, '2024-10-05 10:00:00'),
(3, 101, 200.00, 5, '2024-10-08 11:00:00'),
(4, 103, 120.00, 4, '2024-10-10 12:30:00'),
(5, 101, 180.00, 5, '2024-10-12 14:00:00'),
(6, 102, 220.00, 3, '2024-10-13 15:00:00'),
(7, 104, 300.00, 4, '2024-10-14 16:30:00'),
(8, 101, 250.00, 5, '2024-10-15 09:00:00'),
(9, 103, 175.00, 4, '2024-10-17 11:15:00'),
(10, 104, 190.00, 3, '2024-10-19 14:00:00');

INSERT INTO payments VALUES
(1, 1, 'Completed'),
(2, 2, 'Failed'),
(3, 3, 'Completed'),
(4, 4, 'Completed'),
(5, 5, 'Failed'),
(6, 6, 'Completed'),
(7, 7, 'Completed'),
(8, 8, 'Completed'),
(9, 9, 'Failed'),
(10, 10, 'Completed');

with cte as (
select 
	r.driver_id, 
	p.payment_status  
from rides r 
	join payments p 
	ON r.ride_id = p.ride_id)
select 
	driver_id, 
	ROUND(sum(case when payment_status= 'Completed' THEN 1 END)*1.0/count(*) * 100, 2) 
from cte 
	GROUP BY driver_id;
/*
Calculate the percentage of items sold at the restaurant level.
*/

CREATE TABLE items (
    item_id INT PRIMARY KEY,
    rest_id INT
);
drop table orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    item_id INT,
    quantity INT,
    is_offer BOOLEAN,
    client_id INT,
    date_timestamp TIMESTAMP
);


INSERT INTO items VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4);

INSERT INTO orders VALUES
(1, 1, 2, TRUE, 101, '2024-10-01 12:00:00'),
(2, 2, 1, FALSE, 102, '2024-10-03 14:00:00'),
(3, 3, 3, TRUE, 103, '2024-10-05 16:00:00'),
(4, 4, 2, FALSE, 104, '2024-10-06 13:00:00'),
(5, 1, 4, TRUE, 105, '2024-10-07 15:00:00'),
(6, 5, 3, FALSE, 106, '2024-10-08 11:00:00'),
(7, 6, 1, TRUE, 107, '2024-10-10 17:30:00'),
(8, 2, 5, FALSE, 108, '2024-10-12 12:45:00'),
(9, 7, 2, TRUE, 109, '2024-10-14 14:15:00'),
(10, 8, 3, FALSE, 110, '2024-10-15 10:00:00'),
(11, 3, 2, TRUE, 111, '2024-10-16 09:30:00'),
(12, 4, 4, FALSE, 112, '2024-10-17 13:00:00'),
(13, 5, 5, TRUE, 113, '2024-10-18 14:45:00'),
(14, 6, 1, FALSE, 114, '2024-10-19 18:00:00'),
(15, 3, 3, TRUE, 115, '2024-10-20 15:30:00'),
(16, 8, 2, FALSE, 116, '2024-10-21 12:00:00');

with total_items_cte as (
  SELECT   rest_id, COUNT(item_id) as total_items
    FROM     items
    GROUP BY 1
),sold_items_cte as (
    SELECT   i.rest_id, COUNT(o.item_id) as sold_items
    FROM     orders o JOIN items i ON o.item_id = i.item_id
    GROUP BY 1
)
SELECT t.rest_id,
       ROUND((s.sold_items * 100.0 / t.total_items), 2) as percentage_items_sold
FROM   total_items_cte t JOIN sold_items_cte s ON t.rest_id = s.rest_id;

/*
Compare the time taken for clients who placed their first order with and without an offer to make their next order.
*/
DROP TABLE orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    is_offer BOOLEAN,
    date_timestamp TIMESTAMP
);

INSERT INTO orders VALUES
(1, 101, TRUE, '2024-10-01 12:00:00'),
(2, 102, FALSE, '2024-10-02 13:00:00'),
(3, 101, TRUE, '2024-10-05 14:00:00'),
(4, 102, FALSE, '2024-10-06 15:00:00'),
(5, 103, TRUE, '2024-10-01 08:00:00'), 
(6, 103, TRUE, '2024-10-04 10:00:00'), 
(7, 104, FALSE, '2024-10-02 09:30:00'), 
(8, 104, FALSE, '2024-10-05 11:45:00'), 
(9, 105, TRUE, '2024-10-03 14:30:00'),  
(10, 105, FALSE, '2024-10-07 16:00:00'),
(11, 106, FALSE, '2024-10-04 12:00:00'),
(12, 106, TRUE, '2024-10-06 13:30:00'), 
(13, 107, TRUE, '2024-10-05 14:00:00'), 
(14, 107, TRUE, '2024-10-08 15:00:00'),
(15, 108, FALSE, '2024-10-06 09:00:00'),
(16, 108, TRUE, '2024-10-10 12:00:00');

with cte as (
select 
	is_offer, 
	lead(date_timestamp) over(partition by user_id order by date_timestamp)-date_timestamp as time_taken_to_next_order 
from orders 
	order by user_id, date_timestamp)
select 
	is_offer, 
	avg(time_taken_to_next_order) time_diff 
from cte 
	group by is_offer;

/*
Find all numbers that appear at least three times consecutively in a log table.
*/
CREATE TABLE logs (
    id INT PRIMARY KEY,
    num INT
);

INSERT INTO logs VALUES
(1, 5),
(2, 5),
(3, 5),
(4, 3),
(5, 4),
(6, 4),
(7, 4),
(8, 5),
(9, 5);

with cte as (
select *, lead(num) over() next_num,  lead(num,2) over() next_next_num  from logs)
select distinct num from cte where num = next_num and next_num = next_next_num;

/*
Find the length of the longest consecutive sequence of numbers in a table.
*/

CREATE TABLE consecutive (
    number INT
);

INSERT INTO consecutive VALUES
(1),
(2),
(3),
(5),
(6),
(8),
(9),
(10),
(11);
with cte as (
select number, row_number() over() rn from consecutive
), cte1 as (
select number, rn, rn-number rem from cte 
)
select count(rem) as longest_consecutive_seq from cte1
group by rem
order by longest_consecutive_seq desc
limit 1;

/*
Calculate the percentage of promo trips comparing members with non-members.
*/

CREATE TABLE pass_subscriptions (
    user_id INT,
    pass_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);
drop table orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    is_offer BOOLEAN,
    date_timestamp TIMESTAMP
);

INSERT INTO pass_subscriptions VALUES
(101, 1, '2024-01-01', '2024-12-31', 'PAID'),
(102, 2, '2024-03-01', '2024-12-31', 'PAID'),
(103, 3, '2024-06-01', '2024-12-31', 'PAID'),
(104, 4, '2024-08-01', '2024-12-31', 'PAID'),
(105, 1, '2024-05-15', '2024-12-31', 'EXPIRED'),
(106, 2, '2024-07-01', '2024-12-31', 'PAID'),
(107, 3, '2024-09-01', '2024-12-31', 'PAID'),
(108, 4, '2024-02-15', '2024-12-31', 'EXPIRED'),
(109, 1, '2024-01-15', '2024-12-31', 'PAID');

INSERT INTO orders VALUES
(1, 101, TRUE, '2024-10-01 12:00:00'),
(2, 102, FALSE, '2024-10-03 13:00:00'),
(3, 101, TRUE, '2024-10-05 14:00:00'),
(4, 103, TRUE, '2024-10-06 15:00:00'),
(5, 104, FALSE, '2024-10-07 16:00:00'),
(6, 105, TRUE, '2024-10-08 09:30:00'),
(7, 106, FALSE, '2024-10-09 10:15:00'),
(8, 107, TRUE, '2024-10-10 11:45:00'),
(9, 108, FALSE, '2024-10-11 12:00:00'),
(10, 109, TRUE, '2024-10-12 13:30:00'),
(11, 101, FALSE, '2024-10-13 14:00:00'),
(12, 102, TRUE, '2024-10-14 15:30:00'),
(13, 103, TRUE, '2024-10-15 16:00:00'),
(14, 104, FALSE, '2024-10-16 17:00:00'),
(15, 105, TRUE, '2024-10-17 18:00:00'),
(16, 106, FALSE, '2024-10-18 19:30:00');

with cte as (
select 
	case when status = 'PAID' Then 'member' 
	else 'Non-member' end as is_member
from pass_subscriptions p 
	LEFT JOIN orders o 
	on o.user_id = p.user_id
	where o.is_offer=True
)
select 
	is_member, 
	Round(count(*)*1.0/( select count(*) from cte )*100, 2 ) 
from cte  
	group by is_member;

