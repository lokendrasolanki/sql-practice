 /*
 able: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
 */


-- Create the Logs table
CREATE TABLE Logs (
    id INT PRIMARY KEY,
    num INT
);

-- Insert data into the Logs table
INSERT INTO Logs (id, num) VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 1),
    (6, 2),
    (7, 2);


 -- SOL
with cte as(
 select id, num,lead(num, 1) over() as first_no,  lead(num, 2) over() as secound_no from logs
 )
 select distinct num as ConsecutiveNums from cte where num=first_no and first_no=secound_no