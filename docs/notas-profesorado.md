# Notas para el profesorado

**Documento reservado: contiene los valores de referencia de la verificación.**

## Estado de la validación

| Elemento | Estado |
|---|---|
| Scripts PostgreSQL (01, 02, 03 y 05) | Ejecutados en PostgreSQL 16 local. Cargas y cambios simulados con el usuario `dms_target`. |
| Fórmula de las sumas | Contrastada: PostgreSQL coincide con un cálculo independiente en Python sobre los datos del volcado. |
| Scripts MySQL (00, 04 y 06) | **No ejecutados**: no se dispuso de un servidor MySQL. |
| Pasos de consola y comportamiento de DMS | **No ejecutados en AWS.** Basados en la documentación oficial consultada el 4 de noviembre de 2026. |

Se recomienda realizar una ejecución piloto completa antes de utilizarla con el alumnado.

## Puntos que debe confirmar la ejecución piloto

1. **Roles de DMS (riesgo principal).** La documentación pública del Learner Lab localizada indica que no se pueden crear roles, salvo los vinculados a servicios. Otro fragmento, de la variante Associate Services, incluye DMS e indica que se permite crear roles de servicio, aunque puede ser necesario reintentar. Son copias no oficiales y antiguas: compruebe `dms-vpc-role` y `dms-cloudwatch-logs-role` en su laboratorio. Sin ellos, no se puede crear la instancia de replicación ni enviar registros a CloudWatch.
2. **CDC con RDS for MySQL 8.4.** La documentación de DMS es contradictoria: la página de orígenes admite 8.4 con DMS 3.5.4 o superior, pero la de MySQL conserva la frase «versión 5.6, 5.7 u 8.0» para CDC en RDS. Si falla, cambie a **Migrate existing data**, y omita los pasos 21 y 22.3; en ese caso, los valores finales coincidirán con los de la línea base.
3. **Autenticación.** La documentación no precisa el comportamiento de RDS for MySQL 8.4 con `caching_sha2_password` en DMS. El apartado 8 incluye `mysql_native_password` como alternativa, pero esta opción puede requerir ajustes en el grupo de parámetros. El cliente `mariadb105` tampoco se ha probado contra 8.4.
4. **Servicios del laboratorio.** Compruebe la disponibilidad de endpoints de interfaz, CloudTrail con eventos de datos, `db.t3.medium`, `db.t3.small` y `dms.t3.medium`. La documentación localizada limita las instancias a los tamaños nano a medium o large.
5. **Evento de fallo.** La categoría `Failure` procede de las tablas de eventos de DMS, pero el ejemplo publicado es de un evento `StateChange`. Si no llega el correo, amplíe temporalmente el patrón eliminando `detail` y examine el evento real.
6. **Importación del certificado.** Se usa el paquete regional por tamaño. No se ha contrastado ningún límite concreto de tamaño.
7. **Tiempo y sesión.** Con una sesión de 4 horas, el margen es reducido si el alumnado sufre incidencias. Puede dividir la práctica tras el paso 14, parando las instancias de RDS.

## Decisiones de diseño

- **Claves KMS administradas por AWS.** Evitan depender de políticas de clave en un entorno sin control real de IAM. En producción, se recomendaría una clave administrada por el cliente.
- **Credenciales en los endpoints de DMS, sin Secrets Manager.** Secrets Manager exige un rol de acceso específico, que no puede garantizarse en el laboratorio.
- **`LabRole` y `LabInstanceProfile`.** Incumplen estrictamente el mínimo privilegio. El control se aplica a bases de datos, red y roles de DMS, y la limitación se trabaja como cuestión de la memoria.
- **Tráfico de CloudWatch.** La VPC no dispone de endpoints para CloudWatch porque es el servicio DMS quien publica los registros y métricas; compruébelo también en el piloto.

## Valores de referencia

Línea base, antes del paso 21:

| Tabla | Filas | `suma_md5` |
|---|---:|---:|
| `aux_countries` | 246 | 540244521911 |
| `aux_rol` | 3 | 6913680340 |
| `aux_rol_trabajador` | 6 | 16461055814 |
| `categoria` | 15 | 27800980188 |
| `log` | 3 | 7892381987 |
| `producto` | 1023 | 2227988810061 |
| `proveedor` | 101 | 221380751852 |
| `trabajadores` | 742 | 1578247770723 |
| `usuario_sistema` | 3 | 6017785570 |

Valores finales, tras el paso 21. Las tablas no incluidas no cambian:

| Tabla | Filas | `suma_md5` |
|---|---:|---:|
| `log` | 3 | 6344395343 |
| `producto` | 1024 | 2226151266667 |
| `trabajadores` | 742 | 1578673441298 |

## Orientación para las cuestiones

- **Claves ajenas:** DMS no garantiza el orden de las tablas, por lo que activas podrían provocar fallos.
- **Intercalación:** PostgreSQL distingue mayúsculas y acentos por defecto; pueden coexistir valores que MySQL rechazaría. Se resuelve con índices únicos sobre expresiones o intercalaciones no deterministas.
- **Suma de 32 bits:** detecta cambios accidentales, pero permite colisiones y no es criptográficamente adecuada; puede sustituirse por SHA-256 por fila y un agregado ordenado determinista.
- **Origen local:** VPN o Direct Connect, conectividad enrutada desde la VPC y certificados propios.
