/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 8

*******************************************************************************
*******************************************************************************

In the exercises below you might need to use the any of the clauses learned so 
far.

*/

USE publications;

/* 1. Select the top 5 orders with most quantity sold between 1993-03-11 and
    1994-09-13 from the table sales */

SELECT 
    ord_num, SUM(qty) AS orders_sold
FROM
    SALES
WHERE ord_date BETWEEN '1993-03-11' AND '1994-09-13'
GROUP BY ord_num
ORDER BY orders_sold DESC
LIMIT 5;

SELECT * FROM sales;

/* 2. How many authors have an "i" in their first name, are from Utah,
   Maryland, or Kansas? */
   
--- UT, MD, KS

SELECT COUNT(*) AS authors_with_i FROM authors WHERE state = ("UT", "MD", "KS");

SELECT * FROM authors;

/* 3. In California, how many authors are there in cities that contain an "o"
   in the name?
   - Show only results for cities with more than 1 author.
   - Sort the cities ascendingly by author count.
*/


