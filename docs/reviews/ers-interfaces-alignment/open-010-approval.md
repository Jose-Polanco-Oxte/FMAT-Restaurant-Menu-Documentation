# Incorporación de la aprobación de OPEN-010

Fecha: 2026-09-13. Fuente: el usuario aprueba B y la propuesta monetaria y solicita dejar solo directivas con Inventory abiertas.

Se actualizan ambas ERS a revisión 7, las decisiones, convenciones, revisión de combos, E-20/E-21, schema VariantReview y ejemplo del catálogo. El contrato monetario externo aprobado se conserva en [decisión técnica](./open-010-proposals.md), sin asignar sus rutas al servicio Menu. E-16 conserva cuatro campos monetarios.

La política anterior sin plazo definido queda sustituida: resultados completos siete días desde terminación, tokens siete días desde emisión, registros mínimos y auditoría conservados. Un reintento compactado no vuelve a ejecutar; un token vencido no elimina avisos. Las nuevas garantías se exponen mediante Idempotency-Result-Expires-At y reviewTokenExpiresAt.

OPEN-010 permanece parcial exclusivamente por límites/precisión físicos y contrato de Inventory (rutas, consumidor, búsqueda/paginación, conversiones y cambios de unidad). Catálogo con ID/nombre/unidad y búsqueda ya están confirmados. Dimensionamiento operativo y migración monetaria futura no son nuevas decisiones de negocio abiertas en esta versión.

Aceptación documental: ejecutar validate.py, validate_alignment.py y output/review/validate.py. Los casos de expiración, recuperación sin duplicados, continuidad sin proveedor monetario y concurrencia deberán probarse contra servicios implementados; validar schemas no demuestra persistencia, temporizadores ni integración.
