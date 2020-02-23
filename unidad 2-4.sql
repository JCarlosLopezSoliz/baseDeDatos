--Autor : Jose Carlos Lopez Soliz

USE Northwind
GO

--1.- Utiliza la instruccion SET para definir una variable de usuario que emplees en una consulta

DECLARE @Verde int;
SET @Verde = 4;
SELECT * FROM Products WHERE CategoryID = @Verde;

--2.- Defina 3 variables de entorno

--1
DECLARE @myvar char(20);  
SET @myvar = 'This is a test';  
SELECT @myvar;  
GO 
 
--2
DECLARE @fechas datetime;
SET @fechas = '1000/01/19';
SELECT @fechas;
GO

--3
DECLARE @variable3 nvarchar(30);
SET @variable3 = 'Carlos :D';
SELECT @variable3;
GO

--3. Crea una vista con schemabinding, e intenta modificar el esquema de una
--de las tablas origen de dicha vista

CREATE TABLE dbo.SUPPLY1 (
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 1 and 150),
supplier CHAR(50)
);
CREATE TABLE dbo.SUPPLY2 (
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 151 and 300),
supplier CHAR(50)
);
CREATE TABLE dbo.SUPPLY3 (
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 301 and 450),
supplier CHAR(50)
);
CREATE TABLE dbo.SUPPLY4 (
supplyID INT PRIMARY KEY CHECK (supplyID BETWEEN 451 and 600),
supplier CHAR(50)
);
GO
INSERT dbo.SUPPLY1 VALUES ('34', 'Telmex'), ('9', 'Mexico')
GO

CREATE VIEW dbo.all_supplier_view
WITH SCHEMABINDING
AS

SELECT supplyID, supplier
FROM dbo.SUPPLY1 
UNION ALL
SELECT supplyID, supplier
FROM dbo.SUPPLY2
UNION ALL
SELECT supplyID, supplier
FROM dbo.SUPPLY3
UNION ALL
SELECT supplyID, supplier
FROM dbo.SUPPLY4;


