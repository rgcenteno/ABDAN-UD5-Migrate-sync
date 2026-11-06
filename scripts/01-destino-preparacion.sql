-- =====================================================================
-- 01-destino-preparacion.sql
-- Se ejecuta en Aurora PostgreSQL, base de datos ud5, como adminud5.
-- Sustituya :'clave_dms' mediante psql -v (véase el enunciado).
-- =====================================================================
CREATE SCHEMA IF NOT EXISTS ud5 AUTHORIZATION adminud5;

CREATE ROLE dms_target LOGIN PASSWORD :'clave_dms';

-- Permisos mínimos de DMS sobre el destino.
GRANT CONNECT ON DATABASE ud5 TO dms_target;
GRANT CREATE ON DATABASE ud5 TO dms_target;   -- esquema de control awsdms_control
GRANT USAGE, CREATE ON SCHEMA ud5 TO dms_target;

-- Permite a adminud5 consultar el esquema awsdms_control, propiedad de dms_target.
GRANT dms_target TO adminud5;
