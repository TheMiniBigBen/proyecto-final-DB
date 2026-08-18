-- ==============================================================================
-- 05_calidad_monitoreo.sql
-- Proyecto Final - Administración de Bases de Datos
-- Esquema: parkour
-- ==============================================================================
-- Este archivo contiene consultas de monitoreo, análisis de rendimiento y
-- validación de calidad de los datos.
-- ==============================================================================


-- ==============================================================================
-- PARTE 1: MONITOREO Y RENDIMIENTO
-- ==============================================================================


-- ==============================================================================
-- 1. MONITOREO DE CONEXIONES Y ACTIVIDAD
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Consultar las conexiones activas en la base de datos actual.
--
-- Utilidad:
-- Permite identificar usuarios conectados, estado de sus sesiones y consultas
-- que se encuentran en ejecución.
-- ==============================================================================

SELECT
    pid,
    usename,
    datname,
    state,
    query,
    query_start
FROM
    pg_stat_activity
WHERE
    datname = current_database()
ORDER BY
    query_start DESC NULLS LAST;


-- ==============================================================================
-- 2. MONITOREO DEL TAMAÑO DE LA BASE DE DATOS
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Conocer el espacio en disco utilizado por la base de datos actual.
--
-- Utilidad:
-- Permite realizar un seguimiento básico del crecimiento de la base de datos.
-- ==============================================================================

SELECT
    current_database() AS base_datos,
    pg_size_pretty(
        pg_database_size(current_database())
    ) AS tamanio_base_datos;


-- ==============================================================================
-- 2.1. DETALLE DEL TAMAÑO DE LAS TABLAS
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Identificar cuánto espacio ocupa cada tabla del esquema parkour.
--
-- Utilidad:
-- Complementa el monitoreo general mostrando el tamaño individual de las
-- estructuras principales de la base de datos.
-- ==============================================================================

SELECT
    schemaname AS esquema,
    relname AS tabla,
    pg_size_pretty(
        pg_total_relation_size(relid)
    ) AS tamanio_total
FROM
    pg_catalog.pg_statio_user_tables
WHERE
    schemaname = 'parkour'
ORDER BY
    pg_total_relation_size(relid) DESC;


-- ==============================================================================
-- 3. ANÁLISIS DE RENDIMIENTO CON EXPLAIN ANALYZE
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Analizar el plan de ejecución real de una consulta que filtra asistencias
-- por fecha y relaciona atletas y clases.
--
-- Utilidad:
-- Permite observar el costo estimado y real de la consulta, las filas
-- procesadas y el tipo de acceso elegido por el optimizador de PostgreSQL.
--
-- Importante:
-- PostgreSQL decide automáticamente si utilizar un índice o realizar un
-- Sequential Scan dependiendo del costo estimado y del volumen de datos.
-- ==============================================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    a.fecha_asistencia,
    atl.nombre_completo,
    c.nombre_clase
FROM
    parkour.asistencias AS a
INNER JOIN parkour.atletas AS atl
    ON a.id_atleta = atl.id_atleta
INNER JOIN parkour.clases AS c
    ON a.id_clase = c.id_clase
WHERE
    a.fecha_asistencia >= DATE '2026-08-01';


-- ==============================================================================
-- PARTE 2: REVISIÓN Y CONTROL DE CALIDAD DE DATOS
-- ==============================================================================


-- ==============================================================================
-- 4. DETECCIÓN DE CALIDAD 1:
--    ATLETAS SIN MEMBRESÍA REGISTRADA
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Detectar atletas que no poseen ningún registro de membresía.
--
-- Utilidad:
-- Identifica posibles registros incompletos en la información administrativa.
--
-- Resultado esperado con los datos actuales:
-- No deberían aparecer atletas porque todos cuentan con al menos una
-- membresía registrada.
-- ==============================================================================

SELECT
    atl.id_atleta,
    atl.nombre_completo,
    atl.alias
FROM
    parkour.atletas AS atl
LEFT JOIN parkour.membresias AS m
    ON atl.id_atleta = m.id_atleta
WHERE
    m.id_membresia IS NULL
ORDER BY
    atl.id_atleta;


-- ==============================================================================
-- 5. DETECCIÓN DE CALIDAD 2:
--    ASISTENCIAS SIN MEMBRESÍA QUE CUBRA LA FECHA
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Detectar asistencias para las cuales no existe ninguna membresía cuyo
-- periodo contratado cubra la fecha de asistencia.
--
-- Regla:
-- fecha_asistencia >= fecha_inicio
-- AND fecha_asistencia < fecha_fin
--
-- Utilidad:
-- Permite identificar accesos registrados fuera de cualquier periodo
-- contratado, evitando falsos positivos cuando un atleta tiene varias
-- membresías históricas.
-- ==============================================================================

SELECT
    a.id_asistencia,
    atl.id_atleta,
    atl.nombre_completo AS atleta,
    a.fecha_asistencia,
    a.hora_entrada
FROM
    parkour.asistencias AS a
INNER JOIN parkour.atletas AS atl
    ON a.id_atleta = atl.id_atleta
WHERE NOT EXISTS (
    SELECT
        1
    FROM
        parkour.membresias AS m
    WHERE
        m.id_atleta = a.id_atleta
        AND a.fecha_asistencia >= m.fecha_inicio
        AND a.fecha_asistencia < m.fecha_fin
)
ORDER BY
    a.fecha_asistencia,
    a.hora_entrada;


-- ==============================================================================
-- 6. DETECCIÓN DE CALIDAD 3:
--    ASISTENCIAS FUERA DEL RANGO DE EDAD DE LA CLASE
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Detectar asistencias en las que la edad del atleta no corresponde al rango
-- permitido por la clase.
--
-- Utilidad:
-- Permite verificar una regla de negocio que no está contenida directamente
-- en una restricción FOREIGN KEY o CHECK.
-- ==============================================================================

SELECT
    a.id_asistencia,
    atl.nombre_completo AS atleta,
    c.nombre_clase,
    EXTRACT(
        YEAR FROM AGE(a.fecha_asistencia, atl.fecha_nacimiento)
    )::INTEGER AS edad_al_momento,
    c.edad_minima,
    c.edad_maxima,
    a.fecha_asistencia
FROM
    parkour.asistencias AS a
INNER JOIN parkour.atletas AS atl
    ON a.id_atleta = atl.id_atleta
INNER JOIN parkour.clases AS c
    ON a.id_clase = c.id_clase
WHERE
    EXTRACT(
        YEAR FROM AGE(a.fecha_asistencia, atl.fecha_nacimiento)
    )::INTEGER NOT BETWEEN c.edad_minima AND c.edad_maxima
ORDER BY
    a.fecha_asistencia,
    atl.nombre_completo;