--1.-Crear un usuario a nivel de Windows que se llame Carlos, Asignar una contraseña que cumpla con los criterios de seguridad que marca SQL Server
CREATE LOGIN Carlos WITH PASSWORD = '12345HAHAHAha.'

--2.-Modificar la contraseña de Carlos
ALTER LOGIN Carlos WITH PASSWORD= '12345EstaEsLaContraseña'

--3.-Crear otro usuario de Windows que se llame panchito con todo y contraseña segura
CREATE LOGIN Panchito WITH PASSWORD= '12345ContraseñaCompleja'

--4.-Eliminar a Carlos
DROP LOGIN Carlos
GO

--5.- Asignar a Panchito el rol de administrador del sistema
EXEC sp_addsrvrolemember  'Panchito', 'sysadmin'

--6-Crear un usuario para la bse de datos NORTHWIND que se llame Laura y crear un rol llamado Examen y asignar a Laura este rol.
USE Northwind
GO

CREATE USER Laura FOR LOGIN Panchito
GO

CREATE SERVER ROLE  Examen 
GO

EXEC sp_addsrvrolemember 'Laura', 'Examen'
GO


--7.- Asignar a Laura al rol que permita manejar los permisos dentro de la base de datos
EXEC sp_addSRVrolemember 'db_securityadmin','Laura'
GO
--8.- Eliminar el rol asignado a laura 
Drop Role Examen
--9.-Otorgar el permiso para agregar registros a Laura
GRANT INSERT TO Laura
GO

--10.- Bloquear temporalmente el permiso de agregar registros a Laura, para posteriormente, lo vuelva a tener.

REVOKE INSERT TO Laura
GO