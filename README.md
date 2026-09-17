# FMAT Restaurant Specification

<div align="center">

![Tipo](https://img.shields.io/badge/tipo-especificaci%C3%B3n%20y%20dise%C3%B1o-111111)
![Idioma](https://img.shields.io/badge/idioma-espa%C3%B1ol-444444)
![Estado](https://img.shields.io/badge/estado-base%20documental-1A1A1A)

Repositorio de arquitectura, requisitos, contratos, decisiones y prototipos de interfaz para **FMAT Restaurant**.

</div>

## Propósito

Este repositorio concentra la definición documental del sistema de comandas de FMAT Restaurant. Su objetivo es convertir el análisis del dominio y las decisiones de arquitectura en artefactos verificables que sirvan como referencia común para el diseño, la revisión y la futura implementación.

El alcance actual se centra especialmente en el bounded context `Menu`, responsable de la definición del catálogo, los productos vendibles, las variantes, los modificadores, los combos y las resoluciones necesarias para su operación en el flujo de comandas.

El repositorio funciona como una **fuente de especificación y diseño**. En su estado actual no es una aplicación ejecutable ni contiene un servicio listo para desplegar; contiene los insumos y entregables que describen cómo debería comportarse ese servicio y cómo deberían verse sus principales superficies de usuario.

## Qué contiene

| Área                           | Propósito                                                                                                                                                          |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Requisitos y modelo de dominio | Define el problema, el modelo conceptual, las reglas de negocio y los requisitos funcionales.                                                                      |
| Especificación consolidada     | Reúne el alcance, las responsabilidades del servicio `Menu`, sus invariantes y los requisitos vigentes.                                                            |
| Contratos e interfaces         | Documenta APIs, eventos, tipos, esquemas, convenciones y trazabilidad entre contratos y requisitos cuando estos entregables están presentes en la revisión activa. |
| Diseño de interfaz             | Representa las vistas del mesero y del administrador, sus estados y los flujos de configuración y preorden.                                                        |
| Revisiones y auditorías        | Registra decisiones, hallazgos, correcciones, consultorías y criterios de aceptación.                                                                              |
| Automatización documental      | Contiene scripts para apoyar el flujo de cambios y la validación de la documentación.                                                                              |

## Estructura del repositorio

```text
.
├── .agents/                 Recursos locales para agentes y habilidades de trabajo
├── .ai/                     Prompts y esquemas del flujo documental
├── .stitch/                 Sistema visual y metadatos de los mockups
├── docs/
│   ├── md/                  Fuentes de análisis, modelo, requisitos y auditorías
│   ├── original/            Documentos originales en PDF
│   └── requests/            Solicitudes de trabajo actuales y archivadas
├── output/
│   ├── diagrams/            Diagramas de procesos y flujos
│   ├── ers/                 Especificación consolidada del servicio Menu
│   └── mockup/              Entregables visuales por versión
├── scripts/                 Automatización y validación del flujo documental
├── AGENTS.md                Reglas de colaboración y control de alcance
└── README.md                Guía general del repositorio
```

### `docs/`: fuentes y trazabilidad del análisis

Esta carpeta conserva el material que explica de dónde provienen las decisiones del diseño:

- `docs/md/` contiene el problema inicial, modelos conceptuales, requisitos funcionales, auditorías, consultorías y decisiones de cierre.
- `docs/original/` conserva los documentos fuente en su formato original.
- `docs/requests/` registra solicitudes que orientan o documentan los trabajos realizados sobre la especificación.

### `output/`: entregables consolidados

Aquí se encuentran los artefactos preparados para consulta y revisión:

- `output/ers/spec.md` es la especificación vigente y consolidada del servicio `Menu`.
- `output/diagrams/` contiene diagramas exportados para comunicar procesos del dominio.
- `output/mockup/` organiza los mockups por versión. Cada entrega puede incluir archivos HTML, capturas PNG y su README de alcance y validación.

### `.stitch/`: sistema visual

Contiene el sistema visual y los metadatos utilizados para mantener consistencia entre los mockups: viewport objetivo, tipografía, escala cromática, superficies, bordes y demás tokens de diseño.

### `scripts/`: soporte operativo

Incluye automatizaciones para capturar cambios documentales, ejecutar el flujo de trabajo y validar que las modificaciones respeten las reglas del repositorio.

## Documentos de entrada y entregables principales

- [Problema inicial](docs/md/Problema-Inicial.md)
- [Modelo pre-final del dominio](docs/md/Modelo-Pre-Final.md)
- [Requisitos funcionales aprobados](docs/md/Req-F-Aproved.md)
- [Especificación vigente del servicio `Menu`](output/ers/spec.md)
- [Diagrama del flujo de ordenar](output/diagrams/flujo-ordenar.md)
- [Mockups de la versión 1.2](output/mockup/1.2/README.md)
- [Sistema visual de FMAT Restaurant](.stitch/DESIGN.md)
- [Reglas de colaboración del repositorio](AGENTS.md)

## Cómo leer el repositorio

Se recomienda seguir este orden:

1. Revisar el [problema inicial](docs/md/Problema-Inicial.md) y el [modelo pre-final](docs/md/Modelo-Pre-Final.md) para entender el contexto y el lenguaje del dominio.
2. Consultar los [requisitos funcionales aprobados](docs/md/Req-F-Aproved.md) para identificar las obligaciones del sistema.
3. Usar la [especificación consolidada](output/ers/spec.md) como referencia principal del servicio `Menu`.
4. Revisar los diagramas y los mockups para relacionar el comportamiento del dominio con los flujos de usuario.
5. Consultar las auditorías, decisiones y solicitudes archivadas cuando sea necesario conocer el razonamiento o la evolución de una decisión.

## Convenciones del proyecto

- `docs/` contiene fuentes de análisis, discusión y trazabilidad.
- `output/` contiene entregables consolidados o exportados.
- Los identificadores técnicos, como `REQ-MENU-*`, `V-MES-*` y `V-ADM-*`, se conservan para mantener trazabilidad entre documentos y artefactos.
- La documentación de negocio y las superficies de usuario se redactan en español; los nombres técnicos de contratos, códigos y tipos se conservan cuando forman parte del dominio o de una interfaz.
- Los cambios deben respetar el alcance solicitado y las reglas definidas en [`AGENTS.md`](AGENTS.md).

## Estado y alcance de validación

Los README específicos de cada entrega documentan sus propios criterios de revisión. La existencia de un documento, esquema, diagrama o mockup no implica por sí sola que exista una implementación de runtime, una integración operativa o una validación de producción.

Para interpretar correctamente cualquier resultado, debe distinguirse entre:

- validación documental y estructural;
- revisión visual de mockups;
- consistencia entre requisitos, contratos y modelos;
- pruebas de integración o aceptación de servicios, que requieren una implementación ejecutable independiente.

## Licencia y uso

>[!NOTE]
> No se ha definido una licencia de distribución en este repositorio. El contenido debe tratarse como material de especificación y diseño del proyecto FMAT Restaurant hasta que se establezcan formalmente las condiciones de uso.
