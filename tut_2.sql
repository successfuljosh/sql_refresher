-- CREATE DATABASE mydb; 

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);
-- ALTER TABLE employee ADD branch_id INT;
-- ALTER TABLE employee DROP branch_is;
describe employee;

-- ALTER TABLE employee
-- RENAME COLUMN supervisor_id TO super_id;

CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);
DESCRIBE branch;

ALTER TABLE employee
ADD FOREIGN KEY (branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

DESCRIBE employee;

CREATE TABLE client(
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(20),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- inserst into the table
--corporate branch
INSERT INTO employee VALUES(100,'David','Wallace','1967-11-17','M',250000,NULL, NULL);
--fill up the branch the update row
INSERT INTO branch VALUES(1, 'Corporate',100,'2006-02-09');

UPDATE employee SET branch_id=1 WHERE emp_id=100;

--fill up the rest
INSERT INTO employee VALUES(101,'Jane','Levinson','1961-05-11','F',110000,100,1);

--SCRANTON branch
INSERT INTO employee VALUES(102,'Michael','John','1967-10-17','M',290000,NULL, NULL);
--fill up the branch the update row
INSERT INTO branch VALUES(2, 'Scranton',102,'2007-02-09');

UPDATE employee SET branch_id=2 WHERE emp_id=102;

--fill up the rest
INSERT INTO employee VALUES(103,'Sane','Johnson','1961-05-11','M',110000,102,2);

--FILL UP THE branch_supplier
INSERT INTO branch_supplier VALUES(1,'Hammer Mill','Paper');
INSERT INTO branch_supplier VALUES(2,'Jones Mill','Books');
INSERT INTO branch_supplier VALUES(1,'Coss Estein','Furniture');
INSERT INTO branch_supplier VALUES(2,'Arieta Sams','Face Masks');


--FILL UP client
INSERT INTO client VALUES(400,'Dunnore HighSchool',2);
INSERT INTO client VALUES(401,'Taxas Institute',1);
INSERT INTO client VALUES(402,'Dell Computers',2);
INSERT INTO client VALUES(403,'Appledon College',1);

--fill up works_with
INSERT INTO works_with VALUES(100,400,53000);
INSERT INTO works_with VALUES(100,401,510000);
INSERT INTO works_with VALUES(101,400,500000);
INSERT INTO works_with VALUES(103,403,250000);
INSERT INTO works_with VALUES(102,402,830000);


--view tables
SELECT * FROM employee;
SELECT * FROM branch;
SELECT * FROM client;
SELECT * FROM works_with;

--get forenames and surnames of employees
SELECT first_name AS forenames, last_name AS surnames
FROM employee;

--how many unique sex we have
SELECT DISTINCT sex FROM employee;

--number of males and females  (aggregation)
SELECT COUNT(sex), sex FROM employee
GROUP BY sex;
--group employees by sex
SELECT * FROM employee
ORDER BY sex;
--avg salary
SELECT AVG(salary) FROM employee;
--avg male salary
SELECT AVG(salary) FROM employee
WHERE sex='M';
--employees born after 1975
SELECT * FROM employee WHERE birth_day >= '1975-01-01'; 
--find total sales for wach salesman  (aggregation)
SELECT SUM(total_sales),emp_id FROM works_with
GROUP BY emp_id;
--find total spends done by each client  (aggregation)
SELECT SUM(total_sales),client_id FROM works_with
GROUP BY client_id;



--WILDCARDS (getting dat matching a pattern)
-- % represents any number of characters, _ represents only one character
--find clients who are colleges
SELECT * FROM client
WHERE client_name LIKE '%collEge%'; --cases insentitive, this returns clients whose name contains 'college', either before of after

--find any employee born in october
SELECT * FROM employee
WHERE birth_day LIKE '____-10%';  --the four _ represent the year before the month


--UNION
--rules: no of columns and datatypes should match; datatype may not matter :)
--find a list of employees and branch names
SELECT first_name AS Company_Names
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name 
FROM client;

--find list of all clients name and supplier's name
SELECT client_name, client.branch_id FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id FROM branch_supplier;

--find a list of all money spent or earned by the company
SELECT first_name AS Money_Spent_Earned FROM employee
UNION
SELECT total_sales FROM works_with;


--JOIN: COMBINES RESULT FROM DIFFERENT TABLES BASED ON A COMMON COLUMN
--INNER JOIN
--find all branch names and the name of their managers
SELECT branch.branch_name, employee.first_name, employee.emp_id
FROM employee
JOIN branch ON branch.mgr_id=employee.emp_id;


--LEFT JOIN - INCLUDE ALL ROWS FROM THE LEFT
SELECT branch.branch_name, employee.first_name, employee.emp_id
FROM employee
LEFT JOIN branch ON branch.mgr_id=employee.emp_id;

--RIGHT JOIN INCLUDES ALL ROWS FROM THE RIGHT TABLE
SELECT branch.branch_name, employee.first_name, employee.emp_id
FROM employee
RIGHT JOIN branch ON branch.mgr_id=employee.emp_id;

--FULL OUTER JOIN - INCLUDES ALL ROWS IN BOTH LEFT AND RIGHT TABLES
--NOT implemented


--NESTED QUERIES
--find the names of all employees who have sold over 100,000 to a single client
--my method
SELECT employee.first_name, employee.last_name, client_name, total_sales
FROM employee
JOIN
(SELECT emp_id, client_name, total_sales
FROM works_with
JOIN client ON works_with.client_id=client.client_id
WHERE works_with.total_sales > 100000) AS TE
ON employee.emp_id=TE.emp_id;

--another method-- use of IN
SELECT employee.first_name, employee.last_name
FROM employee 
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 100000
);

--find all clients who are handled by the branch that David Manages
--assuming you know David's ID
SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id FROM branch
    WHERE mgr_id=100
    LIMIT 1
);


--DELETING ENTRIES WITH FOREIGN KEYS
--ON DELETE SET NULL SETS THE FOREIGN KEY TO NULL WHEN ITS DELETED FROM THE OTHER TABLE
--ON DELETE CASCADE ALSO DELETES THE ENTRY IN THE TABLE WHEN ITS DELETED FROM THE OTHER TABLE
delete from employee where emp_id=102;
select * from branch;
select * from employee;




