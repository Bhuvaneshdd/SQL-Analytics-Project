select * from students;

select *from enrollments

select * from courses


select * from departments

--------------------------------------------------------------------------------------------

--Q1 : Display all student details who belong to the Computer Science department.

-- students who belong to computer science department
-- join with departments to filter by department name

SELECT s.*
FROM students s
JOIN departments d
  ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science';


--Q2 : 2. List the first name, last name, and course name for all students enrolled in any course.

-- showing student names with the courses they enrolled in
-- enrollments table connects students and courses

SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM students s
JOIN enrollments e
  ON s.student_id = e.student_id
JOIN courses c
  ON e.course_id = c.course_id;



--Q3 : Show all female students who joined after ‘2022-01-01’.

-- female students who joined after 1 Jan 2022

SELECT first_name, last_name, join_date 
FROM students
WHERE gender = 'Female' AND join_date > '2022-01-01';



--Q4 : Retrieve students whose first name starts with ‘A’.

-- students whose first name begins with A
SELECT first_name, last_name 
FROM students
WHERE first_name LIKE 'A%';

--Q5 : List all students whose fees are between 25000 and 35000.


-- students whose fees fall within the given range
SELECT first_name, last_name 
FROM students
WHERE fees BETWEEN 25000 AND 35000;

--Q6 : Display all students not enrolled in any course.

-- students who did not enroll in any course
SELECT s.*
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;




SELECT * from students


--Q7 : Find the total number of students in each department.


-- counting how many students are in each department
-- join is used to show the department name instead of id
SELECT d.department_name,COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s
  ON d.department_id = s.department_id
GROUP BY d.department_name
ORDER BY d.department_name;


--Q8 : 8. Display the average fees paid by students department-wise.


-- average fees paid by students in each department
-- starting from departments so empty departments are also shown

SELECT d.department_name, round(avg(s.fees),2) AS avg_fees
FROM departments d
LEFT JOIN students s
  ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;



--Q9 : Find the maximum and minimum course credits for each department.

-- max and min credits offered in each department

select d.department_name,max(c.credits) as max_credits, min(c.credits) as min_credits
from departments d
left join courses c
  on d.department_id = c.department_id
group by d.department_id, d.department_name
order by d.department_id;


--Q10 : 10. Show the count of male and female students in each department.

-- counting male and female students in each department

SELECT d.department_name,
    (SELECT COUNT(*) FROM students s
        WHERE s.department_id = d.department_id
            AND s.gender = 'Male')   as  male_count,
    (SELECT COUNT(*) FROM students s
        WHERE s.department_id = d.department_id
            AND s.gender = 'Female') as female_count
FROM departments d;

--Q11 : 11. Find how many students joined in each year.

-- counting number of students who joined in each year
-- extract used to get year from join_date

SELECT
    EXTRACT(YEAR FROM join_date) AS join_year,
    COUNT(*) AS total_students
FROM students
GROUP BY join_year
ORDER BY join_year;

-- Q12: Total enrollments per course

-- joining courses with enrollments and counting
SELECT
    c.course_name,
    COUNT(e.enrollment_id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY c.course_name;

-- Q13: Student name, department, and location

-- joining students with departments

SELECT
    s.first_name,
    d.department_name,
    d.location
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Q14: Courses taken by Physics students

-- joining students, enrollments, courses, and departments

SELECT DISTINCT
    c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN departments d ON s.department_id = d.department_id
WHERE d.department_name = 'Physics';

-- Q15: Number of courses per student

-- counting courses per student

SELECT
    s.first_name,
    COUNT(e.course_id) AS total_courses
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name
ORDER BY s.first_name;

-- Q16: Students per course with department

-- joining courses, departments, and enrollments

SELECT
    c.course_name,
    d.department_name,
    COUNT(e.student_id) AS total_students
FROM courses c
JOIN departments d ON c.department_id = d.department_id
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name, d.department_name
ORDER BY c.course_name;

-- Q17: Students taking courses outside their department

-- comparing student department with course department

SELECT DISTINCT
    s.first_name,
    s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.department_id <> c.department_id;

-- Q18: Students with above-average fees

-- using subquery to get average fees

SELECT
    *
FROM students
WHERE fees > (
    SELECT AVG(fees)
    FROM students
);


-- Q19: Courses with enrollments greater than average

-- comparing course enrollment count with average

SELECT
    course_id,
    COUNT(*) AS total_enrollments
FROM enrollments
GROUP BY course_id
HAVING COUNT(*) > (
    SELECT AVG(course_count)
    FROM (
        SELECT COUNT(*) AS course_count
        FROM enrollments
        GROUP BY course_id
    ) AS avg_table
);

-- Q20: Students with highest fees

-- finding maximum fees and matching

SELECT
    *
FROM students
WHERE fees = (
    SELECT MAX(fees)
    FROM students
);