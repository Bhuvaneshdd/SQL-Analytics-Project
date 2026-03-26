INSERT INTO departments VALUES
(1, 'Computer Science', 'Chennai'),
(2, 'Physics', 'Bangalore'),
(3, 'Mathematics', 'Hyderabad'),
(4, 'Electronics', 'Pune');




INSERT INTO students (
    student_id,
    first_name,
    last_name,
    gender,
    join_date,
    fees,
    department_id
)
SELECT
    1000 + i,

    (ARRAY[
        'Arjun','Amit','Rahul','Kiran','Vikram',
        'Sneha','Priya','Anita','Divya','Neha'
    ])[FLOOR(RANDOM()*10 + 1)],

    (ARRAY[
        'Sharma','Reddy','Nair','Iyer','Verma',
        'Das','Patel','Kumar','Singh','Mehta'
    ])[FLOOR(RANDOM()*10 + 1)],

    CASE WHEN RANDOM() < 0.5 THEN 'Male' ELSE 'Female' END,

    DATE '2020-01-01' + (RANDOM() * 1500)::INT,

    20000 + (RANDOM() * 30000)::INT,

    FLOOR(RANDOM()*4 + 1)
FROM generate_series(1, 200) AS s(i);



INSERT INTO courses (
    course_id,
    course_name,
    credits,
    department_id
)
SELECT
    2000 + i,   -- ✅ guaranteed unique ID

    (ARRAY[
        'Database Systems','Data Structures','Algorithms','Operating Systems',
        'Computer Networks','Machine Learning','Artificial Intelligence',
        'Quantum Mechanics','Thermodynamics','Electromagnetism',
        'Linear Algebra','Statistics','Calculus',
        'Digital Electronics','Microprocessors','Signal Processing'
    ])[FLOOR(RANDOM()*16 + 1)],

    FLOOR(RANDOM()*4 + 2),   -- random credits
    FLOOR(RANDOM()*4 + 1)    -- random department
FROM generate_series(1, 40) AS s(i);



INSERT INTO enrollments (
    enrollment_id,
    student_id,
    course_id,
    enrollment_date
)
SELECT
    5000 + i,

    1001 + ((i - 1) % 200),   -- fixed student range

    2001 + ((i - 1) % 40),    -- correct course range

    DATE '2022-01-01' + (RANDOM() * 365)::INT
FROM generate_series(1, 1000) AS s(i);



select * from enrollments;

delete from courses;


TRUNCATE TABLE courses RESTART IDENTITY CASCADE;



SELECT
    MIN(1000 + ((i - 1) % 200)) AS min_student,
    MAX(1000 + ((i - 1) % 200)) AS max_student,
    MIN(2001 + ((i - 1) % 40)) AS min_course,
    MAX(2001 + ((i - 1) % 40)) AS max_course
FROM generate_series(1, 1000) AS s(i);