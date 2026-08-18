-- ==============================================================================
-- LIMPIEZA INICIAL DEL ESQUEMA
-- ==============================================================================
DROP SCHEMA IF EXISTS parkour CASCADE;
CREATE SCHEMA parkour;

-- ==============================================================================
-- 1. TABLA: instructores
-- ==============================================================================
CREATE TABLE parkour.instructores (
    id_instructor INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    
    -- RESTRICCIÓN: Evitar nombres vacíos o puros espacios
    CONSTRAINT chk_instructor_no_vacio 
        CHECK (length(trim(nombre_completo)) > 0)
);

-- ==============================================================================
-- 2. TABLA: atletas
-- ==============================================================================
CREATE TABLE parkour.atletas (
    id_atleta INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    alias VARCHAR(50) UNIQUE, -- Unicidad para identificación en el gimnasio
    fecha_nacimiento DATE NOT NULL,
    contacto_nombre VARCHAR(100) NOT NULL,
    contacto_tel VARCHAR(20) NOT NULL,

    -- RESTRICCIÓN: Evitar datos vacíos en campos de texto clave
    CONSTRAINT chk_atleta_no_vacio 
        CHECK (length(trim(nombre_completo)) > 0 AND length(trim(contacto_nombre)) > 0)
);

-- ==============================================================================
-- 3. TABLA: clases
-- ==============================================================================
CREATE TABLE parkour.clases (
    id_clase INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_clase VARCHAR(50) NOT NULL,
    id_instructor INT NOT NULL,
    edad_minima INT NOT NULL,
    edad_maxima INT NOT NULL,
    cupo_maximo INT NOT NULL,
    
    CONSTRAINT fk_clase_instructor 
        FOREIGN KEY (id_instructor) 
        REFERENCES parkour.instructores(id_instructor) 
        ON DELETE RESTRICT,
        
    -- RESTRICCIONES DE DOMINIO
    CONSTRAINT chk_clase_no_vacia 
        CHECK (length(trim(nombre_clase)) > 0),
    CONSTRAINT chk_edades_validas 
        CHECK (edad_minima >= 0 AND edad_maxima >= edad_minima),
    CONSTRAINT chk_cupo_valido 
        CHECK (cupo_maximo > 0)
);

-- ==============================================================================
-- 4. TABLA: membresias
-- ==============================================================================
CREATE TABLE parkour.membresias (
    id_membresia INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_atleta INT NOT NULL,
    tipo_membresia VARCHAR(30) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estatus VARCHAR(20) DEFAULT 'ACTIVA' NOT NULL,
    
    CONSTRAINT fk_membresia_atleta 
        FOREIGN KEY (id_atleta) 
        REFERENCES parkour.atletas(id_atleta) 
        ON DELETE RESTRICT,
        
    -- RESTRICCIONES DE DOMINIO Y LÓGICA
    CONSTRAINT chk_fechas_logicas 
        CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_estatus_catalogo 
        CHECK (estatus IN ('ACTIVA', 'VENCIDA', 'CANCELADA')),
    CONSTRAINT chk_tipo_catalogo 
        CHECK (tipo_membresia IN ('MENSUAL', 'TRIMESTRAL', 'SEMESTRAL', 'ANUAL'))
);

-- ==============================================================================
-- 5. TABLA: asistencias
-- ==============================================================================
CREATE TABLE parkour.asistencias (
    id_asistencia INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_atleta INT NOT NULL,
    id_clase INT NOT NULL,
    fecha_asistencia DATE DEFAULT CURRENT_DATE NOT NULL,
    hora_entrada TIME DEFAULT CURRENT_TIME NOT NULL,

    CONSTRAINT fk_asistencia_atleta 
        FOREIGN KEY (id_atleta) 
        REFERENCES parkour.atletas(id_atleta) 
        ON DELETE RESTRICT,
            
    CONSTRAINT fk_asistencia_clase 
        FOREIGN KEY (id_clase) 
        REFERENCES parkour.clases(id_clase) 
        ON DELETE RESTRICT,

    CONSTRAINT unq_asistencia_diaria 
        UNIQUE (id_atleta, id_clase, fecha_asistencia)
);

-- ==============================================================================
-- CREACIÓN DE ÍNDICES PARA OPTIMIZACIÓN
-- ==============================================================================
CREATE INDEX idx_membresias_atleta ON parkour.membresias (id_atleta);
CREATE INDEX idx_asistencias_atleta ON parkour.asistencias (id_atleta);
CREATE INDEX idx_asistencias_clase ON parkour.asistencias (id_clase);
CREATE INDEX idx_clases_instructor ON parkour.clases (id_instructor);
CREATE INDEX idx_asistencias_fecha ON parkour.asistencias (fecha_asistencia);