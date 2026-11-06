-- 05-integridad-postgres.sql — Aurora PostgreSQL, esquema ud5
-- Devuelve, por tabla, el número de filas y una suma de comprobación independiente del orden.
-- La suma se obtiene acumulando los 32 primeros bits del MD5 de cada fila.
SET client_encoding = 'UTF8';
SET search_path TO ud5;

SELECT 'aux_countries' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', id::text, country_code::text, country_name::text)), 8))::bit(32)::bigint) AS suma_md5
FROM aux_countries
UNION ALL
SELECT 'aux_rol' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', id_rol::text, rol::text, descripcion_en::text, descripcion_es::text, orden::text, seccion_ini::text)), 8))::bit(32)::bigint) AS suma_md5
FROM aux_rol
UNION ALL
SELECT 'aux_rol_trabajador' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', id_rol::text, nombre_rol::text)), 8))::bit(32)::bigint) AS suma_md5
FROM aux_rol_trabajador
UNION ALL
SELECT 'categoria' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', id_categoria::text, nombre_categoria::text, COALESCE(id_padre::text, '<NULL>'))), 8))::bit(32)::bigint) AS suma_md5
FROM categoria
UNION ALL
SELECT 'log' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', id_log::text, operacion::text, tabla::text, COALESCE(detalle::text, '<NULL>'))), 8))::bit(32)::bigint) AS suma_md5
FROM log
UNION ALL
SELECT 'producto' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', id_producto::text, codigo::text, nombre::text, descripcion::text, proveedor::text, coste::text, margen::text, stock::text, iva::text, COALESCE(id_categoria::text, '<NULL>'))), 8))::bit(32)::bigint) AS suma_md5
FROM producto
UNION ALL
SELECT 'proveedor' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', cif::text, codigo::text, nombre::text, direccion::text, website::text, email::text, COALESCE(telefono::text, '<NULL>'), id_country::text)), 8))::bit(32)::bigint) AS suma_md5
FROM proveedor
UNION ALL
SELECT 'trabajadores' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', username::text, salariobruto::text, retencionirpf::text, activo::text, id_rol::text, id_country::text)), 8))::bit(32)::bigint) AS suma_md5
FROM trabajadores
UNION ALL
SELECT 'usuario_sistema' AS tabla, COUNT(*) AS filas,
       SUM(('x' || left(md5(concat_ws('|', id_usuario::text, id_rol::text, email::text, pass::text, nombre::text, COALESCE(last_date::text, '<NULL>'), idioma::text, baja::text)), 8))::bit(32)::bigint) AS suma_md5
FROM usuario_sistema
ORDER BY tabla;
