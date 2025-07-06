drop table if exists user_activity;
CREATE TABLE user_activity (
    username VARCHAR(255),
    activity VARCHAR(255),
    startDate DATE,
    endDate DATE
);

INSERT INTO user_activity (username, activity, startDate, endDate) VALUES
('Alice', 'Travel', '2020-02-12', '2020-02-20'),
('Alice', 'Dancing', '2020-02-21', '2020-02-23'),
('Alice', 'Travel', '2020-02-24', '2020-02-28'),
('Bob', 'Travel', '2020-02-11', '2020-02-18');

with cte as(
select *, row_number() over(partition by username order by startdate) rn, lead(username) over(partition by username ) lead 
from user_activity)
select username, activity, startDate, endDate from cte
where (rn = 1 and lead is null) or rn =2;

WITH ranked_activities AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY username ORDER BY startdate desc) AS rn,
           COUNT(*) OVER(PARTITION BY username) AS count
    FROM   UserActivity
)
SELECT username, activity, startdate, enddate
FROM   ranked_activities
WHERE  rn=2 OR count=1;

