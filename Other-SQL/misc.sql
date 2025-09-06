WITH salary_changes AS (
    SELECT DATE '2010-01-01' AS change_date, 1000.0/12 AS monthly_sal
    UNION ALL
    SELECT DATE '2010-02-15', (1000.0 + 200.0)/12
    UNION ALL
    SELECT DATE '2010-04-15', (1000.0 + 200.0 + 100.0)/12
),
months AS (
    SELECT generate_series(
        DATE '2010-01-01',
        DATE '2010-12-01',
        interval '1 month'
    )::date AS month_start
)
SELECT 
    to_char(m.month_start, 'Mon-YY') AS month,
    sc.monthly_sal::numeric(10,2) AS monthly_sal
FROM months m
JOIN LATERAL (
    SELECT monthly_sal
    FROM salary_changes
    WHERE change_date <= m.month_start
    ORDER BY change_date DESC
    LIMIT 1
) sc ON true
ORDER BY m.month_start;

WITH base_data AS (
    SELECT 1 AS emp_id, 1000 AS yearly_sal, DATE '2010-01-01' AS start_date, DATE '2011-01-01' AS end_date
    UNION ALL
    SELECT 1, 200, DATE '2010-02-15', DATE '2011-01-01'
    UNION ALL
    SELECT 1, 100, DATE '2010-04-15', DATE '2011-01-01'
),
monthly_rows AS (
    SELECT 
        emp_id,
        start_date,
        yearly_sal / 12.0 AS monthly_sal,
        date_trunc('month', start_date)::date AS change_month
    FROM base_data
),
calendar AS (
    SELECT generate_series(
        DATE '2010-01-01',
        DATE '2010-12-01',
        interval '1 month'
    )::date AS month_start
),
salary_timeline AS (
    SELECT 
        c.month_start,
        SUM(m.monthly_sal) FILTER (WHERE m.change_month <= c.month_start) AS monthly_sal
    FROM calendar c
    LEFT JOIN monthly_rows m 
        ON m.change_month <= c.month_start
    GROUP BY c.month_start
)
SELECT to_char(month_start, 'Mon-YY') AS month, monthly_sal::numeric(10,2)
FROM salary_timeline
ORDER BY month_start;


-- Create the table
CREATE TABLE player_matches (
    player_id INTEGER NOT NULL,
    match_date DATE NOT NULL,
    match_result CHAR(1) NOT NULL CHECK (match_result IN ('W', 'L'))
);

-- Insert the data
INSERT INTO player_matches (player_id, match_date, match_result) VALUES
(401, '2021-05-04', 'W'),
(401, '2021-05-09', 'L'),
(401, '2021-05-16', 'L'),
(401, '2021-05-18', 'W'),
(401, '2021-05-22', 'L'),
(401, '2021-06-15', 'L'),
(401, '2021-06-16', 'W'),
(401, '2021-06-18', 'W'),
(401, '2021-07-06', 'L'),
(401, '2021-07-13', 'L'),
(402, '2021-05-14', 'L'),
(402, '2021-05-23', 'L'),
(402, '2021-05-24', 'W'),
(402, '2021-06-01', 'W'),
(402, '2021-06-02', 'W'),
(402, '2021-07-01', 'W'),
(402, '2021-07-11', 'W'),
(402, '2021-07-20', 'L'),
(402, '2021-07-26', 'L'),
(402, '2021-07-30', 'L'),
(403, '2021-05-03', 'L'),
(403, '2021-05-11', 'W'),
(403, '2021-05-12', 'W'),
(403, '2021-05-13', 'W'),
(403, '2021-05-20', 'W'),
(403, '2021-05-25', 'W'),
(403, '2021-07-06', 'L'),
(403, '2021-07-15', 'L'),
(403, '2021-07-22', 'W'),
(403, '2021-07-23', 'W'),
(404, '2021-05-10', 'W'),
(404, '2021-05-16', 'W'),
(404, '2021-05-20', 'W'),
(404, '2021-05-22', 'W'),
(404, '2021-05-28', 'L'),
(404, '2021-06-06', 'L'),
(404, '2021-06-14', 'W'),
(404, '2021-07-25', 'W'),
(404, '2021-07-26', 'L'),
(405, '2021-05-07', 'L'),
(405, '2021-05-25', 'L'),
(405, '2021-06-06', 'L'),
(405, '2021-06-07', 'L'),
(405, '2021-06-14', 'L'),
(405, '2021-07-01', 'L'),
(405, '2021-07-02', 'L'),
(405, '2021-07-14', 'W'),
(405, '2021-07-16', 'L'),
(405, '2021-07-30', 'L');

with cte as(
select *, Row_number() over(partition by player_id  order by match_date)-Row_number() over(partition by player_id, match_result  order by match_date) as grp
from player_matches ), 
grp_cte as (
select player_id, count(*) streak_length from cte where match_result='W' group by player_id, grp),
ranked_cte as (
select player_id, streak_length, dense_rank() over(order by streak_length desc) rnk from grp_cte
)
select player_id, streak_length from ranked_cte where rnk=1;


-- Create the table
CREATE TABLE users_purchases (
    user_id INTEGER NOT NULL,
    created_at DATE NOT NULL,
    purchase_amt INTEGER NOT NULL
);

-- Insert the data
INSERT INTO users_purchases (user_id, created_at, purchase_amt) VALUES
(10, '2020-01-01', 3742),
(11, '2020-01-04', 1290),
(12, '2020-01-07', 4249),
(13, '2020-01-10', 4899),
(14, '2020-01-13', -4656),
(15, '2020-01-16', -655),
(16, '2020-01-19', 4659),
(17, '2020-01-22', 3813),
(18, '2020-01-25', -2623),
(19, '2020-01-28', 3640),
(20, '2020-01-31', -1028),
(21, '2020-02-03', 2715),
(22, '2020-02-06', 1592),
(23, '2020-02-09', 1516),
(24, '2020-02-12', 2700),
(25, '2020-02-15', 1543),
(26, '2020-02-18', 4210),
(27, '2020-02-21', -608),
(28, '2020-02-24', 2855),
(29, '2020-02-27', 3564),
(30, '2020-03-01', 3037),
(31, '2020-03-04', 2552),
(32, '2020-03-07', 2487),
(33, '2020-03-10', -1933),
(34, '2020-03-13', 4973),
(35, '2020-03-16', 4475),
(36, '2020-03-19', -913),
(37, '2020-03-22', 2265),
(38, '2020-03-25', 3525),
(39, '2020-03-28', 3251),
(40, '2020-03-31', 3055),
(41, '2020-04-03', 4828),
(42, '2020-04-06', -3230),
(43, '2020-04-09', 4772),
(44, '2020-04-12', -775),
(45, '2020-04-15', 2051),
(46, '2020-04-18', 1974),
(47, '2020-04-21', 2311),
(48, '2020-04-24', -593),
(49, '2020-04-27', 2583),
(50, '2020-04-30', 3414),
(51, '2020-05-03', 4216),
(52, '2020-05-06', 2420),
(53, '2020-05-09', 3138),
(54, '2020-05-12', 1036),
(55, '2020-05-15', 2543),
(56, '2020-05-18', 2127),
(57, '2020-05-21', 1026),
(58, '2020-05-24', 1650),
(59, '2020-05-27', 3514),
(60, '2020-05-30', 3030),
(61, '2020-06-02', 4014),
(62, '2020-06-05', 4390),
(63, '2020-06-08', 4459),
(64, '2020-06-11', -2850),
(65, '2020-06-14', 4369),
(66, '2020-06-17', 1895),
(67, '2020-06-20', 2184),
(68, '2020-06-23', -765),
(69, '2020-06-26', 2001),
(70, '2020-06-29', 4375),
(71, '2020-07-02', 4104),
(72, '2020-07-05', 4223),
(73, '2020-07-08', 633),
(74, '2020-07-11', 3352),
(75, '2020-07-14', 4421),
(76, '2020-07-17', -4284),
(77, '2020-07-20', 1904),
(78, '2020-07-23', 4928),
(79, '2020-07-26', -1680),
(80, '2020-07-29', 1744),
(81, '2020-08-01', 3797),
(82, '2020-08-04', 4053),
(83, '2020-08-07', -1829),
(84, '2020-08-10', 2196),
(85, '2020-08-13', 1792),
(86, '2020-08-16', 4050),
(87, '2020-08-19', 1468),
(88, '2020-08-22', 2191),
(89, '2020-08-25', -594),
(90, '2020-08-28', 2318),
(91, '2020-08-31', 1631),
(92, '2020-09-03', 3804),
(93, '2020-09-06', -2032),
(94, '2020-09-09', 3599),
(95, '2020-09-12', 3043),
(96, '2020-09-15', 1999),
(97, '2020-09-18', -1334),
(98, '2020-09-21', 4344),
(99, '2020-09-24', -3960),
(100, '2020-09-27', 4316),
(101, '2020-09-30', 3722),
(102, '2020-10-03', 1433),
(103, '2020-10-06', -1045),
(104, '2020-10-09', 3035),
(105, '2020-10-12', 4865),
(106, '2020-10-15', -3330),
(107, '2020-10-18', 4228),
(108, '2020-10-21', -1834),
(109, '2020-10-24', 1749);


with cte as (
select *, to_char(created_at, 'MM-YYYY') month_year, case when purchase_amt<0 then 0 else purchase_amt end p_amount from users_purchases
)
select *, sum(p_amount) over(partition by month_year order by created_at
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) from cte;



-- Table1
CREATE TABLE table1 (
    ID   INT PRIMARY KEY,
    NAME VARCHAR(50),
    DEP  VARCHAR(20)
);

-- Table2
CREATE TABLE table2 (
    ID   INT PRIMARY KEY,
    NAME VARCHAR(50),
    DEP  VARCHAR(20)
);
-- Data for Table1
INSERT INTO table1 (ID, NAME, DEP) VALUES
(1, 'abc', 'N/W'),
(2, 'def', 'N/W'),
(3, 'ghi', 'S/W'),
(4, 'jkl', 'S/W');

-- Data for Table2
INSERT INTO table2 (ID, NAME, DEP) VALUES
(1, 'abc', 'S/W'),
(5, 'mno', 'N/W');

SELECT 
    COALESCE(t2.ID, t1.ID) AS ID,
    COALESCE(t2.NAME, t1.NAME) AS NAME,
    COALESCE(t2.DEP, t1.DEP) AS DEP
FROM table1 t1
FULL OUTER JOIN table2 t2
ON t1.ID = t2.ID;

-- take all rows from table2
SELECT ID, NAME, DEP
FROM table2

UNION

-- take rows from table1 only if ID not present in table2
SELECT t1.ID, t1.NAME, t1.DEP
FROM table1 t1
WHERE NOT EXISTS (
    SELECT 1 
    FROM table2 t2
    WHERE t1.ID = t2.ID
);

-- select * from sales

drop table if exists product;
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255)
);

INSERT INTO product (product_id, product_name) VALUES
(1, 'LC Phone'),
(2, 'LC T-Shirt'),
(3, 'LC Keychain');

drop table if exists sales;
CREATE TABLE sales (
    product_id INT REFERENCES Product(product_id),
    period_start DATE,
    period_end DATE,
    average_daily_sales INT
);

INSERT INTO sales (product_id, period_start, period_end, average_daily_sales) VALUES
(1, '2019-01-25', '2019-02-28', 100),
(2, '2018-12-01', '2020-01-01', 10),
(3, '2019-12-01', '2020-01-31', 1);

with remaining_date_fill_cte as (
select *, to_char(s.period_start, 'YYYY') start_year, to_char(s.period_end, 'YYYY') end_year from sales s 
 join generate_series(s.period_start, CASE WHEN to_char(s.period_end, 'YYYY') = to_char(s.period_start, 'YYYY') THEN s.period_end ELSE s.period_end+INTERVAL '1 YEAR' END , INTERVAL '1 YEAR') new_date_rages
ON true)
,ranked_cte as (
select *, to_char(new_date_rages, 'YYYY') ranges_year, ROW_NUMBER() OVER(PARTITION BY product_id order by new_date_rages) rn  from remaining_date_fill_cte)
select p.*, 
case when rn =1 and start_year = end_year then ((period_end - period_start)+1)* average_daily_sales
when rn =1 and start_year != end_year then ((make_date(start_year::int, 12, 31)-period_start)+1)*average_daily_sales
when rn !=1 and start_year != end_year then ((period_end - make_date(ranges_year::int, 01, 01))+1)*average_daily_sales
end from ranked_cte r
Join product p
on r.product_id  = p.product_id;

/*
Write a SQL query to populate category values to the last not null value.
*/

CREATE TABLE brands (
    category VARCHAR(20),
    brand_name VARCHAR(20)
);

INSERT INTO brands VALUES
('chocolates', '5-star'),
(NULL, 'dairy milk'),
(NULL, 'perk'),
(NULL, 'eclair'),
('Biscuits', 'britannia'),
(NULL, 'good day'),
(NULL, 'boost');

with cte as (
select *, row_number() over() rn from brands 

)
select 
min(category) over(order by rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) category, 
brand_name from cte ;


/*
Given a call_log table that contains information about callers' call history,
write a SQL query to find callers whose first and last call was to the same person on a given day.
*/
DROP TABLE call_log;
CREATE TABLE call_log (
   caller_id INT,
   recipient_id INT,
   date_called TIMESTAMP
);

INSERT INTO call_log (caller_id, recipient_id, date_called) VALUES 
(1, 2, '2019-01-01 09:00:00'),
(1, 3, '2019-01-01 17:00:00'),
(1, 4, '2019-01-01 23:00:00'),
(2, 5, '2019-07-05 09:00:00'),
(2, 3, '2019-07-05 17:00:00'),
(2, 3, '2019-07-05 17:20:00'),
(2, 5, '2019-07-05 23:00:00'),
(2, 3, '2019-08-01 09:00:00'),
(2, 3, '2019-08-01 17:00:00'),
(2, 5, '2019-08-01 19:30:00'),
(2, 4, '2019-08-02 09:00:00'),
(2, 5, '2019-08-02 10:00:00'),
(2, 5, '2019-08-02 10:45:00'),
(2, 4, '2019-08-02 11:00:00')


with cte as (
select caller_id, to_char(date_called, 'YYYY-MM-DD'), case when 
first_value(recipient_id) over(partition by caller_id, to_char(date_called, 'YYYY-MM-DD') order by date_called )= 
first_value(recipient_id) over(partition by caller_id, to_char(date_called, 'YYYY-MM-DD') order by date_called desc )  then 1 else 0 end as is_same
from call_log)
select distinct * from cte where is_same = 1 order by caller_id


WITH calls_cte as (
    SELECT   DATE(date_called) as date, 
             caller_id,
             MIN(date_called) as first_call,
             MAX(date_called) as last_call
    FROM     call_log
    GROUP BY 1, 2
    ORDER BY 1, 2
)
SELECT date,
       c.caller_id,
       cl1.recipient_id as recipient_id
FROM   calls_cte c JOIN call_log cl1 ON c.caller_id=cl1.caller_id AND c.first_call=cl1.date_called 
                   JOIN call_log cl2 ON c.caller_id=cl2.caller_id AND c.last_call=cl2.date_called
WHERE  cl1.recipient_id = cl2.recipient_id;


/*
A company wants to hire new employees. The budget of the company for salaries is $70,000. 
The company's criteria for hiring are:

Keep hiring the senior with the smallest salary until you cannot hire any more seniors.

Use the remaining budget to hire the junior with the smallest salary.

Keep hiring the junior with the smallest salary until you cannot hire any more juniors.

Write an SQL query to find the seniors and juniors hired under the mentioned criteria.
*/

CREATE TABLE candidates (
    emp_id INT,
    experience VARCHAR(10),
    salary INT
);

INSERT INTO candidates VALUES
(1, 'Junior', 10000),
(2, 'Junior', 15000),
(3, 'Senior', 40000),
(4, 'Senior', 16000),
(5, 'Senior', 20000);

with cte as (
select *, sum(salary) over(order by salary) as running_sal from candidates where experience = 'Senior')
, senior_cte as (
select * from cte where running_sal<=70000),
junior_salary as (
select *, sum(salary) over(order by salary) as running_sal from candidates where experience = 'Junior'
)
select emp_id,experience, salary  from senior_cte
union all 
select  emp_id, experience, salary  from junior_salary where running_sal <= (70000-(select sum(salary) from senior_cte));


/*
Write a SQL query to list employee names along with their manager's and senior manager's names. The senior manager is the manager's manager.
*/

CREATE TABLE employees (
    emp_id INT,
    emp_name varchar(50),
    manager_id INT
);

INSERT INTO employees VALUES 
(1, 'Ankit', 4),
(2, 'Mohit', 5),
(3, 'Vikas', 4),
(4, 'Rohit', 2),
(5, 'Mudit', 6),
(6, 'Agam', 2),
(7, 'Sanjay', 2),
(8, 'Ashish', 2),
(9, 'Mukesh', 6),
(10, 'Rakesh', 6);

select distinct e1.emp_name, e2.emp_name, e3.emp_name from employees e1 
LEFT JOIN employees e2 
ON e1.manager_id = e2.emp_id
LEFT JOIN employees e3
ON e2.manager_id = e3.emp_id;


