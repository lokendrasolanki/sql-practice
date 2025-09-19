DROP TABLE IF Exists employees;
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    join_date DATE NOT NULL,
    department VARCHAR(10) NOT NULL
);
INSERT INTO employees(employee_id, name, join_date, department)
VALUES
    (1, 'Alice', '2018-06-15', 'IT'),
    (2, 'Bob', '2019-02-10', 'Finance'),
    (3, 'Charlie', '2017-09-20', 'HR'),
    (4, 'David', '2020-01-05', 'IT'),
    (5, 'Eve', '2016-07-30', 'Finance'),
    (6, 'Sumit', '2016-06-30', 'Finance');
 
-- Create salary_history table
DROP TABLE IF Exists salary_history;
CREATE TABLE salary_history (
    employee_id INT,
    change_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    promotion VARCHAR(3)
);

-- Insert sample data
INSERT INTO salary_history (employee_id, change_date, salary, promotion)
VALUES
    (1, '2018-06-15', 50000, 'No'),
    (1, '2019-08-20', 55000, 'No'),
    (1, '2021-02-10', 70000, 'Yes'),
    (2, '2019-02-10', 48000, 'No'),
    (2, '2020-05-15', 52000, 'Yes'),
    (2, '2023-01-25', 68000, 'Yes'),
    (3, '2017-09-20', 60000, 'No'),
    (3, '2019-12-10', 65000, 'No'),
    (3, '2022-06-30', 72000, 'Yes'),
    (4, '2020-01-05', 45000, 'No'),
    (4, '2021-07-18', 49000, 'No'),
    (5, '2016-07-30', 55000, 'No'),
    (5, '2018-11-22', 62000, 'Yes'),
    (5, '2021-09-10', 75000, 'Yes'),
    (6, '2016-06-30', 55000, 'No'),
    (6, '2017-11-22', 50000, 'No'),
    (6, '2018-11-22', 40000, 'No'),
    (6, '2021-09-10', 75000, 'Yes');

/*
1. Find the latest salary for each employee.
2. Calculate the total number of promotions each employee has received.
3. Determine the maximum salary hike percentage between any two consecutive salary changes for each employee.
4. **Identify employees whose salary has never decreased over time.
5. Find the average time (in months) between salary changes for each employee.
6. Rank employees by their salary growth rate (from first to last recorded salary), breaking ties by earliest join date.

*/

-- 1. Find the latest salary for each employee.
with cte as (
SELECT e.employee_id, name, salary, change_date,
row_number() over(partition by e.employee_id order by change_date desc) rn FROM employees e 
join salary_history sh
ON
e.employee_id = sh.employee_id
)
select * from cte where rn=1;

-- 2. Calculate the total number of promotions each employee has received.
with cte as (
SELECT e.employee_id, name, promotion  FROM employees e 
join salary_history sh
ON
e.employee_id = sh.employee_id)
select employee_id, name, 
count(case when promotion='Yes' THEN 1 END) no_of_promotion from cte
group by employee_id, name;

-- 3. Determine the maximum salary hike percentage between any two consecutive salary changes for each employee.
with cte as (
SELECT e.employee_id, name, salary, change_date,
LAG(salary) OVER(partition by e.employee_id order by change_date) prev_sal 
FROM employees e 
join salary_history sh
ON
e.employee_id = sh.employee_id)
select employee_id, name, 
max(case when prev_sal is not null then Round(((salary-prev_sal)/salary)*100,2) ELSE 0 END) as max_change 
from cte
group by employee_id, name;

