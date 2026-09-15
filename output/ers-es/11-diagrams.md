[← Índice](./index.md)

# Diagramas de arquitectura y del dominio

Estos diagramas resumen la especificación vigente de Menu después de `Auditoria-4.md`. Son vistas explicativas de los límites y conceptos documentados; no prescriben clases, unidades de despliegue ni un framework. El comportamiento autoritativo permanece en los requisitos, reglas de negocio y esquemas de interfaces.

## C3 — Componentes lógicos de Menu

La vista C3 separa las responsabilidades ya asignadas a Menu de las responsabilidades que permanecen en servicios externos. `MenuItemVariant` es la unidad vendible de un item hoja; `ComboConfiguration` es la unidad vendible de un combo.

```mermaid
C4Component
title C3 — Responsabilidades lógicas dentro de Menu

Container_Boundary(menu, "Menu") {
  Component(catalog, "Gestión del catálogo", "Menu", "Es propietario de Menu, MenuItem, categorías, presentaciones hoja, configuraciones de combo, grupos de personalización y recetas")
  Component(availability, "Proyección de disponibilidad", "Menu", "Construye necesidades de insumos, correlaciona claves opacas y expone elegibilidad vigente")
  Component(resolution, "Resolución vendible", "Menu", "Resuelve una MenuItemVariant o ComboConfiguration, reglas de selección, precio e insumos netos")
  Component(publication, "Publicación del catálogo", "Menu", "Publica datos de catálogo y comportamiento efectivo de modificadores de presentaciones hoja")
  Component(comboReview, "Revisión de combos", "Menu", "Detecta cambios en ComboConfiguration dependientes y confirma tokens de revisión observados")
}

System_Ext(backoffice, "Backoffice", "Crea y edita definiciones de MenuItem")
System_Ext(waiter, "UI de orden", "Selecciona una unidad vendible y prepara una línea de orden")
System_Ext(orders, "Orders", "Es propietario de líneas, snapshots y confirmación")
System_Ext(inventory, "Inventory", "Evalúa disponibilidad de insumos o existencias")
System_Ext(pos, "POS / KDS", "Consume catálogo publicado y comportamiento efectivo de modificadores")

Rel(backoffice, catalog, "Crea y edita")
Rel(catalog, availability, "Publica necesidades de insumos")
Rel(inventory, availability, "Devuelve evaluaciones de disponibilidad")
Rel(waiter, resolution, "Solicita resolución de selección")
Rel(resolution, orders, "Devuelve precio y preparación resuelta")
Rel(orders, resolution, "Solicita validación antes de confirmar")
Rel(publication, pos, "Publica catálogo y modificadores resueltos")
Rel(comboReview, backoffice, "Proporciona revisión pendiente de combos")
Rel(catalog, comboReview, "Proporciona dependencias fijadas de combos")
```

### Cómo leer la vista C3

- `Gestión del catálogo` es propietaria de las definiciones comerciales. No es propietaria de órdenes, existencias ni ajustes finales de Billing.
- `Proyección de disponibilidad` intercambia necesidades y evaluaciones con Inventory mediante claves opacas. Inventory no interpreta MenuItem, presentaciones, recetas, grupos ni espacios.
- `Resolución vendible` recibe `variantId` para una presentación hoja o `configurationId` para un combo; no crea órdenes ni reserva existencias.
- `Publicación del catálogo` es el límite donde los defaults de modificadores y las excepciones de presentaciones hoja se convierten en datos `ResolvedVariantModifier`. POS/KDS y los consumidores de toma de órdenes no resuelven esa precedencia durante la ejecución.
- `Revisión de combos` aplica únicamente a configuraciones de combo dependientes. El historial de versiones de recetas es distinto de la revisión de combos.

## Modelo del dominio

El modelo distingue un item del catálogo de la unidad concreta que se vende al cliente. Un item hoja tiene presentaciones; un combo tiene configuraciones y espacios. Una opción de combo apunta a una presentación hoja y conserva una cantidad física, pero esa cantidad no cambia automáticamente el precio de la configuración.

```mermaid
classDiagram
  class Menu {
    +menuId
    +name
    +description
  }
  class MenuItem {
    +menuItemId
    +type: PREPARED | STOCKED | COMBO
    +status: ACTIVE | INACTIVE
  }
  class MenuItemVariant {
    +variantId
    +unitPrice
    +status: ACTIVE | INACTIVE | ARCHIVED
  }
  class ComboConfiguration {
    +configurationId
    +unitPrice
  }
  class ComboSlot {
    +slotId
    +minSelections
    +maxSelections
  }
  class ComboOption {
    +optionId
    +itemVariantId
    +quantity
    +priceDelta
  }
  class ModifierGroup {
    +groupId
    +minSelections
    +maxSelections
  }
  class ModifierOption {
    +modifierOptionId
    +name
  }
  class ModifierDefaultConfig {
    +priceDelta
    +maxQuantity
    +ingredientEffects
  }
  class VariantModifierConfig {
    +variantId
    +priceDelta
    +maxQuantity
    +ingredientEffects
  }
  class ResolvedVariantModifier {
    +variantId
    +effectivePriceDelta
    +effectiveMaxQuantity
  }
  class RecipeRevision {
    +recipeVersion
    +ingredients
  }
  class OrderLine {
    +variantId OR configurationId
    +quantity
    +unitPrice
  }

  Menu "1" --> "1..*" MenuItem : contiene
  MenuItem "1" --> "0..*" MenuItemVariant : solo PREPARED/STOCKED
  MenuItem "1" --> "0..*" ModifierGroup : posee, solo hoja
  ModifierGroup "1" --> "1..*" ModifierOption : contiene
  ModifierOption "1" --> "1" ModifierDefaultConfig : comportamiento general
  MenuItemVariant "1" --> "0..*" VariantModifierConfig : excepciones opcionales
  ResolvedVariantModifier ..> ModifierDefaultConfig : publica comportamiento efectivo
  ResolvedVariantModifier ..> VariantModifierConfig : usa excepción si existe
  MenuItem "1" --> "1..*" ComboConfiguration : solo COMBO
  ComboConfiguration "1" --> "1..*" ComboSlot : contiene
  ComboSlot "1" --> "0..*" ComboOption : permite
  ComboOption "*" --> "1" MenuItemVariant : apunta a presentación hoja
  MenuItemVariant "0..*" --> "0..1" RecipeRevision : presentación PREPARED
  OrderLine "*" --> "0..1" MenuItemVariant : referencia hoja
  OrderLine "*" --> "0..1" ComboConfiguration : referencia combo
```

### Reglas de precio e identidad mostradas por el modelo

- `MenuItemVariant.unitPrice` es el precio absoluto de una presentación PREPARED o STOCKED.
- `ComboConfiguration.unitPrice` es el precio absoluto de una configuración de combo.
- El subtotal de un combo es el precio de su configuración más los `priceDelta` de sus opciones y los modificadores seleccionados en sus presentaciones hoja. No se agregan los `unitPrice` de los componentes.
- Una línea hoja conserva `variantId`; una línea combo conserva `configurationId`. Dos líneas con la misma identidad de item y unidad vendible siguen siendo distintas cuando sus selecciones son diferentes.
