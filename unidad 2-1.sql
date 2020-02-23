--Autor : Jose Carlos Lopez Soliz

USE mytest
GO

--1.- Insertar un registro con valores por default

CREATE TABLE Tabla1
(
column_1 varchar(30),
column_2 varchar(30)
CONSTRAINT default_name DEFAULT ('my column default'));
GO

INSERT INTO dbo.Tabla1 (column_2) VALUES ('Explicit value');
INSERT INTO dbo.Tabla1 VALUES ('Explicit value', 'Explicit value');
INSERT INTO Tabla1 DEFAULT VALUES;
GO

SELECT * FROM dbo.Tabla1;
GO

--2.- Habilitar la inserccion en un campo IDENTITY y agregar un valor explicito

CREATE TABLE dbo.Tabla2 ( column_1 int IDENTITY, column_2 VARCHAR(30));
GO

INSERT Tabla2 VALUES ('Row #1');
INSERT Tabla2 (column_2) VALUES ('Row #2');
GO

SET IDENTITY_INSERT Tabla2 ON;
GO

SELECT * FROM Tabla2;
GO

--3.- Insertar un registro empleando la funcion NEWID() para un campo uniqueidentifier

CREATE TABLE dbo.registro
(
column_1 int IDENTITY,
column_2 uniqueidentifier,
);
GO

INSERT INTO dbo.registro (column_2) VALUES (NEWID());
INSERT INTO registro DEFAULT VALUES;
GO

SELECT * FROM dbo.registro;


--4.- Insertar registros a partir de una consulta de otra tabla
CREATE TABLE dbo.empleado ( column_1 int IDENTITY, column_2 VARCHAR(30));
GO

CREATE TABLE empleado2 ( column_1 int IDENTITY, column_2 VARCHAR(30));
GO

INSERT empleado VALUES ('Row #1');
INSERT empleado (column_2) VALUES ('Row #2');
GO

SET IDENTITY_INSERT empleado OFF;
GO

INSERT INTO empleado2 (column_2) SELECT column_2 FROM empleado;

SELECT * from empleado2


--5.- Insertar registros estableciendo un bloqueo exclusivo (XLOCK)

INSERT INTO empleado WITH (XLOCK) VALUES ('Row #3');

SELECT * FROM empleado
GO

--6.- Eliminar registros imprimiendo el total de elementos eliminados
INSERT INTO empleado VALUES
('Row #4'),
('Row #5'),
('Row #6')
GO

SELECT * FROM empleado
GO

DELETE empleado WHERE column_1 BETWEEN 4 AND 6
PRINT 'Number of rows deleted is ' + CAST(@@ROWCOUNT as char(3));


--7.- Eliminar 5 registros con TOP
INSERT INTO empleado VALUES
('Row #4'),
('Row #5'),
('Row #6'),
('Row #7'),
('Row #8'),
('Row #9'),
('Row #10'),
('Row #11'),
('Row #12'),
('Row #13')
GO

DELETE TOP (5) FROM empleado WHERE column_1 > '4';
GO

SELECT * FROM empleado
GO

--8.- Eliminar registros de acuerdo a alguna condicion mostrando los registros eliminados
DELETE TOP (3) FROM empleado OUTPUT deleted.*
WHERE column_1 < '5';
GO