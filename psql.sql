/* The DVDrental database already has a pre-populated data in it, but let's assume that
the business is still running. In this case, the existing data needs to not only be analysed 
but also maintain the database mainly by INSERT-ing data for new rentals and UPDATE-ing the db
for existing rentals-- i.e implementing DML (Data Manipulation Language). To this effect, 

The following are ALL the queries needed to rent out a given movie. */

-- check whether the given movie is registered in the system

SELECT                
    f.film_id, f.title
FROM 
    film f
WHERE 
    f.title = 'Alien Center';

-- check whether the movie is available in the inventory 

SELECT     
    i.inventory_id, f.title, f.film_id, i.store_id, COUNT(f.film_id) AS available_movie
FROM 
    film f
RIGHT JOIN 
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

-- check the last rental_id number to assign a new one

SELECT         
    rental_id  
FROM 
    rental
ORDER BY 1 DESC;

-- INSERT a row into the rental table

INSERT INTO 
            rental (rental_id, inventory_id, customer_id, rental_date, staff_id, last_update)
VALUES 
            (16050, 72, 78, CURRENT_TIMESTAMP , 1, CURRENT_TIMESTAMP);

-- verify that the record is inserted

SELECT *                                                
FROM                         
    rental
WHERE 
    rental_id = 16050;

-- INSERT a row into the payment table

-- check the last payment_id number to assign a new one

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
FROM (
    SELECT
    r.customer_id, cu.first_name,
)