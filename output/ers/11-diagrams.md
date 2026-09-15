[← Index](./index.md)

# Architecture and domain diagrams

These diagrams summarize the active Menu specification after `Auditoria-4.md`. They are explanatory views of the documented boundaries and concepts; they do not prescribe classes, deployment units or a framework. The authoritative behavior remains in requirements, business rules and interface schemas.

## C3 — Logical components of Menu

The C3 view separates the responsibilities that are already assigned to Menu from the responsibilities that remain with external services. A `MenuItemVariant` is the sellable unit for a leaf item; a `ComboConfiguration` is the sellable unit for a combo.

```mermaid
C4Component
title C3 — Logical responsibilities inside Menu

Container_Boundary(menu, "Menu") {
  Component(catalog, "Catalog management", "Menu", "Owns Menu, MenuItem, categories, leaf presentations, combo configurations, modifier groups and recipes")
  Component(availability, "Availability projection", "Menu", "Builds ingredient needs, correlates opaque keys and exposes current eligibility")
  Component(resolution, "Sellable resolution", "Menu", "Resolves a MenuItemVariant or ComboConfiguration, selection rules, price and net ingredients")
  Component(publication, "Catalog publication", "Menu", "Publishes catalog data and effective modifier behavior for leaf presentations")
  Component(comboReview, "Combo review", "Menu", "Detects dependent ComboConfiguration changes and acknowledges observed review tokens")
}

System_Ext(backoffice, "Backoffice", "Creates and edits MenuItem definitions")
System_Ext(waiter, "Ordering UI", "Selects a sellable unit and prepares an order line")
System_Ext(orders, "Orders", "Owns order lines, snapshots and confirmation")
System_Ext(inventory, "Inventory", "Evaluates ingredient or stock availability")
System_Ext(pos, "POS / KDS", "Consumes published catalog and effective modifier behavior")

Rel(backoffice, catalog, "Creates and edits")
Rel(catalog, availability, "Publishes ingredient needs")
Rel(inventory, availability, "Returns availability evaluations")
Rel(waiter, resolution, "Requests selection resolution")
Rel(resolution, orders, "Returns price and resolved preparation")
Rel(orders, resolution, "Requests validation before confirmation")
Rel(publication, pos, "Publishes catalog and resolved modifiers")
Rel(comboReview, backoffice, "Provides pending combo review")
Rel(catalog, comboReview, "Supplies pinned combo dependencies")
```

### Reading the C3 view

- `Catalog management` is the owner of commercial definitions. It does not own orders, stock balances or final billing adjustments.
- `Availability projection` communicates needs and evaluations with Inventory through opaque keys. Inventory does not interpret MenuItem, variants, recipes, groups or slots.
- `Sellable resolution` receives either a leaf `variantId` or a combo `configurationId`; it does not create an order or reserve stock.
- `Catalog publication` is the boundary where modifier defaults and leaf-presentation exceptions become `ResolvedVariantModifier` data. POS/KDS and order-taking consumers do not infer that precedence at runtime.
- `Combo review` applies only to dependent combo configurations. Recipe version history is a separate concern from combo review.

## Domain model

The model distinguishes a catalog item from the concrete unit sold to a customer. A leaf item has presentations; a combo has configurations and slots. A combo option points to a leaf presentation and includes a physical quantity, but that quantity does not automatically change the combo configuration price.

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

  Menu "1" --> "1..*" MenuItem : contains
  MenuItem "1" --> "0..*" MenuItemVariant : PREPARED/STOCKED only
  MenuItem "1" --> "0..*" ModifierGroup : owns, leaf only
  ModifierGroup "1" --> "1..*" ModifierOption : contains
  ModifierOption "1" --> "1" ModifierDefaultConfig : general behavior
  MenuItemVariant "1" --> "0..*" VariantModifierConfig : optional exceptions
  ResolvedVariantModifier ..> ModifierDefaultConfig : publishes effective behavior
  ResolvedVariantModifier ..> VariantModifierConfig : uses exception when present
  MenuItem "1" --> "1..*" ComboConfiguration : COMBO only
  ComboConfiguration "1" --> "1..*" ComboSlot : contains
  ComboSlot "1" --> "0..*" ComboOption : allows
  ComboOption "*" --> "1" MenuItemVariant : points to leaf presentation
  MenuItemVariant "0..*" --> "0..1" RecipeRevision : PREPARED presentation
  OrderLine "*" --> "0..1" MenuItemVariant : leaf reference
  OrderLine "*" --> "0..1" ComboConfiguration : combo reference
```

### Price and identity rules shown by the model

- `MenuItemVariant.unitPrice` is the absolute price of a PREPARED or STOCKED presentation.
- `ComboConfiguration.unitPrice` is the absolute price of a combo configuration.
- A combo subtotal is its configuration price plus option `priceDelta` values and modifiers selected on its leaf presentations. Component `unitPrice` values are not added.
- A leaf order line retains `variantId`; a combo order line retains `configurationId`. Two lines with the same item and sellable reference remain different when their selections differ.
