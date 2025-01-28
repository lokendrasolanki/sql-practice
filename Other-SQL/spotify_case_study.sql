/*
Spotify Case Study
*/

CREATE table spotify_activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from spotify_activity;
insert into spotify_activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');



/*
CASE-1: Find total active user each Day
*/
select event_date, count(distinct user_id) active_user from spotify_activity group by event_date 

/*
CASE-2: Find total active user each Week
*/
with cte as(
select * , 
	CEIL((EXTRACT(DAY FROM event_date) - 1) / 7.0)+1 AS week
		from spotify_activity)
select week, count(distinct user_id) active_user
from cte
group by week 

/*
case-3 - date wise total number of users who made the purchare same day they installed the app
*/

with cte as (
select *, 
lead(event_date) over(partition by user_id order by event_date) next_date
from spotify_activity)
select event_date, 
sum(case when event_date=next_date then 1 else 0 end) same_day_purchese_user 
from cte 
group by event_date 
order by event_date

