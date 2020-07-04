USE Proyecto2;

SELECT 'Votos' AS Contador, COUNT(*) AS Total FROM detalle_eleccion UNION
SELECT 'Partidos' AS Contador, COUNT(*) AS Total FROM partido UNION
SELECT 'Municipios' AS Contador, COUNT(*) AS Total FROM (SELECT DISTINCT id_pais, id_departamento, id_municipio FROM zona) td1 UNION
SELECT 'Departamentos' AS Contador, COUNT(*) AS Total FROM (SELECT DISTINCT id_pais, id_departamento FROM zona) td1 UNION
SELECT 'Regiones' AS Contador, COUNT(*) AS Total FROM (SELECT DISTINCT Region FROM departamento) td1 UNION
SELECT 'Paises' AS Contador, COUNT(*) AS Total FROM pais UNION
SELECT 'Elecciones' AS Contador, COUNT(*) AS Total FROM (SELECT DISTINCT nombre, año FROM eleccion) td1;