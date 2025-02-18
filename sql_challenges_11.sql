/******************************************************************************
*******************************************************************************

SQL CHALLENGES 11

*******************************************************************************
*******************************************************************************/

USE publications;

-- 1. Using LEFT JOIN: in which cities has "Is Anger the Enemy?" been sold?


SELECT * FROM titles; --title title_id;
SELECT * FROM sales; --title_id, stor_id;
SELECT * FROM stores; --stor_id, city; 

SELECT 
    st.city
FROM
    stores AS st
       LEFT  JOIN
    sales AS s ON st.stor_id = s.stor_id
        LEFT JOIN
    titles AS t ON t.title_id = s.title_id
WHERE
    t.title = 'Is Anger the Enemy?';
    

    
/* 2. Select all the book titles that have a link to the employee Howard Snyder 
    (he works for the publisher that has published those books). */

SELECT * FROM titles; --pub_id;
SELECT * FROM employee; --HOWARD SNYDER, pub_id 0736;
SELECT * FROM publishers; --pub_id;

SELECT 
    *
FROM
    titles AS t
        LEFT JOIN
    employee AS e ON t.pub_id = e.pub_id
        LEFT JOIN
    publishers AS p ON e.pub_id = p.pub_id
WHERE
    e.fname = 'Howard'
        AND e.lname = 'Snyder';


/* 3. Using the JOIN of your choice: Select the book title with highest number of 
   sales (qty) */

SELECT * FROM titles;
    SELECT * FROM sales;
    
SELECT 
    s.title_id, t.title, SUM(s.qty) AS total_sales
FROM
    sales AS s
        LEFT JOIN
    titles AS t ON s.title_id = t.title_id
GROUP BY s.title_id , t.title
ORDER BY total_sales DESC
LIMIT 1;

/* 4. Select all book titles and the full name of their author(s).
      
      - If a book has multiple authors, all authors must be displayed (in 
      multiple rows).
      
      - Books with no authors and authors with no books should not be displayed.
*/
SELECT * FROM authors;
SELECT * FROM titles;
SELECT * FROM titleauthor;

SELECT 
    CONCAT(a.au_fname, ' ', a.au_lname) AS full_name, t.title
FROM
    authors AS a
        JOIN
    titleauthor AS ta ON a.au_id = ta.au_id
        JOIN
    titles AS t ON ta.title_id = t.title_id;
    


/* 5. Select the full name of authors of Psychology books

   Bonus hint: if you want to prevent duplicates but allow authors with shared
   last names to be displayed, you can concatenate the first and last names
   with CONCAT(), and use the DISTINCT clause on the concatenated names. */


SELECT 
 DISTINCT CONCAT(a.au_fname, ' ', a.au_lname) AS full_name
FROM
    authors AS a
        JOIN
    titleauthor AS ta ON a.au_id = ta.au_id
        JOIN
    titles AS t ON ta.title_id = t.title_id
WHERE
    t.type = 'Psychology';


/* 6. Explore the table roysched and try to grasp the meaning of each column. 
   The notes below will help:
   
   - "Royalty" means the percentage of the sale price paid to the author(s).
   
   - Sometimes, the royalty may be smaller for the first few sales (which have
     to cover the publishing costs to the publisher) but higher for the sales 
     above a certain threshold.
     
   - In the "roysched" table each title_id can appear multiple times, with
     different royalty values for each range of sales.
     
   - Select all rows for particular title_id, for example "BU1111", and explore
	 the data. */

SELECT * FROM roysched;

/* 7. Select all the book titles and the maximum royalty they can reach.
    Display only titles that are present in the roysched table. */
    
SELECT 
    t.title, MAX(r.royalty) AS max_royalty
FROM
    titles AS t
         JOIN
    roysched AS r ON t.title_id = r.title_id
GROUP BY t.title
ORDER BY max_royalty DESC;


