> Informe histórico de la revisión 3. El estado vigente está en [cierre de invariantes](./closure-review.md). Los conteos y pendientes siguientes describen la revisión anterior.

# Revisión de requisitos de Menu

Fecha: 2026-09-11. Alcance: los once módulos de `output/ers` y sus equivalentes de `output/ers-es`, contrastados con las tres fuentes de `docs/md`. La revisión modifica documentación, no implementa ni prueba el servicio. Se conservaron los identificadores existentes; las divisiones reciben identificadores nuevos y las afirmaciones sin respaldo conservan su identificador con estado pendiente o reclasificado.

## Resultado

Se corrigieron claridad, abstracción, atomicidad y cobertura de las decisiones documentadas. La especificación contiene **75 requisitos confirmados**, **6 identificadores pendientes**, **1 reclasificado**, **10 asuntos OPEN** y **13 decisiones históricas**. Los pendientes impiden afirmar que todos los flujos estén completamente especificados. El número de confirmados incluye reglas, datos, interfaces, calidad y restricciones, no solo funcionales.

Los nombres `MenuItem`, `MenuItemVariant` y otros conceptos del modelo se conservan donde identifican información del dominio. No se prescribe una tecnología en los funcionales. Las decisiones arquitectónicas expresas se conservan como restricciones del diseño adoptado; no se justifican como necesidades inevitables del negocio restaurantero.

## Desviaciones corregidas

Cada fila registra un problema independiente de la versión recibida y su resolución. Los identificadores indican los bloques afectados; las citas son páginas de las fuentes locales.

| # | Desviación | Evidencia y corrección |
| --- | --- | --- |
| 1 | REQ-MENU-004 reunía creación de dimensión y creación de valores. | Modelo-Final p. 21: separados en REQ-MENU-004 y 024. |
| 2 | REQ-MENU-005 afirmaba generación automática de combinaciones y su prueba sugería un producto cartesiano completo. | Modelo-Final p. 21 establece combinaciones e invariantes, no generación exhaustiva: se especifica definición de variantes válidas. |
| 3 | REQ-MENU-006 imponía precio no negativo sin política explícita. | Modelo-Final pp. 26–28 confirma precio absoluto; rango numérico queda en OPEN-010. |
| 4 | REQ-MENU-007 limitaba el mínimo a variantes activas sin definición de ese estado. | Modelo-Final p. 27 dice MIN(variant.unitPrice): se elimina el filtro inventado y se registra OPEN-008. |
| 5 | REQ-MENU-015 mezclaba precio de personalización y máximo seleccionable. | Modelo-Final pp. 42–48: separados en REQ-MENU-015 y 025. |
| 6 | REQ-MENU-016 reunía copias de modificadores y de combos bajo una sola prueba. | Modelo-Final pp. 30–31, 45–46: separados en REQ-MENU-016 y 026. |
| 7 | Faltaba la aplicación de un conjunto de opciones a varias variantes de combo. | Modelo-Final p. 31: REQ-MENU-027; correspondencia de espacios pendiente en OPEN-002. |
| 8 | REQ-MENU-021 exigía versionado automático en cada edición. | Modelo-Final p. 23 solo establece versión y evolución independiente: pendiente OPEN-006. |
| 9 | REQ-MENU-021 exigía conservar todas las versiones anteriores. | La misma fuente no fija conservación histórica: retirado del conjunto confirmado, OPEN-006. |
| 10 | REQ-MENU-022 imponía una vista publicada de catálogo activo. | Modelo-Final pp. 18–19, 29–30 no define publicación ni contrato de vista: pendiente OPEN-007. |
| 11 | REQ-MENU-023 imponía borrado lógico como único mecanismo. | Auditoria-3 p. 9 admite borrado lógico **o** versionado por vigencia: consolidado en QA-MENU-002 y CON-MENU-008. |
| 12 | REQ-MENU-023 y QA-MENU-002 extendían retención a variantes y componentes de receta. | Auditoria-3 p. 9 habla de VariantModifierConfig: se acota el mandato y se registra el resto en OPEN-003. |
| 13 | BR-MENU-001 repetía la creación predeterminada además de la cardinalidad. | Modelo-Final pp. 7–8: BR-MENU-001 conserva cardinalidad; creación/presentación predeterminada queda en REQ-MENU-003. |
| 14 | BR-MENU-008 mezclaba fórmula, semántica absoluta y exclusión de precios de componentes. | Modelo-Final pp. 16–17, 26–28: composición en BR-MENU-008, exclusión en 016 y autoridad en CON-MENU-004. |
| 15 | La fórmula no aclaraba la multiplicidad del modificador hijo. | Modelo-Final pp. 15–17: BR-MENU-017 expresa la contribución de cada modificador; cantidades anidadas no decididas quedan en OPEN-009. |
| 16 | Faltaba una obligación explícita de multiplicar el efecto de ingrediente por cantidad seleccionada. | Modelo-Final pp. 15–16, 42–43: BR-MENU-018. |
| 17 | BR-MENU-011 elegía suma de cantidades como semántica de selección de grupo. | Problema-Inicial p. 126 distingue selección y repetición; Modelo-Final p. 48 no resuelve el conteo: pendiente OPEN-005. |
| 18 | BR-MENU-012 exigía bloquear guardado, pero su verificación hablaba de publicación. | Auditoria-3 p. 8 exige un validador y COUNT >= minSelections, sin fijar fase: se conserva la detección de insuficiencia y se abre OPEN-005 para el bloqueo. |
| 19 | BR-MENU-013 mezclaba validación ADD y OMIT. | Modelo-Final pp. 14, 33–34: medición ADD en BR-MENU-013; omisión sin ajuste cuantitativo en 019. |
| 20 | Faltaba una regla expresa de pertenencia de selección al espacio y variante de combo. | Modelo-Final p. 29: BR-MENU-020. |
| 21 | Los límites comunes del grupo aparecían como detalle incidental. | Modelo-Final pp. 47–48: BR-MENU-021 explicita el alcance común. |
| 22 | DATA-MENU-001 inventaba un borrado en cascada condicionado a bloqueos transaccionales. | Modelo-Final p. 22 no establece esa política: eliminada y contemplada en OPEN-010. |
| 23 | DATA-MENU-002 exigía inmutabilidad temporal de fulfillmentType. | Modelo-Final pp. 6–9 exige homogeneidad entre variantes, no prohíbe una futura reclasificación: permanece BR-MENU-005 y se abre la política en OPEN-010. |
| 24 | DATA-MENU-003 exigía unicidad de nombres dentro de la dimensión. | Modelo-Final p. 21 regula combinaciones y pertenencia, no nombres: retirada, OPEN-010. |
| 25 | Los DATA imponían tipos, claves físicas, nulabilidad, valores predeterminados y banderas isDeleted. | Las fuentes enumeran datos lógicos; se eliminan los mecanismos y validaciones no sustentados. |
| 26 | Varios DATA reunían entidades independientes bajo un identificador. | Se separan valores, definición preparada, opción de combo, opción de modificador y componente de receta en DATA-MENU-011 a 015. |
| 27 | INT-MENU-001/002/005 fijaban interfaces síncronas y REST/gRPC. | Las fuentes citadas no fijan estos transportes: se conservan los contratos pendientes en OPEN-002/007. |
| 28 | INT-MENU-004 ampliaba la copia histórica a nombre y precio del producto. | Auditoria-3 p. 8 exige nombre y ajuste cobrado del modificador: se acota la obligación; alcance adicional queda en OPEN-009. |
| 29 | INT-MENU-004 mezclaba copia inmutable y referencia de auditoría. | Auditoria-3 p. 8: separados en INT-MENU-004 y 006. |
| 30 | Faltaba una obligación activa para notas libres de comanda, aunque se mencionaba en el historial. | Problema-Inicial pp. 109–111: INT-MENU-007, expresamente responsabilidad externa de Orders. |
| 31 | QA-MENU-001 exigía índices y planes sin barridos y sugería O(1). | Modelo-Final pp. 49–50 matiza la complejidad; se conserva resolución sin inferencia y se mantiene OPEN-004 para métricas. |
| 32 | QA-MENU-003 imponía cumplimiento dentro del motor de base de datos. | Modelo-Final p. 21 exige invariantes, no un mecanismo concreto: se verifica aceptación/rechazo de configuraciones. |
| 33 | CON-MENU-001 prohibía transacciones distribuidas y tablas compartidas con servicios no establecidos. | Modelo-Final pp. 19–21 prohíbe relaciones FK/ORM con Inventory: se acota a CON-MENU-001 y 006. |
| 34 | El alcance añadía módulos móviles, promociones y políticas ajenas a las fuentes analizadas. | Se acota la especificación a Menu y las responsabilidades externas explícitas; no se convierten ejemplos en módulos obligatorios. |
| 35 | El historial enlazaba identificadores de una numeración anterior. | Se corrigieron los destinos semánticos y se introdujeron anclas estables por ID en ambos idiomas. |
| 36 | El índice declaraba cobertura y atomicidad garantizadas pese a pendientes y añadidos sin fuente. | Se sustituyó por estado documental acotado, conteos obtenidos del catálogo y limitaciones expresas. |

## Cobertura de fuentes a requisitos

Esta tabla permite comprobar omisiones por decisión, además de la matriz de requisito a fuente de cada versión. Las propuestas sustituidas permanecen en el módulo 08.

| Decisión vigente / información insuficiente | Fuente | Destino |
| --- | --- | --- |
| Catálogo y metadatos comerciales | Modelo-Final pp. 22, 36–37 | REQ-001; DATA-001/002 |
| Variante universal y predeterminada | Modelo-Final pp. 7–8 | REQ-003; BR-001; CON-005 |
| Dimensiones, valores e invariantes | Modelo-Final p. 21 | REQ-004/005/024; BR-002/003/004; DATA-003/004/011 |
| Precio absoluto y mínimo informativo | Modelo-Final pp. 26–28 | REQ-006/007; CON-004; OPEN-008 |
| Suministro por variante | Modelo-Final pp. 6–10, 37 | REQ-008/009/010; BR-005; DATA-005/012 |
| Combo plano, opciones y selección | Modelo-Final pp. 10–11, 29–32 | REQ-011/012; BR-006/020; DATA-006/013 |
| Copia y configuración múltiple | Modelo-Final pp. 30–31, 45–46 | REQ-016/026/027; OPEN-002 |
| Personalización propia de producto | Modelo-Final pp. 12–13, 32–33 | REQ-013/014; BR-014; DATA-007/014 |
| Comportamiento por variante sin herencia | Modelo-Final pp. 41–48, 51–52 | REQ-015/025; BR-009/010/021; DATA-008; CON-003 |
| Ingredientes, instrucciones y multiplicidad | Problema-Inicial pp. 108–111; Modelo-Final pp. 14–16, 33–34 | REQ-017/018/019; BR-013/018/019/022; INT-007 |
| Aislamiento de personalizaciones de combo | Modelo-Final pp. 14–15 | BR-007 |
| Composición de precio | Modelo-Final pp. 16–17, 26–28 | BR-008/016/017; OPEN-009 |
| Estado administrativo y disponibilidad operativa | Modelo-Final pp. 18–19 | REQ-002; BR-015; OPEN-001 |
| Referencias a Inventory y propiedad de recetas | Modelo-Final pp. 19–23, 37–38 | REQ-020; INT-003; DATA-009/010/015; CON-001/006/007 |
| Agregados separados | Modelo-Final pp. 21–23 | CON-002 |
| Ausencia de inferencia en venta | Modelo-Final pp. 49–50 | QA-001; OPEN-004 |
| Viabilidad del grupo | Auditoria-3 p. 8 | BR-012; OPEN-005 |
| Copia histórica del modificador | Auditoria-3 p. 8 | INT-004/006; OPEN-009 |
| Retiro sin romper órdenes pendientes | Auditoria-3 p. 9 | QA-002; CON-008; OPEN-003 |
| Versiones, contratos y validaciones insuficientes | Modelo-Final pp. 21–23, 29–31, 37–38 | OPEN-006/007/010 |

Los identificadores abreviados de esta tabla incluyen el segmento `MENU` (por ejemplo, REQ-001 significa REQ-MENU-001).

## Verificación

Se ejecutó la comprobación documental reproducible en [validate.py](./validate.py); el resultado está en [validation.json](./validation.json). Comprueba identificadores únicos y secuenciales, estados y conteos, correspondencia entre idiomas, campos obligatorios, referencias de fuente y páginas, enlaces con sus anclas, cobertura de la matriz y ausencia de tecnologías en los enunciados funcionales confirmados.

La revisión semántica se realizó contra las fuentes; un script no prueba por sí mismo claridad ni atomicidad. No se ejecutaron pruebas de implementación. Los criterios de verificación de cada requisito describen qué comprobar cuando exista el software o contrato correspondiente.
