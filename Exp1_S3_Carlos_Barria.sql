/* Caso 1: Gestión de inventario y pedidos */
-- Lista el nombre de cada producto agrupado por categoría. Ordena los resultados por precio de mayor a menor.
SELECT UPPER(nombre), categoria, precio
FROM productos
ORDER BY categoria, precio DESC;

-- Calcula el promedio de ventas mensuales (en cantidad de productos) y muestra el mes y año con mayores ventas.
SELECT TO_CHAR(V.fecha, 'YYYY-MM') AS "Mes Año",
    SUM(V.cantidad) AS "Total Ventas"
FROM 
    ventas V
WHERE 
    V.fecha >= ADD_MONTHS(SYSDATE, -12) -- Solo del último año
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

-- Encuentra el ID del cliente que ha gastado más dinero en compras durante el último año. Asegúrate de considerar clientes que se registraron hace menos de un año
SELECT C.cliente_id, C.nombre,
    SUM(V.cantidad * P.precio) AS "Total Gastado"
FROM ventas V
JOIN productos P ON V.producto_id = P.producto_id
JOIN clientes C ON V.cliente_id = C.cliente_id
WHERE V.fecha >= ADD_MONTHS(SYSDATE, -12) --Ultimo año
    AND C.fecha_registro >= ADD_MONTHS(SYSDATE, -12) --Clientes registrados
GROUP BY C.cliente_id, C.nombre
ORDER BY "Total Gastado" DESC
FETCH FIRST 1 ROWS ONLY;


/* Caso 2: Gestión de Recursos Humanos 
Empleados (Employees)
•	‘empleado_id’ (PK)
•	‘nombre’
•	‘departamento’
•	‘fecha_contratacion’
•	‘salario’
CREATE TABLE Employees (
    empleado_id   NUMBER PRIMARY KEY,   
    nombre        VARCHAR2(100) NOT NULL, 
    departamento  VARCHAR2(50),           
    fecha_contratacion DATE,  
    salario       NUMBER(10, 2) 
);

*/
-- •	Determina el salario promedio, el salario máximo y el salario mínimo por departamento.
SELECT E.departamento,
    AVG(E.salario) AS "Salario Promedio",
    MAX(E.salario) AS "Salario Máximo",
    MIN(E.salario) AS "Salario Mínimo"
FROM Employees E
GROUP BY E.departamento;


-- •	Utilizando funciones de grupo, encuentra el salario más alto en cada departamento.
-- 1.	Calcula la antigüedad en años de cada empleado y muestra aquellos con más de 10 años en la empresa.
