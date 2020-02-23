--Autor : Jose Carlos Lopez Soliz

USE Northwind
GO

--1.- Realizar las operaciones JOIN con 2 tablas que tengan una relacion en comun
--INNER JOIN
SELECT Products.ProductID,
Categories.CategoryName,
Products.UnitPrice
FROM Products
INNER JOIN Categories ON
Products.CategoryID = Categories.CategoryID;

--LEFT OUTER JOIN
SELECT Orders.OrderID,
Customers.CompanyName,
Orders.OrderDate
FROM Orders
LEFT OUTER JOIN Customers ON
Orders.CustomerID=Customers.CustomerID;

--RIGTH OUTER JOIN
SELECT Orders.OrderID,
Customers.CompanyName,
Orders.OrderDate
FROM Orders
RIGHT OUTER JOIN Customers ON
Orders.CustomerID=Customers.CustomerID;

--FULL OUTER JOIN
SELECT Orders.OrderID,
Customers.CompanyName,
Orders.OrderDate
FROM Orders
FULL OUTER JOIN Customers ON
Orders.CustomerID=Customers.CustomerID;

--Actualiza los precios de todos los productos de la categoria carnicos
UPDATE Products
SET UnitPrice = 300
WHERE CategoryID = '4'

SELECT ProductName, UnitPrice FROM Products WHERE CategoryID = '4'

--3.- Listar la edad de los empleados haciendo el calculo en dias mostrando dicha edad como entero
SELECT CAST(DATEDIFF(YEAR, BirthDate, '2017/09/22') AS INT)
FROM dbo.Employees

--4.- Elaborar un listado con los autores y el total de libros que han escrito
USE pubs

SELECT authors.au_fname, authors.au_lname,  COUNT(titleauthor.title_id) as 'Total books' FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
GROUP BY authors.au_fname, authors.au_lname

--5.- Muestra la editorial con mas publicaciones
SELECT TOP 1 Publishers.pub_name, count(publishers.pub_name) as 'titles' FROM Publishers
INNER JOIN titles ON publishers.pub_id = titles.pub_id
group by publishers.pub_name

SELECT publishers.pub_name, titles.title from publishers
inner join titles on publishers.pub_id = titles.pub_id

--6.- Lista el producto mas caro
SELECT TOP 1 title, price FROM titles ORDER BY price DESC

--7.- Cual es la region donde mas se levantan pedidos
USE Northwind
GO

SELECT OrderID, EmployeeID FROM orders


