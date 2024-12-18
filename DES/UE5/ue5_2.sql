DROP TABLE new_rental;
DROP TABLE new_customer;

CREATE TABLE new_rental AS
SELECT *
FROM rental;
ALTER TABLE new_rental ADD CONSTRAINT new_rental_pk PRIMARY KEY  (rental_id);

CREATE TABLE new_customer (customer_id, store_id NULL, first_name, last_name, email, address_id NULL, active, create_date, last_update) AS
SELECT *
FROM customer;

ALTER TABLE new_customer ADD CONSTRAINT new_customer_pk PRIMARY KEY  (customer_id);
