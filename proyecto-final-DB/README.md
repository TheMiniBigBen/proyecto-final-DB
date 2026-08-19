Proyecto Final - Administración de Bases de Datos
Administración de una base de datos PostgreSQL para un gimnasio de Parkour


Integrantes


Alfonso Ramírez Bravo
Castillo Nevares Ángel Eduardo

1. Descripción del proyecto

Este proyecto consiste en el diseño y administración de una base de datos PostgreSQL para un gimnasio de Parkour.

La base de datos permite administrar información relacionada con atletas, instructores, clases, membresías y asistencias.

El objetivo principal es aplicar los conocimientos de administración de bases de datos vistos durante la asignatura, incluyendo:

creación de estructuras relacionales;
llaves primarias y foráneas;
restricciones de integridad;
índices;
carga de datos;
consultas SQL;
usuarios y permisos;
respaldo y restauración;
importación y exportación de información;
automatización de respaldos;
monitoreo y revisión de calidad de datos.

MongoDB se aborda únicamente en una sección teórica para comparar el modelo relacional con el modelo orientado a documentos.

2. Caso de estudio

El caso elegido corresponde a la administración de un gimnasio especializado en Parkour.

La información principal del sistema se divide en las siguientes entidades:

Instructores

Contiene el personal encargado de impartir las clases.

Atletas

Contiene la información básica de los clientes o atletas registrados en el gimnasio.

Clases

Contiene las clases disponibles, el instructor asignado, rango de edad y cupo máximo.

Membresías

Permite registrar el historial de membresías de cada atleta, incluyendo tipo, periodo de vigencia y estado administrativo.

Asistencias

Registra la entrada de los atletas a las diferentes clases.

3. Modelo relacional

El proyecto utiliza cinco tablas principales:

INSTRUCTORES
     │
     │ 1:N
     ▼
   CLASES
     │
     │ 1:N
     ▼
ASISTENCIAS
     ▲
     │ N:1
     │
   ATLETAS
     │
     │ 1:N
     ▼
MEMBRESÍAS

Las relaciones principales son:

Un instructor puede impartir varias clases.
Una clase pertenece a un instructor.
Un atleta puede tener varias membresías a lo largo del tiempo.
Una membresía pertenece a un atleta.
Un atleta puede registrar varias asistencias.
Una asistencia pertenece a un atleta y a una clase.
4. Estructura del repositorio
proyecto-final-DB/
│
├── README.md
│
├── sql/
│   ├── 01_creacion.sql
│   ├── 02_datos.sql
│   ├── 03_usuarios_permisos.sql
│   ├── 04_consultas.sql
│   └── 05_calidad_monitoreo.sql
│
├── respaldo_restauracion/
│   ├── procedimiento.md
│   ├── evidencias/
│   └── Respaldos/
│
├── importacion_exportacion/
│   ├── procedimiento.md
│   ├── exportaciones/
│   └── importaciones/
│
├── automatizacion/
│   ├── backup_parkour.ps1
│   ├── procedimiento.md
│   ├── backups/
│   └── evidencias/
│
├── teoria_mongodb/
│   └── fundamentos.md
│
└── evidencias/
5. Requisitos

Para ejecutar el proyecto se necesita:

PostgreSQL.
DBeaver o una herramienta equivalente para administrar la base de datos.
PowerShell para ejecutar los scripts de respaldo y automatización.
pg_dump, pg_restore y psql, incluidos con la instalación de PostgreSQL.

No es necesario instalar MongoDB para este proyecto, ya que su uso corresponde únicamente a la sección teórica solicitada.

6. Orden de ejecución

Los scripts SQL deben ejecutarse en el siguiente orden:

01_creacion.sql
02_datos.sql
03_usuarios_permisos.sql
04_consultas.sql
05_calidad_monitoreo.sql
6.1 Creación de la base

El archivo 01_creacion.sql crea el esquema parkour, las cinco tablas, relaciones, restricciones e índices.

6.2 Carga de datos

El archivo 02_datos.sql inserta los datos de prueba del proyecto.

6.3 Usuarios y permisos

El archivo 03_usuarios_permisos.sql crea los usuarios de consulta y captura y asigna los privilegios correspondientes.

6.4 Consultas

El archivo 04_consultas.sql contiene consultas de operación, análisis y seguimiento.

6.5 Monitoreo y calidad

El archivo 05_calidad_monitoreo.sql contiene consultas de monitoreo, análisis de rendimiento mediante EXPLAIN ANALYZE y validaciones de calidad de datos.

7. Base de datos y restricciones

El proyecto utiliza cinco tablas relacionadas:

parkour.instructores
parkour.atletas
parkour.clases
parkour.membresias
parkour.asistencias

Se implementaron:

llaves primarias con columnas IDENTITY;
llaves foráneas;
restricciones NOT NULL;
restricciones CHECK;
restricciones UNIQUE;
ON DELETE RESTRICT;
índices sobre columnas utilizadas en relaciones y consultas.

Entre las validaciones implementadas se encuentran:

nombres de texto no vacíos;
rangos de edad válidos;
cupos mayores que cero;
fechas de membresía coherentes;
estados de membresía controlados;
tipos de membresía controlados;
prevención de asistencias duplicadas para un mismo atleta, clase y fecha.
8. Datos de prueba

La base de datos utiliza datos ficticios.

Cantidad de registros principales:

Instructores: 3
Atletas: 10
Clases: 4
Membresías: 13
Asistencias: 21

Los datos fueron diseñados para representar diferentes situaciones, incluyendo:

diferentes grupos de edad;
diferentes tipos de membresía;
membresías activas;
membresías vencidas;
membresías canceladas;
historial de renovación;
diferentes fechas de asistencia.
9. Usuarios y permisos

Se crearon dos usuarios para demostrar el principio de privilegio mínimo.

usuario_consulta

Usuario orientado a consultas y revisión de información.

Privilegio principal:

SELECT

No cuenta con permisos de inserción, actualización o eliminación.

usuario_captura

Usuario pensado para operaciones de recepción.

Puede:

consultar las tablas;
insertar atletas;
insertar membresías;
registrar asistencias;
actualizar determinados campos permitidos.

Las actualizaciones se limitaron por columna para evitar modificaciones innecesarias.

No se le otorgó permiso de DELETE.

También se probaron operaciones permitidas y operaciones rechazadas.

10. Consultas SQL

El archivo 04_consultas.sql contiene siete consultas principales.

Entre ellas se incluyen:

Directorio de clases e instructores.
Popularidad de las clases.
Bitácora de asistencias.
Cálculo dinámico de edad.
Atletas con membresías no vigentes y sin renovación activa.
Membresías vigentes en una fecha determinada.
Ranking de asistencia por atleta.

Las consultas utilizan diferentes características de PostgreSQL como:

INNER JOIN;
LEFT JOIN;
GROUP BY;
COUNT;
ORDER BY;
AGE;
EXTRACT;
subconsultas;
NOT EXISTS.
11. Monitoreo y calidad de datos

El archivo 05_calidad_monitoreo.sql contiene consultas para revisar el funcionamiento y la calidad de la base.

Se incluye monitoreo mediante:

pg_stat_activity;
tamaño de la base de datos;
tamaño de las tablas;
EXPLAIN ANALYZE.

También se realizan verificaciones de calidad para detectar:

atletas sin membresía;
asistencias sin una membresía que cubra su fecha;
asistencias fuera del rango de edad permitido para una clase.
12. Respaldo y restauración

Se realizó un respaldo de la base de datos utilizando pg_dump en formato personalizado.

Base original:

db_final

Base utilizada para restauración:

db_final_restore

El procedimiento completo y las evidencias se encuentran en:

respaldo_restauracion/

La restauración fue verificada comprobando las tablas y cantidades principales de registros.

13. Importación y exportación

Se realizó la exportación de la tabla:

parkour.atletas

a formato CSV.

Posteriormente el archivo fue importado a:

parkour.atletas_importados

Se verificó que:

Registros originales: 10
Registros importados: 10

Los archivos y el procedimiento se encuentran en:

importacion_exportacion/
14. Automatización

Se desarrolló un script de PowerShell:

automatizacion/backup_parkour.ps1

El script automatiza la creación de respaldos mediante pg_dump.

El proceso:

comprueba la carpeta de respaldos;
genera un nombre basado en fecha y hora;
ejecuta pg_dump;
crea el archivo .dump;
verifica la existencia del respaldo;
muestra su tamaño.

El procedimiento y las evidencias se encuentran en:

automatizacion/

15. MongoDB

MongoDB se utiliza únicamente como tema teórico de comparación con PostgreSQL.

En la carpeta:

teoria_mongodb/

se explica:

qué es una base de datos no relacional;
qué es MongoDB;
colección;
documento;
campo;
diferencias entre tablas y colecciones;
ventajas;
limitaciones;
casos en los que conviene PostgreSQL;
casos en los que podría utilizarse MongoDB;
aplicación de MongoDB al caso del gimnasio;
ejemplo de documento JSON.

No se instaló ni configuró MongoDB porque la actividad no lo solicita.

16. Evidencias

Las evidencias del proyecto se encuentran organizadas en las diferentes carpetas.

Se incluyen evidencias relacionadas con:

creación de la base;
carga de datos;
usuarios y permisos;
consultas;
monitoreo;
EXPLAIN;
respaldo;
restauración;
importación y exportación;
automatización.

Las evidencias complementan los scripts y procedimientos escritos.

17. Fuentes consultadas
Documentación oficial de PostgreSQL.
Documentación oficial de MongoDB.
Material proporcionado durante la asignatura de Administración de Bases de Datos.
Documentación de pg_dump, pg_restore, psql y consultas de monitoreo de PostgreSQL.
18. Uso de herramientas de IA

Durante el desarrollo del proyecto se utilizaron herramientas de inteligencia artificial como apoyo para revisar sintaxis, analizar posibles problemas de diseño, mejorar consultas SQL y revisar procedimientos.

Las decisiones finales, ejecución de scripts, pruebas de funcionamiento y comprensión del proyecto fueron realizadas y verificadas por los integrantes del equipo.

19. Conclusión

El proyecto permitió aplicar diferentes tareas relacionadas con la administración de PostgreSQL en un caso práctico.

Se diseñó una base de datos relacional con integridad referencial, restricciones e índices. También se implementaron diferentes perfiles de acceso, consultas SQL, respaldo y restauración, importación y exportación, automatización, monitoreo y controles de calidad.

Finalmente, se realizó una revisión teórica de MongoDB para comprender las diferencias principales entre el modelo relacional y el modelo orientado a documentos.

El resultado es una base de datos pequeña pero funcional, organizada y documentada para fines académicos.
