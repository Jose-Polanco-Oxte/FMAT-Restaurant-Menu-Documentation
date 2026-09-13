[Índice](./index.md)

# Verificación

Ejecutar `python output/interfaces/validate.py`. Comprueba enlaces, JSON Schema y ejemplos de cada contrato, formato JSON indentado, rutas de entrada versionadas y ausencia de contratos HTTP de otros servicios. No prueba reglas de negocio ni implementación.

La comprobación Mermaid se ejecuta con `node output/interfaces/render-diagrams.cjs`: compila y renderiza cada bloque a SVG/PNG. Su resultado se registra por separado en validation/mermaid.json. La inspección visual de las imágenes complementa la compilación; ninguna de las dos sustituye pruebas del servicio.

Requisitos locales para repetir: Python con jsonschema y referencing; Node, Playwright y Microsoft Edge. El módulo Playwright puede indicarse en PLAYWRIGHT_MODULE. La versión exacta de Mermaid está fijada en .validation-tools/package-lock.json; ejecutar `npm ci --prefix output/interfaces/.validation-tools` para restaurarla. node_modules y caché están excluidos de Git. El renderizador usa un servidor temporal exclusivamente en loopback y lo cierra al terminar.

Resultado de alineación: 20 fichas HTTP de entrada, ninguna API HTTP saliente, 6 contratos de mensajería y 53 schemas (incluido PriceTerm retirado, que rechaza todo payload). [Resultado documental](./validation.json). Se volvió a compilar/renderizar los tres diagramas de interfaces y el conceptual externo con Mermaid 11.15.0; el diagrama conceptual modificado fue inspeccionado visualmente en esta revisión. [Resultado Mermaid](./validation/mermaid.json).

Ejecutar también `python output/interfaces/validate_alignment.py` y `python output/review/validate.py`. El primero verifica negativos, ejemplos aritméticos, resumen monetario cerrado, separación administrativa e inventarios; el segundo verifica ambas ediciones y propagación de cierres. [Resultado de alineación estructural](./alignment-validation.json). No prueban el estado de un servicio ni equivalencia semántica automática. [Escenarios futuros](../../docs/reviews/ers-interfaces-alignment/acceptance.md).

Escenarios semánticos revisados: duplicado de evaluación, contenido conflictivo, evaluación retrasada/expirada, retirada y tombstone, resolución histórica con elegibilidad actual, componente sin disponibilidad, OMIT antes de ADD por ámbito, lote todo-o-nada, ETag antiguo y copia con IDs propios. Deben convertirse en pruebas del servicio cuando exista implementación. Los esquemas rechazan OMIT con cantidad, suministro no reconocido y falta de campos obligatorios; relaciones entre IDs y sumas se validan en dominio.

Los JSON de ejemplo de todas las fichas son documentos completos, no notación abreviada. Los modelos complejos están enlazados por esquemas por tipo. El conteo y el resultado de validación se encuentran en validation.json. No se ejecutaron pruebas de integración ni de rendimiento.

La [auditoría posterior al límite de uso](../../docs/reviews/ers-interfaces-alignment/execution-audit.md) añadió comprobaciones de coherencia de estados y cobertura por contrato: 278 checks PASS en alignment-validation.json. No confundir estos checks documentales con pruebas de la lógica de concurrencia de un servicio.
