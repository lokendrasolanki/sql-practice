/*
Find the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.

Return the result table in any order.

The result format is in the following example.

Input: 
Salary table:
+----+-------------+--------+------------+
| id | employee_id | amount | pay_date   |
+----+-------------+--------+------------+
| 1  | 1           | 9000   | 2017/03/31 |
| 2  | 2           | 6000   | 2017/03/31 |
| 3  | 3           | 10000  | 2017/03/31 |
| 4  | 1           | 7000   | 2017/02/28 |
| 5  | 2           | 6000   | 2017/02/28 |
| 6  | 3           | 8000   | 2017/02/28 |
+----+-------------+--------+------------+
Employee table:
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 2             |
| 3           | 2             |
+-------------+---------------+
Output: 
+-----------+---------------+------------+
| pay_month | department_id | comparison |
+-----------+---------------+------------+
| 2017-02   | 1             | same       |
| 2017-03   | 1             | higher     |
| 2017-02   | 2             | same       |
| 2017-03   | 2             | lower      |
+-----------+---------------+------------+
Explanation: 
In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.

With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.

*/

drop table if exists Employee;

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    department_id INT
);


drop table if exists Salary;
CREATE TABLE Salary (
    id INT PRIMARY KEY,
    employee_id INT, 
    amount DECIMAL(10, 2),  
    pay_date DATE
);

-- Insert data into the Employee table
INSERT INTO Employee (employee_id, department_id) VALUES
(1, 1),
(2, 2),
(3, 2);

-- Insert data into the Salary table
INSERT INTO Salary (id, employee_id, amount, pay_date) VALUES
(1, 1, 9000, '2017-03-31'),  -- Use YYYY-MM-DD format for dates
(2, 2, 6000, '2017-03-31'),
(3, 3, 10000, '2017-03-31'),
(4, 1, 7000, '2017-02-28'),
(5, 2, 6000, '2017-02-28'),
(6, 3, 8000, '2017-02-28');

with cte as(
select to_char( pay_date, 'YYYY-MM') as pay_date,
e.department_id, s.employee_id, s.amount, 
avg(amount) over(partition by to_char( pay_date, 'YYYY-MM')) avg_salary  
from salary s  
INNER JOIN Employee e
on s.employee_id = e.employee_id
),
cte1 as (
select pay_date, department_id, 
sum(amount) total_amount, 
sum(avg_salary) total_avg_salary  from cte group by pay_date, department_id
)
select pay_date, department_id, 
case when total_amount=total_avg_salary then 'same'
when total_amount>total_avg_salary then 'higher'
else 'lower' end as comparison 
from cte1
order by department_id