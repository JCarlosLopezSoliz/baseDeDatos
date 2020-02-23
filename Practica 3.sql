--Lopez Soliz Jose Carlos
--Instituto tecnologico de Leon
--Ing. en sistemas computacionales
--Taller de base de datos

------------------------------------------------------------------------------------------------------------
USE northwind;
GO

--1.- Hacer un procedimiento almacenado que maneje un cursor como parametro de salida
CREATE PROCEDURE sp_manejoCursor @cursor CURSOR VARYING OUTPUT AS
	SET NOCOUNT ON;
	SET @cursor = CURSOR FORWARD_ONLY STATIC FOR
		SELECT Title, FirstName, LastName FROM Employees;
	OPEN @cursor

DECLARE @myCursor CURSOR;
EXEC sp_manejoCursor @cursor = @myCursor OUTPUT;
WHILE(@@FETCH_STATUS = 0)
BEGIN;
	FETCH NEXT FROM @myCursor;
END;
CLOSE @myCursor;
DEALLOCATE @myCursor;
GO

--2.- Hacer un SP que actualize o inserte
CREATE PROCEDURE sp_actualizarRegion @region varchar(3) AS
	UPDATE Employees SET Region = @region WHERE country = 'UK'
GO

EXEC sp_actualizarRegion 'EU'
select * from employees

--3.- Hacer un SP que elimine registros en tablas relacionadas empleando manejo de errores
select * from [Order Details]
CREATE PROCEDURE sp_eliminarOrden (@orden int) AS
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM OrderDetails WHERE OrderID = @orden;
			DELETE FROM Orders WHERE OrderID = @orden;
		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK
		DECLARE @ErrorMessage varchar(4000), @ErrorSeverity int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY();
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
	END CATCH
GO

CREATE PROCEDURE sp_eliminarOrden2 (@orden int) AS
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM Orders WHERE OrderID = @orden;
			DELETE FROM OrderDetails WHERE OrderID = @orden;
		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK
		DECLARE @ErrorMessage varchar(4000), @ErrorSeverity int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY();
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
	END CATCH
GO
EXEC sp_eliminarOrden 10249
EXEC sp_eliminarOrden2 10249
select * from Orders