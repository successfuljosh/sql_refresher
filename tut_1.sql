-- Drop DATABASE mydb;
CREATE DATABASE mydb; #you run this via the command line client

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    major VARCHAR(20) DEFAULT 'Undecided'
    -- major VARCHAR(20) DEFAULT 'Undecided' UNIQUE
);

DESCRIBE student;
-- DROP TABLE student;
-- ALTER TABLE student ADD gpa DECIMAL(3,2);
-- ALTER TABLE student DROP gpa;

INSERT INTO student VALUES (1,'Jackson','Biology');
INSERT INTO student VALUES (2,'Jackson',NULL);
INSERT INTO student(name, major) VALUES ('Kate','Sociology');
INSERT INTO student(name, major) VALUES ('Bayo','Mathematics');
INSERT INTO student(name) VALUES ('Salami');

UPDATE student SET major = 'Geography' WHERE major = 'Undecided';
UPDATE student SET major = 'Geography', name='LazyTom' WHERE major = 'Undecided';
UPDATE student SET major = 'Undecided' WHERE student_id = 2;

-- DELETE FROM student;
DELETE FROM student WHERE student_id = 3 AND major ='Undecided';



SELECT * FROM student;
SELECT name FROM student;
SELECT student.name, student.major FROM student;
SELECT name, major
 FROM student
 ORDER BY name DESC;

 SELECT * FROM student ORDER BY student_id DESC;
  SELECT * FROM student ORDER BY major, student_id DESC;
  SELECT * FROM student ORDER BY major DESC, student_id;

SELECT * FROM student LIMIT 2;

SELECT name, major FROM student 
WHERE major='Biology' OR major='Geography'
ORDER BY name ASC, major DESC
LIMIT 2;
-- > < = <= >= <> AND OR

SELECT * FROM student 
WHERE major IN('Biology','Geography');
