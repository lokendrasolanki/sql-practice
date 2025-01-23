/*
https://leetcode.com/problems/human-traffic-of-stadium/description/?envType=problem-list-v2&envId=e97a9e5m

visit_date is the column with unique values for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
As the id increases, the date increases as well.
 

Write a solution to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.
*/


CREATE TABLE stadium (
    id INT PRIMARY KEY,
    visit_date DATE,
    people INT
);
-- truncate table stadium
-- Insert statements
INSERT INTO stadium (id, visit_date, people) VALUES
(1, '2017-01-01', 10),
(2, '2017-01-02', 109),
(3, '2017-01-03', 150),
(4, '2017-01-04', 99),
(5, '2017-01-05', 145),
(6, '2017-01-06', 1455),
(7, '2017-01-07', 199),
(8, '2017-01-09', 188),
(9, '2017-01-10', 40),
(10, '2017-01-11', 168),
(11, '2017-01-12', 233),
(12, '2017-01-13', 1888),
(13, '2017-01-14', 40),
(14, '2017-01-15', 40),
(15, '2017-01-16', 30),
(16, '2017-01-17', 1888),
(17, '2017-01-18', 40),
(18, '2017-01-19', 168),
(19, '2017-01-20', 233),
(20, '2017-01-21', 1888);

-- SOl:1
with falg_stadium as (
select *, 
case when people >= 100 then 1 else (people+id) end  as flag from stadium ),
create_user_group as (
select *,
row_number() over(order by id) - row_number() over(partition by flag order by id) AS grp from falg_stadium
),
user_count_each_grp as (
select *, count(*) over(partition by grp) cnt  from create_user_group  where flag=1
)
select id, visit_date ,people from user_count_each_grp where cnt>=3 order by id

-- SOL-2:

with cte as (
select *, id - row_number() over() as id_diff
from stadium
where people >= 100
)
select id, visit_date, people
from cte
where id_diff in (select id_diff from cte group by id_diff having count(*) > 2)
order by visit_date

 