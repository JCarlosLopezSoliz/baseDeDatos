--Autor : Jose Carlos Lopez Soliz

--Practica 1 Crear una Base de Datos con loas caracteristicas de Mode/--

USE master;
GO
IF DB_ID('Practica1')
IS NOT NULL DROP DATABASE Practica1;
GO
CREATE DATABASE Practica1;
GO

--Practica 2 Crear una Base de Datos con 2 archivos de Datos y 2 Archivos de registro de transacciones--
USE master;
GO
CREATE DATABASE Archivos
ON
PRIMARY
(NAME = Arch1,
FILENAME = 'C:\Prueba\archdat1.mdf',
SIZE = 100MB,
MAXSIZE= 200,
FILEGROWTH = 20),
(NAME = Arch2,
FILENAME = 'C:\Prueba\archdat2.ndf',
SIZE = 100MB,
MAXSIZE= 200,
FILEGROWTH = 20),
(NAME = Arch3,
FILENAME = 'C:\Prueba\archdat3.ndf',
SIZE = 100MB,
MAXSIZE= 200,
FILEGROWTH = 20)
LOG ON

(NAME = Archlog1,
FILENAME = 'C:\Prueba\archlog1.ldf',
SIZE = 100MB,
MAXSIZE= 200,
FILEGROWTH = 20),
(NAME = Archlog2,
FILENAME = 'C:\Prueba\archlog2.ldf',
SIZE = 100MB,
MAXSIZE= 200,
FILEGROWTH = 20);

GO


--Practica 3 Crear una Base de Datos con los archivos de datos y de registro de transacciones en diferentes unidadews(o carpetas)--

USE master;
GO
CREATE DATABASE Sales
ON 
PRIMARY
(NAME = SPri1_dat,
FILENAME = 'C:\Prueba2\SPri1dat.mdf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 15 %),
(NAME = SPri2_dat,
FILENAME = 'C:\Prueba2\SPri2dt.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 15 %),

FILEGROUP SalesGroup1
(NAME = SGrp1Fi1_dat,
FILENAME = 'C:\Prueba2\SG1Fi1dt.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5 ),
(NAME = SGrp1Fi2_dat,
FILENAME = 'C:\Prueba2\SG1Fi2dt.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5 ),
FILEGROUP SalesGroup2
(NAME = SGrp2Fi1_dat,
FILENAME = 'C:\Prueba2\SG2Fi1dt.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5 ),
(NAME = SGrp2Fi2_dat,
FILENAME = 'C:\Prueba2\SG2Fi2dt.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5 )
LOG ON

(NAME = Sales_log,
FILENAME = 'C:\Prueba2\Prueba3\salelog.ldf',
SIZE = 5MB,
MAXSIZE = 25MB,
FILEGROWTH = 5MB );

GO

--Practica 4 Separar y Conectar alguna de las Bases de Datos--
USE MASTER;
GO
sp_detach_db Archivos;
GO
CREATE DATABASE mytest
ON (FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\mytest.mdf')
FOR ATTACH;
GO

--Practica 5 Crear una instantanea de alguna de las Base de datos--
USE master;
GO
CREATE DATABASE sales_snapshot0600 ON
(NAME = SPri1_dat, FILENAME = 'C:\SalesData\SPri1dat_0600.ss'),
(NAME = SPri2_dat, FILENAME = 'C:\SalesData\SPri2dat_0600.ss'),
(NAME = SGrp1Fi1_dat, FILENAME = 'C:\SalesData\SG1Fi1dt_0600.ss'),
(NAME = SGrp1Fi2_dat, FILENAME = 'C:\SalesData\SG1Fi2dt_0600.ss'),
(NAME = SGrp2Fi1_dat, FILENAME = 'C:\SalesData\SG2Fi1dt_0600.ss'),
(NAME = SGrp2Fi2_dat, FILENAME = 'C:\SalesData\SG2Fi2dt_0600.ss')
AS SNAPSHOT OF Saless;
GO

