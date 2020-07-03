USE Proyecto2;

/*FUNCIONES

DELIMITER $$
CREATE FUNCTION calculo_porcentaje (Dato INTEGER, Total INTEGER)
RETURNS FLOAT
DETERMINISTIC
BEGIN 
	DECLARE porcentaje FLOAT;
    SET porcentaje = Dato*100;
    SET porcentaje = porcentaje/Total;
RETURN porcentaje;
END $$

select * from data_temporal;
select * from detalle_eleccion;
select * from municipio;
select * from departamento;
select * from raza;
select * from pais;
select * from zona;
select * from eleccion;
select * from partido;

*/

/*
-------------------------- CONSULTA NO. 1 --------------------------------------
Desplegar para cada elección el país y el partido político que obtuvo 
mayor porcentaje de votos en su país. Debe desplegar el nombre de la elección, 
el año de la elección, el país, el nombre del partido político y el porcentaje
que obtuvo de votos en su país.
*/
SELECT 
	e.nombre AS Eleccion, 
    e.año AS Año, 
    p.nombre AS Pais, 
    pt.nombre AS Partido,
    calculo_porcentaje(SUM(analfabetos + alfabetos), (SELECT SUM(analfabetos + alfabetos) FROM detalle_eleccion de2
															INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
															INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
															WHERE z2.id_pais = p.id_pais)) AS Porcentaje
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN partido pt ON de.id_partido = pt.id_partido
GROUP BY e.nombre, e.año, p.nombre, pt.nombre
HAVING Porcentaje = (SELECT MAX(tp.Porcentaje) AS Porcentaje_Maximo FROM (
	SELECT calculo_porcentaje (SUM(analfabetos + alfabetos), (SELECT SUM(analfabetos + alfabetos) FROM detalle_eleccion de3
																INNER JOIN eleccion e3 ON de3.id_eleccion = e3.id_eleccion
																INNER JOIN zona z3 ON e3.id_zona = z3.id_zona
                                                                INNER JOIN pais p3 ON z3.id_pais = p3.id_pais
																WHERE p3.nombre = Pais)) AS Porcentaje
	FROM detalle_eleccion de4
	INNER JOIN eleccion e4 ON de4.id_eleccion = e4.id_eleccion
	INNER JOIN zona z4 ON e4.id_zona = z4.id_zona
	INNER JOIN pais p4 ON z4.id_pais = p4.id_pais
    WHERE p4.nombre = Pais
	GROUP by e4.nombre, z4.id_pais, de4.id_partido) tp);



/*
-------------------------- CONSULTA NO. 2 --------------------------------------
Desplegar total de votos y porcentaje de votos de mujeres por departamento y país.
El ciento por ciento es el total de votos de mujeres por país. (Tip: Todos los
porcentajes por departamento de un país deben sumar el 100%)
*/
-- Total de Votos con Porcentaje
SELECT p.nombre AS Pais, 
	   d.nombre AS Departamento, 
       SUM(analfabetos + alfabetos) AS Votos,
       calculo_porcentaje(SUM(analfabetos + alfabetos), (SELECT SUM(analfabetos + alfabetos) AS Total 
																						FROM detalle_eleccion de2
																						INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_zona
																						INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
																						WHERE de2.sexo = 'mujeres' AND z2.id_pais = z.id_pais)) AS Porcentaje 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_zona
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
WHERE de.sexo = 'mujeres' 
GROUP BY z.id_pais, z.id_departamento;

/*
-------------------------- CONSULTA NO. 3 --------------------------------------
Desplegar el nombre del país, nombre del partido político y número de alcaldías de
los partidos políticos que ganaron más alcaldías por país.
*/

SELECT p.nombre AS Pais,
	   pt.nombre AS Partido,
       COUNT(td2.Partido) AS Alcaldias
FROM (SELECT  z.id_zona AS Zona,
				z.id_pais AS Pais,
				z.id_municipio AS Municipio,
				de.id_partido AS Partido, 
				SUM((de.alfabetos + de.analfabetos)) AS Votos
		FROM detalle_eleccion de
		INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
		INNER JOIN zona z ON e.id_zona = z.id_zona
		GROUP BY z.id_zona, de.id_partido
		HAVING Votos = (SELECT MAX(td1.votos) FROM(SELECT z2.id_pais, z2.id_municipio, de2.id_partido, SUM((de2.alfabetos + de2.analfabetos)) AS Votos
									FROM detalle_eleccion de2
									INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
									INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
									WHERE z2.id_zona = Zona
									GROUP BY z2.id_zona, de2.id_partido) td1)) td2
INNER JOIN Pais p ON td2.Pais = p.id_pais
INNER JOIN Partido pt On td2.Partido = pt.id_partido
GROUP BY td2.Pais, td2.Partido
HAVING Alcaldias = (SELECT MAX(Alcaldias3) FROM (SELECT td2.Pais2 AS Pais3,
							   td2.Partido2 AS Partido3,
							   COUNT(td2.Partido2) AS Alcaldias3
						FROM (SELECT  z.id_zona AS Zona2,
										z.id_pais AS Pais2,
										z.id_municipio AS Municipio2,
										de.id_partido AS Partido2, 
										SUM((de.alfabetos + de.analfabetos)) AS Votos
								FROM detalle_eleccion de
								INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
								INNER JOIN zona z ON e.id_zona = z.id_zona
								GROUP BY z.id_zona, de.id_partido
								HAVING Votos = (SELECT MAX(td1.votos) FROM(SELECT z2.id_pais, z2.id_municipio, de2.id_partido, SUM((de2.alfabetos + de2.analfabetos)) AS Votos
															FROM detalle_eleccion de2
															INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
															INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
															WHERE z2.id_zona = Zona2
															GROUP BY z2.id_zona, de2.id_partido) td1)) td2
						GROUP BY td2.Pais2, td2.Partido2) td3
						WHERE Pais3 = Pais);

/*
-------------------------- CONSULTA NO. 4 --------------------------------------
Desplegar todas las regiones por país en las que predomina la raza indígena. 
Es decir, hay más votos que las otras razas.
*/
SELECT p.nombre AS Pais,
		d.region AS Region,
        r.nombre AS Raza,
        SUM(analfabetos + alfabetos) AS Votos 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN raza r ON de.id_raza = r.id_raza
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
GROUP BY z.id_pais, d.region, de.id_raza
HAVING Votos = (SELECT MAX(td1.Votos) FROM (SELECT p2.nombre AS Pais2, d2.region AS Region2, r2.nombre AS Raza2, SUM(de2.analfabetos + de2.alfabetos) AS Votos 
							FROM detalle_eleccion de2
							INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
							INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
							INNER JOIN pais p2 ON z2.id_pais = p2.id_pais
							INNER JOIN raza r2 ON de2.id_raza = r2.id_raza
							INNER JOIN departamento d2 ON z2.id_departamento = d2.id_departamento
							WHERE p2.nombre = Pais AND d2.region = Region
							GROUP BY z2.id_pais, d2.region, de2.id_raza) td1) AND Raza ='INDIGENAS' ;


/*
-------------------------- CONSULTA NO. 5 --------------------------------------
Desplegar el nombre del país, el departamento, el municipio, el partido político y
la cantidad de votos universitarios de todos aquellos partidos políticos que 
obtuvieron una cantidad de votos de universitarios mayor que el 25% de votos 
de primaria y menor que el 30% de votos de nivel medio 
(correspondiente a ese municipio y al partido político).  
Ordene sus resultados de mayor a menor.
*/


/*
-------------------------- CONSULTA NO. 6 --------------------------------------
Desplegar el porcentaje de mujeres universitarias y hombres universitarios que 
votaron por departamento, donde las mujeres universitarias que votaron fueron más 
que los hombres universitarios que votaron.
*/


/*
-------------------------- CONSULTA NO. 7 --------------------------------------
Desplegar el nombre del país, la región y el promedio de votos por departamento. 
Por ejemplo: si la región tiene tres departamentos, se debe sumar todos los votos 
de la región y dividirlo dentro de tres (número de departamentos de la región).
*/


/*
-------------------------- CONSULTA NO. 8 --------------------------------------
Desplegar el nombre del municipio y el nombre de los dos partidos políticos con 
más votos en el municipio, ordenados por país.
*/


/*
-------------------------- CONSULTA NO. 9 --------------------------------------
Desplegar el total de votos de cada nivel de escolaridad (primario, medio, universitario) 
por país, sin importar raza o sexo.
*/


/*
-------------------------- CONSULTA NO. 10 -------------------------------------
Desplegar el nombre del país y el porcentaje de votos por raza.
*/
SELECT p.nombre AS Pais,
	r.nombre AS Raza,
    calculo_porcentaje(SUM(de.analfabetos + de.alfabetos), (SELECT SUM(de2.analfabetos + de2.alfabetos) 
															FROM detalle_eleccion de2
															INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
															INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
															WHERE z2.id_pais = z.id_pais
															GROUP BY z2.id_pais)) AS PORCENTAJE
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN raza r ON de.id_raza = r.id_raza
GROUP BY z.id_pais, de.id_raza;

/*
-------------------------- CONSULTA NO. 11 -------------------------------------
Desplegar el nombre del país en el cual las elecciones han sido más peleadas. 
Para determinar esto se debe calcular la diferencia de porcentajes de votos entre 
el partido que obtuvo más votos y el partido que obtuvo menos votos.
*/


/*
-------------------------- CONSULTA NO. 12 -------------------------------------
Desplegar el total de votos y el porcentaje de votos emitidos por mujeres 
indígenas alfabetas.
*/
SELECT e.nombre, e.año, SUM(analfabetos + alfabetos) AS Votos, calculo_porcentaje((SELECT SUM(de2.alfabetos) FROM detalle_eleccion de2
																					INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
																					INNER JOIN raza r2 ON de2.id_raza = r2.id_raza
																					WHERE de2.sexo = 'mujeres' AND r2.nombre = 'INDIGENAS' AND e2.año = e.año
																					GROUP BY e2.nombre, e2.año),(SUM(analfabetos + alfabetos))) AS Porcentaje 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
GROUP BY e.nombre, e.año;
/*
-------------------------- CONSULTA NO. 13 -------------------------------------
Desplegar el nombre del país, el porcentaje de votos de ese país en el que han 
votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre de país, 
el de mayor porcentaje).
*/

SELECT p.nombre AS Pais, calculo_porcentaje(SUM(de.analfabetos), SUM(de.analfabetos + alfabetos)) AS Porcentaje FROM detalle_eleccion de 
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
GROUP BY z.id_pais
HAVING Porcentaje = (SELECT MAX(td1.Porcentaje) 
					FROM (SELECT z.id_pais, calculo_porcentaje(SUM(de.analfabetos), SUM(de.analfabetos + alfabetos)) AS Porcentaje 
                    FROM detalle_eleccion de 
							INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
							INNER JOIN zona z ON e.id_zona = z.id_zona
							GROUP BY z.id_pais) td1);

/*
-------------------------- CONSULTA NO. 14 -------------------------------------
Desplegar la lista de departamentos de Guatemala y número de votos obtenidos, 
para los departamentos que obtuvieron más votos que el departamento de Guatemala.
*/
SELECT d.nombre AS Departamento,  SUM(de.analfabetos + de.alfabetos) AS Votos 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
WHERE p.nombre = 'GUATEMALA'
GROUP BY z.id_pais, z.id_departamento
HAVING Votos > (SELECT SUM(de.analfabetos + de.alfabetos) FROM detalle_eleccion de
				INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
				INNER JOIN zona z ON e.id_zona = z.id_zona
				INNER JOIN pais p ON z.id_pais = p.id_pais
				INNER JOIN departamento d ON z.id_departamento = d.id_departamento
				WHERE p.nombre = 'GUATEMALA' AND d.nombre = 'GUATEMALA'
				GROUP BY z.id_pais, z.id_departamento);

/*
-------------------------- CONSULTA NO. 15 -------------------------------------
Desplegar el total de votos de los municipios agrupados por su letra inicial. 
Es decir, agrupar todos los municipios con letra A y calcular su número de votos, 
lo mismo para los de letra inicial B, y así sucesivamente hasta la Z.
*/