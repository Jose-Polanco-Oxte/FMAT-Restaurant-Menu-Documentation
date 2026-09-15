# Mockups de FMAT Restaurant — Versión 1.2 (Línea Base Corregida)

**Fecha de entrega:** 2026-09-14  
**Resolución objetivo estandarizada:** 1024 × 768 px (Tablet horizontal POS)  
**Entorno de generación:** Generación directa HTML5 + CSS3 + Tailwind tokens (.stitch/DESIGN.md) y renderizado headless en Google Chrome a resolución fija 1024 × 768 px (**sin Stitch**).  
**Directorio canónico de entrega:** `output/mockup/1.2/`

---

## 1. Fuentes Normativas y Orden de Prevalencia

1. `output/ui-spec/ui-data-spec.md` (Revisión 2) — Autoridad rectora de requisitos funcionales, estructura de datos, estados de tarjeta y flujos de preorden.
2. `output/mockup/reviews/1.1/revision.md` — Dictamen de auditoría y catálogo vinculante de correcciones estructurales, de flujo y de contenido aplicadas sobre la versión 1.1.
3. `.stitch/DESIGN.md` — Sistema visual monocromático estricto (escala de grises, ausencia de colores cromáticos, tipografía Inter, esquinas moderadas de 8–12px, sin controles píldora).
4. `output/mockup/1.1/` — Referencia histórica y continuidad de nomenclaturas.

---

## 2. Correcciones Principales Aplicadas (v1.1 → v1.2)

1. **Resolución y Viewport Estandarizados a 1024 × 768 px (FAIL → PASS)**:
   - Todas las 30 composiciones fueron construidas bajo un contenedor rígido `1024px` × `768px` con `overflow: hidden` y márgenes seguros de 24px.
   - El 100% de los archivos PNG resultantes tienen dimensiones exactas de **1024 × 768 px** (verificados por script automatizado).
2. **Flujo de Mesas y Órdenes (`V-MES-02` y `V-MES-03`)**:
   - **`V-MES-02-orden-actual`**: Solo muestra líneas confirmadas bloqueadas y subtotal de preorden. Se retiraron por completo los borradores locales, "Editar selección", "Eliminar línea" y "Enviar a la orden". La única acción de continuación es **"Agregar productos"**.
   - **`V-MES-03-append-order-catalogo`**: La acción de agregar en tarjetas y panel se estandarizó en **"Añadir a la orden"**. El panel lateral recibe y muestra las líneas confirmadas como bloqueadas, permitiendo editar únicamente las nuevas selecciones.
3. **Erradicación de Lenguaje de Infraestructura y Diagnóstico**:
   - Se eliminaron de la superficie operativa de las 30 pantallas todos los volcados técnicos y de protocolo: `STATUS 200`, `HTTP 412`, `PRECONDITION FAILED`, `RFC-7232`, `DraftOrderLine[]`, `requestId`, `syncStatus`, `E-16`, `E-09`, `If-Match`, `LOCAL_STAGED`, `slotId`, `componentRef`, `uId`, `MENU_RESOLUTION_REJECTED`, etc.
   - Fueron reemplazados por mensajes claros de negocio en español orientados a la toma de decisiones del mesero y administrador.
4. **Unificación Estructural de V-ADM-01 (Gestión de Catálogo)**:
   - Las cuatro variantes (`active`, `inactive`, `archived`, `review-required`) comparten la **misma shell tabular, filtros, columnas y botones**.
   - La variante archivada es una pestaña de retiro suave con acciones individuales y masivas dentro de la misma tabla, eliminando la consola disonante de auditoría ("CAT-AUDIT").
   - La variante de revisión requerida es un filtro sobre los combos pendientes que enlaza a `V-ADM-03`.
5. **Consistencia de Steppers y Resolución de Estados Contradictorios (V-ADM-02)**:
   - Stepper estandarizado: 4 pasos para `CREATE` y 3 pasos para `EDIT`.
   - `V-ADM-02-create-summary-acceptance`: Se eliminó la contradicción entre estados proponiendo un único resultado claro: **Guardar como Inactivo** (cumpliendo la política de homologación de inventario previa a la venta).
   - `V-ADM-02-edit-conflicto-revision`: Se transformó en un aviso claro de concurrencia con opciones de negocio (cargar versión del servidor o comparar), sin volcado de protocolos HTTP.
6. **Revisión de Combos (V-ADM-03)**:
   - Se eliminó la exposición de tokens opacos y hashes, mostrando claramente los cambios en componentes (precios de bebidas y versiones de recetas) y la confirmación posterior que lleva al estado **Al día**.
7. **Confirmación de Guardado Focalizada (V-ADM-04)**:
   - Se reemplazó el selector demostrativo de múltiples estados por una pantalla de confirmación única, elegante y concreta para un producto registrado exitosamente.
8. **Diseño Visual Monocromático Estricto**:
   - Cumplimiento estricto de `.stitch/DESIGN.md`: solo blancos (`#FFFFFF`), grises neutros (`#F7F7F7`, `#FAFAFA`, `#EDEDED`, `#BDBDBD`, `#D9D9D9`) y tinta oscura (`#111111` / `#1A1A1A`). Sin colores cromáticos (cero rojo, verde, azul, naranja o amarillo).

---

## 3. Matriz de Entregables v1.2 (30 Pantallas)

| ID de Vista | Nombre de la Composición | Referencia v1.1 | Estado v1.2 | HTML | PNG (1024×768) |
|---|---|---|---|---|---|
| `V-MES-01` | `V-MES-01-mesas-asignadas` | `V-MES-01-mesas-asignadas` | CORREGIDO | [HTML](./V-MES-01-mesas-asignadas/V-MES-01-mesas-asignadas.html) | [PNG](./V-MES-01-mesas-asignadas/V-MES-01-mesas-asignadas.png) |
| `V-MES-01` | `V-MES-01-estado-vacio` | `V-MES-01-estado-vacio` | CORREGIDO | [HTML](./V-MES-01-estado-vacio/V-MES-01-estado-vacio.html) | [PNG](./V-MES-01-estado-vacio/V-MES-01-estado-vacio.png) |
| `V-MES-01` | `V-MES-01-error-sala` | `V-MES-01-error-sala` | CORREGIDO | [HTML](./V-MES-01-error-sala/V-MES-01-error-sala.html) | [PNG](./V-MES-01-error-sala/V-MES-01-error-sala.png) |
| `V-MES-02` | `V-MES-02-orden-actual` | `V-MES-02-orden-actual` | CORREGIDO | [HTML](./V-MES-02-orden-actual/V-MES-02-orden-actual.html) | [PNG](./V-MES-02-orden-actual/V-MES-02-orden-actual.png) |
| `V-MES-02` | `V-MES-02-orden-sin-lineas` | `V-MES-02-orden-sin-lineas` | CORREGIDO | [HTML](./V-MES-02-orden-sin-lineas/V-MES-02-orden-sin-lineas.html) | [PNG](./V-MES-02-orden-sin-lineas/V-MES-02-orden-sin-lineas.png) |
| `V-MES-02` | `V-MES-02-error-lectura` | `V-MES-02-error-lectura` | CORREGIDO | [HTML](./V-MES-02-error-lectura/V-MES-02-error-lectura.html) | [PNG](./V-MES-02-error-lectura/V-MES-02-error-lectura.png) |
| `V-MES-03` | `V-MES-03-create-order-catalogo` | `V-MES-03-create-order-catalogo` | CORREGIDO | [HTML](./V-MES-03-create-order-catalogo/V-MES-03-create-order-catalogo.html) | [PNG](./V-MES-03-create-order-catalogo/V-MES-03-create-order-catalogo.png) |
| `V-MES-03` | `V-MES-03-append-order-catalogo` | `V-MES-03-append-order-catalogo` | CORREGIDO | [HTML](./V-MES-03-append-order-catalogo/V-MES-03-append-order-catalogo.html) | [PNG](./V-MES-03-append-order-catalogo/V-MES-03-append-order-catalogo.png) |
| `V-MES-03` | `V-MES-03-estado-catalogo-vacio` | `V-MES-03-estado-catalogo-vacio` | CORREGIDO | [HTML](./V-MES-03-estado-catalogo-vacio/V-MES-03-estado-catalogo-vacio.html) | [PNG](./V-MES-03-estado-catalogo-vacio/V-MES-03-estado-catalogo-vacio.png) |
| `V-MES-03` | `V-MES-03-resolving` | `V-MES-03-resolving` | CORREGIDO | [HTML](./V-MES-03-resolving/V-MES-03-resolving.html) | [PNG](./V-MES-03-resolving/V-MES-03-resolving.png) |
| `V-MES-03` | `V-MES-03-seleccion-no-disponible` | `V-MES-03-seleccion-no-disponible` | CORREGIDO | [HTML](./V-MES-03-seleccion-no-disponible/V-MES-03-seleccion-no-disponible.html) | [PNG](./V-MES-03-seleccion-no-disponible/V-MES-03-seleccion-no-disponible.png) |
| `O-MES-01` | `O-MES-01-configuracion-item-simple` | `O-MES-01-configuracion-item-simple` | CORREGIDO | [HTML](./O-MES-01-configuracion-item-simple/O-MES-01-configuracion-item-simple.html) | [PNG](./O-MES-01-configuracion-item-simple/O-MES-01-configuracion-item-simple.png) |
| `O-MES-01` | `O-MES-01-configuracion-item-prepared` | `O-MES-01-configuracion-item-prepared` | CORREGIDO | [HTML](./O-MES-01-configuracion-item-prepared/O-MES-01-configuracion-item-prepared.html) | [PNG](./O-MES-01-configuracion-item-prepared/O-MES-01-configuracion-item-prepared.png) |
| `O-MES-01` | `O-MES-01-configuracion-item-combo` | `O-MES-01-configuracion-item-combo` | CORREGIDO | [HTML](./O-MES-01-configuracion-item-combo/O-MES-01-configuracion-item-combo.html) | [PNG](./O-MES-01-configuracion-item-combo/O-MES-01-configuracion-item-combo.png) |
| `O-MES-01` | `O-MES-01-edicion-linea` | `O-MES-01-edicion-linea` | CORREGIDO | [HTML](./O-MES-01-edicion-linea/O-MES-01-edicion-linea.html) | [PNG](./O-MES-01-edicion-linea/O-MES-01-edicion-linea.png) |
| `V-ADM-01` | `V-ADM-01-gestion-catalogo-active` | `V-ADM-01-gestion-catalogo-active` | CORREGIDO | [HTML](./V-ADM-01-gestion-catalogo-active/V-ADM-01-gestion-catalogo-active.html) | [PNG](./V-ADM-01-gestion-catalogo-active/V-ADM-01-gestion-catalogo-active.png) |
| `V-ADM-01` | `V-ADM-01-gestion-catalogo-inactive` | `V-ADM-01-gestion-catalogo-inactive` | CORREGIDO | [HTML](./V-ADM-01-gestion-catalogo-inactive/V-ADM-01-gestion-catalogo-inactive.html) | [PNG](./V-ADM-01-gestion-catalogo-inactive/V-ADM-01-gestion-catalogo-inactive.png) |
| `V-ADM-01` | `V-ADM-01-gestion-catalogo-archived` | `V-ADM-01-gestion-catalogo-archived` | CORREGIDO | [HTML](./V-ADM-01-gestion-catalogo-archived/V-ADM-01-gestion-catalogo-archived.html) | [PNG](./V-ADM-01-gestion-catalogo-archived/V-ADM-01-gestion-catalogo-archived.png) |
| `V-ADM-01` | `V-ADM-01-gestion-catalogo-review-required` | `V-ADM-01-gestion-catalogo-review-required` | CORREGIDO | [HTML](./V-ADM-01-gestion-catalogo-review-required/V-ADM-01-gestion-catalogo-review-required.html) | [PNG](./V-ADM-01-gestion-catalogo-review-required/V-ADM-01-gestion-catalogo-review-required.png) |
| `V-ADM-02` | `V-ADM-02-create-step1-classification` | `V-ADM-02-create-step1-classification` | CORREGIDO | [HTML](./V-ADM-02-create-step1-classification/V-ADM-02-create-step1-classification.html) | [PNG](./V-ADM-02-create-step1-classification/V-ADM-02-create-step1-classification.png) |
| `V-ADM-02` | `V-ADM-02-create-stocked-editor` | `V-ADM-02-create-stocked-editor` | CORREGIDO | [HTML](./V-ADM-02-create-stocked-editor/V-ADM-02-create-stocked-editor.html) | [PNG](./V-ADM-02-create-stocked-editor/V-ADM-02-create-stocked-editor.png) |
| `V-ADM-02` | `V-ADM-02-create-prepared-recipe` | `V-ADM-02-create-prepared-recipe` | CORREGIDO | [HTML](./V-ADM-02-create-prepared-recipe/V-ADM-02-create-prepared-recipe.html) | [PNG](./V-ADM-02-create-prepared-recipe/V-ADM-02-create-prepared-recipe.png) |
| `V-ADM-02` | `V-ADM-02-create-combo-editor` | `V-ADM-02-create-combo-editor` | CORREGIDO | [HTML](./V-ADM-02-create-combo-editor/V-ADM-02-create-combo-editor.html) | [PNG](./V-ADM-02-create-combo-editor/V-ADM-02-create-combo-editor.png) |
| `V-ADM-02` | `V-ADM-02-create-modificadores` | `V-ADM-02-create-modificadores` | CORREGIDO | [HTML](./V-ADM-02-create-modificadores/V-ADM-02-create-modificadores.html) | [PNG](./V-ADM-02-create-modificadores/V-ADM-02-create-modificadores.png) |
| `V-ADM-02` | `V-ADM-02-create-summary-acceptance` | `V-ADM-02-create-summary-acceptance` | CORREGIDO | [HTML](./V-ADM-02-create-summary-acceptance/V-ADM-02-create-summary-acceptance.html) | [PNG](./V-ADM-02-create-summary-acceptance/V-ADM-02-create-summary-acceptance.png) |
| `V-ADM-02` | `V-ADM-02-edit-modificadores` | `V-ADM-02-edit-modificadores` | CORREGIDO | [HTML](./V-ADM-02-edit-modificadores/V-ADM-02-edit-modificadores.html) | [PNG](./V-ADM-02-edit-modificadores/V-ADM-02-edit-modificadores.png) |
| `V-ADM-02` | `V-ADM-02-edit-conflicto-revision` | `V-ADM-02-edit-conflicto-revision` | CORREGIDO | [HTML](./V-ADM-02-edit-conflicto-revision/V-ADM-02-edit-conflicto-revision.html) | [PNG](./V-ADM-02-edit-conflicto-revision/V-ADM-02-edit-conflicto-revision.png) |
| `V-ADM-03` | `V-ADM-03-revision-combo-pendiente` | `V-ADM-03-revision-combo-pendiente` | CORREGIDO | [HTML](./V-ADM-03-revision-combo-pendiente/V-ADM-03-revision-combo-pendiente.html) | [PNG](./V-ADM-03-revision-combo-pendiente/V-ADM-03-revision-combo-pendiente.png) |
| `V-ADM-03` | `V-ADM-03-revision-combo-up-to-date` | `V-ADM-03-revision-combo-up-to-date` | CORREGIDO | [HTML](./V-ADM-03-revision-combo-up-to-date/V-ADM-03-revision-combo-up-to-date.html) | [PNG](./V-ADM-03-revision-combo-up-to-date/V-ADM-03-revision-combo-up-to-date.png) |
| `V-ADM-04` | `V-ADM-04-confirmacion-guardado` | `V-ADM-04-confirmacion-guardado` | CORREGIDO | [HTML](./V-ADM-04-confirmacion-guardado/V-ADM-04-confirmacion-guardado.html) | [PNG](./V-ADM-04-confirmacion-guardado/V-ADM-04-confirmacion-guardado.png) |

---

## 4. Resultado de Auditoría Automatizada

- **Total de vistas procesadas:** 30 de 30.
- **Validación de dimensiones PNG:** 30 de 30 imágenes miden exactamente **1024 × 768 píxeles**.
- **Validación léxica de código:** 0 tokens técnicos no autorizados detectados.
- **Validación de consistencia de familia:** Todas las variantes de `V-MES-01`, `V-MES-02`, `V-MES-03`, `O-MES-01`, `V-ADM-01`, `V-ADM-02` y `V-ADM-03` parten de shells compartidas con idéntica geometría y layout.
