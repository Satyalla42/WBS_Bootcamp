USE Chinook;


-- 1. Rank the customers by total sales
SELECT * FROM Invoice; #InvoiceID #CustomerID
SELECT * FROM InvoiceLine; #InvoiceId
SELECT * FROM Customer; #CustomerId
-----
CREATE TEMPORARY TABLE sales_per_customer_distinct AS
SELECT COUNT(DISTINCT i.invoiceId), c.customerid FROM invoice AS i JOIN invoiceline AS il USING (InvoiceId) JOIN Customer AS C USING (customerId) GROUP BY c.customerId;
SELECT * FROM sales_per_customer_distinct RANK() OVER (PARTITION BY CustomerId ORDER BY i.Total DESC) AS rank_by_total;
--------
SELECT
  i.InvoiceId,
  c.CustomerId,
  i.Total,
  RANK() OVER (PARTITION BY c.CustomerId ORDER BY i.Total DESC) AS rank_by_total
FROM Invoice i
JOIN Customer c USING (CustomerId);


-- 2. Select only the top 10 ranked customer from the previous question
SELECT
  i.InvoiceId,
  c.CustomerId,
  i.Total,
  RANK() OVER (PARTITION BY c.CustomerId ORDER BY i.Total DESC) AS rank_by_total
FROM Invoice i
JOIN Customer c USING (CustomerId) ORDER BY rank_by_total DESC LIMIT 10;

-- 3. Rank albums based on the total number of tracks sold.
#checking for common columns
SELECT * FROM Album; #AlbumID 
SELECT * FROM Track; #TrackID #AlbumId
SELECT * FROM InvoiceLine; #TrackID

#checking number of tracks grouped by album sold 
CREATE TEMPORARY TABLE tracks_per_album_sold AS
SELECT COUNT(t.TrackId) AS total_tracks, a.Title, a.albumId FROM Album AS a JOIN Track AS t USING (AlbumID) JOIN InvoiceLine AS il USING (TrackID) GROUP BY a.title, a.albumid;

#verfiying if it worked correctly
SELECT * FROM tracks_per_album_sold;

#ranking
SELECT 
  *,
  RANK() OVER (ORDER BY total_tracks DESC) AS tracks_sold_rank
FROM 
  tracks_per_album_sold;

-- 4. Do music preferences vary by country? What are the top 3 genres for each country? ###. TO DISCUSS

SELECT * FROM Genre; #GenreId
SELECT * FROM TRACk; #GenreID #trackID 
SELECT * FROM INVOICELINE; #TrackID #InvoiceID
SELECT * FROM Invoice; #InvoiceID

SELECT
    g.Name AS GenreName, 
    i.billingcountry, 
    COUNT(t.TrackID) AS TracksSold,
    RANK() OVER (PARTITION BY i.billingcountry ORDER BY COUNT(t.TrackID) DESC) AS GenreRank
FROM InvoiceLine AS il 
JOIN Invoice AS i USING (InvoiceId) 
JOIN Track AS t USING (TrackID) 
JOIN Genre AS g USING (GenreID)
GROUP BY g.genreId, i.billingcountry
HAVING GenreRank <= 3
ORDER BY i.billingcountry, GenreRank;

WITH RankedGenres AS (
    SELECT
        g.Name AS GenreName, 
        i.billingcountry, 
        COUNT(t.TrackID) AS TracksSold,
        RANK() OVER (PARTITION BY i.billingcountry ORDER BY COUNT(t.TrackID) DESC) AS GenreRank
    FROM InvoiceLine AS il 
    JOIN Invoice AS i USING (InvoiceId) 
    JOIN Track AS t USING (TrackID) 
    JOIN Genre AS g USING (GenreID)
    GROUP BY g.genreId, i.billingcountry
)
SELECT GenreName, billingcountry, TracksSold, GenreRank
FROM RankedGenres
WHERE GenreRank <= 3
ORDER BY billingcountry, GenreRank;

    
-- 5. In which countries is Blues the least popular genre?


-- 6. Has there been year on year growth? By how much have sales increased per year?

    
-- 7. How do the sales vary month-to-month as a percentage? 


-- 8. What is the monthly sales growth, categorised by whether it was an increase or decrease compared to the previous month?


-- 9. How many months in the data showed an increase in sales compared to the previous month?


-- 10. As a percentage of all months in the dataset, how many months in the data showed an increase in sales compared to the previous month?


-- 11. How have purchases of rock music changed quarterly? Show the quarterly change in the amount of tracks sold


-- 12. Determine the average time between purchases for each customer.

