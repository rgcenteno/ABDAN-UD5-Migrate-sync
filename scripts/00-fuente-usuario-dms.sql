-- =====================================================================
-- 00-fuente-usuario-dms.sql
-- Se ejecuta en RDS for MySQL como admin. Sustituya <CLAVE_DMS>.
-- =====================================================================
CREATE USER 'dms_user'@'10.50.%' IDENTIFIED BY '<CLAVE_DMS>' REQUIRE SSL;

GRANT SELECT ON ud5.* TO 'dms_user'@'10.50.%';                 -- carga completa
GRANT REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'dms_user'@'10.50.%';   -- CDC

-- Conserva los registros binarios durante 24 horas para la replicación.
CALL mysql.rds_set_configuration('binlog retention hours', 24);
CALL mysql.rds_show_configuration;
