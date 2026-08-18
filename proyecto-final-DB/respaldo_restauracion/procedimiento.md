# Respaldo y restauración de la base de datos

## 1. Objetivo

Realizar un respaldo de la base de datos PostgreSQL del proyecto y comprobar
que puede ser restaurado correctamente en una base de datos diferente.

## 2. Base de datos original

La base de datos utilizada para el proyecto es:

`db_final`

El respaldo fue realizado utilizando la herramienta `pg_dump`.

## 3. Generación del respaldo

Se utilizó el siguiente comando en PowerShell:

```powershell

    & "C:\Program Files\PostgreSQL\18\pgAdmin 4\runtime\pg_dump.exe" -U postgres -F c -d db_final -f "C:\Users\angel\Downloads\BD\proyecto-final-DB\respaldo_restauracion\Respaldos\parkour_backup.dump"

El archivo generado fue:

parkour_backup.dump

El respaldo se realizó correctamente y el archivo quedó almacenado en la carpeta
respaldo_restauracion/Respaldos/.

## 4. Creación de la base de restauración

Para comprobar el respaldo se creó una base de datos diferente:

db_final_restore

## 5. Restauración

El respaldo se restauró mediante pg_restore utilizando:

& "C:\Program Files\PostgreSQL\18\bin\pg_restore.exe" -U postgres -d db_final_restore "C:\Users\angel\Downloads\BD\proyecto-final-DB\respaldo_restauracion\Respaldos\parkour_backup.dump"

6. Verificación

Después de la restauración se verificó que el esquema parkour contuviera las
cinco tablas del proyecto:

atletas
asistencias
clases
instructores
membresias

También se verificó la cantidad de registros restaurados:

Atletas: 10
Membresías: 13
Asistencias: 21
7. Resultado

La restauración fue exitosa. La base db_final_restore conserva la estructura
y los datos principales de la base original db_final.

8. Evidencias

Las capturas utilizadas como evidencia se encuentran en la carpeta:

respaldo_restauracion/evidencias/