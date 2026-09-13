# Auditoría de ejecución y continuación del plan

**Fecha:** 2026-09-13. **Alcance:** historial posterior a la aceptación del plan y contraste de documentos/contratos actuales. No es una auditoría independiente ni prueba de servicios.

## Historial comprobado

Se consultó la tarea `Revisar alineación ERS e interfaces`, ID `01a09887-c2b9-79e1-950c-3d5e29b053fa`, mediante lectura del historial de la aplicación.

| Ejecución | Estado observado | Evidencia |
| --- | --- | --- |
| `01a09931-ac1c-7351-88ea-a6f422ad0173` | Fallida por límite de uso | Comienza con la solicitud explícita de implementar el plan. El error final indica límite de uso. Contiene modificaciones y verificaciones intermedias fallidas, posteriormente corregidas. |
| `01a0998f-db66-7953-adb8-bf3aa58fadf5` | Completada | Responde a «continua»; añade el ejemplo de combo, ejecuta los tres validadores con PASS, crea el reporte de cierre y elimina los generadores temporales. |
| Revisión presente | Verificación y correcciones adicionales | Se contrastaron los archivos, en lugar de dar por suficiente el estado de la ejecución o los PASS anteriores. |

La interrupción existió, pero la continuación sí llegó al cierre documental. Los defectos residuales siguientes no pueden atribuirse únicamente al límite de uso: varios no estaban cubiertos por los validadores anteriores.

## Brechas encontradas y completadas

1. **Fichas administrativas:** E-19/E-20 repetían headers, parámetros y errores de E-21. Se separaron los contratos de lectura de la confirmación, precisando ETag, filtros, errores y alcance de cada operación. E-20 identifica cómo recuperar las versiones comparadas mediante E-14.
2. **Invariantes de estado:** schemas admitían UP_TO_DATE con cambios pendientes, REVIEW_REQUIRED sin cambios, resumen actualizado con variante pendiente y avisos en PREPARED. Se añadieron restricciones condicionales y pruebas negativas. Se observaron seis fallos antes de corregir los schemas; después pasaron.
3. **Cobertura de contratos:** la matriz no enumeraba todas las APIs. Ahora cada uno de los 20 endpoints y 6 mensajes tiene una fila propia con obligaciones confirmadas existentes; el validador detecta contratos omitidos, duplicados o referencias inexistentes. D-01…D-09 también se comprueban.
4. **Autoridad de revisión:** las instrucciones aún presentaban el reporte original como evidencia actual. Ahora distinguen antecedente, decisiones aprobadas, cierre y esta auditoría; conservan el inglés canónico decidido por el usuario.
5. **Historia retirada:** se precisó que E-10 era prevalidación sustituida por validación en E-09, mientras M-05/M-06 correspondían a resolución interactiva sustituida por E-16. Ambas ediciones mantienen la misma decisión.
6. **Metadatos de evidencia:** se actualizaron enlaces al cierre vigente y conteos, conservando explícitamente el resultado anterior de 228 checks como evidencia histórica.

## Contraste con el plan aprobado

| Parte del plan | Evidencia actual | Resultado |
| --- | --- | --- |
| Inglés canónico y traducción sincronizada | [ERS](../../../output/ers/index.md), [traducción](../../../output/ers-es/index.md), validación de IDs/estados | Implementado; la comprobación automática no demuestra equivalencia lingüística por sí sola |
| Precio fijo y opciones incluidas sin recargo | BR-MENU-008/016/017, ComboOption, ejemplos de aritmética | Implementado documentalmente |
| Resumen mínimo a Orders | PriceSummary cerrado, E-16 y rechazo de filtración en preparación | Implementado y validado por schema |
| Referencias administrativas aisladas | Schemas comerciales separados; E-20 | Implementado |
| Avisos, confirmación y concurrencia | E-19/E-20/E-21, invariantes de estado, tokens y escenarios AC-08–AC-11 | Contratos implementados; concurrencia real pendiente de implementación |
| Retirada y elegibilidad | BR-MENU-031 y reglas de revisión | Implementado documentalmente; confirmar aviso no reactiva componentes |
| Validación, copias y versiones | E-17, BR-MENU-041–044, DATA-MENU-013/024/026 | Implementado; las relaciones de dominio requieren pruebas futuras del servicio |
| Hallazgos F-001…F-010 y estados OPEN | [Cierre](./closure-report.md), trazabilidad y catálogo de contratos | Corrección documental completada |
| Verificación y límites de evidencia | Tres validadores actuales y [aceptación futura](./acceptance.md) | PASS estructural; sin afirmar integración o UI |

## Verificaciones actuales

- `python output/interfaces/validate.py`: PASS; 20 endpoints, 6 mensajes, 53 schemas y 35 ejemplos asociados a schemas.
- `python output/interfaces/validate_alignment.py`: PASS; 278 checks, incluyendo invariantes de revisión y cobertura de contratos.
- `python output/review/validate.py`: PASS; 2 ediciones, 191 IDs por edición y 161 obligaciones confirmadas.
- Enlaces locales del paquete de revisión comprobados. Los diagramas no se modificaron en esta pasada; su evidencia de renderizado corresponde a la continuación anterior, no a una ejecución nueva.

## Pendientes legítimos, no tareas olvidadas

OPEN-010 conserva límites físicos, unidades, dimensionamiento/retención e integración de configuración monetaria no decididos. Implementación de servicios/UI, broker, persistencia, concurrencia real y rendimiento están fuera de esta entrega. Los 23 escenarios de aceptación siguen siendo criterios futuros, no pruebas ejecutadas del servicio.

No se identificó otro trabajo documental imprescindible del plan sin completar después de esta pasada. No se hicieron commits ni se alteró el reporte original. Resultados actuales: [contratos](../../../output/interfaces/validation.json), [alineación](../../../output/interfaces/alignment-validation.json) y [ERS](../../../output/review/validation.json).
