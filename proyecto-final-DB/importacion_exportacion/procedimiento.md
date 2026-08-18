# Importación y exportación de datos

## Exportación

Se realizó la exportación de la tabla `parkour.atletas` a un archivo CSV mediante PostgreSQL utilizando `psql` y `\copy`.

### Comando utilizado

```powershell
psql -U postgres -d db_final -c "\copy parkour.atletas TO 'atletas_export_final.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')"

El resultado de la operación fue:

COPY 10

Lo anterior indica que se exportaron los 10 registros de la tabla.

Importación

El archivo CSV se importó posteriormente en la tabla de prueba:

parkour.atletas_importados

Comando utilizado
psql -U postgres -d db_final -c "\copy parkour.atletas_importados FROM 'atletas_export_final.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')"

El resultado de la operación fue:

COPY 10

Verificación

Se comparó el número de registros de la tabla original y de la tabla importada.

Resultado:

Registros originales: 10
Registros importados: 10

La importación se realizó correctamente.