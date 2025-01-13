 /*
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
 

Write a solution to find the employees who earn more than their managers.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
Output: 
+----------+
| Employee |
+----------+
| Joe      |
+----------+
Explanation: Joe is the only employee who earns more than his manager.
 */

 -- Create the Employee table
CREATE TABLE Employee_1 (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    managerId INT
);

-- Insert data into the Employee table
INSERT INTO Employee_1 (id, name, salary, managerId) VALUES
    (3, 'Sam', 60000, NULL),
    (4, 'Max', 90000, NULL),
    (1, 'Joe', 70000, 3),
    (2, 'Henry', 80000, 4);


with cte as(
	select e1.name as emp_name, e2.name as manager_name, e1.salary emp_sal, e2.salary manager_sal from employee_1 e1
	cross join employee_1 e2 where e2.id = e1.managerId-- and  manager_id is null
	)

	select emp_name as Employee from cte where emp_sal>manager_Sal
	