[← Índice](./index.md)

# Requisitos funcionales

Cada bloque establece una obligación primaria. Los atributos enumerados describen un mismo dato u operación; no son pasos independientes. Las verificaciones son criterios propuestos, no pruebas de software ejecutadas. Los términos del modelo identifican conceptos del dominio, no tecnologías exigidas.

---

<a id="req-menu-001"></a>
### REQ-MENU-001 — Definición del producto comercial

**Requisito:**
El servicio Menu deberá registrar un producto comercial con su nombre, descripción, referencia de imagen, categoría, menú al que pertenece y clasificación de suministro (almacenado, preparado o combo).

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 36–37

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Registrar un producto y comparar la información registrada con la definición proporcionada.

**Estado:** Confirmado

---

<a id="req-menu-002"></a>
### REQ-MENU-002 — Estado administrativo

**Requisito:**
El servicio Menu deberá permitir cambiar el estado comercial de un producto entre activo e inactivo.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 18–19

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Ejecutar ambas transiciones e inspeccionar el estado resultante.

**Estado:** Confirmado

---

<a id="req-menu-003"></a>
### REQ-MENU-003 — Presentación vendible predeterminada

**Requisito:**
El servicio Menu deberá proporcionar una presentación vendible predeterminada para un producto sin dimensiones de variante seleccionables por el cliente.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 7–8

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Definir un producto sin dimensiones y comprobar que dispone de una presentación vendible sin exigir al cliente una elección de variante.

**Estado:** Confirmado

---

<a id="req-menu-004"></a>
### REQ-MENU-004 — Definición de dimensiones

**Requisito:**
El servicio Menu deberá permitir definir una dimensión de variación con nombre para un producto comercial.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 21, 36–37

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Definir una dimensión y verificar su nombre y producto asociado.

**Estado:** Confirmado

**Relacionado:** REQ-MENU-024

---

<a id="req-menu-005"></a>
### REQ-MENU-005 — Definición de variantes vendibles

**Requisito:**
El servicio Menu deberá permitir definir una variante vendible mediante su combinación de valores de dimensiones de un producto, sujeta a BR-MENU-002 a BR-MENU-004.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 21

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Registrar una combinación válida e intentar las combinaciones contradictorias, de otro producto y duplicadas que prohíben las reglas referidas.

**Estado:** Confirmado

---

<a id="req-menu-006"></a>
### REQ-MENU-006 — Precio absoluto de la variante

**Requisito:**
El servicio Menu deberá permitir asignar un precio de venta absoluto a cada variante vendible.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 26–28

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Asignar precios distintos a dos variantes y comprobar cada precio de forma independiente.

**Estado:** Confirmado

---

<a id="req-menu-007"></a>
### REQ-MENU-007 — Precio mínimo elegible

**Requisito:**
El servicio Menu deberá mostrar como precio desde el mínimo de los precios de variantes elegibles para una venta nueva según BR-MENU-023.

**Tipo:** REQ

**Fuente:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Comparar variantes activas disponibles, inactivas, archivadas y agotadas; solo las elegibles participan en el mínimo.

**Estado:** Confirmado

---

---

<a id="req-menu-008"></a>
### REQ-MENU-008 — Configuración de suministro almacenado

**Requisito:**
El servicio Menu deberá permitir especificar el artículo de inventario y la cantidad de retiro que suministran una variante vendible almacenada.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 8–9, 37

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Configurar referencias y cantidades distintas para dos presentaciones y verificar su recuperación independiente.

**Estado:** Confirmado

---

<a id="req-menu-009"></a>
### REQ-MENU-009 — Configuración de suministro preparado

**Requisito:**
El servicio Menu deberá permitir seleccionar la receta utilizada para elaborar una variante vendible de un producto preparado.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 8–9, 35–37

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Asignar recetas a dos tamaños y verificar la receta de cada uno. No se exige una receta distinta si ambos utilizan la misma fórmula.

**Estado:** Confirmado

---

<a id="req-menu-010"></a>
### REQ-MENU-010 — Configuración de combo

**Requisito:**
El servicio Menu deberá permitir definir los espacios de selección de cada variante vendible de combo.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 9–10, 37

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Definir espacios distintos para dos variantes de combo y verificar cada configuración.

**Estado:** Confirmado

---

<a id="req-menu-011"></a>
### REQ-MENU-011 — Definición del espacio de selección

**Requisito:**
El servicio Menu deberá permitir configurar un espacio de selección de combo con un nombre y límites mínimo y máximo de selecciones.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 10

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Configurar un espacio con nombre y comparar los límites registrados con los proporcionados.

**Estado:** Confirmado

---

<a id="req-menu-012"></a>
### REQ-MENU-012 — Definición de opciones de combo

**Requisito:**
El servicio Menu deberá permitir configurar una opción de un espacio con una variante vendible concreta STOCKED o PREPARED y cantidad suministrada, sin ajuste de precio por opción.

**Tipo:** Requisitos funcionales

**Fuente:** [ALIGN-002](../../docs/reviews/ers-interfaces-alignment/decisions.md); sustituye `docs/md/Modelo-Final.md` pp. 10, 31–32 respecto al precio de opción.

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Configurar cantidades suministradas distintas en dos slots; las elecciones incluidas nunca cambian el precio base fijo del combo.

**Estado:** Confirmado

---

<a id="req-menu-013"></a>
### REQ-MENU-013 — Definición de grupos de personalización

**Requisito:**
El servicio Menu deberá permitir definir un grupo de personalización con nombre para un producto y límites mínimo y máximo de selecciones.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 12–13, 48

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Definir un grupo y verificar su producto, nombre y límites de selección.

**Estado:** Confirmado

---

<a id="req-menu-014"></a>
### REQ-MENU-014 — Definición de opciones de personalización

**Requisito:**
El servicio Menu deberá permitir definir una opción de personalización con nombre dentro de un grupo de personalización de un producto.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 42–44

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Definir una opción y verificar su nombre y grupo.

**Estado:** Confirmado

---

<a id="req-menu-015"></a>
### REQ-MENU-015 — Precio de personalización por variante

**Requisito:**
El servicio Menu deberá permitir configurar el ajuste relativo de precio de una opción de personalización para una variante vendible específica.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 42–47

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Configurar ajustes distintos para una misma opción en dos tamaños y verificar cada valor.

**Estado:** Confirmado

**Relacionado:** REQ-MENU-025

---

<a id="req-menu-016"></a>
### REQ-MENU-016 — Copia de configuraciones de personalización

**Requisito:**
El servicio Menu deberá permitir copiar configuraciones de personalización seleccionadas, incluidos sus ajustes de precio, límites de cantidad y efectos sobre ingredientes, de una variante origen a una variante destino.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 45–46

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Copiar una configuración seleccionada y comparar los tres grupos de parámetros del destino con el origen. E-17 define FAIL/REPLACE para destinos existentes.

**Estado:** Confirmado

**Relacionado:** REQ-MENU-026

**Contrato activo:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-017"></a>
### REQ-MENU-017 — Directiva de adición de ingrediente

**Requisito:**
El servicio Menu deberá permitir configurar una adición de ingrediente para una personalización de una variante específica, identificando el artículo de inventario, la cantidad añadida y la unidad de medida.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 34, 42–43

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Configurar adiciones de cantidades distintas para la misma opción en dos variantes y verificar cada efecto.

**Estado:** Confirmado

---

<a id="req-menu-018"></a>
### REQ-MENU-018 — Directiva de omisión de ingrediente

**Requisito:**
El servicio Menu deberá permitir configurar una omisión de ingrediente para una personalización de una variante específica mediante la identificación del artículo de inventario que se omitirá en la preparación.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 33–34, 46

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Configurar una omisión y verificar el ingrediente identificado y la directiva de omisión.

**Estado:** Confirmado

---

<a id="req-menu-019"></a>
### REQ-MENU-019 — Personalización de preparación sin efectos sobre ingredientes

**Requisito:**
El servicio Menu deberá permitir definir una personalización de preparación para una variante sin efectos asociados sobre ingredientes.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Problema-Inicial.md` pp. 108–110; `docs/md/Modelo-Final.md` pp. 42

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Definir una instrucción de cocción sin efectos sobre ingredientes y verificar que la configuración se acepta.

**Estado:** Confirmado

---

<a id="req-menu-020"></a>
### REQ-MENU-020 — Definición de recetas

**Requisito:**
El servicio Menu deberá permitir definir una receta culinaria con nombre, versión y composición de ingredientes que especifique cada artículo de inventario, cantidad requerida y unidad de medida.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 20–23, 37–38

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Definir una receta con varios componentes y comparar su composición registrada con la definición proporcionada.

**Estado:** Confirmado

---

<a id="req-menu-021"></a>
### REQ-MENU-021 — Revisiones de receta

**Requisito:**
El servicio Menu deberá crear una revisión inmutable nueva de una receta cuando se acepte un cambio de su nombre o composición.

**Tipo:** REQ

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Cambiar composición y nombre por separado y verificar revisiones nuevas sin alterar las anteriores.

**Estado:** Confirmado

---

---

<a id="req-menu-022"></a>
### REQ-MENU-022 — Publicación de catálogo

**Requisito:**
El servicio Menu deberá exponer definiciones de catálogo e invalidar vistas consumidoras ante cambios efectivos comerciales o de disponibilidad.

**Tipo:** REQ

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar E-01–E-03 y M-07/M-08; stock no crea revisión comercial.

**Estado:** Confirmado

---

<a id="req-menu-023"></a>
### REQ-MENU-023 — Clasificación de continuidad ante retiro

**Requisito:**
La obligación de continuidad se consolida en QA-MENU-002 y su restricción de diseño en CON-MENU-008. Se conserva este identificador para trazabilidad, sin duplicar la obligación.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Auditoria-3.md` pp. 8–9

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Inspección: Consultar QA-MENU-002.

**Estado:** Reclasificado

---

<a id="req-menu-024"></a>
### REQ-MENU-024 — Definición de valores de dimensión

**Requisito:**
El servicio Menu deberá permitir definir valores con nombre dentro de una dimensión de variación de un producto.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 21, 36–37

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Definir dos valores y verificar su asociación con la dimensión seleccionada.

**Estado:** Confirmado

---

<a id="req-menu-025"></a>
### REQ-MENU-025 — Límite de cantidad de personalización por variante

**Requisito:**
El servicio Menu deberá permitir configurar la cantidad máxima seleccionable de una opción de personalización para una variante vendible específica.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 47–48

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Configurar límites distintos para dos tamaños y verificar cada límite independientemente del precio.

**Estado:** Confirmado

---

<a id="req-menu-026"></a>
### REQ-MENU-026 — Copia de configuración de combo

**Requisito:**
El servicio Menu deberá permitir copiar los espacios de selección y sus opciones desde una variante de combo origen a una variante de combo destino.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 30–31

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Prueba: Copiar una configuración de combo y comparar los espacios y definiciones de opciones resultantes con el origen.

**Estado:** Confirmado

**Contrato activo:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-027"></a>
### REQ-MENU-027 — Asignación múltiple de opciones de combo

**Requisito:**
El servicio Menu deberá permitir aplicar un conjunto seleccionado de opciones de componentes a varias variantes de combo seleccionadas en una operación administrativa.

**Tipo:** Requisitos funcionales

**Fuente:** `docs/md/Modelo-Final.md` pp. 31

**Justificación:** Conserva el hecho o comportamiento de la fuente citada dentro de su alcance, sin imponer un mecanismo adicional.

**Verificación:** Demostración: Aplicar un conjunto seleccionado a dos variantes de combo y verificar asociaciones por IDs explícitos de slot según E-17.

**Estado:** Confirmado

**Contrato activo:** [E-17](../interfaces/apis/entrada/E-17.md); [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

---

<a id="req-menu-028"></a>
### REQ-MENU-028 — Archivar variante

**Requisito:**
El servicio Menu deberá permitir retirar una variante mediante su transición a ARCHIVED, sujeta a la validez de las configuraciones activas dependientes.

**Tipo:** REQ

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Archivar una variante con órdenes históricas y verificar conservación y exclusión de ofertas nuevas.

**Estado:** Confirmado

---

<a id="req-menu-029"></a>
### REQ-MENU-029 — Guardar capacidad incompleta

**Requisito:**
El servicio Menu deberá permitir guardar una configuración INACTIVE con capacidad de selección incompleta.

**Tipo:** REQ

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Guardar inactivo un grupo de mínimo 2 sin opciones y verificar persistencia.

**Estado:** Confirmado

---

<a id="req-menu-030"></a>
### REQ-MENU-030 — Informar capacidad incompleta

**Requisito:**
El servicio Menu deberá informar qué grupo o espacio tiene capacidad insuficiente al guardar una configuración incompleta.

**Tipo:** REQ

**Fuente:** [ADR-005](../../docs/md/Decisiones-cierre-invariantes.md#adr-005)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Verificar que la advertencia identifique grupo o espacio, mínimo exigido y capacidad disponible.

**Estado:** Confirmado

---

<a id="req-menu-031"></a>
### REQ-MENU-031 — Sin precio elegible

**Requisito:**
El servicio Menu deberá presentar el producto como no disponible sin precio desde numérico cuando no tenga variantes elegibles.

**Tipo:** REQ

**Fuente:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Hacer inelegibles todas las variantes y verificar ausencia de precio cero sustitutivo o precio archivado.

**Estado:** Confirmado

---

<a id="req-menu-032"></a>
### REQ-MENU-032 — Resolución neta de ingredientes

**Requisito:**
El servicio Menu deberá resolver los insumos netos de una línea seleccionada a partir de las versiones fijadas de producto y recetas y las cantidades de componentes y modificadores.

**Tipo:** REQ

**Fuente:** [ADR-003](../../docs/md/Decisiones-cierre-invariantes.md#adr-003)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Usar ingrediente base 30 g, OMIT base y ADD 10 g dos veces; resultado 20 g limitado al componente.

**Estado:** Confirmado

---

<a id="req-menu-033"></a>
### REQ-MENU-033 — Revisión de producto

**Requisito:**
El servicio Menu deberá crear una revisión inmutable nueva del producto por cada cambio aceptado de su definición comercial o ejecutable.

**Tipo:** REQ

**Fuente:** [ADR-006](../../docs/md/Decisiones-cierre-invariantes.md#adr-006)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Cambiar precio de variante o configuración de modificador; la versión anterior no cambia. La disponibilidad derivada no es una edición de definición.

**Estado:** Confirmado

---

<a id="req-menu-034"></a>
### REQ-MENU-034 — Migración de variante predeterminada

**Requisito:**
El servicio Menu deberá aplicar la sustitución comercial de DEFAULT por variantes con dimensiones como una única revisión de producto.

**Tipo:** REQ

**Fuente:** [ADR-008](../../docs/md/Decisiones-cierre-invariantes.md#adr-008)

**Justificación:** Decisión de cierre adoptada por delegación del usuario; véanse fundamento, límites y alternativas en la decisión citada.

**Verificación:** Intentar migración incompleta y después publicar una válida; no se expone una revisión vendible parcial.

**Estado:** Confirmado

---

<a id="req-menu-035"></a>
### REQ-MENU-035 — Detección de revisión de combo

**Requisito:**
El servicio Menu deberá marcar una variante de combo para revisión cuando una variante componente configurada tenga un cambio relevante de precio, composición, modificadores o estado no atendido.

**Tipo:** REQ

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Incluir opciones deshabilitadas; ignorar cosmética, stock y variantes ajenas; receta solo tras adopción.

**Estado:** Confirmado

---

<a id="req-menu-036"></a>
### REQ-MENU-036 — Visibilidad administrativa de revisión

**Requisito:**
El servicio Menu deberá exponer variantes pendientes y un indicador agregado de revisión por combo en lecturas administrativas.

**Tipo:** REQ

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Inspeccionar E-19/E-20; no combos carecen de estado de revisión.

**Estado:** Confirmado

---

<a id="req-menu-037"></a>
### REQ-MENU-037 — Confirmación de revisión observada

**Requisito:**
El servicio Menu deberá atender únicamente cambios de dependencias identificados por tokens observados enviados para variantes de combo seleccionadas explícitamente.

**Tipo:** REQ

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Confirmar una, varias o todas las mostradas; cambios nuevos concurrentes permanecen pendientes.

**Estado:** Confirmado

---

<a id="req-menu-038"></a>
### REQ-MENU-038 — Conservación de configuración revisada

**Requisito:**
El servicio Menu deberá permitir confirmar revisión sin cambiar precio ni composición fijada del combo.

**Tipo:** REQ

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Confirmar conservando referencia: sin revisión comercial ni reactivación de opción retirada.

**Estado:** Confirmado

---

<a id="req-menu-039"></a>
### REQ-MENU-039 — Referencia visual del slot

**Requisito:**
El servicio Menu deberá exponer sumas de precios componentes guardados y actuales y su diferencia para cada selección base administrativa de slot.

**Tipo:** REQ

**Fuente:** [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md)

**Justificación:** Decisión explícita del usuario en ALIGN; sustituye formulaciones incompatibles anteriores.

**Verificación:** Multiplicar por cantidades suministradas; referencias nunca sobrescriben precio de venta.

**Estado:** Confirmado

---

## Requisitos funcionales confirmados de las UI consumidoras

Los siguientes requisitos formalizan las obligaciones confirmadas de UI solicitadas para las superficies de mesero y administrador. No transfieren a Menu la propiedad de datos externos; sus proyecciones externas faltantes se registran en OPEN-011 a OPEN-019.

<a id="req-ui-001"></a>
### REQ-UI-001 — Conjunto de mesas asignadas

**Requisito:**
La UI de orden deberá mostrar únicamente las mesas incluidas en la proyección autorizada de asignación de mesas para el mesero actual.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-001 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** El mesero recibe de Sala un conjunto limitado de mesas y no debe recibir mesas fuera de su asignación.

**Verificación:** Demostración: cargar una proyección con mesas asignadas y no asignadas y comprobar que solo se muestran las asignadas.

**Estado:** Confirmado

---

<a id="req-ui-002"></a>
### REQ-UI-002 — Distinción de orden en mesa

**Requisito:**
La UI de orden deberá distinguir una mesa con una orden asociada de una mesa sin una orden asociada.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-002 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** La distinción determina si el mesero inicia una orden o agrega productos a una orden existente.

**Verificación:** Demostración: mostrar ambos estados de mesa y comprobar que cada uno tiene una indicación visual distinta.

**Estado:** Confirmado

---

<a id="req-ui-003"></a>
### REQ-UI-003 — Agregado a orden existente

**Requisito:**
La UI de orden deberá permitir preparar productos adicionales para la orden asociada con una mesa que ya tiene una orden.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-003 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** Una mesa con una orden existente debe poder recibir productos nuevos.

**Verificación:** Demostración: abrir una orden existente, crear líneas nuevas de borrador y comprobar que las líneas confirmadas siguen identificables y sin cambios.

**Estado:** Confirmado

---

<a id="req-ui-004"></a>
### REQ-UI-004 — Tipos del catálogo vendible

**Requisito:**
La UI de orden deberá permitir seleccionar items del catálogo con tipo de suministro STOCKED, PREPARED o COMBO.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-004 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** El mesero puede ordenar cada tipo de suministro de Menu soportado desde el mismo catálogo.

**Verificación:** Demostración: mostrar un item elegible de cada tipo de suministro y comprobar que cada uno abre su configuración aplicable.

**Estado:** Confirmado

---

<a id="req-ui-005"></a>
### REQ-UI-005 — Búsqueda y filtros del catálogo

**Requisito:**
Las UI de orden y administrativa deberán proporcionar búsqueda por nombre y filtros por categoría y clasificación comercial.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-005 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** Las vistas de catálogo de mesero y administrador requieren las mismas dimensiones de descubrimiento.

**Verificación:** Demostración: aplicar cada filtro por separado y combinado y comprobar que las tarjetas visibles satisfacen los criterios seleccionados.

**Estado:** Confirmado

---

<a id="req-ui-006"></a>
### REQ-UI-006 — Edición local del borrador de orden

**Requisito:**
La UI de orden deberá permitir cambiar la cantidad, reconfigurar y quitar cada producto seleccionado antes de confirmar la orden.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-006 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** Estas interacciones gestionan la composición local de preorden del mesero y no son operaciones CRUD individuales del backend.

**Verificación:** Demostración: cambiar, reconfigurar y quitar una línea de borrador y comprobar que las líneas confirmadas y el catálogo no se alteran.

**Estado:** Confirmado

---

<a id="req-ui-007"></a>
### REQ-UI-007 — Configuración de item antes de agregar

**Requisito:**
La UI de orden deberá permitir configurar las dimensiones, modificadores, slots y opciones de combo aplicables antes de agregar un item al borrador de orden.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-007 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** La línea seleccionada debe conservar la configuración concreta del cliente antes de incorporarse a la preorden.

**Verificación:** Demostración: configurar un item preparado y un combo, agregarlos al borrador y comprobar que conservan selecciones y cantidades.

**Estado:** Confirmado

---

<a id="req-ui-008"></a>
### REQ-UI-008 — Gestión administrativa del catálogo

**Requisito:**
La UI administrativa deberá proporcionar creación, edición, búsqueda por nombre y filtros por categoría y clasificación comercial del catálogo.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-008 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** El administrador requiere las mismas capacidades de descubrimiento del catálogo que el mesero además de acciones de gestión.

**Verificación:** Demostración: abrir el catálogo administrativo, aplicar los filtros confirmados y abrir las acciones de crear y editar.

**Estado:** Confirmado

---

<a id="req-ui-009"></a>
### REQ-UI-009 — Apartados del ciclo de vida administrativo

**Requisito:**
La UI administrativa deberá presentar como apartados o filtros distinguibles los items activos, inactivos, pendientes de revisión y archivados.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13 y semántica vigente del ciclo de vida de Menu; consolidada como UI-REQ-009 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** Estado administrativo, estado de revisión y archivado son dimensiones distintas de presentación.

**Verificación:** Inspección: comprobar que cada item aparece según la dimensión correcta y que REVIEW_REQUIRED y ARCHIVED no se muestran como un INACTIVE ordinario.

**Estado:** Confirmado

---

<a id="req-ui-010"></a>
### REQ-UI-010 — Retiro suave del apartado archivado

**Requisito:**
La UI administrativa deberá permitir retirar un item archivado, items archivados seleccionados o todos los items archivados dentro del alcance de resultados seleccionado como una operación de retiro suave.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-010 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** Las acciones solicitadas de “eliminar” retiran items del conjunto visible de gestión sin borrado físico de la base de datos.

**Verificación:** Demostración: ejecutar las acciones de un item, items seleccionados y todos los resultados y comprobar que la UI no representa borrado físico ni destrucción de historia.

**Estado:** Confirmado

---

<a id="req-ui-011"></a>
### REQ-UI-011 — Wizard de creación de item

**Requisito:**
La UI administrativa deberá representar la creación de un item en cuatro pasos: clasificación comercial y tipo de suministro, configuración específica del item, configuración de modificadores y resumen de configuración con aceptación.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-011 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** La creación cambia sus controles según la clasificación, el tipo de suministro y la configuración seleccionada.

**Verificación:** Demostración: iniciar la creación de cada tipo de suministro, inspeccionar los cuatro pasos y comprobar el resumen final antes de aceptar.

**Estado:** Confirmado

---

<a id="req-ui-012"></a>
### REQ-UI-012 — Wizard de edición de item

**Requisito:**
La UI administrativa deberá representar la edición de un item en tres pasos: configuración del item, configuración de modificadores y confirmación.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-012 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** Editar un item existente no requiere seleccionar nuevamente el tipo de nuevo item y debe comenzar con datos precargados.

**Verificación:** Demostración: abrir un item existente, comprobar sus datos precargados y verificar que el editor expone exactamente los tres pasos de edición.

**Estado:** Confirmado

---

<a id="req-ui-013"></a>
### REQ-UI-013 — Distinción entre crear y editar

**Requisito:**
La UI administrativa deberá distinguir las acciones de crear y editar mediante su título, acción primaria, estado inicial y presencia de datos precargados.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13; consolidada como UI-REQ-013 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** Crear y editar tienen distinta intención y estado de datos aunque utilicen controles relacionados.

**Verificación:** Inspección: comparar las composiciones CREATE y EDIT y comprobar que no se representan como la misma operación.

**Estado:** Confirmado

---

<a id="req-ui-014"></a>
### REQ-UI-014 — Presentación de revisión pendiente

**Requisito:**
La UI administrativa deberá presentar un combo pendiente de revisión en un contexto de edición distinto que identifique sus variantes afectadas y cambios de dependencias.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13 y contratos de revisión E-19/E-20; consolidada como UI-REQ-014 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** El administrador debe identificar qué cambió antes de confirmar la revisión.

**Verificación:** Demostración: cargar un combo pendiente y comprobar un estado de revisión distinto, variantes afectadas y cambios observados.

**Estado:** Confirmado

---

<a id="req-ui-015"></a>
### REQ-UI-015 — Confirmación de revisión pendiente

**Requisito:**
La UI administrativa deberá permitir confirmar las variantes de combo pendientes seleccionadas y ocultar el indicador de revisión únicamente después de que un estado actualizado de Menu informe UP_TO_DATE.

**Tipo:** Funcional — UI consumidora

**Fuente:** Decisión explícita de UI en la solicitud del 2026-09-13 y contratos de revisión E-20/E-21; consolidada como UI-REQ-014 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** La UI no debe declarar verificación solo porque el administrador pulsó Guardar; el estado resultante de Menu es autoritativo.

**Verificación:** Demostración: confirmar una o más variantes, actualizar el estado de revisión y comprobar que REVIEW_REQUIRED permanece cuando hay cambios nuevos pendientes.

**Estado:** Confirmado

---

<a id="req-ui-016"></a>
### REQ-UI-016 — Costo acumulado de preorden

**Requisito:**
La UI de orden deberá mostrar el costo acumulado de la preorden como la suma de los costos de sus líneas configuradas, tratando los ajustes posteriores de Billing como externos a ese acumulado mostrado.

**Tipo:** Funcional — UI consumidora

**Fuente:** Aclaración explícita de precio en la solicitud del 2026-09-13 y resumen monetario de E-16; consolidada como UI-REQ-015 en `output/ui-spec/ui-data-spec.md`.

**Justificación:** El precio del catálogo es el costo de ordenar el item configurado; la UI debe mostrar la suma de los costos seleccionados sin esperar a Billing final.

**Verificación:** Demostración: cambiar cantidades y configuraciones y comprobar `preorderTotal = Σ(quantity × resolvedUnitSubtotal)`; los ajustes posteriores de Billing no cambian el significado del acumulado mostrado.

**Estado:** Confirmado
