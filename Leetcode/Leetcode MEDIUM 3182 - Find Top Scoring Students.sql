CREATE TABLE if not exists students (
    student_id INT ,
    name VARCHAR(255),
    major VARCHAR(255)
);
CREATE TABLE  if not exists courses (
    course_id INT ,
    name VARCHAR(255),
    credits INT,
    major VARCHAR(255)
);

CREATE TABLE  if not exists enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(255),
    grade VARCHAR(10)

);
Truncate table students;
insert into students (student_id, name, major) values ('1', 'Alice', 'Computer Science');
insert into students (student_id, name, major) values ('2', 'Bob', 'Computer Science');
insert into students (student_id, name, major) values ('3', 'Charlie', 'Mathematics');
insert into students (student_id, name, major) values ('4', 'David', 'Mathematics');
Truncate table courses;
insert into courses (course_id, name, credits, major) values ('101', 'Algorithms', '3', 'Computer Science');
insert into courses (course_id, name, credits, major) values ('102', 'Data Structures', '3', 'Computer Science');
insert into courses (course_id, name, credits, major) values ('103', 'Calculus', '4', 'Mathematics');
insert into courses (course_id, name, credits, major) values ('104', 'Linear Algebra', '4', 'Mathematics');
Truncate table enrollments;
insert into enrollments (student_id, course_id, semester, grade) values ('1', '101', 'Fall 2023', 'A');
insert into enrollments (student_id, course_id, semester, grade) values ('1', '102', 'Fall 2023', 'A');
insert into enrollments (student_id, course_id, semester, grade) values ('2', '101', 'Fall 2023', 'B');
insert into enrollments (student_id, course_id, semester, grade) values ('2', '102', 'Fall 2023', 'A');
insert into enrollments (student_id, course_id, semester, grade) values ('3', '103', 'Fall 2023', 'A');
insert into enrollments (student_id, course_id, semester, grade) values ('3', '104', 'Fall 2023', 'A');
insert into enrollments (student_id, course_id, semester, grade) values ('4', '103', 'Fall 2023', 'A');
insert into enrollments (student_id, course_id, semester, grade) values ('4', '104', 'Fall 2023', 'B');




-- SOL-1
with student_grade as (
select distinct s.student_id, e.grade from students s left join courses c 
on s.major = c.major
left join enrollments e
on e.student_id = s.student_id and e.course_id = c.course_id)
select student_id  from student_grade where 
student_id not in(select student_id from student_grade where grade='B' ) order by student_id 


-- SOL -2

select  s.student_id from students s left join courses c 
on s.major = c.major
left join enrollments e
on e.student_id = s.student_id and e.course_id = c.course_id
group by s.student_id
having count(s.student_id) = sum(case when e.grade='A' then 1 else 0 end  )
order by s.student_id