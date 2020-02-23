--Autor : Jose Carlos Lopez Soliz

use bancos2
go
--1.- Crear un índice UNIQUE
CREATE UNIQUE INDEX iindex1 ON cuenta (numero_cuenta ASC);
--2.-Crear un índice para 2 o más campos
CREATE INDEX iindex2 ON cuenta (numero_cuenta ASC, saldo ASC);
--3.- Ver los óindices existentes en una tabla(sys.indexes)
SELECT i.name AS index_name
    ,i.type_desc
    ,is_unique
    ,ds.type_desc AS filegroup_or_partition_scheme
    ,ds.name AS filegroup_or_partition_scheme_name
    ,ignore_dup_key
    ,is_primary_key
    ,is_unique_constraint
    ,fill_factor
    ,is_padded
    ,is_disabled
    ,allow_row_locks
    ,allow_page_locks
FROM sys.indexes AS i
INNER JOIN sys.data_spaces AS ds ON i.data_space_id = ds.data_space_id
WHERE is_hypothetical = 0 AND i.index_id <> 0 
AND i.object_id = OBJECT_ID('cuenta');
GO

--4.-Crear un índice en base a uno existente sobre escribiendolo (drop_existing=on)

CREATE NONCLUSTERED INDEX iindex2
ON cuenta (numero_cuenta, saldo)
WITH (DROP_EXISTING = ON);

--5.- Crear un índice especificando el factor de relleno en 75% pag736

CREATE NONCLUSTERED INDEX iindex2
ON cuenta(saldo)
WITH (FILLFACTOR = 75,
PAD_INDEX = ON,
DROP_EXISTING = ON);
GO
--6.- Modificar el índice con el fin de reconstruirlo pag 220
ALTER INDEX iindex1 ON cuenta REBUILD;
--7.- Eliminar un índice pag 1078
DROP INDEX iindex1
ON cuenta;
GO
select* from cuenta
go
