/*
For every customer that bought Photoshop, return a list of the customers, and the total spent on all the products except for Photoshop products.
*/

-- CREATE TABLE statement
CREATE TABLE customer_product_revenue (
    customer_id INT,
    product VARCHAR(50),
    revenue DECIMAL(10,2)
);

-- INSERT statements
INSERT INTO customer_product_revenue (customer_id, product, revenue) VALUES
(123, 'Photoshop', 50.00),
(123, 'Premier Pro', 100.00),
(123, 'After Effects', 50.00),
(234, 'Illustrator', 200.00),
(234, 'Premier Pro', 100.00);

with customer_photoshop as (
select customer_id from customer_product_revenue where  product = 'Photoshop')
select c.customer_id, 
sum(case when c.product = 'Photoshop' then 0 else c.revenue end) as revenue 
from customer_product_revenue c 
inner join customer_photoshop cp
on c.customer_id = cp.customer_id
group by c.customer_id;

/*
Adobe has an extensive database of its customers. They often want to focus on active users who are highly engaged with their products. For this question, suppose that Adobe considers an active user as someone who has used any one of their products more than 4 times in a month. Additionally, Adobe is interested in users who provide reviews with at least 4-star ratings.

Given the following sample data tables for users, usage, and reviews, write a query to find the users who meet the above criteria.
*/
CREATE TABLE users (
    user_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sign_up_date DATE NOT NULL
);

INSERT INTO users (user_id, name, sign_up_date) VALUES
(123, 'John Doe', '2022-05-01'),
(265, 'Jane Smith', '2022-05-10'),
(362, 'Alice Johnson', '2022-06-15'),
(192, 'Bob Brown', '2022-06-20'),
(981, 'Charlie Davis', '2022-07-01');

CREATE TABLE usage (
    user_id INT NOT NULL,
    product VARCHAR(100) NOT NULL,
    usage_date DATE NOT NULL
);
INSERT INTO usage (user_id, product, usage_date) VALUES
(123, 'Photoshop', '2022-06-05'),
(123, 'Photoshop', '2022-06-06'),
(123, 'Photoshop', '2022-06-07'),
(123, 'Photoshop', '2022-06-08'),
(123, 'Photoshop', '2022-06-09'),
(265, 'Lightroom', '2022-07-10'),
(265, 'Lightroom', '2022-07-11'),
(265, 'Lightroom', '2022-07-12'),
(362, 'Illustrator', '2022-07-17'),
(362, 'Illustrator', '2022-07-18');

CREATE TABLE reviews (
    review_id INT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    submit_date DATE NOT NULL,
    product_id VARCHAR(100) NOT NULL,
    stars INT NOT NULL CHECK (stars BETWEEN 1 AND 5)
);

INSERT INTO reviews (review_id, user_id, submit_date, product_id, stars) VALUES
(6171, 123, '2022-06-08', 'Photoshop', 4),
(5293, 362, '2022-07-18', 'Illustrator', 5),
(7802, 265, '2022-07-12', 'Lightroom', 4);

select * from users;
select * from usage;
select * from reviews;

with cte as (
select distinct user_id, EXTRACT(month from  usage_date) from usage
group by user_id,  EXTRACT(month from  usage_date)
having count(*)>=4
)
select u.* from cte c
join reviews r on c.user_id = r.user_id and r.stars>=4 
join users u
on c.user_id = u.user_id;

/*
For a company like Adobe, which is known for its various software subscriptions such as Adobe Acrobat, Photoshop, Illustrator and so on, a good question would be to find the average monthly duration of user subscriptions. This would be especially interesting if Adobe wants to know how long users keep using their software on average.
*/
DROP TABLE products;
CREATE TABLE products (
    product_id INT NOT NULL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL
);

INSERT INTO products (product_id, product_name) VALUES
(3001, 'Adobe Photoshop'),
(3002, 'Adobe Acrobat'),
(3003, 'Adobe Illustrator');

CREATE TABLE subscriptions (
    subscription_id INT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

INSERT INTO subscriptions (subscription_id, user_id, product_id, start_date, end_date) VALUES
(1001, 50, 3001, '2022-01-01', '2022-04-01'),
(1002, 70, 3002, '2022-01-02', '2022-03-01'),
(1003, 90, 3001, '2022-01-03', '2022-01-04'),
(1004, 120, 3002, '2022-01-04', '2022-01-10'),
(1005, 200, 3003, '2022-01-05', '2022-01-08');


CREATE TABLE persons (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO persons (id, name) VALUES
(1, 'Person1'),
(2, 'Person2'),
(3, 'Person3'),
(4, 'Person4'),
(5, 'Person5'),
(6, 'Person6'),
(7, 'Person7'),
(8, 'Person8'),
(9, 'Person9'),
(10, 'Person10');


select concat(p2.id,' ', p2.name, ', ', p1.id,' ', p1.name) from persons p1
join persons p2
on p1.id = p2.id+1
and p1.id>p2.id and p1.id%2=0



