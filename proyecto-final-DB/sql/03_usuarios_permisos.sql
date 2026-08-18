-- ==============================================================================
-- 1. LIMPIEZA Y CREACIÓN ROBUSTA DE ROLES 
-- ==============================================================================
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'usuario_consulta') THEN
        REASSIGN OWNED BY usuario_consulta TO CURRENT_USER;
        DROP OWNED BY usuario_consulta;
        DROP ROLE usuario_consulta;
    END IF;
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'usuario_captura') THEN
        REASSIGN OWNED BY usuario_captura TO CURRENT_USER;
        DROP OWNED BY usuario_captura;
        DROP ROLE usuario_captura;
    END IF;
END
$$;

-- Creamos los usuarios con credenciales exclusivas y ficticias para el proyecto
CREATE USER usuario_consulta WITH PASSWORD 'consulta_parkour26';
CREATE USER usuario_captura WITH PASSWORD 'captura_parkour26';

-- ==============================================================================
-- 2. ACCESO AL ESQUEMA
-- ==============================================================================
GRANT USAGE ON SCHEMA parkour TO usuario_consulta;
GRANT USAGE ON SCHEMA parkour TO usuario_captura;

-- ==============================================================================
-- 3. PRIVILEGIOS: USUARIO DE CONSULTA (Solo lectura global)
-- ==============================================================================
GRANT SELECT ON ALL TABLES IN SCHEMA parkour TO usuario_consulta;

-- ==============================================================================
-- 4. PRIVILEGIOS: USUARIO DE CAPTURA (Recepción / Mostrador)
-- ==============================================================================
-- 4.1 Permiso de Lectura (Catálogos y Transacciones)
GRANT SELECT ON ALL TABLES IN SCHEMA parkour TO usuario_captura;

-- 4.2 Permiso de Inserción (Solo en tablas operativas, NUNCA en catálogos)
GRANT INSERT ON parkour.atletas, parkour.membresias, parkour.asistencias TO usuario_captura;

-- 4.3 Permisos de Actualización a Nivel de Columna (Seguridad Quirúrgica)
-- Atletas: Solo puede actualizar datos de contacto y alias.
GRANT UPDATE (alias, contacto_nombre, contacto_tel) ON parkour.atletas TO usuario_captura;

-- Membresías: Solo puede actualizar el estatus o extender la fecha de fin.
GRANT UPDATE (fecha_fin, estatus) ON parkour.membresias TO usuario_captura;

-- Asistencias: SIN PERMISO DE UPDATE. Un registro de asistencia es inmutable.

-- 4.4 Permiso de Secuencias Específicas
GRANT USAGE ON SEQUENCE parkour.atletas_id_atleta_seq TO usuario_captura;
GRANT USAGE ON SEQUENCE parkour.membresias_id_membresia_seq TO usuario_captura;
GRANT USAGE ON SEQUENCE parkour.asistencias_id_asistencia_seq TO usuario_captura;

-- ==============================================================================
-- 5. BATERÍA DE PRUEBAS DE ACCESO (Para Demostración)
-- ==============================================================================
/*
--- 🟢 CONEXIÓN: usuario_captura
-- 1. SELECT Permitido (Verificar catálogos) ✅
SELECT * FROM parkour.clases;

-- 2. INSERT Permitido (Nuevo cliente) ✅
INSERT INTO parkour.atletas (nombre_completo, alias, fecha_nacimiento, contacto_nombre, contacto_tel) 
VALUES ('Juan Prueba', 'Test', '2000-01-01', 'Madre', '6181110000');

-- 3. UPDATE Permitido a nivel columna (Actualizar teléfono) ✅
UPDATE parkour.atletas SET contacto_tel = '6182220000' WHERE id_atleta = 1;

-- 4. UPDATE Denegado a nivel columna (Intentar cambiar fecha_nacimiento) ❌
UPDATE parkour.atletas SET fecha_nacimiento = '2010-01-01' WHERE id_atleta = 1;
-- Resultado esperado: Operación rechazada por falta de privilegio UPDATE sobre la columna.

-- 5. DELETE Denegado (Intentar borrar historial) ❌
DELETE FROM parkour.asistencias WHERE id_asistencia = 1;
-- Resultado esperado: Operación rechazada por falta de privilegio DELETE en la tabla.

-- 6. INSERT Denegado en Catálogo (Intentar agregar un instructor) ❌
INSERT INTO parkour.instructores (nombre_completo) VALUES ('Instructor Hack');
-- Resultado esperado: Operación rechazada por falta de privilegio INSERT en la tabla.


--- 🟢 CONEXIÓN: usuario_consulta
-- 7. SELECT Permitido (Auditoría de ingresos) ✅
SELECT * FROM parkour.asistencias;

-- 8. INSERT Denegado (Intentar alterar transacciones operativas) ❌
INSERT INTO parkour.asistencias (id_atleta, id_clase) VALUES (1, 1);
-- Resultado esperado: Operación rechazada por falta de privilegio INSERT en la tabla.

--- 🟢 Limpieza posterior (Ejecutada por el Administrador): 
-- DELETE FROM parkour.atletas WHERE alias = 'Test';
*/