#makes references to the employees table
#the trigger script is executed from the command line client
CREATE TABLE trigger_test_logger (
    LOG VARCHAR(50)
);
SELECT * FROM trigger_test_logger;

-- CREATE TRIGGERS. SHOULD BE DONE FROM THE SQL CLIENT CMD LINE
use mydb
DELIMITER $$
CREATE TRIGGER my_trigger BEFORE INSERT ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test_logger VALUES('added new employee');
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER my_trigger1 BEFORE INSERT ON employee
    FOR EACH ROW BEGIN
    -- USE THE NEW VALUE ATTRIBUTES
        INSERT INTO trigger_test_logger VALUES(NEW.first_name);
    END $$
DELIMITER ;


-- TEST trigger script BY INSERTING NTO employee
INSERT INTO employee VALUES(102,'Ballister','Hannibal','1967-11-17','F',25000,NULL, NULL);

select * from employee;
select * from trigger_test_logger;

DELIMITER $$
CREATE TRIGGER my_trigger2 AFTER DELETE ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test_logger VALUES('employee deleted');
    END $$

CREATE TRIGGER my_trigger3 AFTER INSERT ON employee
    FOR EACH ROW BEGIN
        IF NEW.sex='M' THEN
            INSERT INTO trigger_test_logger VALUES('Male employee inserted');
        ELSEIF NEW.sex='F' THEN
            INSERT INTO trigger_test_logger VALUES('Female employee inserted');
        ELSE
            INSERT INTO trigger_test_logger VALUES('Unknown Gender employee inserted');
        END IF;
    END $$
DELIMITER ;


DELETE FROM employee WHERE emp_id = 102;
select * from trigger_test_logger;
INSERT INTO employee VALUES(102,'Ballister','Hannibal','1967-11-17','F',25000,NULL, NULL);
select * from trigger_test_logger;

--DELETE TRIGGERS
DROP TRIGGER my_trigger