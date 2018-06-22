-- Practice joins -----
-----------------------
-- Get all invoices where the UnitPrice on the InvoiceLine is greater than $0.99.
SELECT *
FROM Invoice i
    JOIN InvoiceLine il ON il.invoiceId = i.invoiceId
WHERE il.UnitPrice > 0.99;

-- Get the InvoiceDate, customer FirstName and LastName, and Total from all invoices.
SELECT i.InvoiceDate, c.FirstName, c.LastName, i.Total
FROM Invoice i
    JOIN Customer c ON i.CustomerId = c.CustomerId;

-- Get the customer FirstName and LastName and the support rep's FirstName and LastName from all customers.
-- Support reps are on the Employee table.
SELECT c.FirstName, c.LastName, e.FirstName, e.LastName
FROM Customer c
    JOIN Employee e ON c.SupportRepId = e.EmployeeId;

-- Get the album Title and the artist Name from all albums.
SELECT a.Title, ar.Name
FROM Album a
    JOIN Artist ar ON a.ArtistId = ar.ArtistId;

-- Get all PlaylistTrack TrackIds where the playlist Name is Music.
SELECT pt.TrackId
FROM PlaylistTrack pt
    JOIN Playlist p ON p.PlaylistId = pt.PlaylistId
WHERE p.Name = 'Music';

-- Get all Track Names for PlaylistId 5.
SELECT t.Name
FROM Track t
    JOIN PlaylistTrack pt ON pt.TrackId = t.TrackId
WHERE pt.PlaylistId = 5;

-- Get all Track Names and the playlist Name that they're on ( 2 joins ).
SELECT t.name, p.Name
FROM Track t
    JOIN PlaylistTrack pt ON t.TrackId = pt.TrackId
    JOIN Playlist p ON pt.PlaylistId = p.PlaylistId;

-- Get all Track Names and Album Titles that are the genre "Alternative" ( 2 joins ).
SELECT t.name, a.title
FROM Track t
    JOIN Album a ON t.AlbumId = a.AlbumId
    JOIN Genre g ON g.GenreId = t.GenreId
WHERE g.Name = "Alternative";

-- Practice nested queries--
----------------------------
-- Get all invoices where the UnitPrice on the InvoiceLine is greater than $0.99.
SELECT *
FROM INVOICE
WHERE InvoiceId IN (SELECT InvoiceID
FROM InvoiceLine
WHERE UnitPrice > 0.99);

-- Get all Playlist Tracks where the playlist name is Music.
SELECT *
FROM PlaylistTrack
WHERE PlaylistId IN (SELECT PlaylistId
FROM Playlist
WHERE Name = "Music");

-- Get all Track names for PlaylistId 5.
SELECT NAME
FROM Track
WHERE TrackId IN ( SELECT TrackId
FROM PlaylistTrack
WHERE Playlistid = 5);

-- Get all tracks where the Genre is Comedy.
SELECT *
FROM Track
WHERE GenreId IN ( SELECT GenreId
FROM Genre
WHERE Name = "Comedy");

-- Get all tracks where the Album is Fireball.
SELECT *
FROM Track
WHERE AlbumId IN ( SELECT AlbumId
FROM Album
WHERE Title = "Fireball")


-- Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT *
FROM Track
WHERE AlbumId IN ( SELECT AlbumId
FROM Album
WHERE ArtistId IN (
  SELECT ArtistId
FROM Artist
WHERE Name = "Queen")
                  );

--Practice updating Rows--
--------------------------
-- Find all customers with fax numbers and set those numbers to null.
UPDATE Customer
SET Fax = null
WHERE Fax IS NOT null;

-- Find all customers with no company (null) and set their company to "Self".
UPDATE Customer
SET Company = "Self"
WHERE Company IS null;

-- Find the customer Julia Barnett and change her last name to Thompson.
UPDATE Customer
SET LastName = "Thompson"
WHERE FirstName = "Julia" AND LastName = "Barnett";

-- Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE Customer
SET SupportRepId = 4
WHERE Email = "luisrojas@yahoo.cl";

-- Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE Track
SET Composer = "The darkness around us"
WHERE GenreId = (SELECT GenreId
    FROM Genre
    WHERE Name = "Metal")
    AND Composer IS null;

-- Group by---
------------------
-- Find a count of how many tracks there are per genre. Display the genre name with the count.
SELECT Count(*), g.Name
FROM Track t
    Join Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name;

-- Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT Count(*), g.Name
FROM Track t
    JOIN Genre g ON g.GenreId = t.GenreId
WHERE g.Name = 'Pop' OR g.Name = 'Rock'
Group by g.Name;

-- Find a list of all artists and how many albums they have.
SELECT ar.Name, Count(*)
FROM Artist ar
    JOIN Album al ON ar.ArtistId = al.ArtistId
GROUP BY al.ArtistId;

-- Use Distinct--
-----------------
-- From the Track table find a unique list of all Composers.
SELECT DISTINCT Composer
FROM Track;

-- From the Invoice table find a unique list of all BillingPostalCodes.
SELECT DISTINCT BillingPostalCode
FROM Invoice;

-- From the Customer table find a unique list of all Companys.
SELECT DISTINCT Company
FROM Customer;

-- Delete Rows
-- -----------
-- Delete all "bronze" entries from the table.
DELETE 
FROM practice_delete
WHERE Type = "bronze";

-- Delete all "silver" entries from the table.
DELETE 
FROM practice_delete
WHERE Type = "silver";

-- Delete all entries whose value is equal to 150.
DELETE 
FROM practice_delete
WHERE Value = 150;

-- eCommerce Simulation - No Hints---
-------------------------------------
-- Summary
-- Let's simulate an e-commerce site. We're going to need users, products, and orders.
-- Users need a name and an email.
-- Products need a name and a price
-- Orders need a ref to product.
-- All 3 need primary keys.
-- Instructions
-- Create 3 tables following the criteria in the summary.
-- Add some data to fill up each table.
-- At least 3 users, 3 products, 3 orders.
-- Run queries against your data.

CREATE TABLE users
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR
(100),
    email VARCHAR
(100)
);

INSERT INTO users
    ( name, email )
VALUES
    ("Jim Brown", "jimbrown@email.com"),
    ( "John Brown", "johnbrown@email.com"),
    ( "Jane Brown", "janebrown@email.com");

SELECT *
FROM users;
-----------------------------
CREATE TABLE products
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR
(100),
    price INTEGER
);

INSERT INTO products
    ( name, price )
VALUES
    ("Shoes", 50),
    ("Shirt", 20),
    ("Pants", 30);

SELECT *
FROM products;
-----------------

CREATE TABLE orders
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL REFERENCES users
(id),
    product_id INTEGER NOT NULL REFERENCES products
(id) 
);

INSERT INTO orders
    ( user_id, product_id )
VALUES
    (1, 3),
    (2, 2),
    (3, 1);
---------------------
-- Get all products for the first order.
select *
from orders
    JOIN products on orders.product_id = products.id
WHERE orders.id = 1;

-- Get all orders.
select *
from orders;

-- Get the total cost of an order ( sum the price of all products on an order ).
select SUM(price)
from orders
    JOIN products on orders.product_id = products.id
WHERE orders.id = 1;

-- Add a foreign key reference from Orders to Users.
ALTER TABLE orders ADD FOREIGN KEY (fk_users)
                                REFERENCES users(id);

-- Update the Orders table to link a user to each order.
select *
from orders
    JOIN users on orders.user_id = users.id;

-- Run queries against your data.
select *
from orders, users, products

-- Get all orders for a user.
select *
from orders
    JOIN users on orders.user_id = users.id
WHERE orders.id = 1;

-- Get how many orders each user has.
select
    count(*)
from
    orders
group by
user_id;


