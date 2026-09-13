[Índice](./index.md)

# Convenciones de contrato

## Autorización aprobada

D-05: HTTP cifrado con `Authorization: Bearer <credencial>`. Menu valida identidad, vigencia, audiencia Menu, permiso y restaurante autorizado. Se adopta la siguiente matriz de capacidades; no presupone roles ni un servicio Auth particular. El emisor y mecanismo concreto de credenciales se acuerdan al integrar.

| Permiso | Alcance |
| --- | --- |
| menu:catalog:read | Lecturas comerciales |
| menu:definition:read | Configuración administrativa |
| menu:definition:write | Crear, validar y editar Menu/MenuItem |
| menu:recipe:read / menu:recipe:write | Recetas actuales |
| menu:history:read | Revisiones inmutables |
| menu:selection:resolve | Resolver selecciones |
| menu:availability:recover | Recuperación de definiciones planas, consumidor Inventory |

Cada endpoint declara exactamente un permiso. Falta de credencial válida produce 401; identidad válida sin capacidad/ámbito produce 403. Nombres de permisos son decisiones de contrato aprobadas y trazadas a la ERS.

## HTTP

Base /v1/restaurants/{restaurantId} en host Menu. JSON UTF-8, Accept y Content-Type application/json. GET sin body. IDs opacos no vacíos, versiones como contador y fecha ISO8601 con zona, codificadas correctamente en URL. El parámetro restaurantId no autentica ni autoriza por sí solo.

Mutaciones usan Idempotency-Key, asociada a principal, restaurante, método, ruta y contenido normalizado. Mismo intento devuelve resultado original; clave con otro contenido da 409 IDEMPOTENCY_CONFLICT. Ediciones usan If-Match con ETag opaco: falta 400 PRECONDITION_REQUIRED, desactualizado 412 REVISION_CONFLICT. Recuperar resultado idempotente precede a comprobar ETag. No se crea una revisión por guardado idéntico. Simulaciones no reservan un commit posterior. La respuesta completa se conserva siete días desde la terminación; la respuesta de mutación expone Idempotency-Result-Expires-At como instante UTC RFC 3339. Después puede compactarse, conservando clave, ámbito, huella y referencia de resultado. Un reintento conocido compactado devuelve 409 IDEMPOTENCY_RESULT_EXPIRED sin reejecutar; contenido distinto devuelve IDEMPOTENCY_CONFLICT. No purgar operaciones en curso o inciertas. Conservar auditoría y registros mínimos en esta versión.

201 incluye Location y ETag; 200 de lectura administrativa incluye ETag. Vistas comerciales y resolución usan Cache-Control no-store por vigencia de disponibilidad. Listas con items y nextCursor, null al finalizar. limit por defecto 50, máximo 200 (elección de transporte), cursor opaco conserva filtros/snapshot de definición; expiración da 409 CURSOR_EXPIRED. Disponibilidad se evalúa al responder incluso durante paginación.

Errores comparten [Error](./schemas/Error.schema.json). Campos obligatorios: code, message, correlationId y violations. Cada violación contiene path, code, entityId nullable, message y details. Advertencias usan Violation y no invalidan un guardado permitido INACTIVE. Nunca introducir excepciones internas en respuesta. 500 corresponde a fallo interno de Menu; 503 a indisponibilidad de Menu. Evaluación de inventario ausente/expirada produce NOT_ELIGIBLE, no una llamada HTTP implícita.

## Números y modelos

Esquemas JSON Schema 2020-12 describen cuerpos y respuestas completas. En peticiones se rechazan campos desconocidos. En mensajes v1 solo se emiten campos especificados; evolución aditiva exige publicar esquema actualizado y que consumidores acepten extensiones explícitamente compatibles. No declarar compatibilidad automática con un esquema cerrado anterior. Tras publicación con consumidores, cambiar significado/tipo/obligatoriedad exige nueva versión. Esta corrección actualiza v1 directamente porque todavía está en diseño, por decisión explícita del usuario.

DecimalString usa cadena decimal sin exponente. Cantidad de selección y suppliedQuantity son enteros. No mezclar unidades al sumar. D-06 exige cantidades físicas mayores que cero. Precios y ajustes no negativos; moneda externa única por restaurante y precisión monetaria correspondiente, sin redondeo. OPEN-010 conserva únicamente acuerdos pendientes con Inventory. La [configuración monetaria aprobada](../../docs/reviews/ers-interfaces-alignment/open-010-proposals.md) define alta PUT/lectura GET en el proveedor externo, precisión ISO derivada y moneda no sustituible sin migración. Sin configuración aceptada: 503 MONETARY_CONFIGURATION_UNAVAILABLE para escrituras monetarias y E-16; con configuración aceptada, una caída del proveedor no impide operar. Rechazar decimales excedentes incluso si son ceros. El ejemplo MXN no fija moneda de restaurante. No usar float como prescripción de almacenamiento.

## Mensajería común

Envelope: messageId, type, schemaVersion=1, occurredAt con zona, producer, restaurantId y data obligatorios. correlationId es opcional para seguimiento; causationId se elimina de esta revisión. La respuesta a M-04 se reconoce por data.reevaluationRequestId en M-03, no por correlationId. En errores HTTP, correlationId sigue siendo obligatorio como referencia de soporte: Menu lo asigna al atender la petición, distinto del uso opcional en eventos. Credencial del broker determina productor autorizado; el campo producer no acredita identidad. ACL por canal/consumidor y ámbito restaurante. No enviar tokens en payload ni aceptar un replyTo arbitrario.

Menu persiste cambios y trabajo de publicación juntos (outbox aprobado). Deduplica entradas por messageId y persiste consumo/efecto antes de ACK. Reentrega conserva messageId. Publicación nueva usa ID nuevo. No se presupone orden global ni entrega única. Orden semántico de disponibilidad: clave y revisión. Reintentos transitorios con espera configurable; formato inválido, identidad reutilizada con contenido distinto o versión desconocida va a cuarentena durable con causa y alarma. No se descarta trabajo pendiente silenciosamente. Sin garantía de tiempo finito durante una caída indefinida.

Referencias de sintaxis: [HTTP RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html) y [JSON Schema 2020-12](https://json-schema.org/draft/2020-12). Son referencias de transporte, no fuentes de requisitos de dominio.

## Política operativa aprobada

Retención configurada por despliegue, no por restaurante: siete días; cambios futuros no acortan garantías emitidas. Nunca eliminar publicaciones pendientes; deduplicación outbox/inbox se conserva conforme a la ventana real de replay/redelivery, sin aplicar automáticamente el TTL de siete días. Dimensionar capacidad con volumen diario, tamaño medio, índices, auditoría, registros compactos y réplicas. No se fija una cuota comercial ni se promete almacenamiento total acotado.
