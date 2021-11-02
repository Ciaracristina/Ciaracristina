CREATE DATABASE Guided_reading;

USE Guided_reading;

CREATE TABLE Students (
Student_id VARCHAR(10) NOT NULL,
Name VARCHAR(50) NOT NULL,
Surname VARCHAR(50) NOT NULL,
CONSTRAINT
pk_Student_id
PRIMARY KEY
(Student_id));

CREATE TABLE Teachers (
Teacher_id VARCHAR(10) NOT NULL,
Name VARCHAR(50) NOT NULL,
CONSTRAINT
pk_Teacher_id
PRIMARY KEY
(Teacher_id));

CREATE TABLE Books (
Book_id VARCHAR(10) NOT NULL,
Book VARCHAR(50) NOT NULL,
Level INTEGER NOT NULL,
CONSTRAINT
pk_Book_id
PRIMARY KEY
(Book_id));

CREATE TABLE Reading_groups (
Group_id INTEGER NOT NULL,
Student_id VARCHAR(10) NOT NULL,
Book_id VARCHAR(10) NOT NULL,
Teacher_id VARCHAR(10) NOT NULL);

CREATE TABLE Results (
Student_id VARCHAR(10) NOT NULL,
Progression INTEGER NOT NULL,
Date DATE NOT NULL);

ALTER TABLE Results
ADD CONSTRAINT
fk_student_id
FOREIGN KEY (Student_id)
REFERENCES 
Students (Student_id);

ALTER TABLE Reading_groups
ADD CONSTRAINT
fk2_student_id
FOREIGN KEY (Student_id)
REFERENCES 
Students (Student_id);

ALTER TABLE Reading_groups
ADD CONSTRAINT
fk1_book_id
FOREIGN KEY (book_id)
REFERENCES 
Books (Book_id);

ALTER TABLE Students 
DROP COLUMN Groups_id;

ALTER TABLE Reading_groups
DROP COLUMN Groups_id;

INSERT INTO Books
(Book_id, Book, Level)
VALUES
('B1', 'A Crown for Lion', 6),
('B2', 'The Great Pie Lie', 7),
('B3', 'The Fixer', 8),
('B4', 'Lollylegs', 9),
('B5','Jetpack Jelly', 10),
('B6', 'Billy Swift and Bears on the Brain', 11),
('B7', 'A Horse Made of Marshmallow', 12);

INSERT INTO Teachers
(Teacher_id, Name)
VALUES
('T1', 'Miss Chapple'),
('T2', 'Ms Calle'),
('T3', 'Mr Davies'),
('T4', 'Mrs Mouna');

INSERT INTO Students
(Student_id, Name, Surname)
VALUES
('S1', 'Conor', 'Heaney'),
('S2', 'Sarah', 'Wood'),
('S3', 'Rachel', 'Lewis'),
('S4', 'Mark', 'Heaney'),
('S5', 'Oliver', 'Johnson'),
('S6', 'Margot', 'McCracken'),
('S7', 'Hannah', 'Frazer'),
('S8', 'Stefan', 'Rooney'),
('S9', 'Leo', 'Beeston'),
('S10', 'Soraya', 'Patience');

INSERT INTO Reading_groups
(Group_id, Student_id, Book_id, Teacher_id)
VALUES
(1, 'S1', 'B3', 'T1'),
(1, 'S2', 'B3', 'T1'),
(1, 'S3', 'B3', 'T1'),
(1, 'S4', 'B3', 'T1'),
(2, 'S5', 'B4', 'T3');

INSERT INTO Reading_groups
(Group_id, Student_id, Book_id, Teacher_id)
VALUES
(2, 'S6', 'B4', 'T3'),
(2, 'S7', 'B4', 'T3'),
(2, 'S8', 'B4', 'T3'),
(3, 'S9', 'B6', 'T2'),
(3, 'S10', 'B6', 'T2');

INSERT INTO Results
(Student_id, Progression, Date)
VALUES
('S1', 2, '2021-09-07'),
('S2', 1, '2021-09-07'),
('S3', 0, '2021-09-07'),
('S4', 2, '2021-09-07'),
('S5', 3, '2021-09-07'),
('S6', 0, '2021-09-07'),
('S7', 1, '2021-09-07'),
('S8', 4, '2021-09-07'),
('S9', 1, '2021-09-07'),
('S10', 2, '2021-09-07'),
('S1', 2, '2021-09-15'),
('S2', 2, '2021-09-15'),
('S3', 1, '2021-09-15'),
('S4', 3, '2021-09-15'),
('S5', 2, '2021-09-15'),
('S6', 2, '2021-09-15'),
('S7', 1, '2021-09-15'),
('S8', 3, '2021-09-15'),
('S9', 3, '2021-09-15'),
('S10', 1, '2021-09-15'),
('S1', 1, '2021-09-23'),
('S2', 1, '2021-09-23'),
('S3', 1, '2021-09-23'),
('S4', 1, '2021-09-23'),
('S5', 2, '2021-09-23'),
('S6', 2, '2021-09-23'),
('S7', 2, '2021-09-23'),
('S8', 4, '2021-09-23'),
('S9', 2, '2021-09-23'),
('S10', 1, '2021-09-23');

ALTER TABLE Results
ADD CONSTRAINT
fk3_student_id
FOREIGN KEY (Student_id)
REFERENCES 
Students (Student_id);

ALTER TABLE Reading_groups
ADD CONSTRAINT
fk_teacher_id
FOREIGN KEY (Teacher_id)
REFERENCES 
Teachers (Teacher_id);



-- Join -- The names of all the children in Group 1 --

SELECT s.name, gr.group_id
FROM Students s
INNER JOIN Reading_groups gr
ON s.student_id = gr.student_id
WHERE gr.group_id = '1';



-- Find the name, surname, book, teacher and group id of the student S4.

SELECT s.name, s.surname, b.book, t.name, rg.group_id
FROM Reading_groups rg
JOIN Students s ON s.student_id = rg.student_id
JOIN Books b ON b.book_id = rg.book_id
JOIN Teachers t ON t.teacher_id = rg.teacher_id
WHERE rg.student_id = 's4';



-- Stored function - If children make more than 3 points progress are they eligible to move up a group?

DELIMITER //
CREATE FUNCTION Group_progression(
	Progression INT)
Returns VARCHAR(20)
   DETERMINISTIC
   BEGIN
   DECLARE group_change VARCHAR(20);
   IF Progression > 3 THEN
   SET group_change = 'YES';
   ELSEIF Progression >= 3 THEN
   SET group_change = 'MAYBE';
   ELSEIF Progression < 3 THEN
   SET group_change = 'NO';
   END IF;
   RETURN(group_change);
   END //
   DELIMITER ;
   
   SELECT * FROM Results;
   
   SELECT
   Student_id,
   Progression,
   Date,
   Group_progression(progression)
   FROM Results;

   
   
-- Subquery - Show the names and surnames of students who made a progression of 3 points in reading.
   
   SELECT s.name, s.surname
   FROM Students s
   WHERE s.student_id IN(
   SELECT r.student_id
   FROM Results r
   WHERE Progression = 3);
   
   
   
-- Group by - The total number of points progression made by each student.
   
SELECT r.student_id, SUM(r.progression)
FROM Results r
GROUP BY r.student_id;



-- Group by and having - The students who made a total of 3 points progression or more.

SELECT r.student_id, SUM(r.progression)
FROM Results r
GROUP BY r.student_id
HAVING SUM(r.progression) >= 3;



-- View showing the book names and levels.

CREATE VIEW Book_levels
AS
SELECT b.book, b.level
FROM Books b;



-- View showing student names, groups and teacher.

CREATE VIEW Student_info
AS
SELECT s.name, s.surname, rg.group_id, t.name AS teacher_name
FROM Students s
JOIN Reading_groups rg ON rg.student_id = s.student_id
JOIN Teachers t ON rg.teacher_id = t.teacher_id;


SELECT name, teacher_name
FROM Student_info;Students



-- Stored procedure - Rating book difficulty


DELIMITER //
CREATE PROCEDURE Book_difficulty
(IN Book_id VARCHAR(10),
IN Book_name VARCHAR(50),
IN Difficutly INT)
BEGIN
INSERT INTO Book_difficulty
(book_id, book_name, difficulty)
VALUES
('B1', 'A Crown for Lion', 2),
('B2', 'The Great Pie Lie', 1),
('B3', 'The Fixer', 3),
('B4', 'Lollylegs', 4),
('B5','Jetpack Jelly', 1),
('B6', 'Billy Swift and Bears on the Brain', 3),
('B7', 'A Horse Made of Marshmallow', 2);
END //
DELIMITER ;






   
   
   
   
   
   
   