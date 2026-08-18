-- ==============================================================================
-- 04_consultas.sql
-- Proyecto Final - Administración de Bases de Datos
-- Esquema: parkour
-- ==============================================================================
-- Este archivo contiene consultas funcionales para operación, análisis y
-- seguimiento del gimnasio. Las consultas están diseñadas para demostrar:
-- JOIN, LEFT JOIN, agregaciones, funciones de fecha, subconsultas y EXISTS.
-- ==============================================================================


-- ==============================================================================
-- CONSULTA 1: Directorio de Clases e Instructores
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Mostrar la oferta de clases junto con el instructor responsable.
--
-- Utilidad:
-- Permite a recepción consultar rápidamente las clases disponibles,
-- sus rangos de edad y el instructor asignado.
--
-- Conceptos demostrados:
-- INNER JOIN + ORDER BY
-- ==============================================================================

SELECT
    c.id_clase,
    c.nombre_clase,
    i.nombre_completo AS instructor,
    c.edad_minima,
    c.edad_maxima,
    c.cupo_maximo
FROM parkour.clases AS c
INNER JOIN parkour.instructores AS i
    ON c.id_instructor = i.id_instructor
ORDER BY
    c.edad_minima ASC,
    c.nombre_clase ASC;


-- ==============================================================================
-- CONSULTA 2: Popularidad de las Clases
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Contar el total de asistencias registradas por cada clase.
--
-- Utilidad:
-- Permite a la administración identificar las clases con mayor y menor
-- participación.
--
-- Nota:
-- Se utiliza LEFT JOIN para que también aparezcan clases que todavía no
-- tengan ninguna asistencia registrada.
--
-- Conceptos demostrados:
-- LEFT JOIN + COUNT + GROUP BY + ORDER BY
-- ==============================================================================

SELECT
    c.id_clase,
    c.nombre_clase,
    COUNT(a.id_asistencia) AS total_asistencias
FROM parkour.clases AS c
LEFT JOIN parkour.asistencias AS a
    ON c.id_clase = a.id_clase
GROUP BY
    c.id_clase,
    c.nombre_clase
ORDER BY
    total_asistencias DESC,
    c.nombre_clase ASC;


-- ==============================================================================
-- CONSULTA 3: Bitácora de Asistencias
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Mostrar el detalle de las asistencias registradas, relacionando al atleta
-- con la clase correspondiente.
--
-- Utilidad:
-- Sirve como consulta de auditoría para revisar quién asistió, a qué clase
-- y en qué fecha y hora.
--
-- Conceptos demostrados:
-- INNER JOIN múltiple + ORDER BY
-- ==============================================================================

SELECT
    a.id_asistencia,
    a.fecha_asistencia,
    a.hora_entrada,
    atl.nombre_completo AS atleta,
    atl.alias,
    c.nombre_clase
FROM parkour.asistencias AS a
INNER JOIN parkour.atletas AS atl
    ON a.id_atleta = atl.id_atleta
INNER JOIN parkour.clases AS c
    ON a.id_clase = c.id_clase
ORDER BY
    a.fecha_asistencia DESC,
    a.hora_entrada DESC;


-- ==============================================================================
-- CONSULTA 4: Edad Actual de los Atletas
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Calcular dinámicamente la edad de cada atleta utilizando su fecha de
-- nacimiento y la fecha actual del sistema.
--
-- Utilidad:
-- Facilita la revisión de categorías por edad sin almacenar un dato derivado
-- que tendría que actualizarse con el paso del tiempo.
--
-- Conceptos demostrados:
-- AGE() + EXTRACT() + CURRENT_DATE + ORDER BY
-- ==============================================================================

SELECT
    id_atleta,
    nombre_completo,
    alias,
    fecha_nacimiento,
    EXTRACT(
        YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)
    )::INTEGER AS edad_actual,
    contacto_tel
FROM parkour.atletas
ORDER BY
    edad_actual ASC,
    nombre_completo ASC;


-- ==============================================================================
-- CONSULTA 5: Atletas con Membresía No Vigente y Sin Renovación Activa
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Identificar atletas cuya membresía registrada está VENCIDA o CANCELADA
-- y que actualmente no tienen ninguna membresía con estatus ACTIVA.
--
-- Utilidad:
-- Puede utilizarse como listado de seguimiento para renovación de clientes.
--
-- Conceptos demostrados:
-- EXISTS / NOT EXISTS + JOIN + ORDER BY
--
-- Nota:
-- Se utiliza NOT EXISTS en lugar de NOT IN para expresar directamente la
-- ausencia de una membresía activa.
-- ==============================================================================

SELECT
    atl.id_atleta,
    atl.nombre_completo,
    atl.alias,
    atl.contacto_tel,
    m.estatus AS estatus_membresia,
    m.fecha_fin
FROM parkour.atletas AS atl
INNER JOIN parkour.membresias AS m
    ON m.id_atleta = atl.id_atleta
WHERE
    m.estatus IN ('VENCIDA', 'CANCELADA')
    AND NOT EXISTS (
        SELECT 1
        FROM parkour.membresias AS ma
        WHERE
            ma.id_atleta = atl.id_atleta
            AND ma.estatus = 'ACTIVA'
    )
ORDER BY
    m.fecha_fin DESC,
    atl.nombre_completo ASC;

-- ==============================================================================
-- CONSULTA 6: Membresías Vigentes en una Fecha
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Mostrar qué atletas tenían una membresía vigente en una fecha específica.
--
-- Utilidad:
-- Permite consultar el estado histórico de las membresías sin depender
-- exclusivamente del estado administrativo actual.
--
-- Conceptos demostrados:
-- Comparación de rangos de fechas + JOIN
-- ==============================================================================

SELECT
    atl.nombre_completo AS atleta,
    atl.alias,
    m.tipo_membresia,
    m.fecha_inicio,
    m.fecha_fin,
    m.estatus
FROM parkour.membresias AS m
INNER JOIN parkour.atletas AS atl
    ON m.id_atleta = atl.id_atleta
WHERE
    DATE '2026-08-17' >= m.fecha_inicio
    AND DATE '2026-08-17' < m.fecha_fin
ORDER BY
    atl.nombre_completo ASC;

-- ==============================================================================
-- CONSULTA 7: Ranking de Asistencia por Atleta
-- ------------------------------------------------------------------------------
-- Objetivo:
-- Contar las asistencias de cada atleta y mostrar primero a quienes tienen
-- mayor participación.
--
-- Utilidad:
-- Permite identificar los atletas con mayor frecuencia de asistencia.
--
-- Conceptos demostrados:
-- LEFT JOIN + COUNT + GROUP BY + ORDER BY
-- ==============================================================================

SELECT
    atl.id_atleta,
    atl.nombre_completo,
    atl.alias,
    COUNT(a.id_asistencia) AS total_asistencias
FROM parkour.atletas AS atl
LEFT JOIN parkour.asistencias AS a
    ON a.id_atleta = atl.id_atleta
GROUP BY
    atl.id_atleta,
    atl.nombre_completo,
    atl.alias
ORDER BY
    total_asistencias DESC,
    atl.nombre_completo ASC;