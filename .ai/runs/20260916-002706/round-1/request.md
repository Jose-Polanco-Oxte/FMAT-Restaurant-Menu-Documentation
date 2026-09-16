# Prompt para especificación final del proyecto

## Objetivo

Analizar, contrastar y consolidar las siguientes fuentes para producir una única especificación vigente del servicio Menu.

El objetivo no es combinar mecánicamente los documentos, sino reconstruir el diseño final a partir de la evolución de los requisitos, análisis, auditorías y decisiones.

Crear el resultado final en:

`/docs/md/spec.md`

Nota: unicamente se deben inspeccionar y tocar los documentos mencionados en este prompt. No se deben considerar otras fuentes y esta estrictamente prohibido modificar los documentos originales.

---

## Fuentes

Analizar las siguientes fuentes respetando su orden cronológico:

1. [Problema-Inicial.md](/docs/md/Problema-Inicial.md)
2. [Consultoria-1.md](/docs/md/Consultoria-1.md)
3. [Consultoria-2.md](/docs/md/Consultoria-2.md)
4. [Auditoria-1.md](/docs/md/Auditoria-1.md)
5. [Auditoria-2.md](/docs/md/Auditoria-2.md)
6. [Modelo-Pre-Final.md](/docs/md/Modelo-Pre-Final.md)
7. [Decisiones-cierre-invariantes.md](/docs/md/Decisiones-cierre-invariantes.md)
8. [Req-F-Aproved.md](/docs/md/Req-F-Aproved.md)
9. [Auditoria-3.md](/docs/md/Auditoria-3.md)

El orden anterior representa la secuencia en la que el análisis y las decisiones fueron evolucionando.

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

## Prioridad de las fuentes

### Req-F-Aproved.md

[Req-F-Aproved.md](/docs/md/Req-F-Aproved.md) contiene requisitos previamente aprobados y deberá utilizarse como base de los requisitos funcionales finales.

Sus requisitos deberán conservarse salvo cuando una decisión posterior:

- los contradiga;
- los refine;
- los vuelva obsoletos;
- cambie el modelo del que dependían.

En esos casos:

1. identificar la contradicción;
2. determinar la decisión vigente;
3. actualizar el requisito afectado;
4. mantener trazabilidad de la modificación.

### Auditoria-3.md

[Auditoria-3.md](/docs/md/Auditoria-3.md) representa la discusión más reciente y tiene la mayor prioridad para resolver:

- decisiones de dominio;
- invariantes;
- relaciones entre conceptos;
- terminología;
- simplificaciones;
- decisiones descartadas;
- aclaraciones de comportamiento.

No asumir que todo lo contenido en documentos anteriores continúa vigente.

---

## Reglas de consolidación

### Descubrir antes de documentar

Antes de redactar `spec.md`:

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

## Resultado esperado

Crear:

`/docs/md/spec.md` y `docs/md/decisiones.md` (Si tomaste decisiones que no estaban explícitamente documentadas en las fuentes [Unicamente un log]).

La siguiente estructura representa el contenido mínimo esperado.

Puede reorganizarse cuando sea necesario para mejorar la claridad.

### 1. Título

Nombre oficial de la especificación y descripción breve de su propósito.

### 2. Índice

Índice navegable de las secciones principales.

### 3. Configuración del documento

Incluir como mínimo:

- versión;
- estado;
- fecha;
- alcance;
- fuentes utilizadas.

### 4. Contexto, alcance y lenguaje del dominio

Describir:

- responsabilidad del servicio Menu;
- límites respecto a otros bounded contexts;
- conceptos principales;
- terminología vigente.

Incluir un glosario cuando aporte claridad.

### 5. Requisitos funcionales

Consolidar los requisitos funcionales vigentes.

Utilizar [Req-F-Aproved.md](/docs/md/Req-F-Aproved.md) como base y actualizar únicamente aquello afectado por decisiones posteriores.

Mantener identificadores y trazabilidad siempre que sea posible.

### 6. Requisitos no funcionales

Consolidar únicamente los requisitos no funcionales respaldados por las fuentes.

No introducir métricas, tecnologías o restricciones que no hayan sido justificadas.

### 7. Reglas de negocio e invariantes

Documentar las reglas necesarias para interpretar correctamente el modelo y conservar su consistencia.

No convertir esta sección en una repetición de los requisitos funcionales.

### 8. Modelo de dominio

Presentar el modelo vigente.

Incluir cuando corresponda:

- entidades;
- agregados;
- value objects;
- relaciones;
- cardinalidades;
- ownership;
- estados;
- referencias externas.

Agregar diagramas Mermaid cuando ayuden a comprender el modelo.

### 9. Arquitectura

Describir los componentes y relaciones arquitectónicas relevantes para el servicio.

Incluir únicamente información necesaria para comprender:

- límites;
- responsabilidades;
- integración con otros servicios;
- broker u otros mecanismos de comunicación cuando existan.

### 10. Modelo de datos

Derivar el modelo persistente desde el modelo de dominio.

Documentar:

- estructuras principales;
- relaciones;
- restricciones;
- identificadores;
- referencias externas;
- decisiones importantes de persistencia.

No introducir asociaciones persistentes entre bases de datos de distintos bounded contexts.

### 11. Interfaces de entrada y salida

Consolidar las interfaces expuestas y consumidas por Menu.

Documentar únicamente la información respaldada por las fuentes.

### 12. Eventos de negocio

Documentar los eventos relevantes:

- emitidos;
- consumidos;
- propósito;
- información principal transportada;
- relación con cambios del dominio.

### 13. Datos requeridos de otros servicios

Identificar los datos utilizados por Menu cuyo ownership pertenece a otro bounded context.

Para cada dependencia indicar cuando esté disponible:

- propietario;
- dato requerido;
- finalidad;
- forma de referencia o consumo.

### 15. Cuestiones abiertas

Registrar únicamente decisiones que no puedan resolverse con las fuentes disponibles (Única excepción: contratos con servicios externos).

Para cada una indicar:

- problema;
- impacto;
- información faltante.

No resolverlas arbitrariamente.

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

