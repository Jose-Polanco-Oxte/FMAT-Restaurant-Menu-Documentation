# OPEN-010: decisiones de Inventory y propuestas técnicas

Fecha: 2026-09-13. **Estado:** aprobado por el usuario: Inventory, alternativa B y contrato monetario. A/C se conservan solo como alternativas descartadas. Las rutas monetarias pertenecen al proveedor externo, no a Menu.

## 1. Inventory: decisión confirmada

Los máximos y decimales físicos esperan el contrato de Inventory. Inventory proporciona catálogo y búsqueda para seleccionar ingredientes y artículos STOCKED; cada resultado contiene al menos ID, nombre y unidad. Se registró en INT-MENU-024/025 de ambas ERS (revisión 6: 193 identificadores, 163 obligaciones confirmadas). Menu no define un catálogo de unidades independiente. Conversión, cambios de unidad, paginación y ruta concreta todavía requieren acuerdo con Inventory.

## 2. Retención: alternativas viables

No hay un plazo universal para este dominio. Stripe documenta claves conservadas al menos 24 horas y advierte que, después de purgarlas, reutilizarlas puede crear una nueva operación. Es un precedente de proveedor, no un plazo obligatorio para Menu. [Stripe](https://docs.stripe.com/api/idempotent_requests).

| Alternativa | Respuestas idempotentes completas | Tokens de revisión observada | Consecuencia |
| --- | --- | --- | --- |
| A. Sin purga en esta versión | Conservar | Conservar | Implementación inicial sencilla; crecimiento sin límite definido, exige observar volumen |
| B. Ventana de siete días — recomendada | 7 días después de terminar la operación | 7 días desde su emisión | Tolera interrupciones de varios días; requiere expiración explícita y recarga de revisión |
| C. Ventana de un día | 24 horas después de terminar | 24 horas desde emisión | Menor almacenamiento de payloads, más recargas para administradores |

Las duraciones de B/C son propuestas de ingeniería, no estándares. La recomendación B separa:

- **Resultado completo:** tras vencer, puede compactarse. Conservar en esta versión un registro mínimo durable de clave, ámbito, huella de solicitud y referencia del resultado. Un reintento con clave conocida y resultado compactado devuelve 409 IDEMPOTENCY_RESULT_EXPIRED; nunca ejecuta otra vez silenciosamente. Clave con contenido distinto conserva 409 IDEMPOTENCY_CONFLICT. Mostrar recuperación de la entidad/operación antes de iniciar una intención nueva. No purgar operaciones en curso o de resultado incierto.
- **Token:** vencido devuelve 409 REVIEW_TOKEN_EXPIRED y se obtiene otra observación por E-20. La expiración no atiende cambios ni elimina el aviso. Nuevos cambios durante un token vigente siguen pendientes después de confirmar los vistos. Esta política aprobada sustituye la retención anterior sin plazo definido.
- **Auditoría y cambios pendientes:** no caducan con el token. Conservarlos en esta versión; si después se elige una política de archivo, debe ser independiente del TTL del token.
- **Outbox/inbox:** no aplicarles ciegamente siete días. No eliminar publicación pendiente; la deduplicación de mensajes depende de la ventana real de redelivery/replay del broker y de la política de recuperación. AWS señala que outbox puede producir duplicados y requiere consumidores idempotentes; no fija este TTL. [AWS](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html).

Configurar la retención como política operativa del despliegue, no como ajuste comercial por restaurante. Aplicar cambios de política a registros nuevos sin acortar garantías ya emitidas. Si se aprueba B/C, exponer expiración del token y garantía de reintento en el contrato. Medir operaciones/día, tamaño medio de respuesta/token y antigüedad de pendientes antes de fijar capacidad. Fórmula orientativa: operaciones diarias × días × bytes medios, más índices, auditoría, compactos y réplicas; el registro compacto sigue creciendo y no promete almacenamiento total acotado.

## 3. Contrato monetario propuesto

### Autoridad y configuración

Obligaciones activas desde la aprobación: el proveedor externo deberá ofrecer el alta y lectura descritas y derivar minorUnit de ISO 4217. Menu deberá consumir la configuración aceptada conforme a esta sección. Las expresiones de recomendación/propuesta que siguen conservan la exposición original; ya no representan decisiones abiertas.

Propietario lógico: componente externo que administra configuración del restaurante; el servicio concreto aún no está identificado. Menu y Orders reciben la misma configuración validada. No convertir a Menu en administrador de restaurantes ni consultar ese proveedor en cada E-16.

ISO 4217 aporta códigos y unidades menores; SIX mantiene su catálogo oficial. Seleccionar código de tres letras de un conjunto soportado de monedas comerciales; no aceptar cualquier cadena ni códigos de prueba/fondos por defecto. [ISO](https://www.iso.org/iso-4217-currency-codes.html), [SIX](https://www.six-group.com/en/products-services/financial-information/market-reference-data/data-standards.html).

| Dato | Quién lo decide |
| --- | --- |
| currency | Administrador autorizado al aprovisionar el restaurante |
| minorUnit | Derivado del catálogo ISO 4217 mantenido por el proveedor; no editable por restaurante |
| revision | Proveedor; versión de la configuración distribuida |
| Símbolo, separadores y formato | Presentación según locale; no cambian importes ni contrato de cálculo |
| Rechazo de precisión excedente | Regla fija ya aprobada: no redondeo silencioso |
| Impuestos, propinas, descuentos y redondeo de efectivo | Fuera del subtotal de Menu; requieren sus propios contratos |

### Interfaz externa de aprovisionamiento y lectura

Rutas candidatas en el host del propietario, **no endpoints E-* de Menu**:

`PUT /v1/restaurants/{restaurantId}/monetary-settings`

Alta única: `If-None-Match: *`, autenticación de administrador y ámbito restaurante. Body cerrado:

```json
{
  "currency": "MXN"
}
```

Respuesta 201 con ETag y Location. `GET` sobre la misma ruta devuelve 200 con el siguiente cuerpo cerrado:

```json
{
  "restaurantId": "r-1",
  "revision": 1,
  "currency": "MXN",
  "minorUnit": 2
}
```

GET admite If-None-Match y 304. Las precondiciones y ETag siguen RFC 9110; los nombres de ruta/campos son propuestas del proyecto. [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html#section-13.1.2).

Errores propuestos: 400 cuerpo/código mal formado; 401 credencial inválida; 403 falta de permiso/ámbito; 404 configuración no creada al leer; 412 alta condicional si ya existe; 422 moneda no soportada. Las credenciales distinguen lectura de servicio de aprovisionamiento administrativo. En el alta perdida por timeout, consultar GET y comparar antes de reintentar: PUT no crea otra identidad de configuración.

### Integración y cambios

Recomiendo **configurable en el alta, no cambio monetario ordinario después**. Una actualización corriente para convertir MXN en USD no debe reinterpretar los importes existentes. Un cambio posterior requiere migración explícita de catálogos y consumidores, nueva revisión y conservación de moneda histórica; esa migración no forma parte de esta propuesta inicial. El proveedor rechaza sustituciones ordinarias con 409 MONETARY_MIGRATION_REQUIRED. No ofrecer un PATCH libre de currency/minorUnit.

El aprovisionamiento entrega la configuración al proceso de despliegue/configuración externa ya contemplado para Menu y Orders. Ambos conservan la revisión aceptada; no hacen llamadas externas por venta. Si falta configuración validada, bloquear escrituras monetarias y resolución con 503 MONETARY_CONFIGURATION_UNAVAILABLE, sin asumir MXN. Si el proveedor cae pero existe configuración aceptada, continuar con ella; cualquier migración futura debe coordinar adopción antes de operar con una moneda nueva.

Money y E-16 mantienen importes decimales como texto exacto y moneda explícita. Rechazar más decimales que minorUnit, incluso si son ceros sobrantes, para una regla simple; aceptar menos y normalizar presentación sin alterar valor. No es requisito usar punto flotante ni centavos enteros como almacenamiento. E-16 conserva sus cuatro campos monetarios: no añadir configuración, revision ni desglose interno a ese resumen.

## 4. Aprobación y pendientes

El usuario aprobó B y el contrato monetario el 2026-09-13. Solo permanecen abiertos los acuerdos con Inventory: límites y precisión físicos, rutas/consumidor, búsqueda/paginación, conversiones y cambios de unidad. El propietario monetario es el componente externo de configuración del restaurante; su nombre de despliegue no cambia el contrato. La capacidad se dimensiona operativamente mediante las mediciones descritas, sin un límite comercial inventado. La migración de moneda y el archivo futuro no forman parte de esta versión.

Referencias consultadas el 2026-09-13; describen fundamentos, no certifican el diseño del proyecto.
