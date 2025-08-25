/* The DVDrental database already has a pre-populated data in it, but let's assume that
the business is still running. In this case, the existing data needs to not only be analysed 
but also maintain the database mainly by INSERT-ing data for new rentals and UPDATE-ing the db
for existing rentals-- i.e implementing DML (Data Manipulation Language). To this effect, 

The following are ALL the queries needed to rent out a given movie. */

-- Check whether the given movie is registered in the system.

SELECT                
    f.film_id, f.title
FROM 
    film f
WHERE 
    f.title = 'Alien Center';

-- Check whether the movie is available in the invetory. 

SELECT     
    i.inventory_id, f.title, f.film_id, i.store_id, COUNT(f.film_id) AS available_movie
FROM 
    film AS f
JOIN 
    inventory i ON f.film_id = i.film_id 
WHERE 
    f.title = 'Alien Center' AND i.store_id IN ('1','2') 
    AND i.inventory_id NOT IN (
        SELECT 
        r.inventory_id
        FROM 
        rental r 
        WHERE 
        r.return_date IS NULL)
GROUP BY 1, 2, 3;

-- INSERT a row into the rental table

-- Check the last rental_id number to assign a new one

SELECT         
    rental_id  
FROM 
    rental
ORDER BY 1 DESC;

-- INSERT a row into the rental table.

INSERT INTO 
            rental (rental_id, inventory_id, customer_id, rental_date, staff_id, last_update)
VALUES 
            (16050, 72, 78, CURRENT_TIMESTAMP , 1, CURRENT_TIMESTAMP);

-- Verify that the record is inserted.

SELECT *                                                
FROM                         
    rental
WHERE 
    rental_id = 16050;

-- INSERT a row into the payment table

-- Check the last payment_id number to assign a new one

SELECT 
    payment_id  
FROM 
    payment
ORDER BY 1 DESC;

-- INSERT into the payment table

INSERT INTO     
    payment (payment_id, customer_id, staff_id, rental_id, amount, payment_date)
VALUES 
    (32099, 78, 1, 16050, 2.99, CURRENT_TIMESTAMP)

-- verify that the record is inserted

SELECT *   
FROM 
    payment
WHERE 
    payment_id = 32099
ORDER BY 1 DESC

-- check whether the customer has an outstanding balance or overdue rental


SELECT *
FROM(
	SELECT 
	r.customer_id, cu.first_name || '  ' || cu.last_name AS full_name, r.rental_id, f.rental_duration,
	(DATE(r.return_date) - DATE(r.rental_date)) AS unreturned_rental
    FROM 
	rental r
    JOIN 
	customer cu ON r.customer_id = cu.customer_id
	JOIN 
	inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE (DATE(r.return_date) - DATE(r.rental_date)) > f.rental_duration 
	AND cu.customer_id = 78 ) sub;

-- To calculate any applicable late fees, if the return is overdue, for a single rental.

SELECT 
    r.rental_id, r.rental_date, r.return_date, f.rental_duration, r.return_date - r.rental_date AS rented_timeframe,
    GREATEST(EXTRACT(DAY FROM (r.return_date - r.rental_date)) - f.rental_duration, 0) * f.rental_rate AS late_fee
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    r.rental_id = 1114;


-- To look if a given customer had any past late return fee via customer_id.


SELECT 
    cu.customer_id, r.rental_date, r.return_date, f.rental_duration, r.return_date - r.rental_date AS rented_timeframe, 
    GREATEST(EXTRACT(DAY FROM (r.return_date - r.rental_date)) - f.rental_duration, 0) * f.rental_rate AS late_fee
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
JOIN 
    customer cu ON cu.customer_id = r.customer_id
WHERE cu.customer_id = 75
GROUP BY 1,2,3,4,5,6
ORDER BY 6;

/* b.  Write ALL the queries we need to process return of a rented movie. */

--1. Update the rental table and add the return date by first identifying the rental_id to update based 
--   on the inventory_id of the movie being returned.


-- Let's say the movie being returned is "Club Graffiti" and Customer_id is 101.


SELECT                -- Identify rental_id.
    rental_id
FROM(
	SELECT 
	cu.customer_id, f.film_id, f.title, r.rental_id, r.inventory_id, f.rental_duration, 
	return_date
    FROM 
	film f
    JOIN 
	inventory i ON f.film_id = i.film_id
    JOIN 
	rental r ON i.inventory_id = r.inventory_id
    JOIN 
	customer cu ON r.customer_id = cu.customer_id
    WHERE 
	cu.customer_id = 101 AND f.title = 'Club Graffiti') sub;
	
UPDATE 
    rental
SET 
    return_date = CURRENT_TIMESTAMP
WHERE 
    rental_id = 12141;


SELECT *  --Check the update 
FROM 
    rental
WHERE 
    rental_id = 12141;


--------------################--------------------



/* Question 2. DQL: Now that we have an up-to-date database, let's write some queries and analyze the 
data to understand how our DVD rental business is performing so far. */

--QUIRIES

-- a. Which movie genres are the most and least popular? How much revenue have they each generated 
--       for the business?


(SELECT          -- Retrieves the most popular genres which generated the highest revenue.
    name AS genre, COUNT(r.rental_id) AS count_of_rental, SUM(amount) AS revenue_genereated
FROM 
    category ca
JOIN 
    film_category fi ON ca.category_id = fi.category_id
JOIN 
    film f ON fi.film_id = f.film_id
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    payment pay ON r.rental_id = pay.rental_id
GROUP BY 1
ORDER BY 2 DESC, 3 DESC
LIMIT 1)     

UNION

(SELECT          --Retrieves the least popular and generated the lowest revenue.
    name AS genre, COUNT(r.rental_id) AS count_of_rental, SUM(amount) AS revenue_genereated
FROM 
    category ca
JOIN 
    film_category fi ON ca.category_id = fi.category_id
JOIN 
    film f ON fi.film_id = f.film_id
JOIN 
    inventory I ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    payment pay ON r.rental_id = pay.rental_id
GROUP BY 1
ORDER BY 2 , 3 
LIMIT 1);



-- b. 
    -- What are the top 10 most popular movies? How many times have they each been rented out thus far?


SELECT 
    f.title, COUNT(r.rental_id) 
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;



-- c. 
    -- Which genres have the highest and the lowest average rental rate?
	
	
	
(SELECT       --Retrieves genre that has the highest average rental rate.
    name, ROUND(AVG(f.rental_rate), 2) AS average_rental_rate
FROM 
    category ca
JOIN film_category fi ON ca.category_id = fi.category_id
JOIN film f ON fi.film_id = f.film_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1)

UNION

(SELECT 
    name, ROUND(AVG(f.rental_rate), 2) AS average_rental_rate
FROM 
    category ca
JOIN 
    film_category fi ON ca.category_id = fi.category_id
JOIN 
    film f ON fi.film_id = f.film_id
GROUP BY 1
ORDER BY 2
LIMIT 1);


-- d.
    -- How many rented movies were returned late? 


SELECT          --Retrieves the total count of movies which are returned late.
    COUNT(f.title) AS total_count_of_movies_returned_late
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    DATE(r.return_date) - DATE(r.rental_date) > f.rental_duration;



SELECT       --Retrieves the total count of movies which are returned late with respect to their genre.
    name, COUNT(f.title) AS total_count_of_movies_returned_late
FROM 
    category ca
JOIN 
    film_category fi ON ca.category_id = fi.category_id
JOIN 
    film f ON fi.film_id = f.film_id
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    DATE(r.return_date) - DATE(r.rental_date) > f.rental_duration
GROUP BY 1
ORDER BY 2 DESC;


--Is the late return of rental movies somehow correlated with the genre of a movie?

/* No. It is not. And any possible correlation to be drawn is most likely coincidental. This is
    because there is no significant difference between the different genres of the movies and their amount
   of late returns to make us deduce that it has something to do with their genres. */


-- e.
    -- What are the top 5 cities that rent the most movies? 
	

SELECT 
    ci.city, COUNT(*) AS total_rentals
FROM 
    city ci
JOIN 
    address ad ON ci.city_id = ad.city_id
JOIN 
    customer cu ON ad.address_id = cu.address_id
JOIN 
    rental r ON cu.customer_id = r.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

	
	
	-- How about in terms of total sales volume?
	
	
	
SELECT 
    ci.city, SUM(amount) AS total_sales_volume
FROM 
    city ci
JOIN 
    address ad ON ci.city_id = ad.city_id
JOIN 
    customer cu ON ad.address_id = cu.address_id
JOIN 
    rental r ON cu.customer_id = r.customer_id
JOIN 
    payment pay ON cu.customer_id = pay.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



-- f.
    -- Let's say you want to give discounts as a reward to your loyal customers and those who return 
    --    movies they rented on time. So, who are your 10 best customers in this respect?
	


SELECT 
    cu.customer_id, cu.first_name, cu.last_name, COUNT(r.rental_id) AS return_on_time
FROM 
    customer cu
JOIN 
    rental r ON cu.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film fi ON i.film_id = fi.film_id
WHERE 
    DATE(r.return_date) - DATE(r.rental_date) <= rental_duration
GROUP BY 1
ORDER BY 4 DESC
LIMIT 10
	

	
-- g. 
    -- What are the 10 best rated movies?


SELECT 
    f.title AS top_10_best_rated_movies, COUNT(r.rental_id) AS number_of_rental, 
	COUNT(r.rental_id) * f.rental_rate AS revenue
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, f.rental_rate, f.rating
ORDER BY revenue DESC
LIMIT 10;


	-- Is customer rating somehow correlated with revenue?

/* Yes. Although it is not optimal because of the lack of direct data on customer ratings, we are assuming
    it based on how much revenue is generated per movie, and it can certainly still aid us in assuming 
    possible customer feedback. This is possible by correlating what is the most expensive with its demand,
    considering that the demand is relatively high in comparison to other movies, and using that as a 
    way to find the top 10 best-rated movies. But going down the line after the 10th rated movie, the 
    customer rating is nearly impossible to deduce for reasons that the number fluctuations of different 
    movies in their expense and rental count are significant, and the high revenue generated might either 
    be purely because of its popularity with little expense, which is not impressive, or because of its 
    high expense but relatively low popularity in comparison to other movies. This makes it difficult to
   anticipate customer feedback on the movies. */


-- Which actors have acted in most number of the most popular or highest rated movies?


SELECT 
    ac.actor_id, ac.first_name, ac.last_name, COUNT(ac.actor_id) AS appearances
FROM 
    actor ac
JOIN 
    film_actor fa ON fa.actor_id = ac.actor_id
JOIN 
    film f ON f.film_id = fa.film_id
WHERE 
    f.title IN ( 'Bucket Brotherhood', 'Scalawag Duck', 'Wife Turn', 'Apache Divine','Zorro Ark', 
                'Goodfellas Salute', 'Witches Panic', 'Massacre Usual', 'Dogma Family')
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 10;



/* Rentals and hence revenues have been falling behind among young families. In order to reverse this, 
   you wish to target all family movies for a promotion. */


-- h. Identify all movies categorized as family films.


	
SELECT 
    f.film_id, title, name
FROM 
    film f
JOIN 
    film_category fi ON f.film_id = fi.film_id
JOIN 
    category ca ON fi.category_id = ca.category_id
WHERE 
    name = 'Family';
    
	
	-- i. How much revenue has each store generated so far? 
	
	
SELECT 
    sr.store_id, SUM(amount)
FROM 
    payment pay
JOIN 
    staff s ON pay.staff_id = s.staff_id
JOIN 
    store sr ON s.store_id = sr.store_id
GROUP BY 1;



    /* j. As a data analyst for the DVD rental business, you would like to have an easy way of viewing 
   the Top 5 genres by average revenue. */


-- Write the query to get list of the top 5 genres in average revenue in descending order?


SELECT 
    name, ROUND(AVG(amount), 2) AS average_revenue
FROM 
    category ca
JOIN 
    film_category fi ON ca.category_id = fi.category_id
JOIN 
    film f ON fi.film_id = f.film_id
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    payment pay ON r.rental_id = pay.rental_id 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- And create a view for it?


CREATE VIEW top_5_genres_in_avg_revenue AS
SELECT 
    name, ROUND(AVG(amount), 2) AS average_revenue
FROM 
    category ca
JOIN 
    film_category fi ON ca.category_id = fi.category_id
JOIN 
    film f ON fi.film_id = f.film_id
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    payment pay ON r.rental_id = pay.rental_id 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT *  -- Check whether the view is created for the table.
FROM top_5_genres_in_avg_revenue;