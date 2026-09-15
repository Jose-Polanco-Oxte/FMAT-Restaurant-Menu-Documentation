[Índice general](../../index.md)

# Interfaces HTTP de entrada

Todos los endpoints pertenecen a Menu. Cada ficha incluye autorización, parámetros, body con esquema y ejemplo, respuesta con esquema y ejemplo, errores y semántica. Los esquemas enlazados son parte del contrato, no pseudocódigo. IDs y números de ejemplo no fijan valores de negocio.

| ID | Operación | Endpoint versionado completo |
| --- | --- | --- |
| [E-01](./E-01.md) | Listar menús | `GET /v1/restaurants/{restaurantId}/menus` |
| [E-02](./E-02.md) | Consultar catálogo de MenuItem | `GET /v1/restaurants/{restaurantId}/catalog/menu-items` |
| [E-03](./E-03.md) | Detalle comercial | `GET /v1/restaurants/{restaurantId}/catalog/menu-items/{menuItemId}` |
| [E-04](./E-04.md) | Crear menú | `POST /v1/restaurants/{restaurantId}/menus` |
| [E-05](./E-05.md) | Leer menú administrativo | `GET /v1/restaurants/{restaurantId}/menus/{menuId}` |
| [E-06](./E-06.md) | Editar menú | `PUT /v1/restaurants/{restaurantId}/menus/{menuId}` |
| [E-07](./E-07.md) | Crear MenuItem | `POST /v1/restaurants/{restaurantId}/menu-items` |
| [E-08](./E-08.md) | Leer MenuItem administrativo | `GET /v1/restaurants/{restaurantId}/menu-items/{menuItemId}` |
| [E-09](./E-09.md) | Editar MenuItem | `PUT /v1/restaurants/{restaurantId}/menu-items/{menuItemId}` |
| [E-11](./E-11.md) | Crear receta | `POST /v1/restaurants/{restaurantId}/recipes` |
| [E-12](./E-12.md) | Leer receta actual | `GET /v1/restaurants/{restaurantId}/recipes/{recipeId}` |
| [E-13](./E-13.md) | Editar receta | `PUT /v1/restaurants/{restaurantId}/recipes/{recipeId}` |
| [E-14](./E-14.md) | Leer revisión de MenuItem | `GET /v1/restaurants/{restaurantId}/menu-items/{menuItemId}/versions/{menuItemVersion}` |
| [E-15](./E-15.md) | Leer revisión de Recipe | `GET /v1/restaurants/{restaurantId}/recipes/{recipeId}/versions/{recipeVersion}` |
| [E-16](./E-16.md) | Resolver selección de MenuItem | `POST /v1/restaurants/{restaurantId}/menu-items/{menuItemId}/resolutions` |
| [E-17](./E-17.md) | Copiar o asignar configuraciones | `POST /v1/restaurants/{restaurantId}/menu-items/{menuItemId}/configuration-operations` |
| [E-18](./E-18.md) | Recuperar necesidades emitidas por Menu | `GET /v1/restaurants/{restaurantId}/availability-definitions` |
| [E-19](./E-19.md) | Listar MenuItem administrativos | `GET /v1/restaurants/{restaurantId}/menu-items` |
| [E-20](./E-20.md) | Consultar revisión de combo | `GET /v1/restaurants/{restaurantId}/menu-items/{menuItemId}/review` |
| [E-21](./E-21.md) | Confirmar revisión de combo | `POST /v1/restaurants/{restaurantId}/menu-items/{menuItemId}/review-confirmations` |

## Reglas de escritura de MenuItem

Validar siempre pertenencia de valores, una combinación única por variante, suministro homogéneo, grupos propios y ausencia de combos anidados. Capacidad incompleta se admite solo en un contexto `INACTIVE` —`MenuItem` o `MenuItemVariant` para un `ModifierGroup`; `MenuItem` COMBO para un `ComboSlot`, porque `ComboConfiguration` no tiene estado propio— y devuelve warnings con `entityId`, `entityType`, `minSelections` y `capacity`: en un `ModifierGroup`, `capacity` es la suma de `maxQuantity` de sus opciones habilitadas; en un `ComboSlot`, es el número de `ComboOption` habilitadas cuyo componente está `ACTIVE`. Activación exige al menos una variante ACTIVE y capacidad válida de todas las que quedan ACTIVE. Desactivar/archivar componentes está permitido: excluir opciones retiradas de la elegibilidad y marcar combos para revisión; conservar venta con otras selecciones válidas. ARCHIVED no se reactiva. No existe borrado físico de historial.

La versión se genera en Menu como contador y fecha con zona. Recipe y MenuItem tienen secuencias independientes. Añadir características de presentación crea identidades nuevas y archiva DEFAULT en el mismo cambio comercial. No se deduce un tamaño a partir del nombre DEFAULT.

[Semántica de copias](./configuraciones.md). [Tipos y reglas de resolución](../../03-tipos.md).

E-10 fue retirado: no hay una necesidad de comprobación previa independiente. E-09 conserva toda la validación al guardar. [Guía de campos y headers](../../04-guia-de-campos.md).

[Revisión administrativa](../../05-revision-combos.md). El tipo contractual de `MenuItem` (`fulfillmentType`) es inmutable desde la creación.
