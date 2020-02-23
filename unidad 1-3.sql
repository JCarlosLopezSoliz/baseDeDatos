--Autor : Jose Carlos Lopez Soliz

--1.-Cambiar el nombre de una base de datos

USE master;
GO
ALTER DATABASE mytest
Modify Name = miprueba ;
GO

ALTER DATABASE miprueba
MODIFY Name = mytest
GO

-- 2.- Borrar una BD
CREATE DATABASE pruebaborrado
GO
DROP DATABASE pruebaborrado;

-- 3.- Agregar una columna a una tabla
USE mytest
GO

CREATE TABLE Pract3PTE3 (columna_A INT) ;
GO
ALTER TABLE Pract3PTE3 ADD columna_B VARCHAR(20) NULL ;
GO

-- Parte 4 agregar una restricción sin verificar los datos existentes (WITH NOCHECK)

CREATE TABLE Pract3PTE4 ( column_A INT) ;
GO
INSERT INTO Pract3PTE4 VALUES (-1) ;
GO
ALTER TABLE Pract3PTE4 WITH NOCHECK
ADD CONSTRAINT restricción CHECK (column_A > 1) ;
GO
EXEC sp_help Pract3PTE4 ;
GO
DROP TABLE Pract3PTE4;
GO 

-- Parte 5  
-- agregar un valor por DEFAULT

CREATE TABLE Pract3PTE5 ( columna_A INT, columna_B INT) ;
GO
INSERT INTO Pract3PTE5 (columna_A)VALUES ( 7 ) ;
GO
ALTER TABLE Pract3PTE5
ADD CONSTRAINT columna_B_Default
DEFAULT 50 FOR columna_B ;
GO
INSERT INTO Pract3PTE5 (columna_A) VALUES ( 10 ) ;
GO
SELECT * FROM Pract3PTE5 ;
GO
DROP TABLE Pract3PTE5 ;
GO

-- PARTE 6
-- Agregar una columna identidad (IDENTITY)

CREATE TABLE PRACT3PTE6 ( columna_A INT CONSTRAINT 
columna_A_unica UNIQUE) ;
GO

ALTER TABLE PRACT3PTE6 ADD columna_B INT IDENTITY
CONSTRAINT columna_B_PK PRIMARY KEY;

-- Parte 7 Agregar una columna tipo FECHA, llenando los registros existentes con la fecha actual(WITH values)

CREATE TABLE PRACTICA3PTE77 ( columna_A INT) ;
GO
INSERT INTO PRACTICA3PTE77 VALUES (1) ;
GO
ALTER TABLE PRACTICA3PTE77
ADD AñadirFecha smalldatetime NULL
CONSTRAINT AñadirFchaPorDefecto
DEFAULT GETDATE() WITH VALUES ;
GO

-- Parte 8 Agregar una columna encriptada
CREATE TABLE PRACTICA3PTE8 ( columna_A INT) ;
GO
ALTER TABLE PRACTICA3PTE8 ADD Parte8 nvarchar(100)
ENCRYPTED WITH (LLAVE = MiLLave,
ENCRYPTION_TYPE = RANDOMIZED,
ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') ;

-- PARTE 9 

CREATE TABLE dbo.doc_exb
(column_a INT
,column_b VARCHAR(20) NULL
,column_c datetime
,column_d int) ;
GO
-- Remove a single column.
ALTER TABLE dbo.doc_exb DROP COLUMN column_b ;
GO
-- Remove multiple columns.
ALTER TABLE dbo.doc_exb DROP COLUMN column_c, column_d;
go

DROP TABLE dbo.doc_exb