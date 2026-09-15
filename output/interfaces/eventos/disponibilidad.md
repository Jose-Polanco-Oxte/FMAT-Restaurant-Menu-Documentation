[Mensajes](./index.md)

# Coherencia de disponibilidad

Menu conserva la correspondencia entre clave opaca, definición plana y variante hoja u opción suministrada. Inventory solo recibe insumos y unidades. Prepared transmite receta base; stocked su insumo; opción de combo incorpora `itemVariantId` y `quantity` en sus necesidades. Menu calcula disponibilidad del combo si cada slot cubre su mínimo con opciones elegibles. No se enumeran todas las combinaciones de extras y una evaluación no garantiza stock conjunto.

Nueva definición parte sin evaluación positiva. M-01 reemplaza la lista; M-02 incrementa revisión y conserva tombstone. M-03 de definición antigua se ignora. Retirada no puede resucitar por orden de entrega. Lista vacía solo resulta de una definición válida realmente sin consumo, nunca de un error de resolución.

validUntil explícito controla vencimiento. Ante caída detectada o expiración, Menu no disponible. Recuperación pide M-04, conserva reevaluationRequestId y revisión mínima aceptable (última+1) por clave; una respuesta M-03 nueva con el mismo reevaluationRequestId permite salir del estado de recuperación. Tiempo de lease, umbrales de detección y reintento son configuración operativa, no valores inferidos de un ejemplo.

E-18 pagina snapshot consistente de definiciones y tombstones. Al recibir eventos simultáneos se conserva la revisión mayor por clave. Si falla la paginación se reinicia, no se interpretan páginas incompletas como retiradas. Retención de tombstones se mantiene en esta versión. La reconstrucción del consumidor está limitada a este contrato, sin especificar su base de datos.

Menu publica cambios de necesidades, no un eco de M-03. M-08 solo invalida la vista de sus consumidores de catálogo. Selecciones reales se resuelven en E-16; el consumo físico posterior está fuera de Menu.

Base: INT-MENU-008/009/010/011/019, DATA-MENU-019/020, CON-MENU-009/010.
