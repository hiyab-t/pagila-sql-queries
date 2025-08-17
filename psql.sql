/* The DVDrental database already has a pre-populated data in it, but let's assume that
the business is still running. In this case, the existing data needs to not only be analysed 
but also maintain the database mainly by INSERT-ing data for new rentals and UPDATE-ing the db
for existing rentals-- i.e implementing DML (Data Manipulation Language). To this effect, 

The following are ALL the queries needed to rent out a given movie. */

-- check whether the given movie is registered in the system.

SELECT                
    f.film_id, f.title
FROM 
    film f
WHERE 
    f.title = 'Alien Center';

-- check whether the movie is available in the inventory




