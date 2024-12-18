-- Teilweise ist es notwendig, den Check bestimmter Constraints zu verschieben;
-- bekannt unter "Henne-Ei"-Problem:
-- Achtung: Fehlermeldung
CREATE TABLE chicken
(
    cID INT PRIMARY KEY,
    eID INT
);
CREATE TABLE egg
(
    eID INT PRIMARY KEY,
    cID INT REFERENCES chicken (cID) ON DELETE CASCADE INITIALLY DEFERRED
);
ALTER TABLE chicken
    ADD CONSTRAINT fk_chicken_egg FOREIGN KEY (eID) REFERENCES egg (eID) ON DELETE CASCADE INITIALLY DEFERRED;

INSERT INTO chicken
VALUES (1, 2);
INSERT INTO egg
VALUES (2, 1);
COMMIT;

SELECT *
FROM chicken;
SELECT *
FROM egg;

DELETE
FROM chicken
WHERE cID = 1;

SELECT *
FROM chicken;
SELECT *
FROM egg;

ALTER TABLE chicken
    DROP CONSTRAINT fk_chicken_egg;
DROP TABLE egg;
DROP TABLE chicken;
