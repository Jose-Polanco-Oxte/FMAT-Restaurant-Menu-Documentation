# Mockups de FMAT Restaurant — versión 1.1

Versión corregida generada con Stitch para el proyecto `15034143433341050287` (`FMAT Restaurant Wireframing`), usando el Design System `assets/4921283958737766649` (`FMAT POS Wireframe`) y capturando todas las pantallas como `DESKTOP`.

## Fuentes y prioridad

1. `output/ui-spec/ui-data-spec.md` — autoridad funcional y estructural.
2. `output/mockup/reviews/1.0/revision.md` — correcciones visuales y de contenido.
3. `.stitch/DESIGN.md` — sistema visual.
4. `output/mockup/1.0/` — referencia histórica y mapeo.

`output/mockup/1.1/` no se usó como entrada. No se modificaron código de aplicación, especificación, Design System, revisión ni mockups 1.0.

## Matriz completa v1 → v1.1

Cada carpeta contiene exactamente un HTML descargado de Stitch y un screenshot PNG descargado de Stitch.

| Composición | Referencia v1 | Stitch screen ID | Corrección principal |
|---|---|---|---|
| `V-MES-01` Mesas asignadas | `V-MES-01-mesas-asignadas.png` | `b0ba740f8a0e4fdca2d6be7780d3395f` | Mesa asignada, orden existente/sin orden y acciones de mesero sin shell global. |
| `V-MES-01` Estado vacío | `ui-states-alternos.png` | `89cb4f3ecf5d471c9d19de6421592e7a` | Estado vacío separado, sin datos inventados. |
| `V-MES-01` Error de Sala | `ui-states-alternos.png` | `723eeb7d667a485ba0de0a10b7097a4a` | `SALA_UNAVAILABLE` con mensaje de negocio, sin endpoint/HTTP/timeout inventado. |
| `V-MES-02` Orden actual | `V-MES-02-orden-actual.png` | `e28a19b1cee14bcf969193e74c177a70` | `Precio unitario`, líneas confirmadas separadas del borrador y total proyectado. |
| `V-MES-02` Sin líneas | Nueva composición; sin referencia individual v1 | `dedbfb1dc3d145bc8052e6ee76056040` | Orden vacía separada de error y con acciones de negocio. |
| `V-MES-02` Error de lectura | `ui-states-alternos.png` | `7e1b9d3101f441309a8b426c6f709049` | `ORDERS_UNAVAILABLE`, sin líneas/totales y sin alertas técnicas inventadas. |
| `V-MES-03` Crear orden / catálogo | `V-MES-03-catalogo-preorden.png` | `cf2f0f177b55473d9cdb94e366519817` | `eligible` separado de `status`; `fromPrice=null` no se renderiza como cero. |
| `V-MES-03` Agregar a orden | `V-MES-03-catalogo-preorden.png` | `8d5b80e933c246e09e283bcb6b466aef` | `preorderTotal=336+115=451`; item no elegible sin “Agotado”. |
| `V-MES-03` Catálogo vacío | Nueva composición; sin referencia individual v1 | `eafd5b8e19cf4ddf9f4152ca2f746dc2` | Estado vacío de catálogo separado del borrador. |
| `V-MES-03` Resolviendo | `ui-states-alternos.png` | `c5ea06d108074415ad8e53c12df389ef` | `RESOLVING` sin timeout, contador ni stock inferido. |
| `V-MES-03` Selección no disponible | `ui-states-alternos.png` | `97f70ca56fb049419c08343ae48ea131` | `NOT_ELIGIBLE/RESOLUTION_ERROR`, sin `DraftOrderLine`, filtros sin conteos inventados. |
| `O-MES-01` Item preparado | `O-MES-01-configuracion-item-prepared.png` | `262730f0ac7547b492e1de0d8a1e8d15` | Selección/cantidad coherentes; `extrasTotal=20`, `unitSubtotal=188`, `lineCost=376`. |
| `O-MES-01` Combo | `O-MES-01-configuracion-combo.png` | `93f666cf4ac44ae38e90d156948f2a33` | Slots, `optionId`, `baseOptionIds`, `componentRef`, `suppliedQuantity` y cargos base `0`. |
| `O-MES-01` Item simple | Nueva composición; sin referencia individual v1 | `1a1287b548824174b98dc1538ca7bef2` | `MOD-0`, desglose económico completo y acción de negocio. |
| `O-MES-01` Edición de línea | Nueva composición; sin referencia individual v1 | `b11a99c1277740b194ac37172ca7b32f` | Borrador local separado, cantidades coherentes y `lineCost=376`. |
| `V-ADM-01` Catálogo ACTIVE | `V-ADM-01-gestion-catalogo-activo.png` | `d6c64a211d0a4fe7a138b677bea79cba` | Solo tres estados base; `REVIEW_REQUIRED` queda como overlay de combo. |
| `V-ADM-01` Catálogo INACTIVE | Nueva composición; sin referencia individual v1 | `856cdfc942714d2483b4821e353a36e0` | Tres estados base, activación sujeta a Menu y sin conteos decorativos. |
| `V-ADM-01` Revisión de combos | Nueva composición; sin referencia individual v1 | `1602f4bec14a4e0eab3e960ca520cc96` | Revisión contextual de combos, sin pestaña global ni sincronización ficticia. |
| `V-ADM-01` Catálogo ARCHIVED | `V-ADM-01-gestion-catalogo-archived.png` | `a5316b93e6c747a182deda73afc137cc` | Archivo suave, variantes archivadas y separación de `INACTIVE`. |
| `V-ADM-02` CREATE Paso 1 | `V-ADM-02-create-step1-classification.png` | `98bc7033632a4b04b9f4b39db1d10b99` | Clasificación comercial separada de tipo de suministro. |
| `V-ADM-02` CREATE STOCKED | `V-ADM-02-create-stocked-editor.png` | `a2a135dd08014d718f37a38c039ff80b` | `inventoryItemId`, `quantity` y `unit` como referencia/consumo definido, no stock disponible. |
| `V-ADM-02` CREATE PREPARED | `V-ADM-02-create-prepared-recipe.png` | `7263b5c00db5453492560f29f3acec75` | `recipeId/recipeVersion` y adopción de receta separados. |
| `V-ADM-02` CREATE COMBO | `V-ADM-02-create-combo-editor.png` | `f42c6f422a7244caabc9871ef5ed6f2e` | Slots y opciones administrativas sin precio implícito de componentes. |
| `V-ADM-02` CREATE Modificadores | Nueva composición; sin referencia individual v1 | `8810f574029c4f4f86cabbd18718f9ea` | Stepper canónico, `enabled/quantity`, `ADD/OMIT` y suministro sin stock físico. |
| `V-ADM-02` CREATE Resumen | Nueva composición; sin referencia individual v1 | `c34921e9c14e40a49e30c6d749befafc` | Warning separado de aprobación y frontera Menu/Orders/Inventory explícita. |
| `V-ADM-02` EDIT Modificadores | `V-ADM-02-edit-modificadores.png` | `1be00b8bdb414f159a1fc8025b24196f` | Stepper EDIT de tres pasos, `If-Match` y referencias de suministro limpias. |
| `V-ADM-02` EDIT Conflicto | Nueva composición; sin referencia individual v1 | `4c0ad2bca7de4640b73ccd8f0349df3b` | `LOCAL_DRAFT_PRESERVED`, conflicto de revisión y no sobrescritura automática. |
| `V-ADM-03` Revisión pendiente | `V-ADM-03-revision-combo.png` | `206684bf78d24894be143bce1c77a8fe` | Estados locales pending/seen/selected separados de la confirmación. |
| `V-ADM-03` Revisión confirmada | Nueva composición; sin referencia individual v1 | `1f77572c382e411db3ed6c31f5899633` | Respuesta `E-21` primero y refresco `E-20` después para mostrar `UP_TO_DATE`. |
| `V-ADM-04` Confirmación de guardado | `V-ADM-04-confirmacion-guardado.png` | `4600f11ba2e64e55a21eeb1583edbd2f` | Selector mutuamente excluyente, warning separado y borrador `NO PERSISTIDO`. |

## Referencias v1 invalidadas y revisión aplicada

La revisión `output/mockup/reviews/1.0/revision.md` identificó que las 15 imágenes raster de `output/mockup/1.0/` incorporaban sidebars o shells fuera de alcance. Por ello se consideran referencias visuales históricas, no bases reutilizables de layout.

También se corrigieron en 1.1 los puntos específicos de la revisión:

- `V-ADM-01`: `REVIEW_REQUIRED` ya no es una pestaña global; `ACTIVE`, `INACTIVE` y `ARCHIVED` son los estados base.
- `V-ADM-03`: `UP_TO_DATE` está separado y solo aparece después de la respuesta `E-21` y el refresco `E-20`.
- `V-ADM-04`: los resultados de guardado son composiciones seleccionables mutuamente excluyentes; el warning y el borrador local están separados.
- Steppers CREATE/EDIT, etiquetas actor-oriented, filtros de suministro, `enabled/quantity`, opciones de combo, `baseOptionIds`, `optionId`, cantidades por unidad y lenguaje de elegibilidad fueron normalizados.

No queda identificado ningún punto de la revisión como deliberadamente no aplicado. Las composiciones nuevas sin PNG individual en v1 se registran arriba como “Nueva composición”; los estados previamente agrupados en `ui-states-alternos.png` se separaron en pantallas independientes.

## Validación

- 30 carpetas de composición.
- 30 HTML y 30 PNG, todos no vacíos; cada carpeta contiene exactamente un archivo de cada tipo.
- Auditoría de texto visible, excluyendo comentarios, `<script>` y `<title>`: no se detectaron `P. Unitario`, tabs globales de revisión, “Agotado”, timeouts/HTTP inventados, `UNRESOLVED_COMMERCIAL_RATE`, stock exacto ni mensajes equivalentes.
- Se inspeccionaron visualmente screenshots representativos de catálogo ACTIVE/INACTIVE/REVIEW_REQUIRED, preorden, configuración preparada, revisión `UP_TO_DATE`, confirmación de guardado y edición de línea.
- La validación realizada es estructural y visual sobre los artefactos generados. No incluye pruebas de integración, interacción real con Sala/Orders/Menu/Inventory ni validación administrativa independiente.

