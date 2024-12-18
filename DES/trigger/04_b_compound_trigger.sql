DROP TABLE myemps;

CREATE TABLE myemps (
employee_id NUMBER(6,0) PRIMARY KEY,
manager_id NUMBER(6,0) REFERENCES myemps(employee_id),
salary NUMBER
);

INSERT INTO myemps VALUES (1, NULL, 3000);
INSERT INTO myemps VALUES (2, 1, 1000);
INSERT INTO myemps VALUES (3, 2, 1500);
INSERT INTO myemps VALUES (4, 2, 2000);
COMMIT;

--CREATE OR REPLACE TRIGGER propagate_sal
--TODO
--/


--Test Cases
SELECT* FROM myemps;
UPDATE myemps SET salary= salary + 200 WHERE employee_id=4;
SELECT* FROM myemps;
ROLLBACK;

UPDATE myemps SET salary= salary - 200 WHERE employee_id=4;
SELECT* FROM myemps;
ROLLBACK;

UPDATE myemps SET salary= salary + 200 WHERE employee_id>2;
SELECT* FROM myemps;
ROLLBACK;

UPDATE myemps SET salary= salary + 200;
SELECT* FROM myemps;
ROLLBACK;

UPDATE myemps SET salary= salary + CASE WHEN employee_id=2 THEN 1000 ELSE 200 END WHERE employee_id>1;
SELECT* FROM myemps;
ROLLBACK;

DROP TRIGGER propagate_sal; 