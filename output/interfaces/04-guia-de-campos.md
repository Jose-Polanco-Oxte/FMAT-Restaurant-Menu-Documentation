[Índice](./index.md)

# Guía de campos: qué intención expresan

No son todos identificadores del mismo objeto: un ID reconoce algo, una revisión distingue su contenido en el tiempo y una fecha limita vigencia. Los ejemplos de nombres e importes no son reglas de negocio. Cada esquema lleva también estas explicaciones junto al campo.

## Las referencias que suelen confundirse

availabilityKey dice qué necesidad; definitionRevision dice qué composición; evaluationRevision dice cuál evaluación. Las dos primeras las establece Menu y la última Inventory. messageId identifica una publicación. correlationId solo ayuda a seguir una operación y es opcional en los eventos. reevaluationRequestId vincula expresamente M-04 con sus respuestas M-03. causationId se retiró para reducir ruido: no era necesario para decidir disponibilidad.

MenuItemVersion y recipeVersion preservan definiciones comerciales/culinarias; no se incrementan por cada evaluación de stock. availabilityRevision es el contador de la vista comercial de Menu, distinto del evaluationRevision de Inventory.

## Campos del contrato

| Campo | Intención y uso |
| --- | --- |
| `amount` | Importe decimal escrito como texto para conservar su representación exacta en el intercambio. |
| `applied` | Indica si la operación administrativa fue guardada; false en simulación. |
| `availability` | Resultado de elegibilidad que Menu presenta para una referencia vendible: `MenuItemVariant` hoja o `ComboConfiguration`. |
| `availabilityBySellable` | Resultados separados por referencia vendible, para no confundir el estado de una presentación hoja con el de una configuración de combo. |
| `availabilityKey` | Clave estable creada por Menu para una necesidad plana. Inventory la devuelve sin conocer su significado comercial. |
| `availabilityRevision` | Número de cambio de la vista comercial de disponibilidad de un MenuItem. Lo genera Menu, no Inventory. |
| `available` | Respuesta de Inventory sobre la lista de insumos: puede suministrarse o no. No reserva stock. |
| `base` | Precio absoluto de la unidad base de un insumo o receta; no es el precio comercial de un componente. |
| `commercialClassification` | Clasificación comercial de MenuItem hoja: DISH, BEVERAGE, DESSERT o COMPLEMENT. No aplica a COMBO. |
| `comboCategoryId` | Referencia de la categoría propia de COMBO. No se mezcla con ItemCategory. |
| `code` | Nombre estable del problema para que el consumidor pueda distinguirlo sin interpretar el texto humano. |
| `component` | Nombre histórico de una referencia de componente; el contrato vigente usa `itemVariantId` en ComboOption. |
| `components` | En Recipe, ingredientes base; en Selection, opciones de combo elegidas y sus unidades. El esquema determina el contexto. |
| `comboConfigurations` | Configuraciones vendibles de un COMBO; cada una tiene unitPrice y uno o más slots. |
| `configId` | Identidad de la configuración de una opción en una variante. La selección usa este ID para recuperar sus reglas. |
| `configurationId` | Identidad de una ComboConfiguration para un combo; en resolución es alternativa a `variantId`. |
| `configIds` | Configuraciones elegidas como origen de una copia administrativa. |
| `conflictPolicy` | Cómo tratar destinos existentes al copiar: FAIL rechaza y REPLACE sustituye según las reglas de la operación. |
| `correlationId` | Referencia para seguir una operación en registros. Opcional en eventos; en un error HTTP Menu entrega una referencia de soporte. |
| `currency` | Moneda del importe. MXN en ejemplos no impone una moneda a todos los restaurantes. |
| `data` | Contenido específico del mensaje, separado de los datos comunes de envío. |
| `definition` | Contenido completo de una definición de MenuItem retornada por Menu. |
| `definitionRevision` | Número de la composición plana, generado por Menu y copiado por Inventory. Cambia al editar o retirar necesidades. |
| `description` | Descripción visible del recurso, distinta de los campos operativos. |
| `defaultConfigurationId` | Referencia UX opcional a la ComboConfiguration preferida. No es un precio ni reemplaza la selección explícita. |
| `details` | Datos que explican el problema. Para una advertencia de capacidad incompleta incluye `entityType` (`ModifierGroup` o `ComboSlot`), `minSelections` y `capacity`; no incluye información interna sensible. |
| `dimensionId` | Identidad técnica de una característica de presentación elegible, por ejemplo tamaño. |
| `dimensionValueIds` | Valores elegidos por la presentación, por ejemplo el valor grande de tamaño. |
| `dimensions` | Características de presentación y sus valores definidos por el MenuItem. |
| `dryRun` | Simular una operación de copia sin guardarla, para conocer problemas antes de aplicarla. |
| `effects` | Consecuencias ya resueltas sobre ingredientes en una PreparationUnit; la configuración publicada usa `ingredientEffects`. |
| `eligibility` | Conjunto de datos que explica la elegibilidad de la selección al resolverla. |
| `eligible` | Indica que la variante puede ofrecerse considerando estado, configuración y disponibilidad vigente. |
| `enabled` | Habilita una configuración u opción particular. No reemplaza estado administrativo ni disponibilidad de stock. |
| `entityId` | Identidad del elemento afectado por una validación; null si no corresponde a un elemento específico. |
| `evaluatedAt` | Momento en que Inventory calculó la disponibilidad. Ayuda a entender la antigüedad del resultado. |
| `evaluationRevision` | Número creciente de evaluación asignado por Inventory para la clave. Evita aceptar resultados anteriores. |
| `fromPrice` | Menor `unitPrice` entre unidades vendibles elegibles: `MenuItemVariant` para un item hoja o `ComboConfiguration` para un COMBO. La UI antepone “Desde” solo cuando las unidades elegibles tienen precios distintos; es null cuando no hay ninguna. |
| `fulfillment` | Definición concreta de suministro de la variante. Debe coincidir con la clasificación del MenuItem. |
| `fulfillmentType` | Campo técnico cuyo valor representa el tipo de MenuItem: STOCKED, PREPARED o COMBO. La clasificación comercial es independiente y solo existe en MenuItem hoja. |
| `groupId` | Identidad de un grupo de modificadores propio del MenuItem. |
| `imageRef` | Referencia de imagen del artículo, o null si no hay imagen; no contiene los bytes de la imagen. |
| `ingredientEffects` | Efectos ADD u OMIT de una configuración general, excepción de variante o proyección publicada. |
| `ingredients` | Insumos netos resueltos por Menu después de aplicar la selección. No es stock disponible. |
| `inventoryItemId` | Identidad externa de un insumo propiedad de Inventory. Menu solo conserva una referencia lógica. |
| `items` | Elementos de una página; en necesidades planas, lista de insumos. El esquema enlazado precisa cuál de los dos. |
| `keys` | Necesidades concretas que Menu pide reevaluar, cada una con su revisión esperada. |
| `kind` | Discriminador: indica la operación de copia o el tipo de contribución comercial según el esquema. |
| `mappings` | Correspondencia entre identidades origen y destino creadas o conservadas al copiar. |
| `itemCategoryId` | Referencia de la categoría compartida por PREPARED y STOCKED. No aplica a COMBO. |
| `itemVariantId` | Presentación concreta de un MenuItem hoja que una ComboOption suministra. |
| `maxQuantity` | Máximo de unidades que el cliente puede elegir de una opción de modificador. La publicación usa el valor general o la excepción de la presentación hoja cuando existe. |
| `maxSelections` | Máximo de elecciones del grupo o slot, usando el mismo criterio que su mínimo. |
| `menuId` | Identidad de la agrupación Menu a la que pertenece un MenuItem. No es la identidad del microservicio. |
| `menuItem` | Referencia o definición del artículo comercial indicado por el esquema del contexto. |
| `menuItemId` | Identidad estable del artículo comercial, independiente de sus revisiones y variantes. |
| `menuItemVersion` | Revisión comercial exacta generada por Menu. Conserva qué definición eligió el consumidor. |
| `message` | Explicación legible del problema o advertencia. |
| `messageId` | Identidad de una publicación, creada por su emisor. Reenviar el mismo mensaje conserva este valor. |
| `minSelections` | Mínimo de elecciones: suma de cantidades para modificadores y número de opciones para slots. |
| `modifierConfigs` | Excepciones opcionales de una variante respecto a `ModifierOption.defaultConfig`; no se duplica la configuración general. |
| `modifierGroups` | Grupos de personalización disponibles en el artículo. |
| `modifiers` | Modificadores elegidos o resueltos en el ámbito indicado. quantity expresa repetición sin duplicar el ID. |
| `name` | Nombre visible del recurso o configuración. No se utiliza para adivinar identidad ni correspondencias. |
| `nextCursor` | Referencia opaca a la próxima página. El cliente la devuelve sin interpretarla; null indica final. |
| `occurredAt` | Fecha con zona en que ocurrió el hecho publicado. No sustituye las revisiones para decidir el orden. |
| `operation` | Tipo de efecto: OMIT excluye aportación base; ADD añade la cantidad configurada. |
| `optionId` | Identidad de una opción dentro de un grupo o slot. La variante referida no sustituye esta identidad. |
| `options` | Opciones configuradas para el grupo o slot indicado. |
| `path` | Ubicación del campo problemático dentro de la petición; no es un endpoint. |
| `preparationUnits` | Información de preparación resuelta por unidad: nombres, receta fijada y efectos. No es un trabajo de Cocina ni snapshot de Orders. |
| `priceDelta` | Ajuste no negativo de una opción de combo o modificador. En COMBO se suma al unitPrice de ComboConfiguration; no sustituye ese precio. |
| `pricing` | Resumen único de la referencia solicitada: unitPrice, extrasTotal, unitSubtotal y currency; incluye deltas de opción/modificador sin precios base de componentes. |
| `producer` | Servicio que declara emitir el mensaje. Debe coincidir con quien está autorizado a publicarlo. |
| `quantity` | Cantidad en el contexto: física con unidad en un insumo, o número entero de elecciones en un modificador. |
| `reason` | Motivo de disponibilidad o bloqueo, para explicar al consumidor por qué puede o no ofrecerse. |
| `recipe` | Receta fijada o definición resuelta según contexto. null en preparación sin receta, como un artículo almacenado. |
| `recipeId` | Identidad estable de una receta propiedad de Menu. |
| `recipeRefs` | Recetas y versiones utilizadas al resolver, para saber qué composición produjo el resultado. |
| `recipeVersion` | Revisión exacta de receta que se utiliza. Una revisión nueva no sustituye referencias anteriores automáticamente. |
| `reevaluationRequestId` | Identidad de una petición de reevaluación creada por Menu. Inventory la copia solo al responder esa petición. |
| `referenceId` | Identidad de la opción o configuración a la que corresponde un término de precio. |
| `requestId` | Identidad de consulta elegida por Orders en E-16 y devuelta por Menu. No crea una orden ni evita recalcular elegibilidad. |
| `resolvedAt` | Momento en que Menu produjo la resolución; permite reconocer que es una observación temporal. |
| `restaurantId` | Restaurante al que pertenece la información. Lo indica la ruta o el emisor; Menu verifica el acceso. |
| `schemaVersion` | Versión de la forma del mensaje, no de la receta ni de las existencias. |
| `scope` | Ámbito de una unidad resuelta: root para la raíz, o slotId/optionId/unitIndex para una unidad hija. Evita aplicar efectos a un hermano. |
| `selectedQuantity` | Número de elecciones de un modificador o término resuelto. No equivale necesariamente a `ComboOption.quantity`. |
| `selection` | Decisiones del usuario expresadas con IDs de configuración, opciones y cantidades. No incluye recetas inventadas por el cliente. |
| `slotId` | Identidad de un espacio de selección del combo, por ejemplo bebida. |
| `slotIds` | Espacios elegidos como origen de una copia. |
| `slots` | Espacios de selección configurados para una ComboConfiguration. |
| `sourceId` | Identidad de origen de una entrada del resultado de copia. |
| `sourceConfigurationId` | ComboConfiguration de la que se copian configuraciones o slots. |
| `status` | Estado administrativo: ACTIVE, INACTIVE y, en variantes, ARCHIVED. No significa que exista stock. |
| `targetId` | Identidad destino de esa copia, para localizar la configuración resultante. |
| `targetConfigurationIds` | ComboConfiguration a las que se aplicará una copia, dentro del mismo MenuItem. |
| `targets` | Destinos explícitos de asignación, identificados por configuración y slot sin emparejar nombres. |
| `terms` | Contribuciones comerciales identificadas de la selección, sin sumar precios base de componentes de combo. |
| `type` | Nombre del mensaje, incluido su versionado. En fulfillment indica si se suministra desde stock, receta o combo. |
| `unit` | Unidad física de la cantidad, por ejemplo g. Impide sumar medidas incompatibles. |
| `unitIndex` | Posición de una unidad física indicada por `ComboOption.quantity`, comenzando en 1. |
| `unitPrice` | Precio unitario absoluto de una MenuItemVariant hoja o de una ComboConfiguration, antes de ajustes. |
| `units` | Unidades físicas de la opción, para permitir personalizaciones distintas de cada una. Su cardinalidad deriva de `ComboOption.quantity`. |
| `validUntil` | Hasta cuándo es válido un resultado de disponibilidad. Su vencimiento impide seguir mostrando disponibilidad positiva. |
| `valueId` | Identidad de un valor dentro de una característica de presentación, independiente de su etiqueta. |
| `values` | Valores posibles de una característica de presentación. |
| `variantId` | Identidad de una presentación vendible de PREPARED/STOCKED; en COMBO se usa `configurationId`. |
| `variantLabel` | Texto comprensible de la presentación resuelta. Menu lo entrega para mostrarla sin reconstruirla en otro servicio. |
| `variants` | Presentaciones configuradas de un MenuItem PREPARED/STOCKED; un COMBO usa `comboConfigurations`. |
| `violations` | Reglas incumplidas, con ubicación y motivo; permiten corregir la configuración. |
| `warnings` | Advertencias compatibles con guardar, como capacidad incompleta en INACTIVE. |
| `withdrawn` | Indica una necesidad retirada. Su registro conservado evita que un mensaje antiguo la reactive. |

## Headers y conceptos de lectura

| Término | Para qué sirve |
| --- | --- |
| Authorization / permiso | Acreditar quién llama y qué puede hacer en el restaurante. Un ID en el body no concede acceso. |
| ETag / If-Match | Menu entrega una marca de la definición leída; el cliente la devuelve al editar para no pisar cambios posteriores de otra persona. |
| Idempotency-Key | El llamador reconoce una misma intención de escritura al reintentar. Evita guardarla dos veces, no reemplaza ETag. |
| Location | Dirección del recurso que se acaba de crear. |
| Content-Type / Accept | Indican que se envía o espera JSON. |
| Cache-Control: no-store | Evita reutilizar una respuesta comercial como si su disponibilidad siguiera vigente. |
| limit / cursor | Tamaño de página y referencia entregada por Menu para continuar la lista. |
| null frente a campo omitido | null es ausencia explícita admitida por el esquema; un campo opcional puede no enviarse. Un campo requerido no se omite aunque el ejemplo sea sencillo. |
| Snapshot | Copia histórica persistida por Orders del resultado de Menu y datos comerciales de la venta. Resolver en Menu no persiste esa copia en Orders. |
| Resolver / flatten | Validar la selección, aplicar recetas y efectos, y producir insumos netos. Flatten describe el resultado plano, no toda la operación. |
| Outbox | Trabajo de publicación guardado junto al cambio, para poder enviarlo aunque el proceso falle después. |
| ACK | Reconocimiento de recepción/procesamiento del mensaje. No significa venta confirmada ni descuento aceptado. |
| Tombstone | Registro de una retirada conservado para que un mensaje antiguo no reactive la necesidad. |

El resultado de resolución informa qué consumir. Orders solicita el descuento real con identidad propia; Inventory verifica existencias, aplica todo-o-nada y evita duplicados. Estos últimos contratos permanecen fuera de Menu.
