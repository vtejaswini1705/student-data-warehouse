-- Example SQL Queries for Institutional Reporting

-- 1. Enrollment by Academic Year and Program
SELECT admission_year, major, COUNT(*) AS total_students
FROM Students
GROUP BY admission_year, major
ORDER BY admission_year, major;

-- 2. Retention: Students who persisted to the next year
SELECT s.admission_year, COUNT(DISTINCT s.student_id) AS cohort_size,
       COUNT(DISTINCT e.student_id) AS retained_students,
       ROUND((COUNT(DISTINCT e.student_id) * 100.0 / COUNT(DISTINCT s.student_id)), 2) AS retention_rate
FROM Students s
LEFT JOIN Enrollment e
    ON s.student_id = e.student_id
    AND e.term LIKE 'Fall2022'
WHERE s.admission_year = 2021
GROUP BY s.admission_year;

-- 3. Graduation Outcomes (mocked by grade = 'A' in final year course)
SELECT s.major, COUNT(DISTINCT s.student_id) AS total_students,
       SUM(CASE WHEN e.grade = 'A' THEN 1 ELSE 0 END) AS graduated_students,
       ROUND((SUM(CASE WHEN e.grade = 'A' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.student_id)), 2) AS graduation_rate
FROM Students s
LEFT JOIN Enrollment e
    ON s.student_id = e.student_id
GROUP BY s.major;

-- 4. Course Enrollment Counts
SELECT c.course_code, c.course_name, COUNT(e.student_id) AS total_enrolled
FROM Courses c
LEFT JOIN Enrollment e
    ON c.course_id = e.course_id
GROUP BY c.course_code, c.course_name
ORDER BY total_enrolled DESC;
