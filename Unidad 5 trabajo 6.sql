--Jose Carlos Lopez Soliz 
--ITL
--Taller De Base De Datos
---------------------------------------------------------------------------------------------------------------------------------------------------
--1.- Crear un desencadenador que maneje 1 a multiples registros

	--Modificamos un campo
--------------------------------------------------------------------------------------
creamos la tabla alumno
Use mytest
CREATE TABLE alumno
(
nombre VARCHAR(20),
STATUS INT
)
-------------------------------------------------------------------------------------- 
--insertamos 3 registros con status=1
INSERT INTO alumno VALUES ('Carlos',1)
INSERT INTO alumno VALUES ('Ray',1)
INSERT INTO alumno VALUES ('koku',1)

SELECT * FROM alumno
 ----------------------------------------------------------------------------------------------------
--se crea la tabla periodo
CREATE TABLE periodo
(
periodo datetime
)
-----------------------------------------------------------------------------------------------------
--insertamos 2 datos en la tabla periodo 
SELECT * FROM periodo
------------------------------------------------------------------------------------------------------
--creamos el trigger
CREATE TRIGGER [dbo].[trg_Periodo]
ON [dbo].[Periodo]
AFTER INSERT
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
 ------------------------------------------------------------------------------------------------------
-- Insert statements for trigger here
UPDATE Alumno SET
STATUS = 0
WHERE STATUS = 1
END
 -------------------------------------------------------------------------------------------------------
--insertamos un valor en la tabla periodo
INSERT INTO periodo VALUES (GETDATE()+30)
 --------------------------------------------------------------------------------------------------------
--la tabla de alumnos quedaron todos con status=0
SELECT * FROM alumno
---------------------------------------------------------------------------------------------------------
		--Modificamos varios campos
USE AdventureWorks2012
GO
CREATE TRIGGER NewPODetail ON Purchasing.PurchaseOrderDetail
AFTER INSERT AS 
	UPDATE Purchasing.PurchaseOrderHeader
	SET SubTotal = SubTotal +
		(SELECT SUM(LineTotal) FROM inserted 
		WHERE PurchaseOrderHeader.PurchaseOrderID = inserted.PurchaseOrderID)
	WHERE PurchaseOrderHeader.PurchaseOrderID IN (SELECT PurchaseOrderID FROM inserted);
----------------------------------------------------------------------------------------------------------

--2.- Crear un desencadenador instead off y affter
if object_id('empleados') is not null
  drop table empleados;
if object_id('clientes') is not null
  drop table clientes;

create table empleados(
  documento char(8) not null,
  nombre varchar(30),
  domicilio varchar(30),
  constraint PK_empleados primary key(documento)
);

create table clientes(
  documento char(8) not null,
  nombre varchar(30),
  domicilio varchar(30),
  constraint PK_clientes primary key(documento)
);

-- Eliminamos la siguiente vista:
if object_id('vista_empleados_clientes') is not null
  drop view vista_empleados_clientes;

go

-- Creamos una vista que muestra los datos de ambas tablas:
create view vista_empleados_clientes
 as
  select documento,nombre, domicilio, 'empleado' as condicion from empleados
  union
   select documento,nombre, domicilio,'cliente' from clientes;

go

-- Creamos un disparador sobre la vista "vista_empleados_clientes" para inserción,
-- que redirija las inserciones a la tabla correspondiente:
create trigger DIS_empl_clie_insertar
  on vista_empleados_clientes
  instead of insert
  as
    insert into empleados 
     select documento,nombre,domicilio
     from inserted where condicion='empleado'

    insert into clientes
     select documento,nombre,domicilio
     from inserted where condicion='cliente';

go

-- Ingresamos un empleado y un cliente en la vista:
insert into vista_empleados_clientes values('22222222','Ana Acosta', 'Avellaneda 345','empleado');
insert into vista_empleados_clientes values('23333333','Bernardo Bustos', 'Bulnes 587','cliente');

-- Veamos si se almacenaron en la tabla correspondiente:
select * from empleados;
select * from clientes;

go

-- Creamos un disparador sobre la vista "vista_empleados_clientes" para el evento "update",
-- que redirija las actualizaciones a la tabla correspondiente:
create trigger DIS_empl_clie_actualizar
  on vista_empleados_clientes
  instead of update
  as
   declare @condicion varchar(10)
   set @condicion = (select condicion from inserted)
   if update(documento)
   begin
    raiserror('Los documentos no pueden modificarse', 10, 1)
    rollback transaction
   end
   else
   begin
    if @condicion ='empleado'
    begin
     update empleados set empleados.nombre=inserted.nombre, empleados.domicilio=inserted.domicilio
     from empleados
     join inserted
     on empleados.documento=inserted.documento
    end
    else
     if @condicion ='cliente'
     begin
      update clientes set clientes.nombre=inserted.nombre, clientes.domicilio=inserted.domicilio
      from clientes
      join inserted
      on clientes.documento=inserted.documento
     end
   end;

go

-- Realizamos una actualización sobre la vista, de un empleado:
update vista_empleados_clientes set nombre= 'Ana Maria Acosta' where documento='22222222';

-- Veamos si se actualizó la tabla correspondiente:
select * from empleados;

-- Realizamos una actualización sobre la vista, de un cliente:
update vista_empleados_clientes set domicilio='Bulnes 1234' where documento='23333333';

-- Veamos si se actualizó la tabla correspondiente:
select * from clientes;