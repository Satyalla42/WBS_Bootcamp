USE chinook;

-- 1. What is the difference in minutes between the total length of 'Rock' tracks and 'Jazz' tracks?
SELECT * FROM Track; #GenreId #Miliseconds
SELECT * FROM Genre; #GenreId

SELECT SUM(Milliseconds)/60000 AS Rock_Sum FROM Track AS t JOIN Genre AS g USING (GenreId)
	WHERE g.Name = 'Rock';
    
SELECT SUM(Milliseconds)/60000 AS Jazz_Sum FROM Track AS t JOIN Genre AS g USING (GenreId)
	WHERE g.Name = 'Jazz';

SELECT 
    (SELECT SUM(Milliseconds)/60000 FROM Track AS t 
     JOIN Genre AS g USING (GenreId) WHERE g.Name = 'Rock') 
    - 
    (SELECT SUM(Milliseconds)/60000 FROM Track AS t 
     JOIN Genre AS g USING (GenreId) WHERE g.Name = 'Jazz') 
    AS Minute_Difference;



-- 2. How many tracks have a length greater than the average track length?
SELECT AVG(Milliseconds) FROM Track;
SELECT * FROM Track;

CREATE TEMPORARY TABLE avg_length AS  
SELECT AVG(Milliseconds) FROM Track;

SELECT COUNT(*) FROM Track WHERE Milliseconds > (SELECT * FROM avg_length);


-- 3. What is the percentage of tracks sold per genre?
SELECT * FROM Genre; #GenreId
SELECT * FROM InvoiceLine; #TrackId 
SELECT * FROM Track; #TrackId # GenreId
######NO IDEA






CREATE TEMPORARY TABLE total_Genre AS
SELECT COUNT(g.Name) AS total_per_Genre, g.Name FROM Track AS t JOIN Genre AS g USING (GenreId) GROUP BY g.name;


SELECT 
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM total_Genre)) * 100,2) AS genre_percentg
FROM InvoiceLine;

SELECT * FROM avg_length;

SELECT 
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM Track)) * 100,2) AS genre_percentg, g.Name
FROM Track AS t
JOIN Genre AS g USING (GenreId)
JOIN InvoiceLine AS il USING (TrackId)
GROUP BY g.Name
ORDER BY genre_percentg DESC;


-- 4. Can you check that the column of percentages adds up to 100%?


-- 5. What is the difference between the highest number of tracks in a genre and the lowest?
SELECT * FROM Genre; #GenreId
SELECT * FROM Track; #GenreId

CREATE TEMPORARY TABLE total_Genre AS
SELECT COUNT(g.Name) AS total_per_Genre, g.Name FROM Track AS t JOIN Genre AS g USING (GenreId) GROUP BY g.name;

SELECT MAX(total_per_genre) - MIN(total_per_Genre) AS genre_difference FROM total_Genre;

-- 6. What is the average value of Chinook customers (total spending)?
SELECT * FROM Customer; #customerId
SELECT * FROM Invoice; #CustomerId

CREATE TEMPORARY TABLE total_spent_table AS
SELECT SUM(i.Total)AS total_spent, c.FirstName, c.LastName FROM Invoice as i JOIN Customer AS c USING (CustomerID) GROUP BY c.CustomerID ORDER BY total_spent DESC;

SELECT ROUND(AVG(total_spent),2) AS avg_total_spent FROM total_spent_table;


-- 7. How many complete albums were sold? Not just tracks from an album, but the whole album bought on one invoice.
SELECT * FROM ALBUM; #AlbumId #ArtistId
SELECT * FROM Artist; #ArtistId
SELECT * FROM InvoiceLine; #InvoiceId #TrackId
SELECT * FROM Track; #AlbumId #TrackId



-- 8. What is the maximum spent by a customer in each genre?
	

-- 9. What percentage of customers who made a purchase in 2022 returned to make additional purchases in subsequent years?
    

-- 10. Which genre is each employee most successful at selling? Most successful is greatest amount of tracks sold.


-- 11. How many customers made a second purchase the month after their first purchase?

