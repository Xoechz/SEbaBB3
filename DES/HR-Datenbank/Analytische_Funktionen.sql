-- Ergründen Sie was abgefragt wird für die folgenden analytischen Abfragen.
-- Was soll abgefragt werden?
-- Wie sieht das Ergebnis aus?

-- HR
-- der Mitarbeiter mit dem frühesten Einstellungsdatum in jeder Abteilung
SELECT first_name, last_name, hire_date, department_id
FROM employees e1
WHERE hire_date = (SELECT MIN(hire_date)
                   FROM employees e2
                   WHERE e1.department_id = e2.department_id);

-- alle Mitarbeiter und das Einstellungsdatum des Mitarbeiters mit dem frühesten Einstellungsdatum in der Abteilung
SELECT first_name, last_name, hire_date, department_id, MIN(hire_date) OVER (PARTITION BY department_id) AS minHireDate
FROM employees;

-- nur die Mitarbeiter mit dem frühesten Einstellungsdatum in der Abteilung
SELECT first_name, last_name, hire_date, department_id
FROM (
  SELECT first_name, last_name, hire_date, department_id, MIN(hire_date) OVER (PARTITION BY department_id) AS minHireDate
  FROM employees
)
WHERE hire_date = minHireDate;

-- Gehaltsrang innerhalb der Abteilung, dense rank würde nach zwei 2. Plätzen den 3. Platz vergeben während rank den 4. Platz vergeben würde
SELECT first_name, last_name, salary, department_id,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS gehaltsrang,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS gehaltsrangdense
FROM employees;

-- Teilt die Mitarbeiter gehaltsmäßig in 4 Quartile ein
SELECT first_name, last_name, salary, NTILE(4) OVER (ORDER BY salary) AS percent_rank
FROM employees;

-- Gibt die kumulierte Summe der Gehälter der Mitarbeiter bis zu ihrem Einstellungsdatum, die kumulierte Summe der Gehälter der Mitarbeiter innerhalb ihres Einstiegsjahres und den Durchschnitt des Gehalts der Mitarbeiter direkt vor und nach ihrem Einstellungsdatum aus
SELECT first_name, last_name, hire_date, salary,
       SUM(salary) OVER (ORDER BY hire_date) AS cumSum,
       SUM(salary) OVER (PARTITION BY TRUNC(hire_date, 'y') ORDER BY hire_date) AS cumSumWithinYear,
       ROUND(AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 2) AS avgBeforeAfter
FROM employees;

