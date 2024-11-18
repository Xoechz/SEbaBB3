-- Sakila Sample Database Schema
-- Version 0.8

-- Copyright (c) 2006, MySQL AB
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

--  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--  * Neither the name of MySQL AB nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



--
-- Table structure for table actor
--

CREATE TABLE actor (
  actor_id INTEGER NOT NULL,
  first_name VARCHAR2(45) NOT NULL,
  last_name VARCHAR2(45) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  birth_date DATE,
  CONSTRAINT actor_pk PRIMARY KEY (actor_id)
);


--
-- Table structure for table country
--

CREATE TABLE country (
  country_id INTEGER NOT NULL,
  country VARCHAR2(50) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT country_pk PRIMARY KEY  (country_id)
);

--
-- Table structure for table city
--

CREATE TABLE city (
  city_id INTEGER NOT NULL,
  city VARCHAR2(50) NOT NULL,
  country_id INTEGER NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT city_pk PRIMARY KEY  (city_id),
  CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES country (country_id) DEFERRABLE
);

--
-- Table structure for table address
--

CREATE TABLE address (
  address_id INTEGER NOT NULL,
  address VARCHAR2(50) NOT NULL,
  address2 VARCHAR2(50) DEFAULT NULL,
  district VARCHAR2(40),
  city_id INTEGER NOT NULL,
  postal_code VARCHAR2(10),
  phone VARCHAR2(40),
  last_update TIMESTAMP,
  CONSTRAINT address_pk PRIMARY KEY  (address_id),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) DEFERRABLE
);

--
-- Table structure for table category
--

CREATE TABLE category (
  category_id INTEGER NOT NULL,
  name VARCHAR2(25) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT category_pk PRIMARY KEY  (category_id)
);
      
                                 
--
-- Table structure for table staff
--

CREATE TABLE staff (
  staff_id INTEGER NOT NULL,
  first_name VARCHAR2(45) NOT NULL,
  last_name VARCHAR2(45) NOT NULL,
  address_id INTEGER NOT NULL,
  picture BLOB DEFAULT NULL,
  email VARCHAR2(50) DEFAULT NULL,
  store_id INTEGER NOT NULL,
  active INTEGER,
  username VARCHAR2(16) NOT NULL,
  password VARCHAR2(40),
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT staff_pk PRIMARY KEY  (staff_id),
  CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) DEFERRABLE
);

--
-- Table structure for table store
--

CREATE TABLE store (
  store_id INTEGER NOT NULL,
  manager_staff_id INTEGER NOT NULL,
  address_id INTEGER NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT store_pk PRIMARY KEY  (store_id),
  CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) DEFERRABLE,
  CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) DEFERRABLE
);

ALTER TABLE staff ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) DEFERRABLE;

--
-- Table structure for table customer
--

CREATE TABLE customer (
  customer_id INTEGER NOT NULL,
  store_id INTEGER NOT NULL,
  first_name VARCHAR2(45) NOT NULL,
  last_name VARCHAR2(45) NOT NULL,
  email VARCHAR2(50) DEFAULT NULL,
  address_id INTEGER NOT NULL,
  active INTEGER,
  create_date DATE NOT NULL,
  last_update TIMESTAMP,
  CONSTRAINT customer_pk PRIMARY KEY  (customer_id),
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) DEFERRABLE,
  CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) DEFERRABLE
);

--
-- Table structure for table language
--

CREATE TABLE language (
  language_id INTEGER NOT NULL,
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT language_pk PRIMARY KEY (language_id)
);

--
-- Table structure for table film
--

CREATE TABLE film (
  film_id INTEGER NOT NULL,
  title VARCHAR2(255) NOT NULL,
  description VARCHAR2(255),
  release_year INTEGER,
  language_id INTEGER NOT NULL,
  original_language_id INTEGER,
  rental_duration INTEGER NOT NULL,
  rental_rate DECIMAL(4,2) NOT NULL,
  length INTEGER DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL,
  rating VARCHAR2(20),
  special_features VARCHAR2(255),
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT film_pk PRIMARY KEY  (film_id),
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) DEFERRABLE,
  CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) DEFERRABLE
);

--
-- Table structure for table film_actor
--

CREATE TABLE film_actor (
  actor_id INTEGER NOT NULL,
  film_id INTEGER NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT film_actor_pk PRIMARY KEY  (actor_id,film_id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) DEFERRABLE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) DEFERRABLE
);

--
-- Table structure for table film_category
--

CREATE TABLE film_category (
  film_id INTEGER NOT NULL,
  category_id INTEGER NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT film_category_pk PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) DEFERRABLE,
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) DEFERRABLE
);

--
-- Table structure for table inventory
--

CREATE TABLE inventory (
  inventory_id INTEGER NOT NULL,
  film_id INTEGER NOT NULL,
  store_id INTEGER NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT inventory_pk PRIMARY KEY  (inventory_id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) DEFERRABLE,
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) DEFERRABLE
);


--
-- Table structure for table rental
--

CREATE TABLE rental (
  rental_id INT NOT NULL,
  rental_date DATE NOT NULL,
  inventory_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL,
  return_date DATE DEFAULT NULL,
  staff_id INTEGER NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT rental_pk PRIMARY KEY (rental_id),
  CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) DEFERRABLE,
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) DEFERRABLE,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) DEFERRABLE
);

--
-- Table structure for table payment
--

CREATE TABLE payment (
  payment_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL,
  staff_id INTEGER NOT NULL,
  rental_id INT,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATE NOT NULL,
  last_update TIMESTAMP,
  CONSTRAINT payment_pk PRIMARY KEY  (payment_id),
  CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) DEFERRABLE,
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) DEFERRABLE,
  CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) DEFERRABLE
);

