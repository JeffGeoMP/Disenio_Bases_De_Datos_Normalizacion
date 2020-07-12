USE Proyecto2;

/* Insertamos Toda la informacion a nuestro modelo relacional */

-- LLenado de Tabla Municipio
INSERT INTO municipio (nombre)
SELECT DISTINCT t.MUNICIPIO FROM data_temporal t;

-- LLenado de la Tabla Departamento
INSERT INTO departamento (nombre, region)
SELECT DISTINCT t.DEPTO, t.REGION FROM data_temporal t;

-- LLenado de la Tabla Pais
INSERT INTO pais (nombre)
SELECT DISTINCT t.PAIS FROM data_temporal t;

-- LLenado de la Tabla Raza
INSERT INTO raza (nombre)
SELECT DISTINCT t.RAZA FROM data_temporal t;

-- LLenado de la Tabla Partido
INSERT INTO partido (siglas, nombre)
SELECT DISTINCT t.PARTIDO, t.NOMBRE_PARTIDO FROM data_temporal t;

-- LLenado de la Tabla Zona
INSERT INTO zona (ID_MUNICIPIO, ID_DEPARTAMENTO, ID_PAIS)
SELECT DISTINCT m.id_municipio, d.id_departamento, p.id_pais FROM data_temporal t
INNER JOIN municipio m ON t.MUNICIPIO = m.nombre
INNER JOIN departamento d ON t.DEPTO = d.nombre
INNER JOIN pais p ON t.pais = p.nombre;


--- Lenado de la Tabla Eleccion
INSERT INTO eleccion (nombre, año, ID_ZONA)
SELECT DISTINCT t.NOMBRE_ELECCION, t.AÑO_ELECCION, z.id_zona FROM data_temporal t
INNER JOIN municipio m ON t.MUNICIPIO = m.nombre
INNER JOIN departamento d ON t.DEPTO = d.nombre
INNER JOIN pais p ON t.PAIS = p.nombre
INNER JOIN zona z ON  m.id_municipio = z.ID_MUNICIPIO AND d.id_departamento = z.ID_DEPARTAMENTO AND p.id_pais = z.ID_PAIS;

-- Llenado de la Tabla Detalle_Eleccion
INSERT INTO detalle_eleccion (
sexo,
analfabetos,
alfabetos,
primaria,
media,
universitario,
ID_ELECCION,
ID_PARTIDO,
ID_RAZA
)
SELECT DISTINCT
t.SEXO,
t.ANALFABETOS,
t.ALFABETOS,
t.PRIMARIA,
t.NIVEL_MEDIO,
t.UNIVERSITARIOS,
e.id_eleccion,
pt.id_partido,
r.id_raza 
FROM data_temporal t
INNER JOIN municipio m ON t.MUNICIPIO = m.nombre
INNER JOIN departamento d ON t.DEPTO = d.nombre
INNER JOIN pais p ON t.PAIS = p.nombre
INNER JOIN zona z ON  m.id_municipio = z.ID_MUNICIPIO AND d.id_departamento = z.ID_DEPARTAMENTO AND p.id_pais = z.ID_PAIS
INNER JOIN eleccion e ON  z.id_zona = e.id_zona AND t.NOMBRE_ELECCION = e.nombre AND t.AÑO_ELECCION = e.año
INNER JOIN partido pt ON t.PARTIDO = pt.siglas AND t.NOMBRE_PARTIDO = pt.nombre 
INNER JOIN raza r ON t.RAZA = r.nombre;