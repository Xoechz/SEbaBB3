-- 1
SELECT AVG(r.Rating) AS AverageRating
FROM Teacher t
INNER JOIN Rating r
	ON r.EntityId = t.EntityId
WHERE t.Name = 'Bernhard Werth';

-- 2
-- SemesterCourse has a combined PK of CourseId(from Course EntityId) and Semester
SELECT a.FilePath
	,a.DATE
	,a.IsLectureExam
FROM Assignment a
INNER JOIN Course c
	ON a.CourseId = c.EntityId
WHERE a.Semester = "WS2023"
	AND c.Name = "DSE3UE";

-- 3
SELECT AVG(g.Grade) AS AverageGrade
FROM Grade g
INNER JOIN Assignment a
	ON g.AssignmentId = a.EntityId
INNER JOIN Course c
	ON a.CourseId = c.EntityId
WHERE c.Name = "AMS4UE";

-- 4
SELECT s.FilePath
	,s.TEXT
FROM Solution s
INNER JOIN Assignment a
	ON s.AssignmentId = a.EntityId
INNER JOIN Course c
	ON a.CourseId = c.EntityId
WHERE c.Name = "DES3VL"
ORDER BY s.DATE DESC;

-- 5
SELECT Count(*)
FROM Grade g
INNER JOIN User u
	ON g.UserId = u.UserId
WHERE u.Nickname = 'Anon'
