/*
*/
-- Drop the table if it exists
DROP TABLE IF EXISTS forbes_companies;

-- Create the companies table
CREATE TABLE forbes_companies (
    company VARCHAR(255),
    sector VARCHAR(255),
    industry VARCHAR(255),
    continent VARCHAR(255),
    country VARCHAR(255),
    marketvalue DECIMAL(15, 2),
    sales DECIMAL(15, 2),
    profits DECIMAL(15, 2),
    assets DECIMAL(15, 2),
    rank INT
);

-- Insert the data into the companies table
INSERT INTO forbes_companies (company, sector, industry, continent, country, marketvalue, sales, profits, assets, rank) VALUES
('ICBC', 'Financials', 'Major Banks', 'Asia', 'China', 215.60, 148.70, 42.70, 3124.90, 1),
('China Construction Bank', 'Financials', 'Regional Banks', 'Asia', 'China', 174.40, 121.30, 34.20, 2449.50, 4),
('Agricultural Bank of China', 'Financials', 'Regional Banks', 'Asia', 'China', 141.10, 136.40, 27.00, 2405.40, 8),
('JPMorgan Chase', 'Financials', 'Major Banks', 'North America', 'United States', 229.70, 105.70, 17.30, 2435.30, 20),
('Berkshire Hathaway', 'Financials', 'Investment Services', 'North America', 'United States', 309.10, 178.80, 19.50, 493.40, 17),
('Exxon Mobil', 'Energy', 'Oil & Gas Operations', 'North America', 'United States', 422.30, 394.00, 32.60, 346.80, 5),
('General Electric', 'Industrials', 'Conglomerates', 'North America', 'United States', 259.60, 143.30, 14.80, 656.60, 25),
('Wells Fargo', 'Financials', 'Major Banks', 'North America', 'United States', 261.40, 88.70, 21.90, 1543.00, 13),
('Bank of China', 'Financials', 'Major Banks', 'Asia', 'China', 124.20, 105.10, 25.50, 2291.80, 9),
('PetroChina', 'Energy', 'Oil & Gas Operations', 'Asia', 'China', 202.00, 328.50, 21.10, 386.90, 15),
('Royal Dutch Shell', 'Energy', 'Oil & Gas Operations', 'Europe', 'Netherlands', 234.10, 451.40, 16.40, 357.50, 22),
('Toyota Motor', 'Consumer Discretionary', 'Auto & Truck Manufacturers', 'Asia', 'Japan', 193.50, 255.60, 18.80, 385.50, 18),
('Bank of America', 'Financials', 'Major Banks', 'North America', 'United States', 183.30, 101.50, 11.40, 2113.80, 33),
('HSBC Holdings', 'Financials', 'Major Banks', 'Europe', 'United Kingdom', 192.60, 79.60, 16.30, 2671.30, 23),
('Apple', 'Information Technology', 'Computer Hardware', 'North America', 'United States', 483.10, 173.80, 37.00, 225.20, 3);

with cte as(
select company, profits, dense_rank() over(order by profits desc) rnk from forbes_companies )
select company, profits from cte where rnk<=3;

/*
https://platform.stratascratch.com/coding/10319-monthly-percentage-difference?code_type=1

Given a table of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.
The percentage change column will be populated from the 2nd month forward and can be calculated as ((this month's revenue - last month's revenue) / last month's revenue)*100.
*/

-- Drop the table if it exists
DROP TABLE IF EXISTS sf_transactions;

-- Create the sf_transactions table
CREATE TABLE sf_transactions (
    id INT,
    created_at DATE,  -- Use DATE for date-only values
    value INT,
    purchase_id INT
);

-- Insert the data into the sf_transactions table
INSERT INTO sf_transactions (id, created_at, value, purchase_id) VALUES
(9, '2019-02-02', 140032, 25),
(10, '2019-02-06', 116948, 43),
(11, '2019-02-10', 162515, 25),
(12, '2019-02-14', 114256, 12),
(13, '2019-02-18', 197465, 48),
(14, '2019-02-22', 120741, 20),
(15, '2019-02-26', 100074, 49),
(16, '2019-03-02', 157548, 19),
(17, '2019-03-06', 105506, 16),
(18, '2019-03-10', 189351, 46),
(19, '2019-03-14', 191231, 29),
(20, '2019-03-18', 120575, 44);

with cte as(
select  TO_CHAR(created_at, 'YYYY-MM') year_month,
sum(value) this_month_revenue 
from sf_transactions
group by TO_CHAR(created_at, 'YYYY-MM')),
revenue as(
select year_month, 
this_month_revenue, 
lag(this_month_revenue) over(order by year_month) last_month_revenue from cte )
select 
year_month,
ROUND(((this_month_revenue - last_month_revenue)*1.0 / last_month_revenue)*100,2) revenue_diff_pct
from revenue

/*
https://platform.stratascratch.com/coding/10352-users-by-avg-session-time?code_type=1

Calculate each user's average session time, where a session is defined as the time difference 
between a page_load and a page_exit. Assume each user has only one session per day. 
If there are multiple page_load or page_exit events on the same day, use only the 
latest page_load and the earliest page_exit, 
ensuring the page_load occurs before the page_exit. Output the user_id and their average session time.
*/

-- Create the user_actions table
CREATE TABLE fb_user_actions (
    user_id INT,
    timestamp TIMESTAMP,
    action VARCHAR(255)
);

-- Insert statements to populate the table
INSERT INTO fb_user_actions (user_id, timestamp, action) VALUES
(0, '2019-04-25 13:30:15', 'page_load'),
(0, '2019-04-25 13:30:18', 'page_load'),
(0, '2019-04-25 13:30:40', 'scroll_down'),
(0, '2019-04-25 13:30:45', 'scroll_up'),
(0, '2019-04-25 13:31:10', 'scroll_down'),
(0, '2019-04-25 13:31:25', 'scroll_down'),
(0, '2019-04-25 13:31:40', 'page_exit'),
(1, '2019-04-25 13:40:00', 'page_load'),
(1, '2019-04-25 13:40:10', 'scroll_down'),
(1, '2019-04-25 13:40:15', 'scroll_down'),
(1, '2019-04-25 13:40:20', 'scroll_down'),
(1, '2019-04-25 13:40:25', 'scroll_down'),
(1, '2019-04-25 13:40:30', 'scroll_down'),
(1, '2019-04-25 13:40:35', 'page_exit'),
(2, '2019-04-25 13:41:21', 'page_load'),
(2, '2019-04-25 13:41:30', 'scroll_down'),
(2, '2019-04-25 13:41:35', 'scroll_down'),
(2, '2019-04-25 13:41:40', 'scroll_up'),
(1, '2019-04-26 11:15:00', 'page_load'),
(1, '2019-04-26 11:15:10', 'scroll_down'),
(1, '2019-04-26 11:15:20', 'scroll_down'),
(1, '2019-04-26 11:15:25', 'scroll_up'),
(1, '2019-04-26 11:15:35', 'page_exit'),
(0, '2019-04-28 14:30:15', 'page_load'),
(0, '2019-04-28 14:30:10', 'page_load'), 
(0, '2019-04-28 13:30:40', 'scroll_down'), 
(0, '2019-04-28 15:31:40', 'page_exit');

-- SOL:
with cte as(
SELECT *, date(timestamp) date FROM fb_user_actions),
 page_load as (
select user_id, date,
max(timestamp) page_load_time
from cte 
where action = 'page_load'
group by user_id, date
),
page_exit as (
select user_id, date,
min(timestamp) page_exit_time
from cte 
where action = 'page_exit'
group by user_id, date
)
select pl.user_id, 
ROUND(avg(EXTRACT(EPOCH FROM page_exit_time - page_load_time)),2) avg_session_duration 
from page_load pl
inner join page_exit pe
on pl.date = pe.date and pl.user_id = pe.user_id
group by pl.user_id


/*
*/


