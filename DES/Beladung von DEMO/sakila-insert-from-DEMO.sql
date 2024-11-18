
ALTER SESSION SET CONSTRAINTS = DEFERRED;

INSERT INTO actor (actor_id, first_name, last_name, last_update, birth_date)
SELECT actor_id, first_name, last_name, last_update, birth_date
FROM demo30.actor;
       
INSERT INTO country (country_id, country, last_update)
SELECT country_id, country, last_update
FROM demo30.country;

INSERT INTO city (city_id, city, country_id, last_update)
SELECT city_id, city, country_id, last_update
FROM demo30.city;
        
INSERT INTO address (address_id, address, address2, district, city_id, postal_code, phone, last_update)
SELECT address_id, address, address2, district, city_id, postal_code, phone, last_update
FROM demo30.address;

INSERT INTO category (category_id, name, last_update)
SELECT category_id, name, last_update
FROM demo30.category;
            
INSERT INTO staff (staff_id, first_name, last_name, address_id, picture, email, store_id, active, username, password, last_update)
SELECT staff_id, first_name, last_name, address_id, picture, email, store_id, active, username, password, last_update
FROM demo30.staff;
                
INSERT INTO store (store_id, manager_staff_id, address_id, last_update)
SELECT store_id, manager_staff_id, address_id, last_update
FROM demo30.store;

INSERT INTO customer (customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
SELECT customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update
FROM demo30.customer;

INSERT INTO language (language_id, name, last_update)
SELECT language_id, name, last_update
FROM demo30.language;

INSERT INTO film (film_id, title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update)
SELECT film_id, title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update
FROM demo30.film;

INSERT INTO film_actor (actor_id, film_id, last_update)
SELECT actor_id, film_id, last_update
FROM demo30.film_actor;

INSERT INTO film_category (film_id, category_id, last_update)
SELECT film_id, category_id, last_update
FROM demo30.film_category;

INSERT INTO inventory (inventory_id, film_id, store_id, last_update)
SELECT inventory_id, film_id, store_id, last_update
FROM demo30.inventory;

INSERT INTO rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
SELECT rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update
FROM demo30.rental;

INSERT INTO payment (payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update)
SELECT payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
FROM demo30.payment;

COMMIT;