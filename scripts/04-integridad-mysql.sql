-- 04-integridad-mysql.sql — RDS for MySQL, esquema ud5
-- Devuelve, por tabla, el número de filas y una suma de comprobación independiente del orden.
-- La suma se obtiene acumulando los 32 primeros bits del MD5 de cada fila.
SET NAMES utf8mb4;

SELECT 'aux_countries' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', id, country_code, country_name)), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM aux_countries
UNION ALL
SELECT 'aux_rol' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', id_rol, rol, descripcion_en, descripcion_es, orden, seccion_ini)), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM aux_rol
UNION ALL
SELECT 'aux_rol_trabajador' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', id_rol, nombre_rol)), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM aux_rol_trabajador
UNION ALL
SELECT 'categoria' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', id_categoria, nombre_categoria, IFNULL(id_padre, '<NULL>'))), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM categoria
UNION ALL
SELECT 'log' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', id_log, operacion, tabla, IFNULL(detalle, '<NULL>'))), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM log
UNION ALL
SELECT 'producto' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', id_producto, codigo, nombre, descripcion, proveedor, coste, margen, stock, iva, IFNULL(id_categoria, '<NULL>'))), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM producto
UNION ALL
SELECT 'proveedor' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', cif, codigo, nombre, direccion, website, email, IFNULL(telefono, '<NULL>'), id_country)), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM proveedor
UNION ALL
SELECT 'trabajadores' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', username, salarioBruto, retencionIRPF, activo, id_rol, id_country)), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM trabajadores
UNION ALL
SELECT 'usuario_sistema' AS tabla, COUNT(*) AS filas,
       SUM(CAST(CONV(LEFT(MD5(CONCAT_WS('|', id_usuario, id_rol, email, pass, nombre, IFNULL(last_date, '<NULL>'), idioma, baja)), 8), 16, 10) AS UNSIGNED)) AS suma_md5
FROM usuario_sistema
ORDER BY tabla;
