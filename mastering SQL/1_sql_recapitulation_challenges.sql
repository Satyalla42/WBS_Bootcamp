USE Chinook;


-- 1. How many artists are in the database?
SELECT 
    COUNT(*)
FROM
    Artist;

-- 2. Create an alphabetised list of the artists.
SELECT 
    *
FROM
    Artist
ORDER BY Name;

-- 3. Show only the customers from Germany.
SELECT 
    *
FROM
    Customer
WHERE
    Country = 'Germany';
    
-- 4. Get the full name, customer ID, and country of customers not in the US.
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CustomerId,
    Country
FROM
    Customer
WHERE
    Country != 'US';

-- 5. Find the track with the longest duration.
SELECT 
    *
FROM
    Track
ORDER BY Milliseconds DESC
LIMIT 1;

-- 6. Which tracks have 'love' in their title?
SELECT 
    *
FROM
    Track
WHERE
    Name LIKE '%love%';


-- 7. What is the difference in days between the earliest and latest invoice?
SELECT DATEDIFF(MAX(InvoiceDate), MIN(InvoiceDate)) AS Days_Diff FROM Invoice;
   
-- 8. Which genres have more than 100 tracks?
SELECT * FROM Genre;
SELECT * FROM Track;


SELECT g.name AS Genre, COUNT(t.TrackId) AS TotalTracks
FROM Genre AS g 
LEFT JOIN Track AS t ON g.GenreId = t.GenreId
GROUP BY g.GenreId
HAVING TotalTracks > 100;



-- 9. Create a table showing countries alongside how many invoices there are per country.
SELECT * FROM Invoice;

SELECT 
    COUNT(*) AS InvoicePerCountry, BillingCountry
FROM
    Invoice
GROUP BY BillingCountry
ORDER BY InvoicePerCountry DESC;


-- 10. Find the name of the employee who has served the most customers.
SELECT * FROM Employee; #ReportsTo
SELECT * FROM Customer; #SupportRepId

SELECT 
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    COUNT(c.CustomerId) AS CustomerCount
FROM
    Employee AS e
        LEFT JOIN
    Customer AS c ON e.EmployeeId = c.SupportRepId
GROUP BY FullName
ORDER BY CustomerCount DESC
LIMIT 1;


-- 11. Which customers have a first name that starts with 'A' and is 5 letters long?
SELECT FirstName, LastName FROM Customer WHERE FirstName LIKE 'A____';

SELECT * FROM Customer;

-- 12. Find the total number of tracks in each playlist.

SELECT * FROM PlaylistTrack;
SELECT * FROM Playlist;

SELECT 
    COUNT(p.Name) AS total_per_list, p.PlaylistId, p.name
FROM
    PlaylistTrack AS pt
        JOIN
    Playlist AS p ON pt.PlaylistId = p.PlaylistId
GROUP BY p.PlaylistId
ORDER BY total_per_list DESC;



-- 13. Find the artist that appears in the most playlists.
#artist, ARTISTID, album ALBUMID, track, TRACKID, playlisttrack, PLAYLISTID, playlist;


SELECT 
    COUNT(DISTINCT p.PlaylistId) AS PlaylistCount, 
    ar.Name
FROM
    Artist AS ar
        LEFT JOIN Album AS al ON ar.ArtistId = al.ArtistId
        JOIN Track AS t ON al.AlbumId = t.AlbumId
        JOIN PlaylistTrack AS pt ON t.TrackId = pt.TrackId
        JOIN Playlist AS p ON pt.PlaylistId = p.PlaylistId
GROUP BY ar.Name
ORDER BY PlaylistCount DESC
LIMIT 1;




-- 14. Find the genre with the most tracks.
SELECT 
    g.Name, COUNT(t.TrackId) AS TrackCounts
FROM
    Genre AS g
        JOIN
    Track AS T ON g.GenreId = t.GenreId
    GROUP BY g.Name
    ORDER BY TrackCounts DESC LIMIT 1;



-- 15. Which tracks have a composer whose name ends with 'Smith'?
SELECT * FROM Track WHERE Composer LIKE '%Smith';

-- 16. Which artists have albums in the 'Rock' or 'Blues' genres?
SELECT * FROM Album; #AlbumId ArtistId
SELECT * FROM Track; #AlbumId, GenreId
SELECT * FROM Genre; #GenreId
SELECT * FROM Artist; #ArtistId

SELECT 
    DISTINCT(ar.Name) AS ArtistName
FROM
    Artist AS ar
	JOIN Album AS al ON ar.ArtistId = al.ArtistId
    JOIN Track as t ON al.AlbumId = t.AlbumId
    JOIN Genre AS g ON t.GenreId = g.GenreId
    WHERE g.Name IN ('Rock', 'Blues');

    
-- 17. Which tracks are in the 'Rock' or 'Blues' genre and have a name that is exactly 5 characters long?
SELECT 
    t.name
FROM
    Artist AS ar
	JOIN Album AS al ON ar.ArtistId = al.ArtistId
    JOIN Track as t ON al.AlbumId = t.AlbumId
    JOIN Genre AS g ON t.GenreId = g.GenreId
    WHERE g.Name IN ('Rock', 'Blues')
    AND t.name LIKE '_____';

-- 18. Classify customers as 'Local' if they are from Canada, 'Nearby' if they are from the USA, and 'International' otherwise.
SELECT 
    *,
    CASE WHEN Country = 'Canada' THEN 'Local'
    WHEN Country = 'USA' THEN 'Nearby'
    ELSE 'International'
    END Location
FROM
    Customer;

-- 19. Find the total invoice amount for each customer.
SELECT * FROM Customer; #CustomerId
SELECT * FROM Invoice;

SELECT 
    COUNT(i.InvoiceId) AS Total_invoice_count, c.CustomerId, c.FirstName, c.LastName
FROM
    Customer AS c
        JOIN
    Invoice AS i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY Total_invoice_count DESC;

SELECT 
    CONCAT(c.firstname, " ", c.lastname) AS Customer,
    SUM(i.total) AS TotalInvoiceAmount
FROM
    customer c
        JOIN
    invoice i USING (customerid)
GROUP BY c.customerid;

-- 20. Find the customer who has spent the most on music.
SELECT * FROM Invoice;

SELECT 
    CONCAT(c.firstName, " ", c.lastName) AS Customer,
     SUM(il.UnitPrice*il.Quantity) AS TotalSpent
FROM
    customer c
        JOIN
    invoice i USING (customerid)
		JOIN
	invoiceline il USING(invoiceid)
		JOIN
	track t USING(trackid)
		JOIN
	mediatype USING (mediatypeid)
WHERE
	mediatype.name LIKE '%audio%'
GROUP BY c.customerid
ORDER BY TotalSpent DESC
LIMIT 1;


-- 21. How many tracks were sold from each media type?
SELECT * FROM MediaType; #MediaTypeId
SELECT * FROM Track;

SELECT 
    mediatype.MediaTypeId, 
    mediatype.`name` AS MediaType,
    COUNT(*) AS NumSold
FROM
    invoiceline
        LEFT JOIN
    track USING (TrackId)
        LEFT JOIN
    mediatype USING (MediaTypeId)
GROUP BY MediaTypeId;

-- 22. Find the total sales per genre. Only include genres with sales between 100 and 500.

SELECT * FROM Genre; #GenreId
SELECT * FROM InvoiceLine; #TrackId
SELECT * FROM Track; #TrackId # #GenreId

SELECT 
    SUM(i.UnitPrice*i.Quantity) AS Total_sales, g.Name
FROM
    InvoiceLine AS i
        JOIN
    Track AS t ON i.TrackId = t.TrackId
        JOIN
    Genre AS g ON t.GenreId = g.GenreId
GROUP BY g.Name
HAVING Total_sales BETWEEN 100 AND 500;


-- 23. Find the total number of tracks sold per artist. 
SELECT * FROM Artist; #ArtistId
SELECT * FROM InvoiceLine; #TrackId 
SELECT * FROM Track; #TrackId, #AlbumID
SELECT* FROM Album; #ArtistId #AlbumID

SELECT 
    SUM(i.UnitPrice * i.Quantity) AS TotalSales,
    ar.Name
FROM
    InvoiceLine AS i
        JOIN
    Track AS t ON i.TrackId = t.TrackId
        JOIN
    Album AS al ON t.AlbumId = al.AlbumId
        JOIN
    Artist AS ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY TotalSales DESC;




-- Add an extra column categorising the artists into 'High', 'Medium', 'Low' based on the number of tracks sold.
-- High is more than 100, Low is less than 50.
SELECT 
    SUM(i.UnitPrice * i.Quantity) AS TotalSales,
    ar.Name,
    CASE WHEN SUM(i.UnitPrice * i.Quantity) > 100 THEN 'High'
    WHEN SUM(i.UnitPrice * i.Quantity) BETWEEN 50 AND 100 THEN 'Medium'
    WHEN SUM(i.UnitPrice * i.Quantity) < 50 THEN 'Low'
    END SalesVolume
FROM
    InvoiceLine AS i
        JOIN
    Track AS t ON i.TrackId = t.TrackId
        JOIN
    Album AS al ON t.AlbumId = al.AlbumId
        JOIN
    Artist AS ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY TotalSales DESC;









