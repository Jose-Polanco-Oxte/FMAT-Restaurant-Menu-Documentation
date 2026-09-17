# Issues Tracker

Format for each issue:

```md
## [Issue Title]

Description: 

[Describe the issue, ambiguity, or missing information]

Source: [Reference the SRS section, page, or artifact that is ambiguous or missing information]

Status: [Open | Closed | Deferred]
```

## Missing Human Actor, Role, and Permission Assignments

Description:

The SRS defines generic system-level actors (`ADMINISTRATOR`, `POS_CLIENT`, `KDS_CLIENT`) and outlines administrative and consultation operations, but lacks human role definitions, granular permissions, authentication boundaries, and authorization policies (such as separating catalog creation, pricing changes, recipe management, and combo review approval across roles).

- Affected Views / Flows / Controls: All administrative views (`MenuCatalogAdministrationView`, `MenuItemEditorView`, `RecipeEditorView`, `ModifierConfigurationView`, `ComboConfigurationView`, `ComboReviewView`), all administrative interaction flows (`manage-menu-item.md`, `manage-recipe.md`, `manage-modifiers.md`, `manage-combo.md`, `review-combo.md`), control `archiveVariantAction`, and high-impact actions (`saveMenuItemInactive`, `saveAndActivateMenuItem`, `confirmSelectedReviewsAction`).
- Missing Information: Role-based access control (RBAC) model, user credential/identity mechanisms, specific permission tags per view and action, and workflow approval gates for high-impact commercial operations.

Source: `output/ers/spec.md` §3.1, §4.1 (REQ-MENU-ITM-001, REQ-MENU-ITM-002), §4.10 (REQ-MENU-REV-002, REQ-MENU-REV-003), §10.2, §10.3

Status: Open

## Undefined Global Navigation and Application Shell Entry Points

Description:

The SRS specifies functional interactions and view boundaries but does not define the global application shell architecture, persistent navigation structures, hierarchical view transitions, or deep-linking URL routing hierarchies.

- Affected Views / Flows / Controls: Global navigation model (`screen-navigation.md`), all view entry and exit transitions across `CatalogBrowseView`, `MenuCatalogAdministrationView`, and nested contextual editors.
- Missing Information: Global application navigation hierarchy, shell layout boundaries, route path definitions (e.g., `/admin/catalog`, `/admin/items/:id/edit`), session persistence across navigation, and standard back/cancel/exit routing destinations.

Source: `output/ers/spec.md` §3.1, §10.1, §10.2, §12.3; `docs/requests/create-ui-spec.md` §5
  
Status: Open

## Undefined Category Administration and Search Semantics

Description:

While `MenuItem` includes `itemCategory` and catalog consultation assumes category-based grouping and filtering, the SRS provides no requirements or interfaces for category lifecycle management (creating, renaming, ordering, archiving, or deleting categories). In addition, search semantics across the catalog (exact match vs tokenized substring search, case sensitivity, diacritic/accent normalization, and search indexing fields) are left unspecified.

- Affected Views / Flows / Controls: `CatalogBrowseView.yaml` (`catalogSearch`, `categoryFilter`), `MenuItemEditorView.yaml` (`categorySelector`), `browse-catalog.md` (`FilterAction`), `manage-menu-item.md` (`ConfigureNewItemIdentity`).
- Missing Information: Data model and CRUD operations for categories (`ItemCategory`, `ComboCategory`), display ordering rules for category organization and filtering, and algorithmic specification for catalog keyword search and matching.

Source: `output/ers/spec.md` §4.1 (REQ-MENU-ITM-001), §4.3 (REQ-MENU-PRC-002), §7.2 (`MenuItem.itemCategory`), §10.1, §14.1

Status: Open

## Missing Image Reference Acquisition and Upload Interface

Description:

The SRS models `image_url` / `imageReference` on `MenuItem` strictly as an opaque string URI. There is no specification for image asset acquisition, validation, or upload mechanisms (e.g., direct file asset provision, media service integration, supported formats, file size limits, aspect ratios, or thumbnail generation).

- Affected Views / Flows / Controls: `MenuItemEditorView.yaml` (`imageRefInput`), `manage-menu-item.md` (`ConfigureNewItemIdentity`).
- Missing Information: Media storage service integration contract, asset acquisition workflow, file validation criteria (MIME types, max file size, dimensions), and fallback placeholder behaviors when an image reference is null, invalid, or fails to load.

Source: `output/ers/spec.md` §4.1 (REQ-MENU-ITM-001), §7.2 (`MenuItem.image_url`), §9.1 (`MenuItem.image_url`)

Status: Open

## Missing Inventory Item and Recipe Discovery Interface

Description:

The SRS models `inventoryItemId` (in `MenuItemVariant` for `STOCKED` items and `RecipeComponent` for recipes) and `recipeRevisionId` as opaque external string identifiers without providing search, browsing, or selection interfaces from external services (Inventory or Recipe Catalog). In the current specification, administrators must supply or enter raw opaque identifiers without lookup or validation against active stock catalogs.

- Affected Views / Flows / Controls: `MenuItemEditorView.yaml` (`updateStockedSupplyControl`, `associateRecipeRevisionInput`), `RecipeEditorView.yaml` (`componentInventoryItemIdInput`), `manage-menu-item.md` (`ConfigStockedSupply`, `ConfigPreparedSupply`), `manage-recipe.md` (`ConfigureOpaqueInventoryId`).
- Missing Information: External discovery, lookup, or selection mechanisms for Inventory items (inspecting available stock items, descriptive names, and units of measure) and Recipe revisions (resolving recipe identity, descriptive name, and revision metadata) to avoid unvalidated manual entry of opaque identifiers.

Source: `output/ers/spec.md` §4.4 (REQ-MENU-FUL-001, REQ-MENU-FUL-002, REQ-MENU-FUL-003), §9.3, §12.1

Status: Open

## Unspecified UI Input Maxima and Text Length Limits (OPEN-010)

Description:

As formally documented in SRS `OPEN-010`, the SRS establishes non-negativity (>= 0) and logical inequalities (0 <= minSelections <= maxSelections), but omits upper bounds for monetary prices, price deltas, maximum selectable quantities, and text length limits (character counts for item names, descriptions, dimension names, variant values, modifier group names, and combo slot names). It also lacks internationalization (i18n) and currency formatting standards (currency symbol placement, decimal separators, rounding rules).

- Affected Views / Flows / Controls: `MenuItemEditorView.yaml`, `ModifierConfigurationView.yaml`, `ComboConfigurationView.yaml`, `RecipeEditorView.yaml`, `SellableItemConfigurationView.yaml`, and text/numeric input controls across all views.
- Missing Information: Upper numeric thresholds for prices and quantities, maximum character lengths for textual attributes, currency code (`ISO 4217`), locale formatting rules, and frontend validation constraint patterns.

Source: `output/ers/spec.md` §4.1, §4.2, §4.3, §4.5, §4.6, §13.4 (OPEN-010)

Status: Open

## Undefined Combo Slot Matching and Partial Collision Resolution (OPEN-002)

Description:

As recorded in SRS `OPEN-002`, when performing bulk copy operations of combo slots and options across configurations of different topology or cardinality, the SRS does not define an automatic slot matching algorithm (e.g., matching by exact slot name vs positional index) nor the granular rollback/reconciliation policy for partial collisions when simple atomic `FAIL` or `REPLACE` strategies are insufficient or undefined for heterogeneous target slots.

- Affected Views / Flows / Controls: `ComboConfigurationView.yaml` (`executeCopyConfigurationAction`, `executeBulkOptionAssignmentAction`), `manage-combo.md` (`RecordCopyConflictIssue`, `SpecifyTargetSlotName`, `ExecuteConfigurationCopy`, `ExecuteBulkAssignmentAction`).
- Missing Information: Business heuristics for matching slots between disparate combo configurations, conflict handling rules for existing slots with conflicting options, and semantic workflow for manual slot mapping or partial failure recovery.
  
Source: `output/ers/spec.md` §4.6 (REQ-MENU-COM-004, REQ-MENU-COM-005), §10.2, §13.1 (OPEN-002)

Status: Open

## Unresolved Advanced Combo Pricing Behavior (OPEN-009)

Description:

As recorded in SRS `OPEN-009`, the specification does not define commercial pricing rules for advanced combo scenarios, specifically: (a) fractionated components (e.g., half-portions of an item delivered within a combo bundle), (b) multiple or repeated selections of an extra-cost modifier across different slots or leaf components within the same combo instance (e.g., whether modifier price deltas are charged once, accumulated per leaf component, or subjected to bundle discounts/caps), and (c) how modifier price deltas apply when customizing fractionated leaf components within combos, even though modifier selections are correlated to each specific leaf component variant within the combo structure.

- Affected Views / Flows / Controls: `SellableItemConfigurationView.yaml` (`comboComponentModifierQuantityAdjuster`, `confirmSelection`), `ComboConfigurationView.yaml`, `ComboReviewView.yaml` (slot informational pricing reference `saved` / `current` / `difference`), `configure-sellable-item.md` (`AdjustComboComponentModifierQty`, `EmitPayload`), `review-combo.md` (`StateSlotPriceInspected`).
- Missing Information: Pricing calculation algorithms for fractionated portions, repetition discount or aggregation rules for modifier selections correlated across leaf components within combos, and their presentation in informational slot price calculations under REQ-MENU-REV-005.

Source: `output/ers/spec.md` §4.6 (REQ-MENU-COM-001, REQ-MENU-COM-002), §4.10 (REQ-MENU-REV-005), §13.3 (OPEN-009)

Status: Open

## Undefined Menu-to-Orders Configured Selection Handoff Contract

Description:

The SRS explicitly excludes order management, cart lifecycle, and checkout from the Menu bounded context, assigning them to Orders. While the UI specification models the semantic handoff upon selection confirmation—capturing either a configured leaf item variant or a combo selection with chosen slot options and component-level modifier customizations correlated by leaf component (`slotId`, `comboOptionId`/`itemVariantId`, `modifierGroupId`, `modifierOptionId`, quantity, and signed `priceDelta`) alongside running price snapshots—the exact technical interface, serialization schema, and transmission mechanism (`ConfiguredSelectionHandoff`) between Menu and Orders are not formally defined in the SRS or external boundary contracts.

- Affected Views / Flows / Controls: `SellableItemConfigurationView.yaml` (`confirmSelection`), `configure-sellable-item.md` (`ConfirmSelection`, `EmitPayload`).
- Missing Information: Payload technical data contract, serialization format, snapshot structure (holding unit price, revision/version tokens, and leaf or combo component modifier selections), and client-side communication channel (e.g., callback, event emission, or message passing) between the Menu selection interface and the Orders host application.

Source: `output/ers/spec.md` §3.2, §4.8 (REQ-MENU-ING-001), §10.4, §12.2, §12.3, §13.2 (OPEN-007)

Status: Open
