# Criterios de aceptación de implementación

Estos escenarios son especificación para una implementación futura. No son pruebas ejecutadas del servicio. Los checks de schemas y aritmética de ejemplos están en `output/interfaces/validate_alignment.py`.

| Caso | Preparación / acción | Resultado exigido |
| --- | --- | --- |
| AC-01 | Combo 200, elegir pollo o res incluidos | Base 200 en ambos; sin cargo por opción |
| AC-02 | Dos hamburguesas, queso 5 en una y dos extras 5 en otra | pricing 200/15/215/MXN, sin términos internos; preparación distingue unidades |
| AC-03 | Componente sube de 25 a 30 | Referencia actual cambia, diferencia 5; venta conserva precio fijo |
| AC-04 | Precio de modificador fijado 5, actual 7 | Extra sigue 5 hasta adoptar versión |
| AC-05 | Cambia variante no utilizada, cosmética o stock | Sin aviso de revisión |
| AC-06 | Cambia componente de opción deshabilitada | Aviso en variante COMBO dependiente |
| AC-07 | Recipe nueva sin adopción, luego adopción por PREPARED | Primer cambio no avisa; segundo avisa a combos, no a PREPARED |
| AC-08 | Abrir token con A, llega B, confirmar token | A atendido, B pendiente; no pérdida de actualización |
| AC-09 | Confirmar una, varias o todas las mostradas | Solo variantes explícitas; agregado pendiente mientras alguna lo esté |
| AC-10 | Token ajeno, repetición de variante o token inventado | Error 422 sin confirmaciones parciales |
| AC-11 | Confirmar conservando composición/precio | Auditoría con actor/instante; sin revisión comercial ni M-07 |
| AC-12 | Retirar pollo, res válida; luego retirar res | Pollo no seleccionable; combo sigue con res; finalmente no elegible |
| AC-13 | Atender aviso de retirada sin cambiar referencia | No reactivar ni volver seleccionable el componente |
| AC-14 | Copia E-17 con conflicto/412/dryRun | Cero efectos parciales; remapear base al copiar slots |
| AC-15 | Asignar opciones invalida base | Advertencia INACTIVE; rechazo ACTIVE cuando base no satisface mínimos |
| AC-16 | Precio cero, negativo, moneda distinta o precisión excesiva | Cero válido; restantes rechazados sin redondear |
| AC-17 | Físicos cero/negativos; omisión; neto cero | Rechazar entradas no positivas; OMIT sin cantidad; omitir neto cero |
| AC-18 | COMBO como hijo o cambio de tipo existente | Rechazo; no recursión ni reclasificación |
| AC-19 | Nombres repetidos con IDs distintos | Aceptar; no relajar unicidad de combinación dimensional |
| AC-20 | Positivo tardío tras tombstone, conflicto o reevaluación vieja | No habilitar; mantener control por definición/evaluación/requestId |
| AC-21 | Cliente intenta escribir state o filtrar por otro restaurante | Rechazar escritura de estado; aplicar permiso y ámbito autenticados |
| AC-22 | Reentrega de publicación/confirmación | Idempotencia y efectos durables según convenciones; no duplicar auditoría del mismo intento |
| AC-23 | Consulta comercial y E-16 | Sin baseOptionIds, cambios de revisión ni comparativas monetarias administrativas |

No asignar un PASS de implementación a estos escenarios por la existencia de ejemplos. Broker, persistencia, UI, integración y rendimiento requieren evidencia propia.
