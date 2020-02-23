--Autor : Jose Carlos Lopez Soliz

use bancos2
go
--A. CREAR UNA LLAVE PRIMARIA
ALTER TABLE sucursal  ADD 
	CONSTRAINT [PK_sucursal] PRIMARY KEY  CLUSTERED 
	( [nombre_sucursal] )  ON [PRIMARY] 
	
ALTER TABLE cuenta ADD
	CONSTRAINT [PK_cuenta] PRIMARY KEY CLUSTERED
		([numero_cuenta]) ON [PRIMARY]
		
ALTER TABLE cliente ADD
	CONSTRAINT [PK_cliente] PRIMARY KEY CLUSTERED
		([nombre_cliente]) ON [PRIMARY]


-- B. Crear una llave foranea
ALTER TABLE cuenta ADD
	CONSTRAINT FK_cta_suc FOREIGN KEY
		(nombre_sucursal) REFERENCES
			sucursal(nombre_sucursal)
			ON DELETE CASCADE ON UPDATE CASCADE
GO

--D. DEFAULT
CREATE TABLE Banco(Nombre VARCHAR,Dirección VARCHAR);	
GO
ALTER TABLE Banco 
ADD CONSTRAINT cuenta_banco_def  
DEFAULT 'Santannder' FOR Nombre ;  --Se usa el default para establecer ese nombre en la columna Nombre
GO  
--E. CHECK CONSTRAINTS
    ALTER TABLE prestamo
    ADD CHECK (importe >0)
    GO 
    
 ALTER TABLE prestamo
 ADD CONSTRAINT DF_prestamo_estado_03317E3D CHECK (estado LIKE
'[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]'
OR estado LIKE '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]')
GO
--F. Mostrando la definición completa de la tabla

SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
       , IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'prestamo'

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_NAME = 'prestamo'

SELECT name, type_desc, is_unique, is_primary_key
FROM sys.indexes
WHERE [object_id] = OBJECT_ID('dbo.prestamo')

--G. Creating a table with an xml column typed to an XML schema collection
CREATE XML SCHEMA COLLECTION ClienteSchemaCollection AS  
N'<?xml version="1.0" encoding="UTF-16"?>'

CREATE TABLE clientesHistorial
(Nombre nvarchar(25),
Resume xml( DOCUMENT ClienteSchemaCollection) );

--H. Creating a partitioned table
CREATE PARTITION FUNCTION Importes (int)
AS RANGE LEFT FOR VALUES (1, 100, 1000,10000) ;
GO
CREATE PARTITION SCHEME MiScheme
AS PARTITION Importes
TO (FG1,FG2,FG3);
GO
CREATE TABLE PartitionTable (importe1 int, cliente char(10))
ON MiScheme (importe1) ;
GO

--I.- Using the uniqueidentifier data type in a column

CREATE TABLE dbo.CuentasClientes
(guid uniqueidentifier
CONSTRAINT cuentas_Default DEFAULT
NEWSEQUENTIALID() ROWGUIDCOL,
numero_cuenta char(5)
CONSTRAINT Bcuentas_PK PRIMARY KEY (guid) );

--J. Using an expression for a computed column

CREATE TABLE dbo.PromedioImportesPrestamos
( low int, high int, importe AS (low + high/2));

--K. Creating a computed column based on a user-defined type column
ALTER TABLE Deposito DROP COLUMN fecha_deposito;  
GO  
ALTER TABLE Deposito ADD fecha_deposito AS (GETDATE ( ));
--L. Using the USER_NAME function for a computed column
ALTER TABLE Deposito ADD nombre_clientes AS USER_NAME();

--M. Creating a table that has a FILESTREAM column
use bancos
CREATE TABLE dbo.EmpleadoFoto
(
EmployeeId int NOT NULL PRIMARY KEY,
Photo varbinary(max) FILESTREAM NULL
,MyRowGuidColumn uniqueidentifier NOT NULL ROWGUIDCOL
UNIQUE DEFAULT NEWID()
);

--N. Creating a table that uses row compression

CREATE TABLE dbo.Depositos
(c1 int, c2 nvarchar(200) )
WITH (DATA_COMPRESSION = ROW);

--O.Creating a table that has sparse columns and a column set
CREATE TABLE T1
(c1 int PRIMARY KEY,
c2 varchar(50) SPARSE NULL,
c3 int SPARSE NULL,
CSet XML COLUMN_SET FOR ALL_SPARSE_COLUMNS ) ;

--P--

use bancos2
go

CREATE TABLE Departmento
(
DepartmentoNumbero char(10) NOT NULL PRIMARY KEY CLUSTERED,
DepartmentoNombre varchar(50) NOT NULL,
ID int NULL,
LiderDepartomentNumero char(10) NULL,
SysStartTime datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
SysEndTime datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)
)
WITH (SYSTEM_VERSIONING = ON);

--Tabla temporal

CREATE TABLE Departmento1
(
Numero_Departamento char(10) NOT NULL PRIMARY KEY CLUSTERED,
Nombre_Depetartamento varchar(50) NOT NULL,
ID INT NULL,
ParentDepartmentNumber char(10) NULL,
SysStartTime datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
SysEndTime datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)
)
WITH
(SYSTEM_VERSIONING = ON
(HISTORY_TABLE = dbo.Department_History, DATA_CONSISTENCY_CHECK = ON )
);

--Q--

use bancos2
go



CREATE TABLE Departmento_2
(
Numero_Departamento char(10) NOT NULL PRIMARY KEY CLUSTERED,
Nombre_Departamento varchar(50) NOT NULL,
ID INT NULL,
Dueño_Departamento char(10) NULL,
SysStartTime datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
SysEndTime datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)
)
WITH
(SYSTEM_VERSIONING = ON
(HISTORY_TABLE = dbo.cuenta, DATA_CONSISTENCY_CHECK = ON )
);


--R

CREATE TABLE EMPLEADOS(
NOM_EMPLEADO VARCHAR(20),
ID_EMPLEADO VARCHAR(20),
CODIGO_EMPLEADO VARCHAR (20),
--CIFRADO_CLAVE VARBINARY(MAX),
--CIFRADO_GANANCIA VARBINARY(MAX),
GANANCIA_EMPLEADO INT
);

INSERT INTO EMPLEADOS
VALUES ('ERNESTO FIERRO','14520726','GATO','10000')
INSERT INTO EMPLEADOS
VALUES ('ULISES ROSTRO','15862368','CLAVE-CLAVE','10000')
INSERT INTO EMPLEADOS
VALUES ('CRISTOFER TOSTADO','16589742','PERRO','10000')
GO

USE MASTER;
GO
SELECT * FROM sys.symmetric_keys
WHERE NAME='##MS_ServiceMasterKey'
GO

USE bancos2;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD='Clave123456789';
GO

USE bancos2
GO
CREATE CERTIFICATE certificado1
WITH SUBJECT ='PROTECT_DATA';
GO

USE bancos2
GO
CREATE SYMMETRIC KEY CLAVESIMETRICA1
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE certificado1;
GO

USE bancos2
GO
ALTER TABLE EMPLEADOS ADD
CIFRADO_CLAVE VARBINARY(MAX),
CIFRADO_GANANCIA VARBINARY(MAX)
GO

OPEN SYMMETRIC KEY CLAVESIMETRICA1
DECRYPTION BY CERTIFICATE certificado1
GO
UPDATE EMPLEADOS
SET CIFRADO_CLAVE= ENCRYPTBYKEY (KEY_GUID('CLAVESIMETRICA1'), CODIGO_EMPLEADO),
    CIFRADO_GANANCIA= ENCRYPTBYKEY (KEY_GUID('CLAVESIMETRICA1'), GANANCIA_EMPLEADO)
FROM EMPLEADOS;
GO

CLOSE SYMMETRIC KEY CLAVESIMETRICA1;
GO

OPEN SYMMETRIC KEY CLAVESIMETRICA1
DECRYPTION BY CERTIFICATE certificado1;
GO

SELECT NOM_EMPLEADO, CIFRADO_CLAVE,CIFRADO_GANANCIA,
CONVERT (varchar, DecryptByKey(CIFRADO_CLAVE)) AS 'CLAVE ENCRIPTADA',
CONVERT (varchar, DecryptByKey(CIFRADO_GANANCIA)) AS 'CLAVE ENCRIPTADA1'
FROM EMPLEADOS
GO

CLOSE SYMMETRIC KEY CLAVESIMETRICA1;
GO



 





SELECT*FROM EMPLEADOS
