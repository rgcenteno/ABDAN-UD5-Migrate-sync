-- =====================================================================
-- 06-prueba-cdc.sql
-- Se ejecuta en RDS for MySQL como admin mientras la tarea replica cambios.
-- =====================================================================
USE ud5;
START TRANSACTION;

INSERT INTO log (operacion, tabla, detalle)
VALUES ('insert', 'producto', 'Prueba de CDC: alta de producto de la práctica de migración');

INSERT INTO producto (codigo, nombre, descripcion, proveedor, coste, margen, stock, iva, id_categoria)
VALUES ('DMS0000001', 'Producto CDC', 'Alta con caracteres ñ, á y € tras la carga', 'A5000031E', 199.99, 2.50, 10, 21, 3);

UPDATE producto SET stock = stock + 5, coste = 149.50 WHERE id_producto = 1;
UPDATE trabajadores SET salarioBruto = 5100.00 WHERE username = 'administrador';
DELETE FROM log WHERE id_log = 1;

COMMIT;
