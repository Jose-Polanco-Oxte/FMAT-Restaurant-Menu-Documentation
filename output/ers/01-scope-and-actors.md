[← Index](./index.md)

# Scope and vocabulary

This revision covers the Menu microservice and explicitly supported obligations of its consumers in the local sources and the delegated closure decisions. It is not a complete restaurant-system specification. Page citations refer to the Markdown source page markers; no external requirements were introduced.

Menu owns commercial definitions, variants, customizations, combo configurations, recipes and the resolved unit subtotal. Orders applies line quantities and external order rules, retains the aggregate monetary snapshot and orchestrates preparation delivery to Kitchen. Inventory owns inventory items and stock balances. No direct Menu–Kitchen contract is required. The administrator manages combo review through backoffice reads and explicit acknowledgement. Authority: [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md); approved authorization conventions remain in interfaces.

Decision sequence: original model and critique (`Problema-Inicial`, pp. 103–133); proposal, external review and correction (`Modelo-Final`, pp. 6–52); review and final recommendations (`Auditoria-3`, pp. 1–9). Repeated passages are not independent decisions. Later corrections replace variant delta pricing with absolute pricing and move modifier price, cap and effects into the variant configuration. The consultant verdict does not establish complete operational contracts.

| Concept | Meaning |
| --- | --- |
| Menu | Product grouping with a restaurant reference, name and description. |
| MenuItem | Commercial product with metadata, administrative status and fulfillment classification. |
| MenuItemVariant | Concrete sellable presentation with an absolute price and its own fulfillment. |
| Default variant | Presentation for a product without selectable dimensions; DEFAULT is a conceptual label, not a mandated global identifier. |
| VariantDimension / VariantValue | Product variation axis and a value selected by a variant. |
| STOCKED / PREPARED / COMBO | Fulfillment through an inventory item, recipe or component selection slots. |
| ComboSlot / ComboOption | Selection slot and included option with a pinned STOCKED/PREPARED variant and supplied quantity; no option price adjustment. |
| ModifierGroup / ModifierOption | Customization group and option owned by a product. |
| VariantModifierConfig | Option behavior on a variant: price adjustment, maximum selectable quantity and effects. |
| IngredientEffect | Measured addition (ADD) or ingredient omission (OMIT). |
| Recipe / RecipeComponent | Identified and versioned recipe, and its ingredients with quantity and unit. |
| inventoryItemId | Logical reference to an Inventory-owned item; no storage type is prescribed. |

Sources: `docs/md/Problema-Inicial.md` pp. 108–111; `docs/md/Modelo-Final.md` pp. 6–23, 26–52; `docs/md/Auditoria-3.md` pp. 8–9.

## Delegated closure scope

Consultoria-2 (pp. 9–16), Consultoria-rendimiento and the [closure decisions](../../docs/md/Decisiones-cierre-invariantes.md) are incorporated. Inventory computes availability using opaque keys and ingredients; Menu retains variant and combo meaning. Orders retains snapshots and requests movements; POS/KDS participates in performance acceptance. These are external commitments, not internal Menu functions. Product ACTIVE/INACTIVE remains administrative; variants add ARCHIVED. Recipe revisions are explicitly pinned in definitions.
