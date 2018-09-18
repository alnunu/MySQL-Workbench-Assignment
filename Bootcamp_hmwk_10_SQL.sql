use sakila;

-- 1a
SELECT first_name, last_name
FROM actor;
-- b
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

-- 2a
SELECT first_name, last_name, actor_id
FROM actor
WHERE first_name = 'Joe';
-- b
SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name LIKE '%GEN%';
-- c 
SELECT  first_name, last_name, actor_id
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name , first_name;
-- d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD COLUMN middle_name varchar(40) AFTER first_name;
-- b
ALTER TABLE actor
MODIFY COLUMN middle_name blob;
-- c
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a
SELECT last_name, count(last_name) AS 'last_name_frequency'
FROM actor
GROUP BY last_name
HAVING `last_name_frequency` >= 1;
-- b
SELECT last_name, count(last_name) AS 'last_name_frequency'
FROM actor
GROUP BY last_name
Having `last_name_frequency` >= 2;
-- c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
and last_name = 'WILLIAMS';
-- d
UPDATE actor
SET first_name =
CASE
 WHEN first_name = 'HARPO'
  THEN 'GROUCHO'
 ELSE 'GROUCHO'
END
WHERE actor_id = 172;

-- 5
SHOW CREATE TABLE address;

-- 6a 
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a
ON (s.address_id = a.address_id);
 -- b
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff  s
INNER JOIN payment p
ON p.staff_id = s.staff_id
WHERE MONTH(p.payment_date) = 08 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;
-- c
SELECT f.title, COUNT(fa.actor_id) AS 'Actors'
FROM film_actor fa
INNER JOIN film f
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY Actors desc;
-- d 
SELECT title, COUNT(inventory_id) AS 'Number of Copies'
FROM film
INNER JOIN inventory
USING (film_id)
WHERE title = 'Hunchback Impossible'
GROUP BY title;
-- e
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total Paid'
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a
SELECT title
FROM film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND language_id IN
(
 SELECT language_id
 FROM language
 WHERE name = 'English'
);

-- b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id =
  (
     SELECT film_id
     FROM film
     WHERE title = 'Alone Trip'
    )
 );
-- c 
SELECT first_name, last_name, email, country
FROM customer cus
INNER JOIN address a
ON (cus.address_id = a.address_id)
INNER JOIN city cit
ON (a.city_id = cit.city_id)
INNER JOIN country ctr
ON (cit.country_id = ctr.country_id)
WHERE ctr.country = 'Canada';
-- d
SELECT title, c.name
FROM film f
INNER JOIN film_category fc
ON (f.film_id = fc.film_id)
INNER JOIN category c
ON (c.category_id = fc.category_id)
WHERE name = 'family';
-- e
SELECT title, COUNT(title) as 'movie_rentals'
FROM film f
INNER JOIN inventory i
ON (f.film_id = i.film_id)
INNER JOIN rental r
ON (i.inventory_id = r.inventory_id)
GROUP by title
ORDER BY movie_rentals desc;
-- f
SELECT s.store_id, SUM(amount) AS revenue
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (i.inventory_id = r.inventory_id)
INNER JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;
-- g
SELECT store_id, city, country
FROM store s
INNER JOIN address a
ON (s.address_id = a.address_id)
INNER JOIN city cit
ON (cit.city_id = a.city_id)
INNER JOIN country ctr
ON(cit.country_id = ctr.country_id);
-- h
SELECT SUM(amount) AS 'Gross Revenue', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category fc
ON (i.film_id = fc.film_id)
INNER JOIN category c
ON (fc.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC;

-- 8a
CREATE VIEW top_five_genres AS
SELECT SUM(amount) AS 'Gross Revenue', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category fc
ON (i.film_id = fc.film_id)
INNER JOIN category c
ON (fc.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;
-- b
SELECT *
FROM top_five_genres;
-- c
DROP VIEW top_five_genres;