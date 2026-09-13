# Decisiones aprobadas de alineación

Fuente: plan solicitado explícitamente por el usuario para implementación, incluido su requisito final de resumen monetario por variante. Fecha de consolidación: 2026-09-13. Este registro es normativo para la corrección y no cambia el reporte histórico.

## ALIGN-001 — Autoridad y alcance

ERS inglesa canónica; española sincronizada. Contratos v1 aún en diseño. Solo documentación/contratos/validadores; sin servicios ni UI. D-01…D-09 aprobadas con modificaciones explícitas siguientes. No convertir detalles de transporte en requisitos funcionales.

## ALIGN-002 — Precio fijo y resumen

Combo solo contiene STOCKED/PREPARED. Precio fijo manual; opciones incluidas sin cargos ni diferencias. Referencia visual por slot con selección base y cantidades, guardada/actual/diferencia, exclusivamente administrativa. No sugerir ni sobrescribir precio de venta. Extras no negativos por cantidad y por unidad personalizada fijada. E-16 devuelve pricing {basePrice, extrasTotal, unitSubtotal, currency} para una unidad de variante raíz, sin términos internos. Orders conserva resumen y selección, aplica cantidad de línea y orquesta preparación a Cocina. Sustituye la antigua exigencia de precios de modificador individuales en Orders.

## ALIGN-003 — Revisión

Avisos únicamente para variantes COMBO y agregación por producto. Todas las opciones, incluso deshabilitadas. Cambios relevantes de variante usada; ignorar cosmética, stock y otras variantes. Recipe cambia aviso solo tras adopción por componente. Confirmación individual/múltiple/todas las mostradas; token limita cambios atendidos, posteriores siguen pendientes. Permitir conservar versiones y precio. Auditoría separada sin versión comercial ni eventos de cambio comercial por confirmar. Retirar componente bloquea su opción, no otras selecciones válidas; reconocer aviso no reanima elegibilidad.

## ALIGN-004 — Validación y copias

Moneda externa única y precisión correspondiente; cero monetario permitido, negativos rechazados. Físicos positivos y neto cero omitido. Nombres repetibles; tipo de suministro inmutable. E-17 mismo MenuItem, FAIL/REPLACE, IDs, simulación, concurrencia y todo-o-nada. Identidades y versiones fijadas según D-07/D-08. Los límites físicos de Inventory permanecen en OPEN-010; la aprobación posterior fija retención y configuración monetaria.

## ALIGN-005 — Integraciones y evidencia

Catálogo e invalidaciones definidos, E-16 síncrono, E-18 recuperación. Orders orquesta Cocina; no ruta Menu–Cocina. M-02/M-03/M-04 conservan tombstones, conflictos, expiración y reevaluationRequestId. Outbox Menu aprobado separado de Orders. Autorización y convenciones aprobadas. E-10/M-05/M-06 retirados. Validación estructural, alineación semántica y aceptación de implementación son evidencias distintas.

## Decisiones de contrato para materializar el plan

### Aclaración posterior de OPEN-010 — Inventory

Fuente: decisiones explícitas posteriores del usuario, 2026-09-13. Los máximos y precisión de cantidades físicas permanecen abiertos hasta conocer el contrato de Inventory. Inventory proporciona el catálogo de ingredientes/artículos utilizables en STOCKED, con al menos identificador, nombre y unidad de medida, y proporciona búsqueda sobre ese catálogo. Menu no define unilateralmente las unidades ni conversiones. Se incorporan INT-MENU-024/025 como obligaciones externas. La ruta concreta, consumidor técnico y reglas de conversión/cambio de unidad siguen sujetos al contrato de Inventory. Las alternativas de retención y configuración monetaria están en [propuestas](./open-010-proposals.md) ; B y el contrato monetario fueron aprobados posteriormente por el usuario.

E-19 listado administrativo, E-20 revisión, E-21 confirmación. Tokens opacos ligados al ámbito; confirmar lista explícita valida todo antes de efectos. Campos administrativos no se envían en E-16. Copiar slots remapea baseOptionIds; asignar opciones borra base sustituida, advierte INACTIVE/rechaza ACTIVE inválido. Estos refinamientos hacen verificable el plan sin añadir reglas de cobro.

## Aprobación posterior de OPEN-010 — retención y moneda

Fuente: aprobación explícita del usuario, 2026-09-13. Se adopta íntegramente la alternativa B y el contrato monetario de [la decisión técnica](./open-010-proposals.md). Solo quedan pendientes directivas de Inventory. La retención operativa es de siete días para respuestas completas y tokens; se conservan registros mínimos, auditoría y avisos pendientes. La moneda se configura al alta, precisión derivada de ISO 4217, sin sustitución ordinaria ni dependencia externa por venta. Esta decisión sustituye las etiquetas anteriores de propuesta/no aprobación.
