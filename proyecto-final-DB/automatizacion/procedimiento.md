# Automatización de respaldo

## Objetivo

Automatizar la generación de respaldos de la base de datos `db_final`
mediante un script de PowerShell.

## Script utilizado

El archivo utilizado es:

`backup_parkour.ps1`

## Funcionamiento

El script realiza las siguientes acciones:

1. Verifica que exista la carpeta de respaldos.
2. Genera automáticamente una fecha y hora para nombrar el archivo.
3. Ejecuta `pg_dump`.
4. Guarda el respaldo en formato personalizado `.dump`.
5. Comprueba que el archivo haya sido creado correctamente.
6. Muestra el tamaño del archivo generado.

## Ejecución

El script se ejecutó desde PowerShell mediante:

```powershell
.\backup_parkour.ps1

Resultado

La ejecución fue exitosa y se generó el siguiente respaldo:

parkour_backup_20260818_113308.dump

Tamaño aproximado:

19486 bytes

Conclusión

La tarea de respaldo fue automatizada correctamente. El script permite
generar nuevos respaldos sin tener que escribir manualmente el comando
pg_dump cada vez.