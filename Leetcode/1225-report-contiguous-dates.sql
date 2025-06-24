CREATE TABLE Failed (
    fail_date DATE
);

INSERT INTO Failed (fail_date) VALUES
('2018-12-28'),
('2018-12-29'),
('2019-01-04'),
('2019-01-05');

CREATE TABLE Succeeded (
    success_date DATE
);

INSERT INTO Succeeded (success_date) VALUES
('2018-12-30'),
('2018-12-31'),
('2019-01-01'),
('2019-01-02'),
('2019-01-03'),
('2019-01-06');

with cte as(
select fail_date as task_date, 'failed' as status from Failed where fail_date between '2019-01-01' and '2019-12-31'
union all 
select success_date as task_date, 'succeeded' as status from succeeded where success_date between '2019-01-01' and '2019-12-31'),
final as (
select *
,row_number() OVER(order by task_date)  - row_number() OVER(partition by status order by task_date) group_id
from cte )
select status as period_state, min(task_date) start_date, max(task_date) end_date from final
group by group_id, status
order by start_date;

