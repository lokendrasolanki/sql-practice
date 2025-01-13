/*
able: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.
 

Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.

For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.

For Pandas users, please note that you are supposed to modify Person in place.

After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table. The final order of the Person table does not matter.

The result format is in the following example.

 

Example 1:

Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Output: 
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.

*/
 
 
 CREATE TABLE Person1 (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) 
);

INSERT INTO Person1 (email)
VALUES ('john@example.com'), ('bob@example.com'), ('john@example.com');

-- sol
with remove_dups as(
select *,row_number() over(partition by email order by id asc) rn from person1 )

select id, email from remove_dups where rn=1 order by id;

--for deleting you can write below Query
-- Write your PostgreSQL query statement below
with remove_dups as(
select *,row_number() over(partition by email order by id) rn from person)
 delete from person where id not in (select id from remove_dups where rn=1)

