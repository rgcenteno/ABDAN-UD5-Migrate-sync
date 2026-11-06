-- =====================================================================
-- 03-destino-postcarga.sql
-- Se ejecuta en Aurora PostgreSQL como adminud5 DESPUÉS de detener la
-- tarea de DMS. Crea los objetos que DMS no migra y ajusta las secuencias.
-- =====================================================================
BEGIN;
SET search_path TO ud5;

-- Restricciones UNIQUE
ALTER TABLE producto        ADD CONSTRAINT producto_unique UNIQUE (codigo);
ALTER TABLE usuario_sistema ADD CONSTRAINT usuario_sistema_email_key UNIQUE (email);

-- Índices secundarios
CREATE INDEX idx_aux_countries_cc       ON aux_countries (country_code);
CREATE INDEX idx_categoria_id_padre     ON categoria (id_padre);
CREATE INDEX idx_producto_proveedor     ON producto (proveedor);
CREATE INDEX idx_producto_id_categoria  ON producto (id_categoria);
CREATE INDEX idx_proveedor_id_country   ON proveedor (id_country);
CREATE INDEX idx_trabajadores_id_rol    ON trabajadores (id_rol);
CREATE INDEX idx_usuario_sistema_id_rol ON usuario_sistema (id_rol);

-- Claves ajenas (con el comportamiento declarado en MySQL)
ALTER TABLE categoria
    ADD CONSTRAINT fk_padre_categoria FOREIGN KEY (id_padre)
        REFERENCES categoria (id_categoria) ON UPDATE CASCADE;
ALTER TABLE producto
    ADD CONSTRAINT fk_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria),
    ADD CONSTRAINT fk_proveedor FOREIGN KEY (proveedor)
        REFERENCES proveedor (cif);
ALTER TABLE proveedor
    ADD CONSTRAINT proveedor_aux_countries_fk FOREIGN KEY (id_country)
        REFERENCES aux_countries (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE trabajadores
    ADD CONSTRAINT usuario_fk FOREIGN KEY (id_rol)
        REFERENCES aux_rol_trabajador (id_rol) ON UPDATE CASCADE;
ALTER TABLE usuario_sistema
    ADD CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol)
        REFERENCES aux_rol (id_rol) ON UPDATE CASCADE;

-- Sincronización de las secuencias de identidad con el valor máximo migrado
SELECT setval(pg_get_serial_sequence('ud5.aux_countries', 'id'),               (SELECT max(id) FROM aux_countries));
SELECT setval(pg_get_serial_sequence('ud5.aux_rol', 'id_rol'),                 (SELECT max(id_rol) FROM aux_rol));
SELECT setval(pg_get_serial_sequence('ud5.aux_rol_trabajador', 'id_rol'),      (SELECT max(id_rol) FROM aux_rol_trabajador));
SELECT setval(pg_get_serial_sequence('ud5.categoria', 'id_categoria'),         (SELECT max(id_categoria) FROM categoria));
SELECT setval(pg_get_serial_sequence('ud5.log', 'id_log'),                     (SELECT max(id_log) FROM log));
SELECT setval(pg_get_serial_sequence('ud5.producto', 'id_producto'),           (SELECT max(id_producto) FROM producto));
SELECT setval(pg_get_serial_sequence('ud5.usuario_sistema', 'id_usuario'),     (SELECT max(id_usuario) FROM usuario_sistema));
COMMIT;
