[← Index](./index.md)

# Scope and vocabulary

This revision covers the Menu microservice and the explicitly supported obligations of its consumers in the local sources, the delegated closure decisions, the explicit UI request dated 2026-09-13 and `docs/md/Auditoria-4.md`. It is not a complete restaurant-system specification. Audit item numbers are used as direct traceability for the consolidated model; external UI contracts remain open rather than fabricated.

Menu owns commercial definitions, leaf-item presentations, item modifiers, combo configurations and recipes. `PREPARED` and `STOCKED` are leaf `MenuItem` types that share `MenuItemVariant`; `COMBO` is a composition whose sellable units are `ComboConfiguration`. Orders applies line quantities and external order rules, retains the aggregate monetary snapshot and orchestrates preparation delivery to Kitchen. Inventory owns inventory items and stock balances. No direct Menu–Kitchen contract is required. The administrator manages combo review through backoffice reads and explicit acknowledgement. Authority: [ALIGN](../../docs/reviews/ers-interfaces-alignment/decisions.md) as amended by `Auditoria-4.md`; approved authorization conventions remain in interfaces.

## Consumer UI scope

The ordering UI covers assigned-table selection, existing-order context, catalog selection and local pre-order composition. The administrative UI covers catalog management, lifecycle separation, item creation/editing and pending-combo review. These are consumer obligations: they do not make tables, orders, inventory, images or final billing adjustments Menu-owned data. Their confirmed requirements use the `REQ-UI-*`, `BR-UI-*` and `DATA-UI-*` identifiers, while missing external projections remain in `OPEN-011` through `OPEN-019`.

The commercial UI classification applies only to leaf `MenuItem` records and has the confirmed values `DISH` (Platillo), `BEVERAGE` (Bebida), `DESSERT` (Postre) and `COMPLEMENT` (Complemento). `COMBO` is selected as a `MenuItem` type, not as a commercial classification. Leaf `MenuItem` records use `ItemCategory`; combos use the separate `ComboCategory` repository. These categories are not interchangeable with the `MenuItem` type.

Decision sequence: original model and critique (`Problema-Inicial`, pp. 103–133); proposal, external review and correction (`Modelo-Final`, pp. 6–52); review and final recommendations (`Auditoria-3`, pp. 1–9); consolidated model correction (`Auditoria-4`, items 1–46). Repeated passages are not independent decisions. `Auditoria-4` supersedes the earlier all-variants modifier configuration, fixed-price combo option and combo-as-variant interpretations. Variant prices and combo-configuration prices are absolute. The consultant verdict does not establish complete operational contracts.

| Concept                         | Meaning                                                                                                                                                                |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Menu                            | Restaurant-owned menu/catalog with an identity, name and description.                                                                                                  |
| MenuItem                        | One catalog item in a `Menu`; its type is `PREPARED`, `STOCKED` or `COMBO`.                                                                                            |
| Leaf item                       | A `MenuItem` of type `PREPARED` or `STOCKED`; it is sold through one or more `MenuItemVariant` records.                                                                |
| PreparedItem / StockedItem      | Technical names for leaf `MenuItem` types. Both contain one or more concrete `MenuItemVariant` records.                                                                |
| Combo                           | Commercial composition of `ComboConfiguration`, `ComboSlot` and `ComboOption`; it is not a leaf variant.                                                               |
| MenuItemVariant                 | Concrete sellable presentation of a PREPARED or STOCKED leaf `MenuItem` with an absolute `unitPrice` and its own fulfillment definition.                               |
| Default variant                 | Technical presentation used when a leaf `MenuItem` has no customer-selectable presentation characteristics; it is not the same as an optional customer-facing default. |
| ComboConfiguration              | Concrete sellable configuration of a combo with an absolute `unitPrice` and one or more selection slots.                                                               |
| VariantDimension / VariantValue | Technical names for a named presentation characteristic and one of its values, such as size and Large.                                                                 |
| STOCKED / PREPARED / COMBO      | `MenuItem` types selected as the first backoffice decision; the first two are leaf fulfillment types and COMBO is a composition.                                       |
| ComboSlot / ComboOption         | Selection slot and included option with a pinned leaf `MenuItemVariant`, positive `quantity` and optional commercial `priceDelta` contribution.                        |
| ModifierGroup / ModifierOption  | Customization group and option owned by a leaf `MenuItem`. `ModifierOption` contains the general/default behavior.                                                     |
| VariantModifierConfig           | Optional exception for a `ModifierOption` on one leaf variant; it exists only when the effective behavior differs from the default.                                    |
| ResolvedVariantModifier         | Published effective modifier projection consumed by POS/KDS; it removes default/exception resolution from order-taking.                                                |
| IngredientEffect                | Measured addition (ADD) or ingredient omission (OMIT).                                                                                                                 |
| Recipe / RecipeComponent        | Identified and versioned recipe, and its ingredients with quantity and unit.                                                                                           |
| inventoryItemId                 | Logical reference to an Inventory-owned item; no storage type is prescribed.                                                                                           |

Sources: `docs/md/Problema-Inicial.md` pp. 108–111; `docs/md/Modelo-Final.md` pp. 6–23, 26–52; `docs/md/Auditoria-3.md` pp. 8–9; `docs/md/Auditoria-4.md` items 1–46.

## Delegated closure scope

Consultoria-2 (pp. 9–16), Consultoria-rendimiento and the [closure decisions](../../docs/md/Decisiones-cierre-invariantes.md) remain incorporated. Inventory computes availability using opaque keys and ingredients; Menu retains leaf-presentation and combo-configuration meaning. Orders retains snapshots and requests movements; POS/KDS participates in performance acceptance. These are external commitments, not internal Menu functions. `MenuItem` ACTIVE/INACTIVE remains administrative; leaf presentations add ARCHIVED. Recipe revisions are explicitly pinned in definitions. A leaf order line always retains its selected presentation; a combo line retains its selected combo configuration.
