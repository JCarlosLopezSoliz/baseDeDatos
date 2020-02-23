--Jose Carlos Lopez Soliz

/*  1.- Explique cada una de las propiedades ACID de una transaccion
	Atomicidad: 
	Cuando se ejecuta una operacion, que consiste en varios pasos, esta se hace por completo o se anulan
    los pasos que se habian completado ya. En resumen, se hace la transaccion completa o no se hace.

    Consistencia:
	Solo se ejecutan aquellas operaciones que no van a romper las reglas de la base de datos. La propiedad de 
	consistencia sostiene que cualquier transacción llevará a la base de datos desde un estado válido a otro
    también válido.

    Aislamiento:
	Esta propiedad asegura que solo se podra afectar los datos por medio de una transaccion a la vez, si hay dos
	transacciones tratando de accesar a los mismos datos, una de ellas tendra que esperar a que la otra termine.

    Durabilidad:
	Esta propiedad asegura que una vez realizada la operación, esta persistirá y no
    se podrá deshacer aunque falle el sistema y que de esta forma los datos sobrevivan.

	*/

	--2-Con transacciones autocometidas. Crear una base de datos llamada Unidad 4 y dentrode ella crear una tabla
		--llamada Examen4 con los siguientes campos(c1 int primary key, c2 varchar(10), c3 XML)
		Set implicit_transactions off
		go
		USE master
		go
		Create database Unidad4
		go
		
		create table Examen4(
		 c1 int not null Primary key, 
		 c2 varchar(10), 
		 c3 XML)

		 drop database Unidad4
	--3.- Con una transaccion explicita, inserte  el siguiente registro en la tabla Examen4.
	Begin transaction
		insert into Examen4 values(1,'Examen','<doc id="123"> 
		<sections><section num ="2"> <heading>Background</heading></section>
		<section num="3">
		<heading>Sort</heading></section> <section num="4">
		<heading>Search</heading> </section>
		</sections> </doc>')
	--4.- Establecer un punto de verificacion
	checkpoint
	--5.-Completar la transaccion explicita 
	BEGIN TRY
		commit transaction
		 end try 
	--6.-Deshacerla transaccion explicita
		 begin catch
		 ROLLBACK TRANSACTION;
		 PRINT  
            N'Se ah producido un error'
		 end catch

	--7.-Crear un indice agrupado para la tabla Examen4 llamado IX_Agrupa
		create clustered index IX_Agrupa on Examen4(c2);
		go
		
	--8.-Crear un indice de tipo filtrado llamdo IX_FIL sobre la tabla Examen4 para todos los c2 que sean de tipo
	--Examen
		CREATE NONCLUSTERED INDEX IX_FIL
		ON Examen4 (c2)  
		WHERE c2='Examen';  
		GO  
	--9.-Sobre la base de datos Unidad4, crear una tabla llamada Jerarquia en la qe se almacene lo siguiente y 
	--crear un indice primero en profundidad llamado IX_JerProfe:
		USE DatosJer
CREATE TABLE Jerarquia ( Level hierarchyid not null,
							nombre varchar(50) not null)
INSERT INTO Jerarquia Values ('/','DEPTO1')
INSERT INTO Jerarquia Values ('/1/','PROFESOR1')
INSERT INTO Jerarquia Values ('/2/','PROFESOR2')
INSERT INTO Jerarquia Values ('/3/','PROFESOR3')
INSERT INTO Jerarquia Values ('/1/1/','CURSO1')
INSERT INTO Jerarquia Values ('/1/2/','CURSO2')
INSERT INTO Jerarquia Values ('/2/1/','CURSO3')
INSERT INTO Jerarquia Values ('/3/1/','CURSO4')

CREATE UNIQUE INDEX IX_JerProfe
ON Jerarquia(Level)
GO

SELECT CAST (Level AS nvarchar(100)) AS [Niveles], *
FROM Jerarquia ORDER BY Level; 
	--10.- Escribir la sintaxis que permite obtener toda la informacion de los indices de la tabla Examen4 para 
	--su posterior mantenimiento, ya sea reconstruccion o reorganizacion, dependiendo de los porcentajes
	DECLARE @db_id SMALLINT;
DECLARE @object_id INT;

SET @db_id = DB_ID(N'Unidad4');
SET @object_id = OBJECT_ID(N'Unidad4.dbo.Examen4');

IF @db_id IS NULL
BEGIN;
	PRINT N'Invalid database';
END;
ELSE IF @object_id IS NULL
BEGIN;
	PRINT N'Invalid database';
END;
ELSE 
BEGIN;
SELECT * FROM sys.dm_db_index_physical_stats(@db_id,@object_id,NULL,NULL,'DETAILED');
END;
GO