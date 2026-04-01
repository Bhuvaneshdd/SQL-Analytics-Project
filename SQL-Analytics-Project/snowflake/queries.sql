-- ================================
-- SNOWFLAKE SQL ANALYTICS QUERIES
-- ================================
--Database: Snowflake
-- Purpose: Analytical queries for student dataset
-- Total Queries: 20

-- Q1: Students with more than 2 enrollments

-- grouping enrollments per student and filtering

SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > 2;



-- Q2: Total students per department (sorted desc)

SELECT
    d.department_name,
    COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_name
ORDER BY total_students DESC;


-- Q3: Students per course with department

SELECT
    c.course_name,
    d.department_name,
    COUNT(e.student_id) AS total_students
FROM courses c
JOIN departments d ON c.department_id = d.department_id
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name, d.department_name;



-- Q4: Students with no enrollments

SELECT
    s.first_name,
    s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;



-- Q5: Students paying above department average

SELECT
    s.*
FROM students s
WHERE s.fees > (
    SELECT AVG(s2.fees)
    FROM students s2
    WHERE s2.department_id = s.department_id
);


-- Q6: Courses without enrollments

SELECT
    c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;



-- Q7: Top 3 departments by avg course credits

SELECT
    d.department_name,
    AVG(c.credits) AS avg_credits
FROM departments d
JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_name
ORDER BY avg_credits DESC
LIMIT 3;



-- Q8: Students whose join year matches first enrollment year

SELECT
    s.student_id,
    s.first_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.join_date
HAVING EXTRACT(YEAR FROM s.join_date) =
       EXTRACT(YEAR FROM MIN(e.enrollment_date));



-- Q9: Earliest enrolled student per department

SELECT
    d.department_name,
    s.first_name,
    e.enrollment_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN departments d ON s.department_id = d.department_id
QUALIFY e.enrollment_date =
        MIN(e.enrollment_date) OVER (PARTITION BY d.department_name);



-- Q10: Department name, course count, avg credits

SELECT
    d.department_name,
    COUNT(c.course_id) AS total_courses,
    AVG(c.credits) AS avg_credits
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_name;



-- Q11: First letter = last letter (case-insensitive)

SELECT
    *
FROM students
WHERE LOWER(SUBSTR(first_name, 1, 1)) =
      LOWER(SUBSTR(first_name, -1, 1));



-- Q12: Students taking courses outside department

SELECT DISTINCT
    s.student_id,
    s.first_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.department_id <> c.department_id;



-- Q13: Students with >= 2 enrollments

SELECT
    s.student_id,
    s.first_name,
    COUNT(e.course_id) AS total_enrollments
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name
HAVING COUNT(e.course_id) >= 2;


-- Q14: DOB < 2000 and course credits > 3

SELECT DISTINCT
    s.first_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.date_of_birth < '2000-01-01'
AND c.credits > 3;



-- Q15: Departments with high average fees

SELECT
    d.department_name
FROM departments d
JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_name
HAVING AVG(s.fees) > 0.8 * (SELECT MAX(fees) FROM students);



-- Q16: Course(s) with highest enrollments

SELECT
    course_id,
    COUNT(*) AS total_students
FROM enrollments
GROUP BY course_id
QUALIFY COUNT(*) = MAX(COUNT(*)) OVER ();



-- Q17: Total credits per student

SELECT
    s.first_name,
    d.department_name,
    SUM(c.credits) AS total_credits
FROM students s
JOIN departments d ON s.department_id = d.department_id
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY s.first_name, d.department_name;


-- Q18: Same last name across different departments

SELECT DISTINCT
    s1.last_name
FROM students s1
JOIN students s2
ON s1.last_name = s2.last_name
AND s1.department_id <> s2.department_id;



-- Q19: Below avg fees and at least one enrollment

SELECT DISTINCT
    s.*
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE s.fees < (SELECT AVG(fees) FROM students);



-- Q20: No course with credits > 3

SELECT
    d.department_name
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_name
HAVING MAX(c.credits) <= 3 OR MAX(c.credits) IS NULL;