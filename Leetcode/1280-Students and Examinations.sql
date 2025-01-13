/*

Write a solution to find the number of times each student attended each exam.

Return the result table ordered by student_id and subject_name.

Output: 
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+

*/
-- Create the Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL
);

-- Insert data into the Students table
INSERT INTO Students (student_id, student_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(13, 'John'),
(6, 'Alex');

-- Create the Subjects table
CREATE TABLE Subjects (
    subject_name VARCHAR(50) PRIMARY KEY
);

-- Insert data into the Subjects table
INSERT INTO Subjects (subject_name) VALUES
('Math'),
('Physics'),
('Programming');

-- Create the Examinations table
CREATE TABLE Examinations (
    student_id INT,
    subject_name VARCHAR(50)
);

-- Insert data into the Examinations table
INSERT INTO Examinations (student_id, subject_name) VALUES
(1, 'Math'),
(1, 'Physics'),
(1, 'Programming'),
(2, 'Programming'),
(1, 'Physics'),
(1, 'Math'),
(13, 'Math'),
(13, 'Programming'),
(13, 'Physics'),
(2, 'Math'),
(1, 'Math');


with cte as (
select * from practice.students st cross join practice.subjects s )
select st.student_id,st.student_name, st.subject_name,
count(e.subject_name) as cnt
from cte st left join practice.examinations e
on st.student_id = e.student_id and st.subject_name=e.subject_name
group by st.student_id,st.student_name, st.subject_name order by st.student_id,st.student_name