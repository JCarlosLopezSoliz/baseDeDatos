--Jose Carlos Lopez Soliz
--Ing en sistemas computacionales 
--Taller de base datos 
---------------------------------------------------------------------------------------------------------------------------
--1.- crear una funcion que haga uso dee CTE, para obtener informacion de 1 empleado y sus subordinados en la bd northwind


--2.- crear un decencadenador que despues de insertar, actualizar y eliminar consulte las tablas inserted y deleted
use Northwind
go
CREATE TABLE tablaPruebas (
	 cve TINYINT
	 , nombre VARCHAR(30)
	 , fecha DATE)
------------------------------------------------------------
	CREATE TRIGGER dbo.triggerTablaPruebas ON tablaPruebas
	AFTER INSERT, UPDATE, DELETE
	AS
	 SELECT * FROM deleted;
	 SELECT * FROM inserted;
------------------------------------------------------------
	INSERT INTO tablaPruebas
	VALUES( 1, 'PEDRO' , '20130101' )
	, ( 2 , 'JUAN', '20130403' )
-----------------------------------------------------------
	UPDATE tablaPruebas
	SET nombre = 'LUIS' , fecha = '20101212'
	WHERE cve = 2
----------------------------------------------------------
	DELETE FROM tablaPruebas
	WHERE cve = 1
-----------------------------------------------------------
--3.- Crear un desencadenador que envie un mensaje por correo electronico

CREATE PROCEDURE [dbo].[sp_send_cdontsmail] 
@From varchar(100),
@To varchar(100),
@Subject varchar(100),
@Body varchar(4000),
@CC varchar(100) = null,
@BCC varchar(100) = null
AS
Declare @MailID int
Declare @hr int
EXEC @hr = sp_OACreate 'CDONTS.NewMail', @MailID OUT
EXEC @hr = sp_OASetProperty @MailID, 'From',@From
EXEC @hr = sp_OASetProperty @MailID, 'Body', @Body
EXEC @hr = sp_OASetProperty @MailID, 'BCC',@BCC
EXEC @hr = sp_OASetProperty @MailID, 'CC', @CC
EXEC @hr = sp_OASetProperty @MailID, 'Subject', @Subject
EXEC @hr = sp_OASetProperty @MailID, 'To', @To
EXEC @hr = sp_OAMethod @MailID, 'Send', NULL
EXEC @hr = sp_OADestroy @MailID


exec sp_send_cdontsmail 'karlos48@live.com.mx','ren_evans14@outlook.es','Pruebasss','Funciona'