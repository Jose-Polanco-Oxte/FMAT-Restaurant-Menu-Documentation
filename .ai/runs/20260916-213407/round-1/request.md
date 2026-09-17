# Normalización de identificadores de requisitos

## Objetivo

Normalizar todos los identificadores de requisitos de `/docs/md/spec.md`.

Actualmente existen identificadores desordenados, numeraciones históricas y referencias cruzadas que no corresponden a una estructura coherente.

## Esquema requerido

Los requisitos funcionales de Menu deberán utilizar:

`REQ-MENU-{ABREVIACION_APARTADO}-{NNN}`

Ejemplos conceptuales:

```text
REQ-MENU-VAR-001
REQ-MENU-MOD-001
REQ-MENU-COM-001
REQ-MENU-AVL-001

```

La abreviación deberá representar de manera clara y estable el apartado funcional al que pertenece el requisito.

Definir primero el conjunto mínimo de abreviaciones necesarias a partir de la estructura vigente de requisitos.

No crear abreviaciones innecesariamente específicas.

## Numeración

La numeración deberá:

comenzar en 001 dentro de cada abreviación;
ser consecutiva;
respetar el orden lógico en el que aparecen los requisitos;
no conservar huecos derivados de IDs anteriores.

Ejemplo:

```text
REQ-MENU-MOD-001
REQ-MENU-MOD-002
REQ-MENU-MOD-003

REQ-MENU-COM-001
REQ-MENU-COM-002
```

## Procedimiento

Antes de modificar el documento:

1. identificar todos los IDs actuales;
2. determinar su apartado funcional;
3. generar internamente un mapa completo:

   ```text
   OLD_ID -> NEW_ID
   ```

4. comprobar que ningún NEW_ID esté duplicado;
5. aplicar la sustitución de forma global.

Actualizar todas las referencias a los identificadores antiguos, incluyendo:

- encabezados;
- texto narrativo;
- campos Relacionado;
- verificaciones;
- reglas de negocio;
- trazabilidad;
- tablas;
- referencias entre requisitos;
- cuestiones abiertas;
- diagramas;
- cualquier otra referencia interna.

## Reglas

No modificar el significado de los requisitos durante esta operación.

No dividir ni fusionar requisitos salvo que sea imprescindible porque exista una duplicidad real detectada previamente.

Si se detectan dos requisitos equivalentes, reportarlo antes de eliminarlos o fusionarlos.

Mantener IDs de otros tipos de artefactos si siguen una nomenclatura independiente y válida.

## Validación final

Comprobar que:

- no queda ningún identificador antiguo;
- no existen IDs duplicados;
- no existen referencias rotas;
- la numeración de cada apartado es continua;
- todos los requisitos utilizan la nomenclatura acordada.

## Resultado

Modificar `/docs/md/spec.md` directamente.

