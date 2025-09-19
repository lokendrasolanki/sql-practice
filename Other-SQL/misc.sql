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

/*
Write a query to print the cumulative balance of the merchant account at the end of each day,
with the total balance reset back to zero at the end of the month.
Output the transaction date and cumulative balance.
*/
drop table if exists transactions;
CREATE TABLE transactions (
    transaction_id INT,
    type VARCHAR(20),
    amount DECIMAL(10, 2),
    transaction_date TIMESTAMP
);

INSERT INTO transactions (transaction_id, type, amount, transaction_date) VALUES
(19153, 'deposit', 65.90, '2022-07-10 10:00:00'),
(53151, 'deposit', 178.55, '2022-07-08 10:00:00'),
(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00'),
(16461, 'withdrawal', 45.99, '2022-07-08 10:00:00'),
(77134, 'deposit', 32.60, '2022-07-10 10:00:00');

with cte as (
select transaction_date , sum(case when type = 'withdrawal' then -amount else amount end) total_sum 
from transactions group by transaction_date)
select transaction_date, 
sum(total_sum) over(order by transaction_date) as balance 
from cte;

/*
The Airbnb Booking Recommendations team is trying to understand the "substitutability" of two rentals and whether one rental is a good substitute for another.

Write a query to find the unique combination of two Airbnb rentals with the exact same amenities offered.

Assumptions:

If property 1 has a kitchen and pool, and property 2 has a kitchen and pool too, they are good substitutes and represent a unique matching rental.

If property 3 has a kitchen, pool, and fireplace, and property 4 only has a pool and fireplace, then they are not a good substitute.


*/
CREATE TABLE rental_amenities (
  rental_id int,
  amenity varchar(50)
);

INSERT INTO rental_amenities (rental_id, amenity) VALUES
(123, 'pool'),
(123, 'kitchen'),
(234, 'hot tub'),
(234, 'fireplace'),
(345, 'kitchen'),
(345, 'pool'),
(456, 'pool');

with cte as (
select rental_id, 
STRING_AGG(amenity, ', ' ORDER BY amenity) all_amenity from rental_amenities 
 GROUP BY rental_id )
 select count(*) as matching_airbnb 
 from cte c1
 INNER JOIN cte c2 
 on c1.all_amenity = c2.all_amenity 
 and c1.rental_id < c2.rental_id;


 /*
 Find all regions where sales have increased for five consecutive years. A region qualifies if, for each of the five years, sales are higher than in the previous year. Return the region name along with the starting year of the five-year growth period.
 */


 -- Create the sales_data table
CREATE TABLE sales_data (
    region_name TEXT,
    year INTEGER,
    sales NUMERIC
);
INSERT INTO sales_data (region_name, year, sales) VALUES
    ('latam', 2012, 230.62),
    ('us_west', 2010, 163.94),
    ('us_east', 2012, 270.63),
    ('emea', 2010, 150.0),
    ('us_east', 2010, 108.69),
    ('us_west', 2012, 188.41),
    ('canada_central', 2017, 138.9),
    ('us_east', 2015, 168.64),
    ('us_west', 2011, 176.69),
    ('apac', 2015, 173.46),
    ('us_west', 2011, 176.69),
    ('apac', 2017, 210.97),
    ('apac', 2013, 143.11),
    ('europe_north', 2015, 255.28),
    ('us_east', 2014, 149.76),
    ('us_west', 2012, 260.8),
    ('us_west', 2010, 163.94),
    ('canada_central', 2011, 235.01),
    ('apac', 2010, 181.7),
    ('canada_central', 2010, 161.44),
    ('apac', 2011, 120.0),
    ('emea', 2014, 150.0),
    ('europe_north', 2010, 164.99),
    ('us_west', 2012, 188.41),
    ('emea', 2011, 150.0),
    ('europe_north', 2011, 177.19),
    ('emea', 2013, 150.0),
    ('india_south', 2013, 179.75),
    ('apac', 2020, 272.29),
    ('emea', 2012, 150.0),
    ('us_west', 2014, 231.01),
    ('us_east', 2011, 118.99),
    ('us_west', 2013, 216.04),
    ('us_west', 2015, 258.55),
    ('apac', 2018, 236.95),
    ('apac', 2019, 248.11),
    ('apac', 2015, 126.78),
    ('europe_north', 2012, 196.77),
    ('emea', 2015, 150.0),
    ('apac', 2012, 133.4),
    ('us_east', 2010, 197.51),
    ('apac', 2014, 178.72),
    ('us_west', 2012, 250.08),
    ('europe_north', 2017, 247.0),
    ('europe_north', 2008, 294.09),
    ('india_south', 2007, 201.45),
    ('europe_north', 2013, 219.27),
    ('us_east', 2012, 133.07),
    ('europe_north', 2014, 205.25),
    ('us_east', 2013, 153.85),
    ('apac', 2021, 280.0),
    ('apac', 2022, 300.0),
    ('apac', 2023, 320.0),
    ('apac', 2024, 350.0),
    ('apac', 2025, 400.0),
    ('europe_north', 2016, 200.0),
    ('europe_north', 2018, 250.0),
    ('europe_north', 2019, 270.0),
    ('europe_north', 2020, 300.0);

with cte as (
select *, row_number() over() rn, lag(sales) over(partition by region_name order by year) prev_sale from sales_data)
,case_cte as (
select *,
CASE WHEN (sales IS NULL OR (sales-prev_sale)>0) THEN 1 ELSE 0 END as check_sales from cte )
, cte1 as (
select *,  row_number() over(partition by region_name, check_sales order by year ) rn1 ,rn - check_sales AS group_id from case_cte where check_sales=1)
select region_name, rn -rn1, count(*) from cte1 
group by region_name, rn -rn1
having count(*)>=5;

/*
Identify returning active users by finding users who made a second purchase within 7 days or less of any previous purchase. Output a list of these user_id.
*/

-- Create the `sales` table
CREATE TABLE amazon_transactions (
    id INT,
    user_id INT,
    item TEXT,
    created_at DATE,
    revenue INT
);

-- Insert data into the `sales` table
INSERT INTO amazon_transactions (id, user_id, item, created_at, revenue) VALUES
(1, 109, 'milk', '2020-03-03', 123),
(2, 139, 'biscuit', '2020-03-18', 421),
(3, 120, 'milk', '2020-03-18', 176),
(4, 108, 'banana', '2020-03-18', 862),
(5, 130, 'milk', '2020-03-28', 333),
(6, 103, 'bread', '2020-03-29', 862),
(7, 122, 'banana', '2020-03-07', 952),
(8, 125, 'bread', '2020-03-13', 317),
(9, 139, 'bread', '2020-03-30', 929),
(10, 141, 'banana', '2020-03-17', 812),
(11, 116, 'bread', '2020-03-31', 226),
(12, 128, 'bread', '2020-03-04', 112),
(13, 146, 'biscuit', '2020-03-04', 362),
(14, 119, 'banana', '2020-03-28', 127),
(15, 142, 'bread', '2020-03-09', 503),
(16, 122, 'bread', '2020-03-06', 593),
(17, 128, 'biscuit', '2020-03-24', 160),
(18, 112, 'banana', '2020-03-24', 262),
(19, 149, 'banana', '2020-03-29', 382),
(20, 100, 'banana', '2020-03-18', 599),
(21, 130, 'milk', '2020-03-16', 604),
(22, 103, 'milk', '2020-03-31', 290),
(23, 112, 'banana', '2020-03-23', 523),
(24, 102, 'bread', '2020-03-25', 325),
(25, 120, 'biscuit', '2020-03-21', 858),
(26, 109, 'bread', '2020-03-22', 432),
(27, 101, 'milk', '2020-03-01', 449),
(28, 138, 'milk', '2020-03-19', 961),
(29, 100, 'milk', '2020-03-29', 410),
(30, 129, 'milk', '2020-03-02', 771),
(31, 123, 'milk', '2020-03-31', 434),
(32, 104, 'biscuit', '2020-03-31', 957),
(33, 110, 'bread', '2020-03-13', 210),
(34, 143, 'bread', '2020-03-27', 870),
(35, 130, 'milk', '2020-03-12', 176),
(36, 128, 'milk', '2020-03-28', 498),
(37, 133, 'banana', '2020-03-21', 837),
(38, 150, 'banana', '2020-03-20', 927),
(39, 120, 'milk', '2020-03-27', 793),
(40, 109, 'bread', '2020-03-02', 362),
(41, 110, 'bread', '2020-03-13', 262),
(42, 140, 'milk', '2020-03-09', 468),
(43, 112, 'banana', '2020-03-04', 381),
(44, 117, 'biscuit', '2020-03-19', 831),
(45, 137, 'banana', '2020-03-23', 490),
(46, 130, 'bread', '2020-03-09', 149),
(47, 133, 'bread', '2020-03-08', 658),
(48, 143, 'milk', '2020-03-11', 317),
(49, 111, 'biscuit', '2020-03-23', 204),
(50, 150, 'banana', '2020-03-04', 299),
(51, 131, 'bread', '2020-03-10', 155),
(52, 140, 'biscuit', '2020-03-17', 810),
(53, 147, 'banana', '2020-03-22', 702),
(54, 119, 'biscuit', '2020-03-15', 355),
(55, 116, 'milk', '2020-03-12', 468),
(56, 141, 'milk', '2020-03-14', 254),
(57, 143, 'bread', '2020-03-16', 647),
(58, 105, 'bread', '2020-03-21', 562),
(59, 149, 'biscuit', '2020-03-11', 827),
(60, 117, 'banana', '2020-03-22', 249),
(61, 150, 'banana', '2020-03-21', 450),
(62, 134, 'bread', '2020-03-08', 981),
(63, 133, 'banana', '2020-03-26', 353),
(64, 127, 'milk', '2020-03-27', 300),
(65, 101, 'milk', '2020-03-26', 740),
(66, 137, 'biscuit', '2020-03-12', 473),
(67, 113, 'biscuit', '2020-03-21', 278),
(68, 141, 'bread', '2020-03-21', 118),
(69, 112, 'biscuit', '2020-03-14', 334),
(70, 118, 'milk', '2020-03-30', 603),
(71, 111, 'milk', '2020-03-19', 205),
(72, 146, 'biscuit', '2020-03-13', 599),
(73, 148, 'banana', '2020-03-14', 530),
(74, 100, 'banana', '2020-03-13', 175),
(75, 105, 'banana', '2020-03-05', 815),
(76, 129, 'milk', '2020-03-02', 489),
(77, 121, 'milk', '2020-03-16', 476),
(78, 117, 'bread', '2020-03-11', 270),
(79, 133, 'milk', '2020-03-12', 446),
(80, 124, 'bread', '2020-03-31', 937),
(81, 145, 'bread', '2020-03-07', 821),
(82, 105, 'banana', '2020-03-09', 972),
(83, 131, 'milk', '2020-03-09', 808),
(84, 114, 'biscuit', '2020-03-31', 202),
(85, 120, 'milk', '2020-03-06', 898),
(86, 130, 'milk', '2020-03-06', 581),
(87, 141, 'biscuit', '2020-03-11', 749),
(88, 147, 'bread', '2020-03-14', 262),
(89, 118, 'milk', '2020-03-15', 735),
(90, 136, 'biscuit', '2020-03-22', 410),
(91, 132, 'bread', '2020-03-06', 161),
(92, 137, 'biscuit', '2020-03-31', 427),
(93, 107, 'bread', '2020-03-01', 701),
(94, 111, 'biscuit', '2020-03-18', 218),
(95, 100, 'bread', '2020-03-07', 410),
(96, 106, 'milk', '2020-03-21', 379),
(97, 114, 'banana', '2020-03-25', 705),
(98, 110, 'bread', '2020-03-27', 225),
(99, 130, 'milk', '2020-03-16', 494),
(100, 117, 'bread', '2020-03-10', 209);


with cte as (
select *, LAG( created_at) over(partition by user_id order by created_at) prev_date from amazon_transactions )
select distinct user_id from cte
where (created_at - prev_date)<=7 
group by user_id, created_at - prev_date
Order by user_id
	
