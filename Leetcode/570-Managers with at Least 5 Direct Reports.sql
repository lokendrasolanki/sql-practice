/*

Write a solution to find managers with at least five direct reports.

Return the result table in any order.

Output: 
+------+
| name |
+------+
| John |
+------+

*/


 -- Create the Employee table
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department CHAR(1) NOT NULL,
    managerId INT
    
);

-- Insert data into the Employee table
INSERT INTO Employee (id, name, department, managerId) VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101);

INSERT INTO Employee (id, name, department, managerId) VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101),
(111, 'John', 'A', NULL),
(112, 'Dan', 'A', 111),
(113, 'James', 'A', 111),
(114, 'Amy', 'A', 111),
(115, 'Anne', 'A', 111),
(116, 'Ron', 'B', 111);

-- Solution


select e.name from employee e join employee e1
on e.id = e1.managerid group by  e.name, e.id having count(*)>=5
