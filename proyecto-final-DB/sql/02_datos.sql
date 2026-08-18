-- ==============================================================================
-- 1. INSTRUCTORES (3 registros)
-- ==============================================================================
INSERT INTO parkour.instructores (nombre_completo) VALUES
('Carlos Medina'),
('Ana Sofia Torres'),
('Roberto Salazar');

-- ==============================================================================
-- 2. ATLETAS (10 registros) 
-- Las fechas de nacimiento están calculadas para que los atletas encajen
-- lógicamente en sus respectivas categorías según las validaciones de las clases.
-- ==============================================================================
INSERT INTO parkour.atletas (nombre_completo, alias, fecha_nacimiento, contacto_nombre, contacto_tel) VALUES
('Luis Garcia', 'Shadow', '2016-04-12', 'Martha Garcia', '6181112233'),   -- Categoria: Kids
('Pedro Martinez', 'Raptor', '2010-09-05', 'Jose Martinez', '6182223344'), -- Categoria: Teens
('Sofia Ruiz', 'Valkyrie', '2009-11-20', 'Elena Ruiz', '6183334455'),      -- Categoria: Teens
('Miguel Soto', 'Dash', '1998-02-15', 'Carmen Soto', '6184445566'),        -- Categoria: Adultos
('Jorge Nunez', 'Jumper', '2001-07-08', 'Laura Nunez', '6185556677'),      -- Categoria: Adultos
('Andrea Lopez', 'Storm', '2017-01-30', 'Raul Lopez', '6186667788'),       -- Categoria: Kids
('Raul Gomez', 'Bullet', '1995-12-10', 'Silvia Gomez', '6187778899'),      -- Categoria: Adultos
('Valeria Rivas', 'Viper', '2011-03-25', 'Daniel Rivas', '6188889900'),    -- Categoria: Teens
('Diego Flores', 'Ghost', '2018-06-18', 'Monica Flores', '6189990011'),    -- Categoria: Kids
('Fernando Diaz', 'Titan', '1999-08-22', 'Teresa Diaz', '6180001122');     -- Categoria: Adultos

-- ==============================================================================
-- 3. CLASES (4 registros)
-- ==============================================================================
INSERT INTO parkour.clases (nombre_clase, id_instructor, edad_minima, edad_maxima, cupo_maximo) VALUES
('Parkour Kids', 2, 5, 12, 15),
('Parkour Teens', 1, 13, 17, 20),
('Parkour Adultos', 3, 18, 50, 25),
('Acondicionamiento Fisico', 3, 15, 60, 20);

-- ==============================================================================
-- 4. MEMBRESIAS (13 registros)
-- Una fecha de asistencia está dentro del periodo contratado cuando:
-- fecha_asistencia >= fecha_inicio
-- AND fecha_asistencia < fecha_fin.
-- El estatus administrativo se valida por separado.
-- ==============================================================================
INSERT INTO parkour.membresias (id_atleta, tipo_membresia, fecha_inicio, fecha_fin, estatus) VALUES
(1, 'MENSUAL', '2026-08-01', '2026-09-01', 'ACTIVA'),
(2, 'MENSUAL', '2026-07-15', '2026-08-15', 'VENCIDA'),
(2, 'MENSUAL', '2026-08-16', '2026-09-16', 'ACTIVA'),
(3, 'TRIMESTRAL', '2026-06-01', '2026-09-01', 'ACTIVA'),
(4, 'ANUAL', '2026-01-10', '2027-01-10', 'ACTIVA'),
(5, 'SEMESTRAL', '2026-02-01', '2026-08-01', 'VENCIDA'),
(6, 'MENSUAL', '2026-08-05', '2026-09-05', 'ACTIVA'),
(7, 'TRIMESTRAL', '2026-05-20', '2026-08-20', 'ACTIVA'),
(8, 'MENSUAL', '2026-07-01', '2026-08-01', 'VENCIDA'),
(8, 'MENSUAL', '2026-08-10', '2026-09-10', 'CANCELADA'), -- Prueba de estatus (cancelación prematura)
(9, 'MENSUAL', '2026-08-10', '2026-09-10', 'ACTIVA'),
(10, 'ANUAL', '2025-08-15', '2026-08-15', 'VENCIDA'),
(10, 'MENSUAL', '2026-08-16', '2026-09-16', 'ACTIVA');

-- ==============================================================================
-- 5. ASISTENCIAS (21 registros)
-- Alineadas cronológicamente para caer dentro de los periodos de membresía.
-- ==============================================================================
INSERT INTO parkour.asistencias (id_atleta, id_clase, fecha_asistencia, hora_entrada) VALUES
-- Asistencias Kids
(1, 1, '2026-08-10', '16:05:00'),
(6, 1, '2026-08-10', '16:10:00'),
(9, 1, '2026-08-10', '16:02:00'),
(1, 1, '2026-08-12', '16:00:00'),
(6, 1, '2026-08-12', '16:12:00'),
(1, 1, '2026-08-14', '16:01:00'),
(9, 1, '2026-08-14', '16:00:00'),

-- Asistencias Teens
(2, 2, '2026-08-10', '17:00:00'),
(3, 2, '2026-08-10', '17:15:00'),
(2, 2, '2026-08-12', '17:02:00'),
(3, 2, '2026-08-12', '17:05:00'),
(3, 2, '2026-08-14', '17:10:00'),
(2, 2, '2026-08-17', '17:00:00'),

-- Asistencias Adultos
(4, 3, '2026-08-10', '19:00:00'),
(7, 3, '2026-08-10', '19:05:00'),
(4, 3, '2026-08-12', '18:55:00'),
(7, 3, '2026-08-12', '19:00:00'),

-- Asistencias Acondicionamiento
(10, 4, '2026-08-12', '20:00:00'),
(5, 4, '2026-07-20', '20:05:00'),
(4, 4, '2026-08-14', '20:10:00'),
(10, 4, '2026-08-17', '20:00:00');