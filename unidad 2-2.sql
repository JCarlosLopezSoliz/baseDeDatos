--Autor : Jose Carlos Lopez Soliz

USE Northwind
GO

--1.- Crear una tabla, a partir de de la consulta de otra usando SELECT INTO
IF OBJECT_ID (N'Bicycles',N'U') IS NOT NULL
DROP TABLE Bicycles;
GO

SELECT * INTO Bicycles FROM Products
WHERE ProductName LIKE 'Ch%';
GO

SELECT * from Bicycles

--2.- Mostrar la antiguedad de los empleados usando las funciones de fecha

SELECT HireDate FROM dbo.Employees

SELECT DATEDIFF(year, HireDate, '2017/09/22') AS Antiguedad
FROM dbo.Employees

--3.- Calcular la edad real de todos los empleados

SELECT BirthDate FROM dbo.Employees

SELECT DATEDIFF(year, BirthDate, '2017/09/22') AS Edad
FROM dbo.Employees

--4.- Mostrar los productos, agrupados ´por categoria en donde al menos 10 articulos de ella

SELECT ProductName, CategoryID FROM Products
WHERE(UnitsInStock >=10)
GROUP BY ProductName, CategoryID
ORDER BY ProductName;
GO

--5.Mostrar los productos cuyo costo es menor que el costo promedio

SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice < (SELECT  AVG(UnitPrice) AS [Average Price] FROM Products)
GO

--6.- Hacer la union de 2 tablas con valores repetidos y sin valores repetidos

--Con valores Repetidos
SELECT CategoryID, CategoryName FROM Categories
UNION ALL
SELECT	CategoryID, ProductName FROM Products
GO

--Sin valores repetidos
SELECT CategoryID, CategoryName
FROM Categories
UNION 
SELECT	CategoryID, ProductName
FROM Products
GO