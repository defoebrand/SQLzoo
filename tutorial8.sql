-- List the teachers who have NULL for their department
SELECT name
FROM teacher
WHERE dept IS NULL

-- Note the INNER JOIN misses the teachers with no department and the departments with no teacher
SELECT teacher.name, dept.name
FROM teacher
INNER JOIN dept ON (teacher.dept = dept.id)

-- Use a different JOIN so that all teachers are listed
SELECT teacher.name, dept.name
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id

-- Use a different JOIN so that all departments are listed
SELECT teacher.name, dept.name
FROM dept
LEFT JOIN teacher ON teacher.dept = dept.id

-- Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. Show teacher name and mobile number or '07986 444 2266'
SELECT name, COALESCE(mobile, '07986 444 2266') AS mobile
FROM teacher

-- Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no departments
SELECT teacher.name, COALESCE(dept.name, 'None')
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id

-- Use COUNT to show the number of teachers and the number of mobile phones
SELECT COUNT(name), COUNT(mobile)
FROM teacher

-- Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed
SELECT dept.name, COUNT(teacher.name)
FROM teacher
RIGHT JOIN dept ON dept.id = teacher.dept
GROUP BY dept.name

-- Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise
SELECT name, CASE WHEN dept = 1 OR dept = 2 THEN 'Sci' ELSE 'Art' END dept
FROM teacher

-- Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise
SELECT name, CASE WHEN dept = 1 OR dept = 2 THEN 'Sci' WHEN dept = 3 THEN 'Art' ELSE 'None' END dept
FROM teacher

-- Show the the percentage who STRONGLY AGREE
SELECT A_STRONGLY_AGREE
FROM nss
WHERE question='Q01'
AND institution='Edinburgh Napier University'
AND subject='(8) Computer Science'

-- Show the institution and subject where the score is at least 100 for question 15
SELECT institution, subject
FROM nss
WHERE question='Q15'
AND score >= 100

-- Show the institution and score where the score for '(8) Computer Science' is less than 50 for question 'Q15'
SELECT institution, score
FROM nss
WHERE question='Q15'
AND subject='(8) Computer Science'
AND score < 50

-- Show the subject and total number of students who responded to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'
SELECT subject, SUM(response)
FROM nss
WHERE question='Q22'
AND (subject='(8) Computer Science'
OR subject='(H) Creative Arts and Design')
GROUP BY subject

-- Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'
SELECT subject, (SUM(response*A_STRONGLY_AGREE)/100)
FROM nss
WHERE question='Q22'
AND (subject='(8) Computer Science'
OR subject='(H) Creative Arts and Design')
GROUP BY subject

-- Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'
SELECT subject, ROUND(SUM(response*(A_STRONGLY_AGREE/100))/SUM(response)*100)
FROM nss
WHERE question='Q22'
AND (subject='(8) Computer Science'
OR subject='(H) Creative Arts and Design')
GROUP BY subject

-- Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name
SELECT institution, ROUND(SUM(score*response) / SUM(response))
FROM nss
WHERE question='Q22'
AND (institution LIKE '%Manchester%')
GROUP BY institution

-- Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'
SELECT institution, SUM(sample) AS Tot_Samp, SUM(case when subject = '(8) Computer Science' then sample else 0 END) AS Comp_Stu
FROM nss
WHERE question = 'Q01'
AND (institution LIKE '%Manchester%')
GROUP BY institution
