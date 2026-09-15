[Índice](./index.md)

# Precio y revisión administrativa de combos

Fuentes aprobadas: [decisiones de alineación](../../docs/reviews/ers-interfaces-alignment/decisions.md) y [Auditoria-4](../../docs/md/Auditoria-4.md).

## Precio y referencia visual

Cada COMBO tiene una o más `ComboConfiguration`, cada una con `unitPrice` absoluto y uno o más slots. Cada `ComboOption` referencia un `itemVariantId` hoja concreto, `quantity` positiva y `priceDelta`; `quantity` indica cuántas unidades físicas se incluyen y no cambia por sí sola el `unitPrice` de la configuración ni multiplica automáticamente el `priceDelta`. `baseOptionIds` pertenece al slot como ayuda administrativa, no como selección por defecto del cliente. Un `MenuItem` COMBO `INACTIVE` admite una configuración base incompleta con warning; `ACTIVE` exige una configuración válida al activar. Retirar posteriormente un componente no reescribe la composición histórica.

E-20 calcula `saved` con versiones fijadas y `current` con precios actuales de las mismas `itemVariantId`, multiplicados por `quantity` cuando compara dependencias. `difference=current-saved` es firmado y solo sirve para revisión administrativa. No cambia el `unitPrice` de la ComboConfiguration. Referencias retiradas conservan su último precio histórico; no se interpreta ese precio como elegibilidad. Una retirada sin nuevas referencias no borra historia.

E-16 devuelve pricing con `unitPrice`, `extrasTotal`, `unitSubtotal` y `currency`, al nivel de la referencia raíz solicitada. Para COMBO, `unitSubtotal = ComboConfiguration.unitPrice + SUM(ComboOption.priceDelta) + extrasTotal` y nunca se suman precios base de los MenuItem hoja. Extras suman quantity por priceDelta de cada modificador de cada unidad personalizada, usando la configuración efectiva publicada. No se multiplican de nuevo por `ComboOption.quantity`: cada unidad ya está representada. No se devuelven términos de precio, precios base de slots/componentes ni referencias administrativas. Orders aplica cantidad de línea y reglas externas; orquesta preparación hacia Cocina.

## Detección y catálogo

Menu mantiene dependencias por identidad de `itemVariantId` para todas las opciones de combos, incluso deshabilitadas. Compara precio, suministro/receta adoptada, modificadores aplicables y estado efectivo; ignora cosmética, stock y otras variantes del MenuItem. No hay combos anidados ni avisos en PREPARED/STOCKED. Cambiar Recipe sin adopción explícita por la variante no genera aviso de combo.

Estado por `ComboConfiguration`: REVIEW_REQUIRED si existen cambios relevantes no atendidos; UP_TO_DATE en otro caso. MenuItem agregado pendiente si alguna configuración lo está. Estado separado de status, versiones comerciales y disponibilidad. Estado inicial al crear/adoptar registra la observación de dependencias usada para configurar; guardar posteriormente no confirma avisos existentes. Cualquier cambio posterior a esa observación queda pendiente. No emitir M-07 por el mero aviso ni por confirmarlo.

E-19 alimenta el panel administrativo con filtro/paginación. E-20 expone referencias y cambios, nunca el catálogo comercial. No se añaden eventos públicos de revisión: refrescar por estas lecturas. El servicio debe detectar cambios de dependencias antes de responder con un estado actualizado.

## Confirmación concurrente

reviewToken es opaco, emitido por Menu, ligado a restaurante, MenuItem, ComboConfiguration y conjunto de changeId observado. No acredita autorización. E-21 acepta una lista explícita de configuraciones/tokens; confirmar todo significa enviar todas las configuraciones mostradas, no un comodín. Duplicados, tokens desconocidos o de otro ámbito producen 422 antes de cualquier efecto.

La confirmación atiende únicamente cambios del token. Nuevos cambios permanecen pendientes, incluso si llegaron durante la revisión. Repetir una observación ya atendida no reabre cambios. Idempotencia devuelve el recibo original para el mismo intento. Un token observado no caduca por nuevas versiones comerciales; caduca siete días desde su emisión, expuestos en reviewTokenExpiresAt (UTC RFC 3339). Al vencer: 409 REVIEW_TOKEN_EXPIRED y recarga E-20. La caducidad no elimina avisos, auditoría ni cambios pendientes. La recuperación idempotente precede a validar de nuevo un token; el recibo completo se conserva siete días desde terminar la operación, después rige IDEMPOTENCY_RESULT_EXPIRED.

Actor autenticado, instante y cambios atendidos quedan en auditoría separada. Puede conservarse precio/composición/versiones sin cambios: no genera versión comercial, M-07 ni M-08. Cambiar definición usa E-09 con If-Match; confirmar revisión usa E-21 explícitamente después. No puede asignarse state desde un cuerpo de escritura de MenuItem.

## Retirada

Desactivar/archivar un componente está permitido con combos dependientes. Su opción deja de ser elegible; el combo sigue disponible solo si puede satisfacer cada slot con opciones elegibles. Atender el aviso no rehabilita opciones ni modifica el estado ACTIVE/INACTIVE. Las referencias históricas pueden conservarse. Falta de stock conserva su tratamiento operativo, sin aviso de revisión administrativa.

## Copias

E-17 copia baseOptionIds remapeando IDs al copiar slots entre ComboConfiguration. ASSIGN_COMBO_OPTIONS invalida la base reemplazada y la deja vacía; un `MenuItem` COMBO `INACTIVE` permite advertencia, mientras `ACTIVE` rechaza si incumple límites. El administrador configura una base válida por E-09 antes de activar. Simulación informa estas violaciones; aplicación nunca deja efectos parciales. El estado/tokens de revisión no se copian: corresponden al destino y sus observaciones.
