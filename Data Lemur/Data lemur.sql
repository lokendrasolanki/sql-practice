/**

order_id, location, tmestamp.         
123, Del, 2024-12-01 01:00 PM      
123, Del, 2024-12-02 03:00 PM      
123, BLR, 2024-12-03 01:00 AM      
123, Mum, 2024-12-04 06:00 PM
123, Del, 2024-12-05 01:00 PM     
123, Del, 2024-12-06 01:00 PM   
123, BLR, 2024-12-07 01:00 PM
123, BLR, 2024-12-08 01:00 PM
123, Guj, 2024-12-10 12:00 PM

and it's O/P

123 Del 2024-12-02 03:00 PM
123 BLR 2024-12-03 01:00 AM
123 Mum 2024-12-04 06:00 PM
123 Del 2024-12-06 01:00 PM
123 BLR 2024-12-08 01:00 PM
123 Guj 2024-12-10 12:00 PM

*/
-- Create the table
CREATE TABLE order_location (
    order_id INT,
    location VARCHAR(50),
    timestamp TIMESTAMP
);

-- Insert the sample data
INSERT INTO order_location (order_id, location, timestamp) VALUES
(123, 'Del', '2024-12-01 13:00:00'),
(123, 'Del', '2024-12-02 15:00:00'),
(123, 'BLR', '2024-12-03 01:00:00'),
(123, 'Mum', '2024-12-04 18:00:00'),
(123, 'Del', '2024-12-05 13:00:00'),
(123, 'Del', '2024-12-06 13:00:00'),
(123, 'BLR', '2024-12-07 13:00:00'),
(123, 'BLR', '2024-12-08 13:00:00'),
(123, 'Guj', '2024-12-10 12:00:00');

WITH OrderedData AS (
    SELECT
        order_id,
        location,
        timestamp,
        LEAD(location) OVER (Partition by order_id ORDER BY timestamp) AS next_location
    FROM
        order_location
)
SELECT
    order_id,
    location,
    timestamp
FROM
    OrderedData
WHERE
    location != next_location OR
    next_location IS NULL;


/*
*/


-- Create the messages table
CREATE TABLE messages (
    message_id INT PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    content TEXT,
    sent_date TIMESTAMP
);

-- Insert the data
INSERT INTO messages (message_id, sender_id, receiver_id, content, sent_date) VALUES
(901, 3601, 4500, 'You up?', '2022-08-03 16:43:00'),
(743, 3601, 8752, 'Let''s take this offline', '2022-06-14 14:30:00'),
(888, 3601, 7855, 'DataLemur has awesome user base!', '2022-08-12 08:45:00'),
(1002, 2520, 6987, 'Send this out now!', '2021-08-16 00:35:00'),
(898, 2520, 9630, 'Are you ready for your upcoming presentation?', '2022-08-13 14:35:00'),
(990, 2520, 8520, 'Maybe it was done by the automation process.', '2022-08-19 06:30:00'),
(819, 2310, 4500, 'What''s the status on this?', '2022-07-10 15:55:00'),
(922, 3601, 4500, 'Get on the call', '2022-08-10 17:03:00'),
(942, 2520, 3561, 'How much do you know about Data Science?', '2022-08-17 13:44:00'),
(966, 3601, 7852, 'Meet me in five!', '2022-08-17 02:20:00'),
(902, 4500, 3601, 'Only if you''re buying', '2022-08-03 06:50:00');


select * from messages;
SELECT 
    sender_id, 
    COUNT(message_id) AS message_count
FROM 
    messages
WHERE 
    sent_date >= '2022-08-01' 
    AND sent_date < '2022-09-01'
GROUP BY 
    sender_id
ORDER BY 
    message_count DESC
LIMIT 2;


--- get monthly active user

drop table user_actions
CREATE TABLE user_actions (
    user_id INT,
    event_id INT,
    event_type VARCHAR(20),
    event_date TIMESTAMP
);

INSERT INTO user_actions (user_id, event_id, event_type, event_date) VALUES
(445, 7765, 'sign-in', '2022-05-31 12:00:00'),
(445, 3634, 'like', '2022-06-05 12:00:00'),
(648, 3124, 'like', '2022-06-18 12:00:00'),
(648, 2725, 'sign-in', '2022-06-22 12:00:00'),
(648, 8568, 'comment', '2022-07-03 12:00:00'),
(445, 4363, 'sign-in', '2022-07-05 12:00:00'),
(445, 2425, 'like', '2022-07-06 12:00:00'),
(445, 2484, 'like', '2022-07-22 12:00:00'),
(648, 1423, 'sign-in', '2022-07-26 12:00:00'),
(445, 5235, 'comment', '2022-07-29 12:00:00'),
(742, 6458, 'sign-in', '2022-07-03 12:00:00'),
(742, 1374, 'comment', '2022-07-19 12:00:00');


with cte1 as(
select *, 
date_part('month', event_date) as months 
from user_actions
)
select months as month , count(distinct user_id)  monthly_active_users from cte1
where  months=7 and user_id in (select user_id from cte1 where months!=7)
group by months





---------------------

CREATE TABLE tweets (
    user_id INTEGER,
    tweet_date TIMESTAMP,
    tweet_count INTEGER
);

INSERT INTO tweets (user_id, tweet_date, tweet_count) VALUES
(111, '2022-06-01 00:00:00', 2),
(111, '2022-06-02 00:00:00', 1),
(111, '2022-06-03 00:00:00', 3),
(111, '2022-06-04 00:00:00', 4),
(111, '2022-06-05 00:00:00', 5),
(111, '2022-06-06 00:00:00', 4),
(111, '2022-06-07 00:00:00', 6),
(199, '2022-06-01 00:00:00', 7),
(199, '2022-06-02 00:00:00', 5),
(199, '2022-06-03 00:00:00', 9),
(199, '2022-06-04 00:00:00', 1),
(199, '2022-06-05 00:00:00', 8),
(199, '2022-06-06 00:00:00', 2),
(199, '2022-06-07 00:00:00', 2),
(254, '2022-06-01 00:00:00', 1),
(254, '2022-06-02 00:00:00', 1),
(254, '2022-06-03 00:00:00', 2),
(254, '2022-06-04 00:00:00', 1),
(254, '2022-06-05 00:00:00', 3),
(254, '2022-06-06 00:00:00', 1),
(254, '2022-06-07 00:00:00', 3);

with calculate_running_sum as (
select *, 
sum(tweet_count) over(partition by user_id order by tweet_date rows between 2 preceding and current row) running_sum ,
row_number() over(partition by user_id) rn
from tweets),
calculate_divident as (
select *, case when rn<3 then rn else 3 end divident from calculate_running_sum
)
select user_id, tweet_date, round(running_sum*1.0/divident,2) rolling_avg_3d from calculate_divident

-------

/*
Data Lumer - https://datalemur.com/questions/sql-highest-grossing
*/
CREATE TABLE product_spend (
    category TEXT,
    product TEXT,
    user_id INTEGER,
    spend NUMERIC,
    transaction_date TIMESTAMP
);

INSERT INTO product_spend (category, product, user_id, spend, transaction_date) VALUES
('appliance', 'washing machine', 123, 219.80, '2022-03-02 11:00:00'),
('electronics', 'vacuum', 178, 152.00, '2022-04-05 10:00:00'),
('electronics', 'wireless headset', 156, 249.90, '2022-07-08 10:00:00'),
('electronics', 'vacuum', 145, 189.00, '2022-07-15 10:00:00'),
('electronics', 'computer mouse', 195, 45.00, '2022-07-01 11:00:00'),
('appliance', 'refrigerator', 165, 246.00, '2021-12-26 12:00:00'),
('appliance', 'refrigerator', 123, 299.99, '2022-03-02 11:00:00'),
('appliance', 'washing machine', 123, 220.00, '2022-07-27 04:00:00'),
('electronics', 'vacuum', 156, 145.66, '2022-08-10 04:00:00'),
('electronics', 'wireless headset', 145, 198.00, '2022-08-04 04:00:00'),
('electronics', 'wireless headset', 215, 19.99, '2022-09-03 16:00:00'),
('appliance', 'microwave', 169, 49.99, '2022-08-28 16:00:00'),
('appliance', 'microwave', 101, 34.49, '2023-03-01 17:00:00'),
('electronics', '3.5mm headphone jack', 101, 7.99, '2022-10-07 16:00:00'),
('appliance', 'microwave', 101, 64.95, '2023-07-08 16:00:00');

with cte as(
select 
category, product, sum(spend) total_spend
from product_spend
where date_part('year', transaction_date)=2022
group by category, product
order by category),
cte1 as (
select *,
dense_rank() over(partition by category order by total_spend desc) rnk
from cte )
select category, product, total_spend from cte1 where rnk<=2


-----------
/*
https://datalemur.com/questions/top-fans-rank
*/
-- Create the artists table
CREATE TABLE artists (
    artist_id INTEGER PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL,
    label_owner VARCHAR(255)
);

-- Insert data into the artists table
INSERT INTO artists (artist_id, artist_name, label_owner) VALUES
(101, 'Ed Sheeran', 'Warner Music Group'),
(120, 'Drake', 'Warner Music Group'),
(125, 'Bad Bunny', 'Rimas Entertainment');

-- Create the songs table
CREATE TABLE songs (
    song_id INTEGER PRIMARY KEY,
    artist_id INTEGER REFERENCES artists(artist_id), -- Foreign key referencing artists table
    name VARCHAR(255) NOT NULL
);

-- Insert data into the songs table
INSERT INTO songs (song_id, artist_id, name) VALUES
(55511, 101, 'Perfect'),
(45202, 101, 'Shape of You'),
(22222, 120, 'One Dance'),
(19960, 120, 'Hotline Bling');




-- Create the global_song_rank table
CREATE TABLE global_song_rank (
    day INTEGER NOT NULL,
    song_id INTEGER REFERENCES songs(song_id), -- Foreign key referencing songs table
    rank INTEGER NOT NULL,
    PRIMARY KEY (day, song_id) -- Composite primary key
);

-- Insert data into the global_song_rank table
INSERT INTO global_song_rank (day, song_id, rank) VALUES
(1, 45202, 5),
(3, 45202, 2),
(1, 19960, 3),
(9, 19960, 15);


with artist_global_no_songs as(
select a.artist_name,  count(a.artist_name) no_of_global_song  from artists a 
join songs s
on a.artist_id = s.artist_id
join global_song_rank g
on s.song_id = g.song_id
where g.rank<=10
group by a.artist_name
),artist_rank as (
select artist_name, dense_rank() over( order by no_of_global_song desc  ) artist_rank from artist_global_no_songs)
select * from artist_rank
where artist_rank<=5


/*
https://datalemur.com/questions/supercloud-customer
*/

-- Create the customer_contracts table
CREATE TABLE customer_contracts (
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    amount NUMERIC NOT NULL);

-- Insert data into the customer_contracts table
INSERT INTO customer_contracts (customer_id, product_id, amount) VALUES
(1, 1, 1000),
(2, 2, 2000),
(3, 1, 1100),
(4, 1, 1000),
(7, 1, 1000),
(7, 3, 4000),
(6, 4, 2000),
(1, 5, 1500),
(2, 5, 2000),
(4, 5, 2200),
(7, 6, 5000),
(1, 2, 2000);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_category VARCHAR(255),
    product_name VARCHAR(255)
);


-- Insert data into the products table
INSERT INTO products (product_id, product_category, product_name) VALUES
(1, 'Analytics', 'Azure Databricks'),
(2, 'Analytics', 'Azure Stream Analytics'),
(3, 'Containers', 'Azure Kubernetes Service'),
(4, 'Containers', 'Azure Service Fabric'),
(5, 'Compute', 'Virtual Machines'),
(6, 'Compute', 'Azure Functions');

-- SOL-
with cte as
(select cc.customer_id, count(distinct p.product_category) cnt from customer_contracts cc 
Left join
products p on
cc.product_id = p.product_id
group by customer_id
)
select customer_id from cte where cnt=(SELECT COUNT(DISTINCT product_category) FROM products)

/*

https://datalemur.com/questions/signup-confirmation-rate

*/

-- Create the emails table (if it doesn't already exist)
CREATE TABLE IF NOT EXISTS emails (
    email_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    signup_date TIMESTAMP WITHOUT TIME ZONE -- Use TIMESTAMP for date and time
);

-- Insert data into the emails table. Use ISO 8601 format for dates/times.
INSERT INTO emails (email_id, user_id, signup_date) VALUES
(125, 7771, '2022-06-14 00:00:00'),
(236, 6950, '2022-07-01 00:00:00'),
(433, 1052, '2022-07-09 00:00:00');

-- Create the texts table (if it doesn't already exist)
CREATE TABLE IF NOT EXISTS texts (
    text_id INTEGER PRIMARY KEY,
    email_id INTEGER NOT NULL,
    signup_action VARCHAR(255),
    FOREIGN KEY (email_id) REFERENCES emails(email_id) -- Foreign key referencing emails table
);

-- Insert data into the texts table
INSERT INTO texts (text_id, email_id, signup_action) VALUES
(6878, 125, 'Confirmed'),
(6920, 236, 'Not Confirmed'),
(6994, 236, 'Confirmed');

with cte as(
select  count(distinct e.email_id) total_mail_sent, 
sum(case when t.signup_action='Confirmed' then 1 else 0 end) activated_user
from emails e
left join texts t 
on e.email_id = t.email_id
group by e.email_id)

select round(sum(activated_user)*1.0/sum(total_mail_sent),2) confirm_rate from cte


/*
*/

-- Create the measurements table
CREATE TABLE measurements (
    measurement_id INTEGER PRIMARY KEY,
    measurement_value DECIMAL(10, 2), -- Use DECIMAL for precise decimal values
    measurement_time TIMESTAMP -- Use TIMESTAMP for date and time
);

-- Insert data into the measurements table
INSERT INTO measurements (measurement_id, measurement_value, measurement_time) VALUES
(131233, 1109.51, '2022-07-10 09:00:00'),
(135211, 1662.74, '2022-07-10 11:00:00'),
(523542, 1246.24, '2022-07-10 13:15:00'),
(143562, 1124.50, '2022-07-11 15:00:00'),
(346462, 1234.14, '2022-07-11 16:45:00');

-- Verify data insertion (Optional)
with cte as (
SELECT *, 
date(measurement_time) measurement_day,
row_number() over(partition by date(measurement_time) order by measurement_time asc) %2 as odd_even
FROM measurements)

select measurement_day, 
sum(case when odd_even=1 then measurement_value else 0 end ), 
sum(case when odd_even=0 then measurement_value else 0 end ) 
from cte 
group by measurement_day

/*
https://datalemur.com/questions/sql-swapped-food-delivery
*/

-- Create the orders table
CREATE TABLE zomato_orders (
    order_id INTEGER PRIMARY KEY,
    item VARCHAR(255)
);

-- Insert data into the orders table
INSERT INTO zomato_orders (order_id, item) VALUES
(1, 'Chow Mein'),
(2, 'Pizza'),
(3, 'Pad Thai'),
(4, 'Butter Chicken'),
(5, 'Eggrolls'),
(6, 'Burger'),
(7, 'Tandoori Chicken');

with cte as (
select item, 
case 
when (order_id%2)=0 then order_id-1 
when max(order_id) over()=order_id then order_id
else order_id+1 end corrected_order_id
from zomato_orders )
select corrected_order_id, item from cte order by corrected_order_id

/*
https://datalemur.com/questions/sql-bloomberg-stock-min-max-1
*/

-- Create the stock_prices table
CREATE TABLE stock_prices (
    date DATE NOT NULL,  -- Use DATE for just the date portion
    ticker VARCHAR(255) NOT NULL,
    open DECIMAL(10, 2), -- Use DECIMAL for precise financial values
    high DECIMAL(10, 2),
    low DECIMAL(10, 2),
    close DECIMAL(10, 2),
    PRIMARY KEY (date, ticker) -- Composite key for uniqueness
);

CREATE TABLE stock_prices (
    date TIMESTAMP,
    ticker VARCHAR(10),
    open NUMERIC(10, 2),
    high NUMERIC(10, 2),
    low NUMERIC(10, 2),
    close NUMERIC(10, 2)
);

INSERT INTO stock_prices (date, ticker, open, high, low, close) VALUES
('2023-08-31 00:00:00', 'AAPL', 187.48, 187.84, 189.12, 187.87),
('2023-07-31 00:00:00', 'AAPL', 195.26, 196.06, 196.49, 196.45),
('2023-06-30 00:00:00', 'AAPL', 191.26, 191.63, 194.48, 193.97),
('2023-05-31 00:00:00', 'AAPL', 176.76, 177.33, 179.35, 177.25),
('2023-04-30 00:00:00', 'AAPL', 167.88, 168.49, 169.85, 169.68),
('2023-03-31 00:00:00', 'AAPL', 161.91, 162.44, 165.00, 164.90),
('2023-02-28 00:00:00', 'AAPL', 146.83, 147.05, 149.08, 147.41),
('2023-01-31 00:00:00', 'AAPL', 142.28, 142.70, 144.34, 144.29),
('2022-12-31 00:00:00', 'AAPL', 127.43, 128.41, 129.95, 129.93),
('2022-11-30 00:00:00', 'AAPL', 140.55, 141.40, 148.72, 148.03),
('2022-10-31 00:00:00', 'AAPL', 151.92, 153.16, 154.24, 153.34),
('2022-09-30 00:00:00', 'AAPL', 138.00, 141.28, 143.10, 138.20),
('2022-08-31 00:00:00', 'AAPL', 157.14, 160.31, 160.58, 157.22),
('2022-07-31 00:00:00', 'AAPL', 159.50, 161.24, 163.63, 162.51),
('2022-06-30 00:00:00', 'AAPL', 133.77, 137.25, 138.37, 136.72),
('2022-05-31 00:00:00', 'AAPL', 146.84, 149.07, 150.66, 148.84),
('2022-04-30 00:00:00', 'AAPL', 157.25, 161.84, 166.20, 157.65),
('2022-03-31 00:00:00', 'AAPL', 174.40, 177.84, 178.03, 174.61),
('2022-02-28 00:00:00', 'AAPL', 162.43, 163.06, 165.42, 165.12),
('2022-01-31 00:00:00', 'AAPL', 169.51, 170.16, 175.00, 174.78),
('2021-12-31 00:00:00', 'AAPL', 167.48, 182.13, 157.80, 177.57),
('2021-11-30 00:00:00', 'AAPL', 148.99, 165.70, 147.48, 165.30),
('2021-10-31 00:00:00', 'AAPL', 141.90, 153.17, 138.27, 149.80),
('2021-09-30 00:00:00', 'AAPL', 152.83, 157.26, 141.27, 141.50),
('2021-08-31 00:00:00', 'AAPL', 146.36, 153.49, 144.50, 151.83),
('2021-07-31 00:00:00', 'AAPL', 136.60, 150.00, 135.76, 145.86),
('2021-06-30 00:00:00', 'AAPL', 125.08, 137.41, 123.13, 136.96),
('2021-05-31 00:00:00', 'AAPL', 132.04, 134.07, 122.25, 124.61),
('2021-04-30 00:00:00', 'AAPL', 123.66, 137.07, 122.49, 131.46),
('2021-03-31 00:00:00', 'AAPL', 123.75, 128.72, 116.21, 122.15),
('2021-02-28 00:00:00', 'AAPL', 133.75, 137.88, 118.39, 121.26),
('2021-01-31 00:00:00', 'AAPL', 133.52, 145.09, 126.38, 131.96),
('2020-12-31 00:00:00', 'AAPL', 121.01, 138.79, 120.01, 132.69),
('2020-11-30 00:00:00', 'AAPL', 109.11, 121.99, 107.32, 119.05),
('2020-10-31 00:00:00', 'AAPL', 117.64, 125.39, 107.72, 108.86),
('2020-09-30 00:00:00', 'AAPL', 132.76, 137.98, 103.10, 115.81),
('2020-08-31 00:00:00', 'AAPL', 108.20, 131.00, 107.89, 129.04),
('2020-07-31 00:00:00', 'AAPL', 91.28, 106.42, 89.14, 106.26),
('2020-06-30 00:00:00', 'AAPL', 79.44, 93.10, 79.30, 91.20),
('2020-05-31 00:00:00', 'AAPL', 71.56, 81.06, 71.46, 79.49),
('2020-04-30 00:00:00', 'AAPL', 61.63, 73.63, 59.22, 73.45),
('2020-03-31 00:00:00', 'AAPL', 70.57, 76.00, 53.15, 63.57),
('2020-02-29 00:00:00', 'AAPL', 76.07, 81.81, 64.09, 68.34),
('2020-01-31 00:00:00', 'AAPL', 74.06, 81.96, 73.19, 77.38);

with cte as(
SELECT ticker, open, date, 
rank() over(partition by ticker order by open desc) high_rank,
rank() over(partition by ticker order by open) low_rank
FROM stock_prices),
cte1 as(
select ticker, date as highest_mth, open as highest_open  from cte where high_rank=1 ),
cte2 as(
select ticker, date as lowest_mth, open  as lowest_open from cte where low_rank=1
)
select c1.ticker, 
to_char(c1.highest_mth, 'Mon-YYYY') highest_mth,
c1.highest_open, 
to_char(c2.lowest_mth, 'Mon-YYYY') lowest_mth,
c2.lowest_open 
from  cte1 c1 
join cte2 c2
on c1.ticker = c2.ticker

/*
https://datalemur.com/questions/amazon-shopping-spree
*/

-- Create the transactions table
CREATE TABLE transactions (
    user_id INT,
    amount DECIMAL(10, 2),
    transaction_date "timestamp"
);

-- Insert the data into the transactions table
INSERT INTO transactions (user_id, amount, transaction_date) VALUES
(1, 9.99, '2022-08-01 12:00:00'),
(1, 55.00, '2022-08-17 12:00:00'),
(2, 149.50, '2022-08-05 12:00:00'),
(2, 4.89, '2022-08-06 12:00:00'),
(2, 34.00, '2022-08-07 12:00:00'),
(3, 178.00, '2022-07-01 12:00:00'),
(4, 25.00, '2022-08-08 12:00:00'),
(5, 56.00, '2022-07-28 12:00:00'),
(5, 11.50, '2022-07-29 12:00:00'),
(5, 60.99, '2022-07-30 12:00:00');

with cte as (
select user_id, max(date(transaction_date))-min(date(transaction_date)) date_diff from transactions group by user_id
)
select user_id from cte where date_diff=2
order by user_id

/*
https://datalemur.com/questions/histogram-users-purchases
*/

-- Create the product_transactions table
CREATE TABLE user_transactions (
    product_id INT,
    user_id INT,
    spend DECIMAL(10, 2),
    transaction_date timestamp
);

-- Insert the data into the product_transactions table
INSERT INTO user_transactions (product_id, user_id, spend, transaction_date) VALUES
(3673, 123, 68.90, '2022-07-08 10:00:00'),
(9623, 123, 274.10, '2022-07-08 10:00:00'),
(1467, 115, 19.90, '2022-07-08 10:00:00'),
(2513, 159, 25.00, '2022-07-08 10:00:00'),
(1452, 159, 74.50, '2022-07-10 10:00:00'),
(1452, 123, 74.50, '2022-07-10 10:00:00'),
(9765, 123, 100.15, '2022-07-11 10:00:00'),
(6536, 115, 57.00, '2022-07-12 10:00:00'),
(7384, 159, 15.50, '2022-07-12 10:00:00'),
(1247, 159, 23.40, '2022-07-12 10:00:00');

 with cte as(
select user_id, transaction_date, count(*) purchase_count ,
rank() over(partition by user_id order by transaction_date desc) rnk
from user_transactions 
group by user_id, transaction_date)
select transaction_date, user_id,	purchase_count from 
cte where rnk=1
order by  transaction_date;

/*
https://datalemur.com/questions/alibaba-compressed-mode
*/

-- Create the order_data table
CREATE TABLE items_per_order (
    order_occurrences INT,
    item_count INT
);

-- Insert the data into the order_data table
INSERT INTO items_per_order (order_occurrences, item_count) VALUES
(500, 1),
(1000, 2),
(800, 3),
(1000, 4),
(500, 5),
(550, 6),
(400, 7),
(200, 8),
(10, 9);

with cte as(
select *, dense_rank() over(order by order_occurrences desc) rnk from items_per_order)
select item_count as mode from cte where rnk = 1;


/*
https://datalemur.com/questions/card-launch-success
*/

-- Create the monthly_cards_issued table
-- Create the monthly_cards_issued table (if it doesn't exist already)
CREATE TABLE IF NOT EXISTS monthly_cards_issued (
    card_name VARCHAR(255),
    issued_amount INT,
    issue_month INT,
    issue_year INT
);

-- Insert the data into the monthly_cards_issued table
INSERT INTO monthly_cards_issued (card_name, issued_amount, issue_month, issue_year) VALUES
('Chase Sapphire Reserve', 160000, 12, 2020),
('Chase Sapphire Reserve', 170000, 1, 2021),
('Chase Sapphire Reserve', 175000, 2, 2021),
('Chase Sapphire Reserve', 180000, 3, 2021),
('Chase Freedom Flex', 55000, 1, 2021),
('Chase Freedom Flex', 60000, 2, 2021),
('Chase Freedom Flex', 65000, 3, 2021),
('Chase Freedom Flex', 70000, 4, 2021),
('Chase Sapphire Reserve', 150000, 11, 2020);

with cte as(
select *, rank() over(partition by card_name order by issue_year,issue_month ) rnk from monthly_cards_issued)

select card_name, issued_amount from cte where rnk =1 ORDER by issued_amount desc

/*
https://datalemur.com/questions/international-call-percentage
*/

-- Create the phone_calls table
CREATE TABLE phone_calls(
    caller_id INT,
    receiver_id INT,
    call_time Timestamp
);

-- Insert the data into the phone_calls table
INSERT INTO phone_calls(caller_id, receiver_id, call_time) VALUES
(1, 2, '2022-07-04 10:13:49'),
(1, 5, '2022-08-21 23:54:56'),
(5, 1, '2022-05-13 17:24:06'),
(5, 6, '2022-03-18 12:11:49');

-- Create the phone_info table
CREATE TABLE phone_info (
    caller_id INT,
    country_id VARCHAR(2), -- Use VARCHAR for country codes (e.g., US, IN)
    network VARCHAR(50),  -- Use VARCHAR for network names
    phone_number VARCHAR(20) -- Use VARCHAR for phone numbers (can include + and -)
);

-- Insert the data into the phone_info table
INSERT INTO phone_info (caller_id, country_id, network, phone_number) VALUES
(1, 'US', 'Verizon', '+1-212-897-1964'),
(2, 'US', 'Verizon', '+1-703-346-9529'),
(3, 'US', 'Verizon', '+1-650-828-4774'),
(4, 'US', 'Verizon', '+1-415-224-6663'),
(5, 'IN', 'Vodafone', '+91 7503-907302'),
(6, 'IN', 'Vodafone', '+91 2287-664895');


with cte as(
select distinct count(pi.country_id) over() total_calls, sum(case when  pi.country_id!=pi1.country_id then 1 else 0 end) over() international_calls from phone_calls pc
inner join phone_info pi
on pc.caller_id = pi.caller_id
inner join phone_info  pi1
on pc.receiver_id = pi1.caller_id)

select round(international_calls*1.0/total_calls,1 )*100 as international_calls_pct
from cte

/*
https://datalemur.com/questions/uncategorized-calls-percentage
*/

-- Drop the table if it exists
DROP TABLE IF EXISTS callers;

-- Create the callers table
CREATE TABLE callers (
    policy_holder_id INT,
    case_id VARCHAR(36),          -- UUIDs are 36 characters including hyphens
    call_category VARCHAR(255),
    call_date TimeStamp,           
    call_duration_secs INT
);

-- Insert the data into the callers table
INSERT INTO callers (policy_holder_id, case_id, call_category, call_date, call_duration_secs) VALUES
(1, 'f1d012f9-9d02-4966-a968-bf6c5bc9a9fe', 'emergency assistance', '2023-04-13 19:16:53', 144),
(1, '41ce8fb6-1ddd-4f50-ac31-07bfcce6aaab', 'authorisation', '2023-05-25 09:09:30', 815),
(2, '9b1af84b-eedb-4c21-9730-6f099cc2cc5e', 'n/a', '2023-01-26 01:21:27', 992),
(2, '8471a3d4-6fc7-4bb2-9fc7-4583e3638a9e', 'emergency assistance', '2023-03-09 10:58:54', 128),
(2, '38208fae-bad0-49bf-99aa-7842ba2e37bc', 'benefits', '2023-06-05 07:35:43', 619);

with cte as (
select  case when call_category='n/a' or call_category is null then 1 else 0 end uncategorised_call from callers)
select  round((sum(uncategorised_call)*1.0/count(*)) *100, 1) uncategorised_call_pct
from  cte

/*
https://datalemur.com/questions/yoy-growth-rate
*/
CREATE TABLE user_transactions_ (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    spend DECIMAL(10, 2),
    transaction_date Timestamp
);

INSERT INTO user_transactions_ (transaction_id, product_id, spend, transaction_date)
VALUES
(1341, 123424, 1500.60, '2019-12-31 12:00:00'),
(1423, 123424, 1000.20, '2020-12-31 12:00:00'),
(1623, 123424, 1246.44, '2021-12-31 12:00:00'),
(1322, 123424, 2145.32, '2022-12-31 12:00:00'),
(1344, 234412, 1800.00, '2019-12-31 12:00:00'),
(1435, 234412, 1234.00, '2020-12-31 12:00:00'),
(4325, 234412, 889.50, '2021-12-31 12:00:00'),
(5233, 234412, 2900.00, '2022-12-31 12:00:00'),
(2134, 543623, 6450.00, '2019-12-31 12:00:00'),
(1234, 543623, 5348.12, '2020-12-31 12:00:00'),
(2423, 543623, 2345.00, '2021-12-31 12:00:00'),
(1245, 543623, 5680.00, '2022-12-31 12:00:00');

with cte as (
select *, date_part('Year', transaction_date) as year,
lag(spend) over(partition By product_id order by transaction_date) prev_year_spend
from user_transactions_)
select year, 
product_id, 
spend as curr_year_spend, 
prev_year_spend, 
round((spend - prev_year_spend) / prev_year_spend * 100,2) as 
yoy_rate from cte

/*
https://datalemur.com/questions/prime-warehouse-storage
*/
CREATE TABLE inventory (
    item_id INT PRIMARY KEY,
    item_type VARCHAR(20),
    item_category VARCHAR(50),
    square_footage DECIMAL(6, 2)
);

INSERT INTO inventory (item_id, item_type, item_category, square_footage)
VALUES
(1374, 'prime_eligible', 'mini refrigerator', 68.00),
(4245, 'not_prime', 'standing lamp', 26.40),
(5743, 'prime_eligible', 'washing machine', 325.00),
(8543, 'not_prime', 'dining chair', 64.50),
(2556, 'not_prime', 'vase', 15.00),
(2452, 'prime_eligible', 'television', 85.00),
(3255, 'not_prime', 'side table', 22.60),
(1672, 'prime_eligible', 'laptop', 8.50),
(4256, 'prime_eligible', 'wall rack', 55.50),
(6325, 'prime_eligible', 'desktop computer', 13.20);

WITH cte AS
(SELECT 
SUM(CASE WHEN item_type = 'not_prime' THEN 1 ELSE 0 END) n_prime,
SUM(CASE WHEN item_type = 'prime_eligible' THEN 1 ELSE 0 END) prime,
SUM(CASE WHEN item_type = 'not_prime' THEN square_footage END) sum_np,
SUM(CASE WHEN item_type = 'prime_eligible' THEN square_footage END) sum_p
FROM inventory)
select 'prime_eligible' as item_type,
floor(500000/sum_p)*prime item_count
from cte
union all
select 'not_prime' as item_type,
TRUNC((500000-TRUNC(500000/SUM_P,0)*SUM_P)/SUM_NP, 0)*n_prime item_count
from cte


/*
https://datalemur.com/questions/median-search-freq
*/

-- Create table statement
CREATE TABLE search_frequency (
    searches INTEGER NOT NULL,
    num_users INTEGER NOT NULL
);

-- Insert statements
INSERT INTO search_frequency (searches, num_users) VALUES
(1, 2),
(4, 1),
(2, 2),
(3, 3),
(6, 1),
(5, 3),
(7, 2);

  -- Sol-1
with cte as (
SELECT searches, num_users, row_number() over( order by searches ) rn
FROM search_frequency
CROSS JOIN LATERAL generate_series(1, num_users))


select round(sum(searches)*1.0/2,1) from cte where rn in ((select count(*) from cte)/2 , ((select count(*) from cte)/2)+1)

-- SOL-2 - Optimize solution
WITH cte AS (
    SELECT searches, 
           row_number() OVER (ORDER BY searches) AS rn,
           count(*) OVER () AS total_count
    FROM search_frequency
    CROSS JOIN LATERAL generate_series(1, num_users)
)
SELECT round(avg(searches), 1) AS median
FROM cte
WHERE rn IN ((total_count / 2), (total_count / 2) + 1);
/*
-- You are given the two tables containing information on Etsy’s user signups and purchases. 

-- Write a query to obtain the percentage of users who signed up and made a purchase within 7 days of signing up. 
-- The result should be rounded to the nearest 2 decimal places.

-- Assumptions:

-- Signups who didn't buy any products yet should also count as part of the percentage of users who signed up and made a purchase within 7 days of signing up.

-- If the signup date is on 06/21/2022 and the purchase date on 06/26/2022, then the user makes up part of the percentage of users who signed up and purchased within the 7 days of signing up.

-- Explanation: The only users who purchased within 7 days of signing up are users 648 and 123. The total count of given signups is 5, resulting in a percentage of 2/5 = 40%.

*/
-- Create signups table
CREATE TABLE signups (
    user_id INTEGER NOT NULL,
    signup_date TIMESTAMP NOT NULL
);

-- Create user_purchases table
CREATE TABLE user_purchases (
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    purchase_amount DECIMAL(10,2) NOT NULL,
    purchase_date TIMESTAMP NOT NULL
);

-- TRUNCATE TABLE signups;
-- TRUNCATE TABLE user_purchases;
-- Insert data into signups table
INSERT INTO signups (user_id, signup_date) VALUES
(445, '2022-06-21 12:00:00'),
(742, '2022-06-19 12:00:00'),
(648, '2022-06-24 12:00:00'),
(789, '2022-06-27 12:00:00'),
(123, '2022-06-27 12:00:00');

-- Insert data into user_purchases table
INSERT INTO user_purchases (user_id, product_id, purchase_amount, purchase_date) VALUES
(244, 5754, 45.00, '2022-06-22 12:00:00'),
(742, 2415, 50.00, '2022-06-28 12:00:00'),
(648, 6325, 55.50, '2022-06-25 12:00:00'),
(123, 4756, 67.30, '2022-06-29 12:00:00'),
(244, 3417, 74.10, '2022-06-30 12:00:00');

select 
ROUND(count(*)*1.0/(select count(*) from signups)*100,2) single_purchase_pct 
from signups s 
inner join user_purchases u 
ON
s.user_id = u.user_id
and u.purchase_date<=(signup_date + Interval '7 days');

/*
-- Monthly Merchant Balance [Visa SQL Interview Question]

-- Say you have access to all the transactions for a given merchant account. 

-- Write a query to print the cumulative balance of the merchant account at the end of each day, with the total balance reset back to zero at the end of the month. Output the transaction date and cumulative balance.

*/
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    type VARCHAR(50),
    amount NUMERIC(10, 2),
    transaction_date TIMESTAMP
);

INSERT INTO transactions (transaction_id, type, amount, transaction_date) VALUES
(19153, 'deposit', 65.90, '2022-07-10 10:00:00'),
(53151, 'deposit', 178.55, '2022-07-08 10:00:00'),
(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00'),
(16461, 'withdrawal', 45.99, '2022-07-08 10:00:00'),
(77134, 'deposit', 32.60, '2022-07-10 10:00:00');

with cte as (
select transaction_date, 
sum(CASE when type = 'withdrawal' then -amount else amount end) total_balance 
from transactions
group by transaction_date
)
select transaction_date, sum(total_balance) over(order by transaction_date) balance from cte;
/*
Write an SQL query to find the customers who have made purchases in all categories. Assume that the list of categories is dynamic and can change over time 
You are given the following two tables:
*/
-- Customer Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- Purchases Table
CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    Category VARCHAR(50)
);


-- Insert Data into Customers
INSERT INTO Customers (CustomerID, Name) VALUES
(1, 'Ravi Kumar'),
(2, 'Priya Sharma'),
(3, 'Amit Singh'),
(4, 'Neha Verma'),
(5, 'Rajesh Mehra');

-- Insert Data into Purchases
INSERT INTO Purchases (PurchaseID, CustomerID, Category) VALUES
(101, 1, 'Electronics'),
(102, 1, 'Books'),
(103, 2, 'Clothing'),
(104, 5, 'Groceries'),
(105, 3, 'Electronics'),
(106, 4, 'Books'),
(107, 4, 'Groceries'),
(108, 5, 'Clothing'),
(109, 5, 'Electronics'),
(110, 5, 'Books');

-- get_catagaory_cust(
-- select distinct Category from Purchases
-- )

-- select * from Customers where CustomerID in (select distinct CustomerID from Purchases)

with cte as (
select CustomerID, count(distinct Category) from Purchases 
Group by CustomerID
Having count(*) = (select count(distinct Category) from Purchases))
select cs.* from cte c inner join Customers cs 
on c.CustomerID = cs.CustomerID;

/*
Calculate the rolling salary over the last 2 months
*/
CREATE TABLE EmployeeSalaries (
    EmployeeID INT,
    Salary NUMERIC(10,2),
    SalaryDate DATE
);

INSERT INTO EmployeeSalaries (EmployeeID, Salary, SalaryDate) VALUES
(1, 50000.00, '2025-01-01'),
(1, 52000.00, '2025-02-01'),
(1, 54000.00, '2025-03-01'),

(2, 60000.00, '2025-01-01'),
(2, 61000.00, '2025-02-01'),
(2, 62000.00, '2025-03-01'),

(3, 45000.00, '2025-01-01'),
(3, 47000.00, '2025-02-01'),
(3, 48000.00, '2025-03-01'),

(4, 55000.00, '2025-01-01'),
(4, 56000.00, '2025-02-01'),
(4, 57000.00, '2025-03-01');

with cte as (
select *, sum(salary) over(partition by EmployeeID order by SalaryDate) rolling_salary  from EmployeeSalaries),
ranked as (
select *, row_number() over(partition by EmployeeID order by SalaryDate desc) rn from cte )
select EmployeeID, SalaryDate, rolling_salary  from ranked where rn <=2 order by EmployeeID, SalaryDate;

with cte as (
select *, sum(salary) over(partition by EmployeeID order by SalaryDate rows between 1 preceding and current row ) rolling_salary  from EmployeeSalaries),
ranked as (
select *, row_number() over(partition by EmployeeID order by SalaryDate desc ) rn from cte)
select EmployeeID, SalaryDate,rolling_salary  from ranked where rn<=2 order by EmployeeID, SalaryDate 

CREATE TABLE Logs (
    log_id INT PRIMARY KEY
);

INSERT INTO Logs (log_id) VALUES
(1),
(2),
(3),
(7),
(8),
(10);

with cte as (
select *, log_id - row_number() over() as grp from Logs)
select min(log_id) start_id, max(log_id) end_id from cte 
group by grp
order by start_id;

/*
SQL Question 1: First 14-Day Satisfaction
The Growth Team at DoorDash wants to ensure that new users, who make orders within their first 14 days on the platform, have a positive experience. However, they have noticed several issues with deliveries that result in a bad experience.

These issues include:

Orders being completed incorrectly, with missing items or wrong orders.
Orders not being received due to incorrect addresses or drop-off spots.
Orders being delivered late, with the actual delivery time being 30 minutes later than the order placement time. Note that the estimated_delivery_timestamp is automatically set to 30 minutes after the order_timestamp.
Write a query that calculates the bad experience rate for new users who signed up in June 2022 during their first 14 days on the platform. The output should include the percentage of bad experiences, rounded to 2 decimal places.
*/
-- Orders Table
DROP TABLE IF EXISTS  orders;
DROP TABLE  IF EXISTS trips;
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    trip_id INTEGER,
    status VARCHAR(50),
    order_timestamp TIMESTAMP
);

-- Trips Table
CREATE TABLE trips (
    dasher_id INTEGER,
    trip_id INTEGER PRIMARY KEY,
    estimated_delivery_timestamp TIMESTAMP,
    actual_delivery_timestamp TIMESTAMP
);

-- Customers Table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    signup_timestamp TIMESTAMP
);

-- Insert Data into Orders
INSERT INTO orders (order_id, customer_id, trip_id, status, order_timestamp) VALUES
(727424, 8472, 100463, 'completed successfully', '2022-06-05 09:12:00'),
(242513, 2341, 100482, 'completed incorrectly', '2022-06-05 14:40:00'),
(141367, 1314, 100362, 'completed incorrectly', '2022-06-07 15:03:00'),
(582193, 5421, 100657, 'never received', '2022-07-07 15:22:00'),
(253613, 1314, 100213, 'completed successfully', '2022-06-12 13:43:00');

-- Insert Data into Trips
INSERT INTO trips (dasher_id, trip_id, estimated_delivery_timestamp, actual_delivery_timestamp) VALUES
(101, 100463, '2022-06-05 09:42:00', '2022-06-05 09:38:00'),
(102, 100482, '2022-06-05 15:10:00', '2022-06-05 15:46:00'),
(101, 100362, '2022-06-07 15:33:00', '2022-06-07 16:45:00'),
(102, 100657, '2022-07-07 15:52:00', NULL), -- NULL for not delivered
(103, 100213, '2022-06-12 14:13:00', '2022-06-12 14:10:00');

-- Insert Data into Customers
INSERT INTO customers (customer_id, signup_timestamp) VALUES
(8472, '2022-05-30 00:00:00'),
(2341, '2022-06-01 00:00:00'),
(1314, '2022-06-03 00:00:00'),
(1435, '2022-06-05 00:00:00'),
(5421, '2022-06-07 00:00:00');

/*
SQL Question 2: Analyze DoorDash Delivery Performance
As a Data Analyst at DoorDash, you're tasked to analyze the delivery performance of the drivers. Specifically, you are asked to compute the average delivery duration of each driver for each day, the rank of each driver's daily average delivery duration, and the overall average delivery duration per driver.

Use the deliveries table where each row represents a single delivery. The columns are:

delivery_id: An identifier for the delivery
driver_id: An identifier for the driver
delivery_start_time: Timestamp for the start of the delivery
delivery_end_time: Timestamp for the end of the delivery
*/
CREATE TABLE deliveries (
    delivery_id INTEGER PRIMARY KEY,
    driver_id INTEGER,
    delivery_start_time TIMESTAMP,
    delivery_end_time TIMESTAMP
);

INSERT INTO deliveries (delivery_id, driver_id, delivery_start_time, delivery_end_time) VALUES
(1, 123, '2022-08-01 14:00:00', '2022-08-01 14:40:00'),
(2, 123, '2022-08-01 15:15:00', '2022-08-01 16:10:00'),
(3, 265, '2022-08-01 14:00:00', '2022-08-01 15:30:00'),
(4, 265, '2022-08-01 16:00:00', '2022-08-01 16:50:00'),
(5, 123, '2022-08-02 11:00:00', '2022-08-02 11:35:00');


---


CREATE TABLE employee_attendance (
    employee_id INT,
    attendance_date DATE
);

INSERT INTO employee_attendance (employee_id, attendance_date) VALUES
(101, '2024-07-01'),
(101, '2024-07-02'),
(101, '2024-07-03'),
(101, '2024-07-04'),
(101, '2024-07-05'),
(101, '2024-07-07'),
(101, '2024-07-08'),
(101, '2024-07-09'),
(101, '2024-07-10'),

(102, '2024-07-01'),
(102, '2024-07-02'),
(102, '2024-07-03'),
(102, '2024-07-05'),
(102, '2024-07-06'),
(102, '2024-07-08'),
(102, '2024-07-10'),

(103, '2024-07-02'),
(103, '2024-07-04'),
(103, '2024-07-06'),
(103, '2024-07-07'),
(103, '2024-07-09'),
(103, '2024-07-10');

with cte as (
select *, 
row_number() over(partition by employee_id order by attendance_date) rn
from employee_attendance),
grp_cte as (
select *, attendance_date - rn * INTERVAL '1 day' grp from cte)
select employee_id, grp, count(*) from grp_cte group by employee_id, grp;

-- Create table and insert data in one script
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL
);

INSERT INTO products (product_id, product, category) VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'), 
(3, 'Tablet', 'Electronics'),
(9, 'Printer', 'Electronics'),
(4, 'Headphones', 'Accessories'),
(5, 'Smartwatch', 'Accessories'),
(6, 'Keyboard', 'Accessories'),
(7, 'Mouse', 'Accessories'),
(8, 'Monitor', 'Accessories');

with cte as (
select *, 
row_number() over(partition by category order by product_id ) rn1, 
row_number() over(partition by category order by product_id desc) rn2
from products)

select c1.product_id, c2.product, c1.category from cte c1 inner join cte c2
on c1.category = c2.category and c1.rn1 = c2.rn2;

/*
-- The Apple retention team needs your help to investigate buying patterns. 

-- Write a query to determine the percentage of buyers who bought AirPods directly after they bought iPhones. 
-- Round your answer to a percentage (i.e. 20 for 20%, 50 for 50) with no decimals.

-- Clarifications:

-- The users were interested in buying iPhones and then AirPods, with no intermediate purchases in between.
-- Users who buy iPhones and AirPods at the same time, with the iPhone logged first, can still be counted.
-- Tip:

-- Multiply by 100 before you perform the rounding to make sure you get the same answer we did :)


*/

DROP TABLE IF EXISTS transactions;
-- Create the table
CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    transaction_timestamp TIMESTAMP NOT NULL
);

-- Insert the data
INSERT INTO transactions (transaction_id, customer_id, product_name, transaction_timestamp) VALUES
(1, 101, 'iPhone', '2022-08-08 00:00:00'),
(2, 101, 'AirPods', '2022-08-08 00:00:00'),
(5, 301, 'iPhone', '2022-09-05 00:00:00'),
(6, 301, 'iPad', '2022-09-06 00:00:00'),
(7, 301, 'AirPods', '2022-09-07 00:00:00');

with total_counts as (
select count(distinct customer_id) AS total from transactions
),cte as (
select *, lead(product_name) over (partition by customer_id 
order by transaction_timestamp) next_product,
count( customer_id) over( partition by customer_id) total_cust  from transactions)
select count(distinct customer_id)*1.0/total * 100 follow_up_percentage from cte
cross join total_counts 
where next_product = 'AirPods' and product_name = 'iPhone'
group by customer_id, total;

/*
-- Uniquely Staffed Consultants [Accenture SQL Interview Questions]

-- As a Data Analyst on the People Operations team at Accenture, you are tasked with understanding how many consultants are staffed to each client, and how many consultants are exclusively staffed to a single client.

-- Write a query that displays the outputs of client name and the number of uniquely and exclusively staffed consultants ordered by client name.


*/


-- Create the table
CREATE TABLE employee_engagement (
    employee_id INTEGER NOT NULL,
    engagement_id INTEGER NOT NULL
);

-- Insert the data
INSERT INTO employee_engagement (employee_id, engagement_id) VALUES
(1001, 1),
(1001, 2),
(1002, 2),
(1003, 3),
(1004, 4);

-- Create the table
CREATE TABLE consulting_engagements (
    engagement_id INTEGER PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    client_name VARCHAR(100) NOT NULL
);

-- Insert the data
INSERT INTO consulting_engagements (engagement_id, project_name, client_name) VALUES
(1, 'SAP Logistics Modernization', 'Department of Defense'),
(2, 'Oracle Cloud Migration', 'Department of Education'),
(3, 'Trust & Safety Operations', 'Google'),
(4, 'SAP IoT Cloud Integration', 'Google');




