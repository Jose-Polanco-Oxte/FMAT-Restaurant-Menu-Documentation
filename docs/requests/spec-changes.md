# Prompt para modificación de la especificación

## Objetivo

Analizar, contrastar y consolidar las siguientes fuentes para corregir contradicciones, cambiar ciertas decisiones del modelo, actualizar requisitos.

El objetivo no es combinar mecánicamente los documentos, sino reconstruir el diseño final a partir de la evolución de los requisitos, análisis, auditorías y decisiones.

Nota: unicamente se deben inspeccionar y tocar los documentos mencionados en este prompt. No se deben considerar otras fuentes y esta estrictamente prohibido modificar los documentos originales.

---

## Fuentes

Analizar las siguientes fuentes respetando su orden cronológico:

1. [Auditoria 4](/docs/md/Auditoria-4.md)

---

## Criterio de análisis

Reconstruir el modelo vigente identificando:

- qué requisitos siguen vigentes;
- qué conceptos fueron refinados;
- qué decisiones fueron reemplazadas;
- qué contradicciones quedaron resueltas;
- qué invariantes se derivan de las decisiones confirmadas;
- qué responsabilidades pertenecen al servicio Menu;
- qué información pertenece a otros servicios;
- qué decisiones siguen abiertas.

Una decisión posterior reemplaza a una anterior cuando exista una contradicción explícita o cuando la decisión posterior refine de forma incompatible el modelo anterior.

No conservar simultáneamente alternativas incompatibles.

---

## Reglas de consolidación

### Descubrir antes de documentar

Antes de modificar `spec.md`:

1. identificar los conceptos principales del dominio;
2. reconstruir sus relaciones;
3. identificar las decisiones vigentes;
4. detectar contradicciones entre fuentes;
5. resolverlas utilizando la evolución temporal y semántica;
6. comprobar que requisitos, modelo, interfaces y diagramas describen el mismo sistema.

No utilizar la estructura del documento final como sustituto del análisis.

### Separar hechos de decisiones

Distinguir cuando corresponda entre:

- requisito;
- regla de negocio;
- invariante;
- decisión de diseño;
- decisión arquitectónica;
- decisión de UX;
- detalle de implementación;
- contrato;
- cuestión abierta.

No convertir automáticamente toda decisión de modelado en requisito funcional.

### No inventar decisiones

Cuando las fuentes no permitan resolver una decisión:

- no elegir arbitrariamente;
- no completar mediante supuestos implícitos;
- no introducir patrones únicamente porque sean habituales;
- registrar el punto como cuestión abierta.

Sí pueden derivarse consecuencias necesarias de decisiones confirmadas cuando sean lógicamente consecuencia del modelo consolidado.

### Mantener un único modelo vigente

`spec.md` debe describir el sistema final, no narrar toda la evolución histórica.

Evitar redacción como:

> inicialmente se propuso X, después Y y finalmente Z.

En el cuerpo principal deberá aparecer directamente la decisión vigente.

Las alternativas anteriores sólo deberán aparecer cuando aporten valor para justificar una decisión o mantener trazabilidad.

### Mantener terminología consistente

Identificar el lenguaje final del dominio y utilizarlo consistentemente.

Cuando distintas fuentes utilicen nombres diferentes para el mismo concepto:

- determinar el término vigente;
- utilizarlo en toda la especificación;
- evitar sinónimos técnicos innecesarios.

### Mantener ownership claro

Determinar qué información pertenece realmente a Menu y qué información pertenece a otros bounded contexts.

No trasladar ownership de datos externos a Menu únicamente porque Menu necesite referenciarlos o consumirlos.

### Verificar consistencia global

Antes de finalizar, revisar coherencia entre:

- requisitos;
- reglas e invariantes;
- modelo de dominio;
- modelo de datos;
- diagramas;
- interfaces;
- eventos;
- dependencias externas.

No debe existir una capacidad descrita por requisitos que resulte imposible según el modelo final.

Tampoco deben existir entidades, estados, atributos o relaciones importantes sin respaldo en las fuentes consolidadas.

---

## Decisiones registradas

Si se tomaron decisiones que no estaban explícitamente documentadas en las fuentes, registrarlas en el [log de decisiones](/output/ers/decisiones.md)

## Resultado esperado

modificar:

`/output/ers/spec.md`

---

## Libertad de estructura

La estructura anterior es una guía de contenido mínimo, no una obligación rígida.

Se permite:

- combinar secciones;
- crear subsecciones;
- reorganizar contenido;
- utilizar tablas;
- añadir diagramas;
- separar temas particularmente complejos;

cuando mejore la claridad del documento.

No crear secciones vacías.

No documentar aspectos que no tengan relevancia o respaldo en las fuentes.

No aumentar artificialmente el tamaño de la especificación.

---

## Criterios de calidad

Antes de finalizar `spec.md`, comprobar que:

- los requisitos aprobados fueron considerados;
- las decisiones posteriores fueron incorporadas;
- no permanecen decisiones obsoletas;
- no se combinaron alternativas incompatibles;
- la terminología es consistente;
- los diagramas coinciden con el texto;
- el modelo de datos deriva del modelo de dominio;
- las interfaces utilizan conceptos existentes en el modelo;
- las dependencias externas tienen ownership claro;
- las cuestiones abiertas permanecen identificadas como abiertas;
- no se introdujeron decisiones sin respaldo;
- el documento describe el sistema vigente y no el historial de discusión.

---

## Objetivo final

`spec.md` debe convertirse en la fuente consolidada de verdad del servicio Menu.

Una persona que no haya leído las discusiones anteriores deberá poder utilizarlo para comprender:

1. qué debe hacer el servicio;
2. cuáles son sus responsabilidades y límites;
3. cuáles son sus conceptos de dominio;
4. qué reglas e invariantes deben mantenerse;
5. cómo se estructuran y persisten sus datos;
6. cómo interactúa con otros servicios;
7. qué interfaces y eventos utiliza;
8. qué decisiones arquitectónicas están vigentes;
9. qué cuestiones permanecen abiertas.

El documento final debe surgir del análisis de las fuentes y no de una solución preestablecida por este prompt.
