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
group by pl.user_i


/*
https://platform.stratascratch.com/coding/10351-activity-rank?code_type=1

Find the email activity rank for each user.
Email activity rank is defined by the total number of emails sent. 
The user with the highest number of emails sent will have a rank of 1, and so on. 
Output the user, total emails, and their activity rank.

•	Order records first by the total emails in descending order.
•	Then, sort users with the same number of emails in alphabetical order by their username.
•	In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails.
*/

CREATE TABLE google_gmail_emails (
    id INT PRIMARY KEY,  -- Important: Add a primary key
    from_user VARCHAR(255),
    to_user VARCHAR(255),
    day INT
);

-- Insert statements
INSERT INTO google_gmail_emails (id, from_user, to_user, day) VALUES
(0, '6edf0be4b2267df1fa', '75d295377a46f83236', 10),
(1, '6edf0be4b2267df1fa', '32ded68d89443e808', 6),
(2, '6edf0be4b2267df1fa', '55e60cfcc9dc49c17e', 10),
(3, '6edf0be4b2267df1fa', 'e0e0defbb9ec47f6f7', 6),
(4, '6edf0be4b2267df1fa', '47be2887786891367e', 1),
(5, '6edf0be4b2267df1fa', '2813e59cf6c1ff698e', 6),
(6, '6edf0be4b2267df1fa', 'a84065b7933ad01019', 8),
(7, '6edf0be4b2267df1fa', '850badf89ed8f06854', 1),
(8, '6edf0be4b2267df1fa', '6b503743a13d778200', 1),
(9, '6edf0be4b2267df1fb', 'd63386c884aeb9f71d', 3),
(10, '6edf0be4b2267df1fb', '5b8754928306a18b68', 2),
(11, '6edf0be4b2267df1fb', '6edf0be4b2267df1fa', 8),
(12, '6edf0be4b2267df1fb', '406539987dd9b679c0', 9),
(13, '6edf0be4b2267df1fb', '114bafadff2d882864', 5),
(14, '6edf0be4b2267df1fb', '157e3e9278e32aba3e', 2);

-- SOL -
with cte as(
SELECT from_user, 
count(1) total_emails  
FROM google_gmail_emails
group by from_user)
select from_user, total_emails, 
Row_number() over(order by total_emails desc, from_user asc)
from cte;

/*
https://platform.stratascratch.com/coding/10322-finding-user-purchases?code_type=1

Identify returning active users by finding users who made a second purchase within 7 days of any previous purchase. 
Output a list of these user_ids.
*/
-- Create the sales table
CREATE TABLE amazon_transactions (
    id INT PRIMARY KEY,
    user_id INT,
    item VARCHAR(255),
    created_at DATE,
    revenue DECIMAL(10, 2) -- Use DECIMAL for currency
);

-- Insert statements
INSERT INTO amazon_transactions (id, user_id, item, created_at, revenue) VALUES
(1, 109, 'milk', '2020-03-03', 123.00),
(2, 139, 'biscuit', '2020-03-18', 421.00),
(3, 108, 'banana', '2020-03-18', 86.00),
(4, 139, 'bread', '2020-03-30', 929.00),
(5, 109, 'bread', '2020-03-22', 432.00),
(6, 109, 'bread', '2020-03-02', 362.00);

-- SOL-

with cte as (
select user_id, 
created_at, 
lag(created_at) over(partition by user_id order by created_at) prev_date 
from amazon_transactions 
)
select distinct user_id from cte 
where (created_at - prev_date)<=7;

/*
https://platform.stratascratch.com/coding/10318-new-products?code_type=1

Calculate the net change in the number of products launched by companies in 2020 compared to 2019.
Your output should include the company names and the net difference.
(Net difference = Number of products launched in 2020 - The number launched in 2019.)
*/

-- Create the car_models table
CREATE TABLE car_launches (
    year INT,
    company_name VARCHAR(255),
    product_name VARCHAR(255)
);

-- Insert statements
INSERT INTO car_launches (year, company_name, product_name) VALUES
(2019, 'Toyota', 'Avalon'),
(2019, 'Toyota', 'Camry'),
(2020, 'Toyota', 'Corolla'),
(2019, 'Honda', 'Accord'),
(2019, 'Honda', 'Passport'),
(2019, 'Honda', 'CR-V'),
(2020, 'Honda', 'Pilot'),
(2019, 'Honda', 'Civic'),
(2020, 'Chevrolet', 'Trailblazer'),
(2020, 'Chevrolet', 'Trax'),
(2019, 'Chevrolet', 'Traverse'),
(2020, 'Chevrolet', 'Blazer'),
(2019, 'Ford', 'Figo'),
(2020, 'Ford', 'Aspire'),
(2019, 'Ford', 'Endeavour'),
(2020, 'Jeep', 'Wrangler'),
(2020, 'Jeep', 'Cherokee'),
(2020, 'Jeep', 'Compass'),
(2019, 'Jeep', 'Renegade'),
(2019, 'Jeep', 'Gladiator');

-- Select statement to view the table
with cte as (
SELECT year, company_name, count(1) no_of_product FROM car_launches 
group by year, company_name),
past_purches as (
select *, lag(no_of_product) over(partition by company_name order by year) past_year_purches from cte)
select company_name, (no_of_product - past_year_purches) net_difference from past_purches
where past_year_purches is not null;

/*
https://platform.stratascratch.com/coding/10304-risky-projects?code_type=1

Identify projects that are overbudget. 
A project is overbudget if the prorated cost of all employees assigned to it exceeds the project’s budget.
To determine this, prorate each employee's annual salary to match the project's duration.
For example, if a project with a six-month duration has a budget of $10,000.
Output a list of overbudget projects with the following details: 
project name, project budget, and prorated total employee expenses (rounded up to the nearest dollar).
Hint: Assume all years have 365 days and disregard leap years.

OP-
"Project4"	15776	18429
"Project6"	41611	44469
*/

CREATE TABLE linkedin_projects (
    id BIGINT PRIMARY KEY,
    title TEXT NOT NULL,
    budget BIGINT,
    start_date DATE,
    end_date DATE
);
INSERT INTO linkedin_projects (id, title, budget, start_date, end_date) VALUES
(1, 'Project1', 29498, '2018-08-31', '2019-03-13'),
(2, 'Project2', 32487, '2018-01-27', '2018-12-13'),
(3, 'Project3', 43909, '2019-11-05', '2019-12-09'),
(4, 'Project4', 15776, '2018-06-28', '2018-11-20'),
(5, 'Project5', 36268, '2019-03-13', '2020-01-02'),
(6, 'Project6', 41611, '2018-09-18', '2019-08-28'),
(7, 'Project7', 34003, '2020-05-28', '2020-10-01'),
(8, 'Project8', 49284, '2019-12-18', '2020-04-18'),
(9, 'Project9', 32341, '2018-05-24', '2019-05-11'),
(10, 'Project10', 47587, '2018-06-24', '2018-11-19'),
(11, 'Project11', 11705, '2020-03-06', '2020-11-03');

CREATE TABLE linkedin_emp_projects (
    emp_id BIGINT,
    project_id BIGINT
 
);
INSERT INTO linkedin_emp_projects (emp_id, project_id) VALUES
(10592, 1),
(10593, 2),
(10594, 3),
(10595, 4),
(10596, 5),
(10597, 6),
(10598, 7),
(10599, 8),
(10600, 9),
(10601, 10),
(10602, 11),
(10642, 1),
(10643, 2),
(10644, 3),
(10645, 4),
(10646, 5),
(10647, 6),
(10648, 7),
(10649, 8),
(10650, 9),
(10651, 10),
(10652, 11);
CREATE TABLE linkedin_employees (
    id BIGINT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    salary BIGINT
);

INSERT INTO linkedin_employees (id, first_name, last_name, salary) VALUES
(10592, 'Jennifer', 'Roberts', 20204),
(10593, 'Haley', 'Ho', 33154),
(10594, 'Eric', 'Mccarthy', 32360),
(10595, 'Gina', 'Martinez', 46388),
(10596, 'Jason', 'Fields', 12348),
(10597, 'Joseph', 'Hernandez', 47183),
(10598, 'Catherine', 'Mccarthy', 37423),
(10599, 'Kelsey', 'Miles', 34488),
(10600, 'Scott', 'Lopez', 24444),
(10601, 'Gina', 'Miller', 36866),
(10602, 'Nicole', 'Jenkins', 14327);

-- get project duration
with project_duration as (
select *, end_date-start_date as project_duration  from linkedin_projects
),
--get employee prorated cost for project duration
employee_cost as (
select pd.id as project_id, le.id as emp_id, le.salary,  
(le.salary/365.0) * pd.project_duration as prorated_cost 
from linkedin_employees le
inner join linkedin_emp_projects lep
on le.id = lep.emp_id
inner join project_duration pd
on lep.project_id = pd.id
),
-- get total project cost 
total_project_cost as (
select project_id, sum(prorated_cost)  toatal_prorated_cost from employee_cost
group by project_id
)
select pd.title, 
pd.budget, 
CEIL(tpc.toatal_prorated_cost) as prorated_employee_expense --rounded up to the nearest 
from total_project_cost tpc
inner join project_duration pd 
on tpc.project_id = pd.id
where tpc.toatal_prorated_cost>pd.budget
order by title

/*
https://platform.stratascratch.com/coding/10284-popularity-percentage?code_type=1

Find the popularity percentage for each user on Meta/Facebook. 
The dataset contains two columns, user1 and user2, which represent pairs of friends. 
Each row indicates a mutual friendship between user1 and user2, meaning both users are friends with each other.
A user's popularity percentage is calculated as the total number of friends they have 
(counting connections from both user1 and user2 columns) divided by the total number of unique users 
on the platform. Multiply this value by 100 to express it as a percentage.


Output each user along with their calculated popularity percentage. 
The results should be ordered by user ID in ascending order.
*/
CREATE TABLE facebook_friends (
    user1 BIGINT,
    user2 BIGINT
);
INSERT INTO facebook_friends (user1, user2) VALUES
(2, 1),
(1, 3),
(4, 1),
(1, 5),
(1, 6),
(2, 6),
(7, 2),
(8, 3),
(3, 9);

with cte as(
select  user1, user2 from facebook_friends 
union 
select  user2, user1 from facebook_friends ),
cte_count as (
select 
user1, 
count( user1) over() as total_unique_user, 
count(1) as total_friend from cte 
group by user1
)
select user1,
Round((total_friend*1.0/total_unique_user) * 100,2) popularity_percent 
from cte_count
order by user1
/*
https://platform.stratascratch.com/coding/10296-facebook-accounts?code_type=1
Calculate the ratio of accounts closed on January 10th, 2020 using the fb_account_status table.
*/

CREATE TABLE fb_account_status (
    acc_id BIGINT,
    date DATE,
    status TEXT
	
);

INSERT INTO fb_account_status (acc_id, date, status) VALUES
(3, '2019-12-23', 'closed'),
(4, '2020-01-10', 'open'),
(5, '2020-01-10', 'open'),
(6, '2020-01-10', 'open'),
(7, '2020-01-10', 'closed'),
(8, '2020-01-10', 'closed'),
(9, '2020-01-11', 'closed'),
(10, '2019-12-28', 'closed'),
(11, '2020-01-15', 'open');

with cte as (
select
ROUND(sum(case when status = 'closed' then 1 else 0 end)*1.0/  count(distinct acc_id),2) as closed_ratio
  from fb_account_status where date = '2020-01-10'
)
select * from cte
/*
https://platform.stratascratch.com/coding/10288-clicked-vs-non-clicked-search-results?code_type=1

The question asks you to calculate two percentages based on search results. 
First, find the percentage of all search records clicked (clicked = 1) and in the top 3 positions.
Second, find the percentage of all search records that were not clicked (clicked = 0) but in the top 3 positions. 
Both percentages are calculated with respect to the total number of search records and should be output 
in the same row as two columns.

*/

CREATE TABLE fb_search_events (
    search_id BIGINT,
    search_term TEXT,
    clicked INT,
    search_results_position INT
);

INSERT INTO fb_search_events (search_id, search_term, clicked, search_results_position) VALUES
(1, 'rabbit', 1, 1),
(2, 'airline', 1, 2),
(2, 'quality', 1, 3),
(3, 'hotel', 0, 1),
(3, 'scandal', 0, 3),
(5, 'rabbit', 1, 1),
(6, 'politics', 1, 2),
(10, 'rabbit', 0, 3);

-- SOL-1
select ROUND((sum(case when clicked=1 then 1 else 0 end)*1.0/ (select count(*) from fb_search_events))*100 ,2) as top_3_clicked  ,  
 ROUND((sum(case when clicked=0 then 1 else 0 end)*1.0/ (select count(*) from fb_search_events))*100,2) as top_3_notclicked from fb_search_events
where search_results_position<=3

-- SOL-2
with total_row_cte as (
select clicked,
search_results_position,
count(search_id) over() as total
from fb_search_events
)
select 
 ROUND((sum(case when clicked=1 then 1 else 0 end)*1.0/ max(total))*100 ,2) as top_3_clicked  ,  
 ROUND((sum(case when clicked=0 then 1 else 0 end)*1.0/ max(total))*100,2) as top_3_notclicked  
 from total_row_cte
 where search_results_position<=3
 
/*
https://platform.stratascratch.com/coding/10285-acceptance-rate-by-date?code_type=1

Calculate the friend acceptance rate for each date when friend requests were sent.
A request is sent if action = sent and accepted if action = accepted. If a request is not accepted, 
there is no record of it being accepted in the table. 
The output will only include dates where requests were sent and at least one of them was accepted, 
as the acceptance rate can only be calculated for those dates. 
Show the results ordered from the earliest to the latest date.
*/

drop table if exists fb_friend_requests;
CREATE TABLE fb_friend_requests (
    user_id_sender TEXT,
    user_id_receiver TEXT,
    date DATE,
    action TEXT
);
INSERT INTO fb_friend_requests (user_id_sender, user_id_receiver, date, action) VALUES
('ad4943sdz', '948ksx123d', '2020-01-04', 'sent'),
('ad4943sdz', '948ksx123d', '2020-01-06', 'accepted'),
('dfdfxf9483', '9djjjd9283', '2020-01-04', 'sent'),
('dfdfxf9483', '9djjjd9283', '2020-01-15', 'accepted'),
('ffdfff4234234', 'lpjzjdi4949', '2020-01-06', 'sent'),
('fffkfld9499', '993lsldidif', '2020-01-06', 'sent'),
('fffkfld9499', '993lsldidif', '2020-01-10', 'accepted'),
('fg503kdsdd', 'ofp049dkd', '2020-01-04', 'sent'),
('fg503kdsdd', 'ofp049dkd', '2020-01-10', 'accepted'),
('hh643dfert', '847jfkf203', '2020-01-04', 'sent'),
('r4gfgf2344', '234ddr4545', '2020-01-06', 'sent'),
('r4gfgf2344', '234ddr4545', '2020-01-11', 'accepted');

with total_sent_req as (
select date, 
count(*) total
from fb_friend_requests
where action='sent'
group by date 
),
next_action_status as (
select *, lead(action) over(partition by user_id_sender )
from fb_friend_requests
)
select n.date,
ROUND(sum(case when action='sent' and lead='accepted' then 1 else 0 end)*1.0/max(total),2) percentage_acceptance  
from next_action_status n
join total_sent_req t
on n.date=t.date
group by n.date 

/*
https://platform.stratascratch.com/coding/514-marketing-campaign-success-advanced?code_type=1

You have a table of in-app purchases by user. Users that make their first in-app purchase are placed 
in a marketing campaign where they see call-to-actions for more in-app purchases. 
Find the number of users that made additional in-app purchases due to the success of the marketing campaign.

The marketing campaign doesn't start until one day after the initial in-app purchase so users
that only made one or multiple purchases on the first day do not count, 
nor do we count users that over time purchase only the products they purchased on the first day.
*/


CREATE TABLE marketing_campaign (
    user_id INT,
    created_at DATE,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2)
);

INSERT INTO marketing_campaign (user_id, created_at, product_id, quantity, price) VALUES
(10, '2019-01-01', 101, 3, 55.00),
(10, '2019-01-02', 119, 5, 29.00),
(10, '2019-03-31', 111, 2, 149.00),
(11, '2019-01-02', 105, 3, 234.00),
(11, '2019-03-31', 120, 3, 99.00),
(12, '2019-01-02', 112, 2, 200.00);


SELECT * FROM marketing_campaign;

/*
https://platform.stratascratch.com/coding/2005-share-of-active-users?code_type=1

Output share of US users that are active. Active users are the ones with an "open" status in the table.

*/
-- Create the users table
CREATE TABLE fb_active_users (
    user_id INT PRIMARY KEY,
    name VARCHAR(255),
    status VARCHAR(255), -- Or ENUM if you have a fixed set of statuses
    country VARCHAR(255)
);

-- Insert statements
INSERT INTO fb_active_users (user_id, name, status, country) VALUES
(33, 'Amanda Leon', 'open', 'Australia'),
(27, 'Jessica Farrell', 'open', 'Luxembourg'),
(18, 'Wanda Ramirez', 'open', 'USA'),
(50, 'Samuel Miller', 'closed', 'Brazil');

--SOL-
select 
Round(sum(case when status = 'open' then 1 else 0 end)*1.0/count(*), 1)  as active_users_share 
from fb_active_users

/*
https://platform.stratascratch.com/coding/2053-retention-rate?code_type=1

Find the monthly retention rate of users for each account separately for Dec 2020 and Jan 2021. Retention rate is the percentage of active users an account retains over a given period of time. In this case, assume the user is retained if he/she stays with the app in any future months. For example, if a user was active in Dec 2020 and has activity in any future month, consider them retained for Dec. You can assume all accounts are present in Dec 2020 and Jan 2021. Your output should have the account ID and the Jan 2021 retention rate divided by Dec 2020 retention rate. Hint: In Oracle you should use "date" when referring to date column (reserved keyword).
*/


CREATE TABLE sf_events (
    date DATE,
    account_id VARCHAR(255),
    user_id VARCHAR(255)
);

-- Insert statements
INSERT INTO sf_events (date, account_id, user_id) VALUES
('2021-01-01', 'A1', 'U1'),
('2021-01-01', 'A1', 'U2'),
('2021-01-06', 'A1', 'U3'),
('2021-01-02', 'A1', 'U1'),
('2020-12-24', 'A1', 'U2'),
('2020-12-08', 'A1', 'U1'),
('2020-12-09', 'A1', 'U1'),
('2021-01-10', 'A2', 'U4'),
('2021-01-11', 'A2', 'U4'),
('2021-01-12', 'A2', 'U4'),
('2021-01-15', 'A2', 'U5'),
('2020-12-17', 'A2', 'U4'),
('2020-12-25', 'A3', 'U6'),
('2020-12-25', 'A3', 'U6'), 
('2020-12-25', 'A3', 'U6'), 
('2020-12-06', 'A3', 'U7'),
('2020-12-06', 'A3', 'U6'),
('2021-01-14', 'A3', 'U6'),
('2021-02-07', 'A1', 'U1'),
('2021-02-10', 'A1', 'U2'),
('2021-02-01', 'A2', 'U4'),
('2021-02-01', 'A2', 'U5'),
('2020-12-05', 'A1', 'U8');

--dentifies distinct users active in December 2020.
WITH dec_2020_users AS (
    SELECT DISTINCT account_id, user_id
    FROM sf_events
    WHERE date BETWEEN '2020-12-01' AND '2020-12-31'
),
--Identifies distinct users active in January 2021.
jan_2021_users AS (
    SELECT DISTINCT account_id, user_id
    FROM sf_events
    WHERE date BETWEEN '2021-01-01' AND '2021-01-31'
),
--Identifies users from December 2020 who were active in any future month (after December 2020)
retained_dec_users AS (
    SELECT d.account_id, d.user_id
    FROM dec_2020_users d
    JOIN sf_events s
    ON d.account_id = s.account_id AND d.user_id = s.user_id
    WHERE s.date > '2020-12-31'
),
--Identifies users from January 2021 who were active in any future month (after January 2021).
retained_jan_users AS (
    SELECT j.account_id, j.user_id
    FROM jan_2021_users j
    JOIN sf_events s
    ON j.account_id = s.account_id AND j.user_id = s.user_id
    WHERE s.date > '2021-01-31'
),
--Calculates the retention rate for December 2020 by dividing the number of retained users by the total number of active users in December 2020
dec_retention_rate AS (
    SELECT d.account_id, 
       COUNT(DISTINCT r.user_id) * 1.0 / COUNT(DISTINCT d.user_id) AS retention_rate
    FROM dec_2020_users d
    LEFT JOIN retained_dec_users r
    ON d.account_id = r.account_id AND d.user_id = r.user_id
    GROUP BY d.account_id
),
--Calculates the retention rate for January 2021 by dividing the number of retained users by the total number of active users in January 2021.
jan_retention_rate AS (
    SELECT j.account_id, 
      COUNT(DISTINCT r.user_id) * 1.0 / COUNT(DISTINCT j.user_id) AS retention_rate
    FROM jan_2021_users j
    LEFT JOIN retained_jan_users r
    ON j.account_id = r.account_id AND j.user_id = r.user_id
    GROUP BY j.account_id
)
--Computes the ratio of the January 2021 retention rate to the December 2020 retention rate for each account.
SELECT d.account_id, 
   ROUND(j.retention_rate / d.retention_rate) AS retention_rate_ratio
FROM dec_retention_rate d
JOIN jan_retention_rate j
ON d.account_id = j.account_id;

/*
https://platform.stratascratch.com/coding/2104-user-with-most-approved-flags?code_type=1

Which user flagged the most distinct videos that ended up approved by YouTube? Output, in one column, their full name or names in case of a tie. In the user's full name, include a space between the first and the last name.
*/


CREATE TABLE user_flags (
    user_firstname VARCHAR(255),
    user_lastname VARCHAR(255),
    video_id VARCHAR(255),
    flag_id VARCHAR(255)
);

-- Insert statements
INSERT INTO user_flags (user_firstname, user_lastname, video_id, flag_id) VALUES
('Richard', 'Hasson', 'y6120QOlsfU', '0cazx3'),
('Mark', 'May', 'Ct6BUPvE2sM', '1cn76u'),
('Gina', 'Korman', 'dQw4w9WgXcQ', '1i43zk'),
('Mark', 'May', 'Ct6BUPvE2sM', '1n0vef'),
('Mark', 'May', 'jNQXAC9IVRw', '1sv6ib'),
('Gina', 'Korman', 'dQw4w9WgXcQ', '20xekb'),
('Mark', 'May', '5qap5aO4i9A', '4cvwuv');

-- SOL- 
with user_no_of_flag as (
select CONCAT(user_firstname, ' ', user_lastname) username, count(distinct video_id) as no_of_flag from user_flags 
where flag_id is not null
group by CONCAT(user_firstname, ' ', user_lastname) ),
user_ranking as(
select username, 
dense_rank() over(order by no_of_flag desc) rnk from user_no_of_flag)

select username from user_ranking where rnk=1 order by username;

/*

https://platform.stratascratch.com/coding/2099-election-results?code_type=1

The election is conducted in a city and everyone can vote for one or more candidates, or choose not to vote at all. Each person has 1 vote so if they vote for multiple candidates, their vote gets equally split across these candidates. For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 vote each.
Find out who got the most votes and won the election. Output the name of the candidate or multiple names in case of a tie. To avoid issues with a floating-point error you can round the number of votes received by a candidate to 3 decimal places.
*/

CREATE TABLE voting_results (
    voter VARCHAR(255),
    candidate VARCHAR(255)
);

-- Insert statements
INSERT INTO voting_results (voter, candidate) VALUES
('Kathy', 'Charles'),
('Ryan', 'Charles'),
('Christine', 'Charles'),
('Kathy', 'Benjamin'),
('Christine', 'Anthony'),
('Paul', 'Anthony'),
('Anthony', 'Edward'),
('Ryan', 'Charles');

-- Select statement to view the table
with get_voter_split as(
SELECT voter, 
1*1.0/count(1) as no_of_votes FROM voting_results where candidate is not null  group by 1),
candidate_vote_count as (
select candidate,
sum(no_of_votes) total_votes from voting_results vr 
inner join 
get_voter_split vs
on
vr.voter=vs.voter
group by vr.candidate
)
select candidate from candidate_vote_count order by total_votes desc limit 1

/*
https://platform.stratascratch.com/coding/2102-flags-per-video?code_type=1

For each video, find how many unique users flagged it. A unique user can be identified using the combination of their first name and last name. Do not consider rows in which there is no flag ID.
*/


CREATE TABLE user_flags (
    user_firstname VARCHAR(255),
    user_lastname VARCHAR(255),
    video_id VARCHAR(255),
    flag_id VARCHAR(255),
    PRIMARY KEY (user_firstname, user_lastname, video_id, flag_id)
);

-- Insert statements
INSERT INTO user_flags (user_firstname, user_lastname, video_id, flag_id) VALUES
('Richard', 'Hasson', 'y6120QOlsfU', '0cazx3'),
('Mark', 'May', 'Ct6BUPvE2sM', '1cn76u'),
('Gina', 'Korman', 'dQw4w9WgXcQ', '1i43zk'),
('Mark', 'May', 'Ct6BUPvE2sM', '1n0vef'),
('Mark', 'May', 'jNQXAC9IVRw', '1sv6ib'),
('Gina', 'Korman', 'dQw4w9WgXcQ', '20xekb'),
('Mark', 'May', '5qap5aO4i9A', '4cvwuv');

-- Select statement to view the table
SELECT video_id, count (distinct CONCAT(user_firstname,' ',  user_lastname))  num_unique_users FROM user_flags where flag_id is not null
group by  video_id

/*
https://platform.stratascratch.com/coding/9610-find-students-with-a-median-writing-score?code_type=1

Identify the IDs of students who scored exactly at the median for the SAT writing section.
*/

CREATE TABLE sat_scores (
    school VARCHAR(255),
    teacher VARCHAR(255),
    student_id INT,
    sat_writing INT,
    sat_verbal INT,
    sat_math INT,
    hrs_studied INT,
    id INT,
    average_sat INT,
    love VARCHAR(255)
);

-- Insert statements
INSERT INTO sat_scores (school, teacher, student_id, sat_writing, sat_verbal, sat_math, hrs_studied, id, average_sat, love) VALUES
('Washington HS', 'Frederickson', 1, 583, 307, 528, 190, 1, 583, NULL),
('Washington HS', 'Frederickson', 2, 401, 791, 248, 149, 2, 401, NULL),
('Washington HS', 'Frederickson', 3, 523, 445, 756, 166, 3, 523, NULL),
('Washington HS', 'Frederickson', 4, 306, 269, 327, 137, 4, 306, NULL),
('Washington HS', 'Frederickson', 5, 300, 539, 743, 115, 5, 300, NULL),
('Washington HS', 'Frederickson', 6, 213, 500, 771, 173, 6, 213, NULL),
('Washington HS', 'Frederickson', 7, 548, 683, 740, 47, 7, 548, NULL),
('Washington HS', 'Frederickson', 8, 314, 503, 341, 174, 8, 314, NULL),
('Washington HS', 'Frederickson', 9, 401, 630, 666, 111, 9, 401, NULL);

with cte as(
SELECT student_id, sat_writing, row_number() over(order by sat_writing) rn,
count(*) over() total_rows FROM sat_scores 
)
SELECT student_id from cte where sat_writing =(
select avg(sat_writing) from cte
where rn in (
(total_rows+1)/2,
(total_rows+1)/2
)) order by student_id

/*
https://platform.stratascratch.com/coding/9650-find-the-top-10-ranked-songs-in-2010?code_type=1

What were the top 5 ranked songs in 2010?
Output the rank, group name, and song name but do not show the same song twice.
Sort the result based on the year_rank in ascending order.
*/


CREATE TABLE billboard_top_100_year_end (
    year INT,
    year_rank INT,
    group_name VARCHAR(255),
    artist VARCHAR(255),
    song_name VARCHAR(255),
    id INT PRIMARY KEY -- Assuming 'id' is the unique identifier for each song
);

-- Insert statements
INSERT INTO billboard_top_100_year_end (year, year_rank, group_name, artist, song_name, id) VALUES
(2010, 1, 'Ke$ha', 'Ke$ha', 'TiK ToK', 5909),
(2010, 2, 'Lady Antebellum', 'Lady Antebellum', 'Need You Now', 5910),
(2010, 3, 'Train', 'Train', 'Hey, Soul Sister', 5911),
(2010, 4, 'Katy Perry feat. Snoop Dogg', 'Katy Perry', 'California Gurls', 5912),
(2010, 4, 'Katy Perry feat. Snoop Dogg', 'Snoop Dogg', 'California Gurls', 5913),
(2010, 5, 'Usher feat. will.i.am', 'Usher', 'OMG', 5914),
(2010, 5, 'Usher feat. will.i.am', 'will.i.am', 'OMG', 5915),
(2010, 6, 'B.o.B feat. Hayley Williams', 'B.o.B', 'Airplanes', 5916),
(2010, 6, 'B.o.B feat. Hayley Williams', 'Hayley Williams', 'Airplanes', 5917),
(2010, 7, 'Eminem feat. Rihanna', 'Eminem', 'Love The Way You Lie', 5918),
(2010, 7, 'Eminem feat. Rihanna', 'Rihanna', 'Love The Way You Lie', 5919);

-- SOL- 
with cte as(
select  dense_rank() over(order by year_rank) rank , group_name, song_name 
from billboard_top_100_year_end
where year=2010)
select distinct * from cte  order by rank limit 5 

/*
https://platform.stratascratch.com/coding/9782-customer-revenue-in-march?code_type=1

Calculate the total revenue from each customer in March 2019. Include only customers who were active in March 2019.
Output the revenue along with the customer id and sort the results based on the revenue in descending order.
*/

CREATE TABLE customer_orders (
    id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_details VARCHAR(255),
    total_order_cost DECIMAL(10, 2)
);

-- Insert statements
INSERT INTO customer_orders (id, cust_id, order_date, order_details, total_order_cost) VALUES
(1, 3, '2019-03-04', 'Coat', 100.00),
(2, 3, '2019-03-01', 'Shoes', 80.00),
(3, 3, '2019-03-07', 'Skirt', 30.00),
(4, 7, '2019-02-01', 'Coat', 25.00),
(5, 7, '2019-03-10', 'Shoes', 80.00),
(6, 15, '2019-02-01', 'Boats', 100.00),
(7, 15, '2019-01-11', 'Shirts', 60.00),
(8, 15, '2019-03-11', 'Slipper', 20.00),
(9, 15, '2019-03-01', 'Jeans', 80.00),
(10, 15, '2019-03-09', 'Shirts', 50.00);

-- Select statement to view the table
with cte as (
SELECT cust_id, sum(total_order_cost) total_revenue FROM customer_orders
where to_char(order_date, 'yyyy-MM') = '2019-03'
group by cust_id)

select * from cte order by total_revenue desc

/*
 write a sql query to find for each month and country, the number of transactions and their total amount, the number of approved transations and their total amount.
*/

drop table transactions;
create table if not exists transactions (
id int primary key,
country varchar(15),
state varchar(15),
amount int,
trans_date date
);

insert into transactions values(1,'US','approved',1000,'2023-12-18');
insert into transactions values(2,'US','declined',2000,'2023-12-19');
insert into transactions values(3,'US','approved',2000,'2024-01-01');
insert into transactions values(4,'India','approved',2000,'2023-01-07');

with cte as(
select *, to_char(trans_date, 'yyyy-MM') date_month from transactions
)
select country, date_month, count(*) transaction_count,
sum(amount) trnas_total_amount,
sum(case when state='approved' then 1 end ) approved_count,
sum(case when state='approved' then amount end ) approved_amount
from cte group by country, date_month


/*
https://platform.stratascratch.com/coding/9897-highest-salary-in-department?code_type=1

Find the employee with the highest salary per department.
Output the department name, employee's first name along with the corresponding salary.
*/

CREATE TABLE employee (
  id INT PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  age INT,
  sex CHAR(1),
  employee_title VARCHAR(255),
  department VARCHAR(255),
  salary DECIMAL(10, 2),
  target DECIMAL(10, 2),
  bonus DECIMAL(10, 2),
  email VARCHAR(255),
  city VARCHAR(255),
  address VARCHAR(255),
  manager_id INT
);

-- Insert the first employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (1, 'Richerd', 'Gear', 57, 'M', 'Manager', 'Management', 250000.00, 0.00, 300.00, 'Richerd@company.com', 'Alabama', NULL, NULL); 

-- Insert the second employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (5, 'Max', 'George', 26, 'M', 'Sales', 'Sales', 1300.00, 200.00, 150.00, 'Max@company.com', 'California', '2638 Richards Avenue', 1); 

-- Insert the third employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (10, 'Jennifer', 'Dion', 34, 'F', 'Sales', 'Sales', 1000.00, 200.00, 150.00, 'Jennifer@company.com', 'Alabama', NULL, 1); 

-- Insert the fourth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (11, 'Katty', 'Bond', 56, 'F', 'Manager', 'Management', 150000.00, 0.00, 300.00, 'Katty@company.com', 'Arizona', NULL, NULL); 

-- Insert the fifth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (13, 'George', 'Joe', 50, 'M', 'Manager', 'Management', 100000.00, 0.00, 300.00, 'George@company.com', 'Florida', '1003 Wyatt Street', NULL); 

-- Insert the sixth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (18, 'Laila', 'Mark', 26, 'F', 'Sales', 'Sales', 1000.00, 200.00, 150.00, 'Laila@company.com', 'Florida', '3655 Spirit Drive', 13); 

-- Insert the seventh employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (19, 'Suzan', 'Lee', 34, 'F', 'Sales', 'Sales', 1300.00, 200.00, 150.00, 'Suzan@company.com', 'Florida', '1275 Monroe Avenue', 13); 

-- Insert the eighth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (20, 'Sarrah', 'Bicky', 31, 'F', 'Senior Sales', 'Sales', 2000.00, 200.00, 150.00, 'Sarrah@company.com', 'Florida', '1176 Tyler Avenue', 19); 

-- Insert the ninth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (21, 'Suzan', 'Lee', 34, 'F', 'Sales', 'Sales', 1300.00, 200.00, 150.00, 'Suzan@company.com', 'Florida', '1275 Monroe Avenue', 19); 

-- Insert the tenth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (22, 'Mandy', 'John', 31, 'F', 'Sales', 'Sales', 1300.00, 200.00, 150.00, 'Mandy@company.com', 'Florida', '2510 Maryland Avenue', 19); 

-- Insert the eleventh employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (23, 'Britney', 'Berry', 45, 'F', 'Sales', 'Sales', 1200.00, 200.00, 100.00, 'Britney@company.com', 'Florida', '3946 Steve Hunt Road', 19); 

-- Insert the twelfth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (25, 'Jack', 'Mick', 29, 'M', 'Sales', 'Sales', 1300.00, 200.00, 100.00, 'Jack@company.com', 'Hawaii', '3762 Stratford Drive', 19); 

-- Insert the thirteenth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (26, 'Ben', 'Ten', 43, 'M', 'Sales', 'Sales', 1300.00, 150.00, 100.00, 'Ben@company.com', 'Hawaii', '3055 Indiana Avenue', 19); 

-- Insert the fourteenth employee
INSERT INTO Employee (id, first_name, last_name, age, sex, employee_title, department, salary, target, bonus, email, city, address, manager_id)
VALUES (27, 'Tom', 'Fridy', 32, 'M', 'Sales', 'Sales', 1200.00, 200.00, 150.00, 'Tom@company.com', 'Hawaii', '801 Stratford Drive', 19);

with cte as(
select department, first_name, salary, dense_rank() over(partition by department order by salary desc) rnk from employee )
select department, first_name, salary from cte where rnk = 1;
