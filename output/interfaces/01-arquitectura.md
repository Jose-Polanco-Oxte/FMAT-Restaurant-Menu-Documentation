[Índice](./index.md)

# Frontera de Menu

Menu posee Menu, MenuItem, MenuItemVariant, modificadores, combos y Recipe. Resuelve una selección de su catálogo con versiones fijadas y expone insumos netos e información de preparación. No crea líneas de Orders, no confirma ventas, no descuenta existencias y no despacha trabajos de Cocina.

| Interlocutor | Punto de anclaje de Menu |
| --- | --- |
| Backoffice/POS | Lectura o administración de recursos Menu por APIs de entrada |
| Consumidor de selección, por ejemplo Orders | Solicita resolución por E-16; recibe definición resuelta, no confirmación de venta |
| Inventory | Consume necesidades opacas publicadas por Menu y le entrega evaluaciones |
| Consumidores de catálogo | Reciben invalidaciones de MenuItem y recuperan información autorizada por las entradas de catálogo |
| Cocina | Sin contrato directo adicional en esta revisión; los datos de preparación salen de Menu hacia quien solicita resolución |

D-01 actualizado por acuerdo: mensajería para disponibilidad e invalidaciones. Orders solicita por HTTP E-16 la resolución interactiva. Menu devuelve resultado al solicitante, no envía esa resolución por separado a Inventory ni crea una orden. M-05/M-06 se retiran. La UI puede consultar Menu para previsualizar, pero Orders obtiene su propia resolución antes de usarla como autoridad.

D-02: ningún endpoint de salida HTTP requerido. No se elige broker ni almacenamiento. Canales lógicos versionados se enlazarán a la topología del broker al implementar.

D-03: usar MenuItem en rutas, campos, tipos y eventos. Se conserva restaurantId como referencia de ámbito, sin exponer administración de restaurantes. availability-definitions son definiciones calculadas propiedad de Menu, no recursos de Inventory.

D-04: efectos externos posteriores al resultado de resolución se describen solo como contexto. Menu calcula el subtotal unitario, pero no adopta reglas externas de cobro de Orders, un ledger de movimientos ni un esquema de snapshot de Orders. Tampoco condiciona este contrato a endpoints de otros servicios.

Base: CON-MENU-001/002/006/007/009/010; INT-MENU-003/008/009; REQ-MENU-032.
