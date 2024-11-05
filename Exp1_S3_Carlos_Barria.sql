/* Caso 1: Gesti�n de inventario y pedidos */
-- Lista el nombre de cada producto agrupado por categor�a. Ordena los resultados por precio de mayor a menor.
SELECT UPPER(nombre), categoria, precio
FROM productos
ORDER BY categoria, precio DESC;

-- Calcula el promedio de ventas mensuales (en cantidad de productos) y muestra el mes y a�o con mayores ventas.
SELECT TO_CHAR(V.fecha, 'YYYY-MM') AS "Mes A�o",
    SUM(V.cantidad) AS "Total Ventas"
FROM 
    ventas V
WHERE 
    V.fecha >= ADD_MONTHS(SYSDATE, -12) -- Solo del �ltimo a�o
GROUP BY TO_CHAR(V.fecha, 'YYYY-MM')
ORDER BY "Total Ventas" DESC
FETCH FIRST 1 ROWS ONLY;

-- Promedio mensual de ventas
SELECT AVG("Total Ventas") AS promedio_mensual
FROM 
(SELECT TO_CHAR(V.fecha, 'YYYY-MM') AS mes_anio,
        SUM(V.cantidad) AS "Total Ventas"
    FROM ventas V
    WHERE V.fecha >= ADD_MONTHS(SYSDATE, -12)
    GROUP BY TO_CHAR(V.fecha, 'YYYY-MM'));

-- Encuentra el ID del cliente que ha gastado m�s dinero en compras durante el �ltimo a�o. Aseg�rate de considerar clientes que se registraron hace menos de un a�o
SELECT C.cliente_id, C.nombre,
    SUM(V.cantidad * P.precio) AS "Total Gastado"
FROM ventas V
JOIN productos P ON V.producto_id = P.producto_id
JOIN clientes C ON V.cliente_id = C.cliente_id
WHERE V.fecha >= ADD_MONTHS(SYSDATE, -12) --Ultimo a�o
    AND C.fecha_registro >= ADD_MONTHS(SYSDATE, -12) --Clientes registrados
GROUP BY C.cliente_id, C.nombre
ORDER BY "Total Gastado" DESC
FETCH FIRST 1 ROWS ONLY;


/* Caso 2: Gesti�n de Recursos Humanos 
Empleados (Employees)
�	�empleado_id� (PK)
�	�nombre�
�	�departamento�
�	�fecha_contratacion�
�	�salario�
CREATE TABLE Employees (
    empleado_id   NUMBER PRIMARY KEY,   
    nombre        VARCHAR2(100) NOT NULL, 
    departamento  VARCHAR2(50),           
    fecha_contratacion DATE,  
    salario       NUMBER(10, 2) 
);

*/
-- �	Determina el salario promedio, el salario m�ximo y el salario m�nimo por departamento.
SELECT E.departamento,
    AVG(E.salario) AS "Salario Promedio",
    MAX(E.salario) AS "Salario M�ximo",
    MIN(E.salario) AS "Salario M�nimo"
FROM Employees E
GROUP BY E.departamento;


-- �	Utilizando funciones de grupo, encuentra el salario m�s alto en cada departamento.
-- 1.	Calcula la antig�edad en a�os de cada empleado y muestra aquellos con m�s de 10 a�os en la empresa.
