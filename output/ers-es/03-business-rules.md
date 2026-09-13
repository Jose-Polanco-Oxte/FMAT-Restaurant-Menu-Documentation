[← Índice](./index.md)

# Reglas de negocio

Cada bloque establece una obligación primaria. Los atributos enumerados describen un mismo dato u operación; no son pasos independientes. Las verificaciones son criterios propuestos, no pruebas de software ejecutadas. Los términos del modelo identifican conceptos del dominio, no tecnologías exigidas.

---

Las obligaciones de Orders/comandas se identifican como responsabilidades externas a Menu.
---

<a id="br-menu-001"></a>
### BR-MENU-001 — Variante universal

**Requisito:**
El sistema deberá exigir al menos una variante vendible para cada producto comercial.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 7–8

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar definir un producto sin variante vendible.

**Estado:** Confirmado

---

<a id="br-menu-002"></a>
### BR-MENU-002 — Un valor por dimensión

**Requisito:**
El sistema deberá impedir que una variante seleccione más de un valor de la misma dimensión.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 21

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar seleccionar dos tamaños en una variante.

**Estado:** Confirmado

---

<a id="br-menu-003"></a>
### BR-MENU-003 — Pertenencia de los valores de variante

**Requisito:**
El sistema deberá permitir asociar valores de dimensiones a una variante solo cuando pertenezcan a dimensiones del mismo producto.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 21

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar asociar un valor de otro producto.

**Estado:** Confirmado

---

<a id="br-menu-004"></a>
### BR-MENU-004 — Combinación única

**Requisito:**
El sistema deberá impedir que dos variantes del mismo producto tengan el mismo conjunto de valores de dimensiones.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 21

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar registrar dos veces la misma combinación, incluidos valores reordenados.

**Estado:** Confirmado

---

<a id="br-menu-005"></a>
### BR-MENU-005 — Homogeneidad de suministro

**Requisito:**
El sistema deberá exigir que la clasificación de suministro de cada variante coincida con la de su producto.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 6–9

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar asignar suministro almacenado a una variante de producto preparado.

**Estado:** Confirmado

---

<a id="br-menu-006"></a>
### BR-MENU-006 — Prohibición de combos anidados

**Requisito:**
El sistema deberá permitir que una opción de combo haga referencia únicamente a una variante de producto almacenado o preparado.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 11

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar configurar una variante de combo como opción componente.

**Estado:** Confirmado

---

<a id="br-menu-007"></a>
### BR-MENU-007 — Alcance de personalización del combo

**Requisito:**
El sistema deberá impedir que una personalización del combo modifique los ingredientes de sus productos componentes.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 14–15

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar aplicar una omisión del paquete a un ingrediente de un producto hijo.

**Estado:** Confirmado

---

<a id="br-menu-008"></a>
### BR-MENU-008 — Subtotal unitario resuelto

**Requisito:**
El servicio Menu deberá calcular el subtotal de una unidad de variante vendible como su precio base fijo más las contribuciones agregadas de modificadores seleccionados.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Combo 200 con extras por unidad de 5 y 10 resuelve 215; cambiar solo opciones incluidas mantiene 200.

**Estado:** Confirmado

---

<a id="br-menu-009"></a>
### BR-MENU-009 — Aplicabilidad de modificador habilitado

**Requisito:**
El servicio Orders deberá permitir seleccionar un modificador solo si existe una configuración habilitada para la variante seleccionada.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Comparar configuraciones ausentes, deshabilitadas y habilitadas; siguen aplicando límites de cantidad.

**Estado:** Confirmado

---

---

<a id="br-menu-010"></a>
### BR-MENU-010 — Límite de multiplicidad

**Requisito:**
El sistema de comandas deberá impedir seleccionar una cantidad de modificador superior al máximo configurado para la variante seleccionada.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 47–48

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Seleccionar el máximo configurado y después una cantidad superior.

**Estado:** Confirmado

---

<a id="br-menu-011"></a>
### BR-MENU-011 — Conteo de selecciones

**Requisito:**
El servicio Orders deberá aceptar la selección de un grupo de modificadores solo si minSelections <= suma de cantidades seleccionadas <= maxSelections.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Mínimo 2: una opción dos veces cumple si su máximo es 2; cantidades 1 y 3 fallan con límites 2..2.

**Estado:** Confirmado

---

---

<a id="br-menu-012"></a>
### BR-MENU-012 — Capacidad configurada del grupo

**Requisito:**
El servicio Menu deberá considerar vendible un grupo para una variante solo cuando la suma de maxQuantity de sus configuraciones habilitadas sea al menos minSelections.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Una opción habilitada de máximo 2 satisface mínimo 2; deshabilitarla elimina su aportación.

**Estado:** Confirmado

---

---

<a id="br-menu-013"></a>
### BR-MENU-013 — Medida de adición

**Requisito:**
El servicio Menu deberá exigir una cantidad de ingrediente y una unidad de medida al definir un efecto de adición.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 14, 34, 42–43

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar una adición sin cantidad y después sin unidad. Los rangos numéricos están en OPEN-010.

**Estado:** Confirmado

---

<a id="br-menu-014"></a>
### BR-MENU-014 — Propiedad exclusiva de modificadores

**Requisito:**
El servicio Menu deberá impedir que una definición de personalización perteneciente a un producto se comparta con otro producto.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 12–13, 32–33

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar reutilizar la identidad de un grupo u opción en otro producto; las copias independientes son definiciones distintas.

**Estado:** Confirmado

---

<a id="br-menu-015"></a>
### BR-MENU-015 — Habilitación comercial de venta

**Requisito:**
El sistema de comandas deberá permitir vender un producto solo cuando su estado administrativo sea activo.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 18–19

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar una venta nueva de un producto inactivo. No se especifica el tiempo de propagación.

**Estado:** Confirmado

---

<a id="br-menu-016"></a>
### BR-MENU-016 — Precio fijo de combo

**Requisito:**
El servicio Menu deberá excluir precios individuales y elecciones de opciones incluidas de los cambios al precio base configurado del combo.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Comparar selecciones y precios componentes actualizados con la misma base configurada.

**Estado:** Confirmado

---

<a id="br-menu-017"></a>
### BR-MENU-017 — Multiplicidad de modificadores

**Requisito:**
El servicio Menu deberá calcular cada contribución de modificador como cantidad seleccionada por ajuste configurado fijado para su unidad personalizada individual.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Dos unidades, queso de 5 en una: extras 5, no 10; ambas: 10.

**Estado:** Confirmado

---

<a id="br-menu-018"></a>
### BR-MENU-018 — Multiplicidad de adición de ingredientes

**Requisito:**
El sistema deberá calcular la cantidad añadida por un modificador seleccionado como su cantidad seleccionada multiplicada por la cantidad de adición de ingrediente configurada para la variante seleccionada.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 15–16, 42–43

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Comparar la cantidad de ingrediente añadida para una y dos selecciones del mismo modificador.

**Estado:** Confirmado

---

<a id="br-menu-019"></a>
### BR-MENU-019 — Omisión sin cantidad

**Requisito:**
El servicio Menu deberá representar una omisión de ingrediente sin ajuste cuantitativo de ingrediente.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 33–34, 46

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Inspeccionar una omisión y verificar que sea una directiva de exclusión y no una resta de gramos.

**Estado:** Confirmado

---

<a id="br-menu-020"></a>
### BR-MENU-020 — Pertenencia al espacio del combo

**Requisito:**
El sistema de comandas deberá aceptar una variante componente seleccionada para un espacio de combo solo cuando esté configurada como opción de ese espacio para la variante de combo seleccionada.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 29

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Probar una opción configurada y otra configurada solo para otro tamaño o espacio.

**Estado:** Confirmado

---

<a id="br-menu-021"></a>
### BR-MENU-021 — Límites de grupo comunes

**Requisito:**
El servicio Menu deberá utilizar los mismos límites de selección del grupo en las variantes del producto al que pertenece el grupo.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 47–48

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Inspeccionar un producto con varias variantes y verificar que todas remitan a los mismos límites de grupo.

**Estado:** Confirmado

---

<a id="br-menu-022"></a>
### BR-MENU-022 — Operaciones de ingrediente admitidas

**Requisito:**
El servicio Menu deberá restringir los efectos sobre ingredientes a operaciones de adición y omisión en el alcance vigente.

**Tipo:** Reglas de negocio

**Fuente:** `docs/md/Modelo-Final.md` pp. 33–35

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Intentar configurar un efecto de retiro cuantitativo o asignación de cantidad.

**Estado:** Confirmado

---

<a id="br-menu-023"></a>
### BR-MENU-023 — Elegibilidad de venta

**Requisito:**
El servicio Menu deberá considerar elegible una variante solo si producto y variante están ACTIVE, su configuración es válida y tiene disponibilidad positiva vigente para la revisión actual.

**Tipo:** BR

**Fuente:** [ADR-001](../../docs/md/Decisiones-cierre-invariantes.md#adr-001)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Omitir cada condición por separado.

**Estado:** Confirmado

---

<a id="br-menu-024"></a>
### BR-MENU-024 — Rangos de selección

**Requisito:**
El servicio Menu deberá exigir límites enteros de selección que satisfagan 0 <= minSelections <= maxSelections.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Rechazar límites negativos, fraccionarios e invertidos.

**Estado:** Confirmado

---

<a id="br-menu-025"></a>
### BR-MENU-025 — Rango de cantidad de modificador

**Requisito:**
El servicio Orders deberá exigir cantidades enteras de modificador entre cero y maxQuantity inclusive.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Probar cero, máximo, máximo+1, negativo y fraccionario.

**Estado:** Confirmado

---

<a id="br-menu-026"></a>
### BR-MENU-026 — Conteo de espacio

**Requisito:**
El servicio Orders deberá contar una selección por cada ComboOption elegida, independientemente de su cantidad suministrada.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Una opción que suministra seis unidades cuenta una vez.

**Estado:** Confirmado

---

<a id="br-menu-027"></a>
### BR-MENU-027 — Repetición en espacio

**Requisito:**
El servicio Orders deberá impedir elegir la misma ComboOption más de una vez por unidad de combo.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Rechazar identidad repetida; dos opciones configuradas pueden referir la misma variante.

**Estado:** Confirmado

---

<a id="br-menu-028"></a>
### BR-MENU-028 — Límites de espacio

**Requisito:**
El servicio Orders deberá aceptar un espacio solo cuando su número de opciones seleccionadas esté entre minSelections y maxSelections inclusive.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Probar debajo, en y sobre los límites.

**Estado:** Confirmado

---

<a id="br-menu-029"></a>
### BR-MENU-029 — Capacidad de espacio

**Requisito:**
El servicio Menu deberá considerar vendible un espacio solo si su número de opciones habilitadas con componente ACTIVE cubre minSelections.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Opciones deshabilitadas y componentes archivados aportan capacidad cero.

**Estado:** Confirmado

---

<a id="br-menu-030"></a>
### BR-MENU-030 — Validación de activación

**Requisito:**
El servicio Menu deberá rechazar activar un producto si no queda al menos una variante ACTIVE o alguna variante que quedará ACTIVE tiene un grupo o espacio no vendible.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Probar conjunto activo vacío y variante con grupo o espacio insuficiente.

**Estado:** Confirmado

---

<a id="br-menu-031"></a>
### BR-MENU-031 — Elegibilidad de opciones retiradas

**Requisito:**
El servicio Menu deberá excluir opciones de componentes inactivos o archivados de nuevas selecciones permitiendo elegibilidad de combos con otras selecciones válidas.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Retirar pollo: res sigue elegible; sin alternativas en slot obligatorio el combo no está disponible.

**Estado:** Confirmado

---

<a id="br-menu-032"></a>
### BR-MENU-032 — Archivado irreversible

**Requisito:**
El servicio Menu deberá impedir reactivar una variante ARCHIVED en esta versión.

**Tipo:** BR

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Intentar pasar de ARCHIVED a ACTIVE o INACTIVE.

**Estado:** Confirmado

---

<a id="br-menu-033"></a>
### BR-MENU-033 — Cantidad suministrada

**Requisito:**
El servicio Menu deberá exigir cantidad suministrada entera y mayor que cero para cada ComboOption.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Rechazar cantidades cero, negativas y fraccionarias.

**Estado:** Confirmado

---

<a id="br-menu-034"></a>
### BR-MENU-034 — Omisión antes de adición

**Requisito:**
El servicio Menu deberá excluir mediante OMIT solo la aportación base del ingrediente antes de sumar los efectos ADD del componente seleccionado.

**Tipo:** BR

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Base 30, OMIT y ADD 10 producen 10; componentes hermanos no cambian.

**Estado:** Confirmado

---

<a id="br-menu-035"></a>
### BR-MENU-035 — Secuencia de revisiones

**Requisito:**
El servicio Menu deberá asignar versiones con formato `<contador>_<fecha ISO8601 con zona>`, empezando en 1 e incrementando en uno por cambio efectivo aceptado dentro de cada identidad de producto o receta.

**Tipo:** BR

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Verificar inicio 1, siguiente 2, zona y contadores independientes.

**Estado:** Confirmado

---

<a id="br-menu-036"></a>
### BR-MENU-036 — Revisión sin cambio

**Requisito:**
El servicio Menu deberá conservar la versión cuando se reintente el mismo cambio o se guarde una definición idéntica.

**Tipo:** BR

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Repetir un cambio y un guardado idéntico; no se crea otra revisión.

**Estado:** Confirmado

---

<a id="br-menu-037"></a>
### BR-MENU-037 — Adopción explícita de receta

**Requisito:**
El servicio Menu deberá conservar la referencia de revisión de receta de una variante hasta que una edición explícita del producto adopte otra revisión.

**Tipo:** BR

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Publicar receta v2 con producto fijado a v1; permanece v1 hasta editar el producto.

**Estado:** Confirmado

---

<a id="br-menu-038"></a>
### BR-MENU-038 — Identidad histórica predeterminada

**Requisito:**
El servicio Menu deberá conservar la identidad histórica de DEFAULT al crear nuevas identidades para las variantes con dimensiones que la sustituyan.

**Tipo:** BR

**Fuente:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Verificar que órdenes existentes sigan identificando DEFAULT tras migrar.

**Estado:** Confirmado

---

<a id="br-menu-039"></a>
### BR-MENU-039 — Capacidad cero de modificador

**Requisito:**
El servicio Menu deberá admitir maxQuantity entero mayor o igual que cero en una configuración de modificador.

**Tipo:** BR

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Cero no aporta capacidad ni permite selección; negativos y fraccionarios fallan.

**Estado:** Confirmado

---

<a id="br-menu-040"></a>
### BR-MENU-040 — Identidad dimensional de venta

**Requisito:**
El servicio Menu deberá excluir variantes sin combinación de dimensiones de nuevas ventas cuando el producto tenga dimensiones seleccionables.

**Tipo:** BR

**Fuente:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Al introducir dimensiones, DEFAULT no puede seguir ofertada como tamaño indefinido.

**Estado:** Confirmado

---

<a id="br-menu-041"></a>
### BR-MENU-041 — Validación monetaria

**Requisito:**
El servicio Menu deberá rechazar precios o ajustes negativos, monedas incompatibles con el restaurante e importes que excedan la precisión de su moneda.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Aceptar cero; rechazar precisión excedente, incluidos ceros sobrantes, sin redondear. Inspeccionar el contrato monetario externo aprobado en ALIGN: moneda elegida al alta, minorUnit derivado de ISO 4217, revisión aceptada conservada y compartida con Orders, sin consulta externa por venta ni sustitución ordinaria de moneda. Sin configuración aceptada se bloquean escrituras monetarias y resolución; una caída del proveedor no invalida la configuración aceptada.

**Estado:** Confirmado

---

<a id="br-menu-042"></a>
### BR-MENU-042 — Positividad física

**Requisito:**
El servicio Menu deberá rechazar cantidades físicas no positivas en suministro STOCKED, recetas y adiciones de ingredientes.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Omisión usa OMIT; neto cero se omite; rechazar cantidades de entrada negativas/cero.

**Estado:** Confirmado

---

<a id="br-menu-043"></a>
### BR-MENU-043 — Tipo de suministro inmutable

**Requisito:**
El servicio Menu deberá rechazar cambiar el tipo de suministro de un MenuItem existente.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Intentar STOCKED a PREPARED aun antes de activar; requiere nueva identidad.

**Estado:** Confirmado

---

<a id="br-menu-044"></a>
### BR-MENU-044 — Nombres como etiquetas

**Requisito:**
El servicio Menu deberá permitir nombres visibles repetidos para entidades con identidades válidas distintas.

**Tipo:** BR

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Etiquetas repetidas aceptadas; combinaciones dimensionales repetidas rechazadas.

**Estado:** Confirmado
