/*--------- Creamos la Base de Datos ---------
CREATE DATABASE Proyecto2;
----------------------------------------------*/

USE Proyecto2;

DROP TABLE IF EXISTS detalle_eleccion;
DROP TABLE IF EXISTS raza;
DROP TABLE IF EXISTS partido;
DROP TABLE IF EXISTS eleccion;
DROP TABLE IF EXISTS zona;
DROP TABLE IF EXISTS municipio;
DROP TABLE IF EXISTS departamento;
DROP TABLE IF EXISTS pais;


-- Creamos la Tabla Municipio
CREATE TABLE municipio (
id_municipio    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre          VARCHAR(50) NOT NULL
);

-- Creamos la Tabla Departamento
CREATE TABLE departamento (
id_departamento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre          VARCHAR(50) NOT NULL,
region          VARCHAR(20) NOT NULL
);

-- Creamos la Tabla Pais
CREATE TABLE pais (
id_pais         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre          VARCHAR(30) NOT NULL
);

--- Creamos la Tabla Zona
CREATE TABLE zona (
id_zona         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
ID_MUNICIPIO    INT NOT NULL,
ID_DEPARTAMENTO INT NOT NULL,
ID_PAIS         INT NOT NULL,
CONSTRAINT FK_ZONA_MUNICIPIO FOREIGN KEY (ID_MUNICIPIO) REFERENCES municipio(id_municipio),
CONSTRAINT FK_ZONA_DEPARTAMENTO FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES departamento(id_departamento),
CONSTRAINT FK_ZONA_PAIS FOREIGN KEY (ID_PAIS) REFERENCES pais (id_pais)
);

-- Creamos la Tabla Eleccion
CREATE TABLE eleccion (
id_eleccion     INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre          VARCHAR(50) NOT NULL,
año             YEAR NOT NULL,
ID_ZONA         INT NOT NULL,
CONSTRAINT FK_ELECCION_ZONA FOREIGN KEY (ID_ZONA) REFERENCES zona (id_zona)
);

-- Creamos la Tabla Raza
CREATE TABLE raza (
id_raza         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre          VARCHAR(25) NOT NULL
);

-- Creamos la Tabla Partido
CREATE TABLE partido (
id_partido      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
siglas          VARCHAR(10),
nombre          VARCHAR(30) NOT NULL
);

-- Creamos la Tabla Detalle_Eleccion
CREATE TABLE detalle_eleccion (
id_detalle      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
sexo            VARCHAR(20) NOT NULL,
analfabetos     INT NOT NULL,
alfabetos       INT NOT NULL,
primaria        INT NOT NULL,
media           INT NOT NULL,
universitario   INT NOT NULL,
ID_ELECCION     INT NOT NULL,
ID_PARTIDO      INT NOT NULL,
ID_RAZA         INT NOT NULL,
CONSTRAINT FK_DETALLE_ELECCION FOREIGN KEY (ID_ELECCION) REFERENCES eleccion(id_eleccion),
CONSTRAINT FK_DETALLE_PARTIDO FOREIGN KEY (ID_PARTIDO) REFERENCES partido (id_partido),
CONSTRAINT FK_DETALLE_RAZA FOREIGN KEY (ID_RAZA) REFERENCES raza(id_raza),
CONSTRAINT CHECK_SEXO CHECK (sexo='hombres' OR sexo = 'mujeres'),
CONSTRAINT CHECK_EDU_MIN CHECK (alfabetos>=0 AND analfabetos>=0),
CONSTRAINT CHECK_EDU_MAX CHECK (primaria>=0 AND media>=0 AND universitario>=0)
);

