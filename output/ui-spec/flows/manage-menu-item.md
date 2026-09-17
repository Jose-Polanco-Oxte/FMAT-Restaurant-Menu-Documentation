---
id: manage-menu-item
name: Manage Menu Item
actors:
  - ADMINISTRATOR
views:
  - MenuCatalogAdministrationView
  - MenuItemEditorView
  - RecipeEditorView
  - ModifierConfigurationView
  - ComboConfigurationView
  - ComboReviewView
requirements:
  - REQ-MENU-ITM-001
  - REQ-MENU-ITM-002
  - REQ-MENU-VAR-001
  - REQ-MENU-VAR-002
  - REQ-MENU-VAR-003
  - REQ-MENU-VAR-004
  - REQ-MENU-VAR-005
  - REQ-MENU-VAR-006
  - REQ-MENU-PRC-001
  - REQ-MENU-PRC-002
  - REQ-MENU-PRC-003
  - REQ-MENU-FUL-001
  - REQ-MENU-FUL-002
  - REQ-MENU-FUL-003
  - REQ-MENU-FUL-004
  - REQ-MENU-LIF-001
  - REQ-MENU-LIF-002
  - REQ-MENU-LIF-003
  - REQ-MENU-VER-001
  - REQ-MENU-REV-001
  - REQ-MENU-REV-002
  - REQ-MENU-MOD-001
  - REQ-MENU-COM-001
  - REQ-MENU-COM-006
  - BR-MENU-018
  - INV-MENU-001
  - INV-MENU-004
---

# Flow: Manage Menu Item

```mermaid
flowchart TD
    subgraph MenuCatalogAdministrationView["MenuCatalogAdministrationView"]
        CatalogEntry(["Entry: ADMINISTRATOR<br/>(Inputs: optional menuId, initialSearchTerm, initialFilterStatus)"])
        CatalogMonitoring["Administrative Catalog Monitoring<br/>Display items with orthogonal status dimensions:<br/>administrativeStatus (ACTIVE / INACTIVE),<br/>isStructurallyEligible, isAvailable, currentRevision, reviewStatus<br/>[data: administrativeCatalogItems]<br/>[REQ-MENU-ITM-001, REQ-MENU-ITM-002, REQ-MENU-PRC-003, REQ-MENU-AVL-007]"]

        DirectStatusToggle["Direct administrative status toggle<br/>[control: transitionStatusAction, action: transitionAdministrativeStatus]<br/>[REQ-MENU-ITM-002]"]
        CheckDirectToggleTarget{"Target administrative status?<br/>[REQ-MENU-ITM-002]"}
        CheckDirectStructuralEligibility{"Item satisfies structural eligibility?<br/>(>= 1 eligible unit, complete supply, capacity met)<br/>[REQ-MENU-PRC-003, REQ-MENU-VAR-006, REQ-MENU-COM-006]"}
        DirectActivationBlocked["Validation Failure: Activation rejected.<br/>Item lacks eligible sellable units or has structural deficits.<br/>Item is NOT silently activated; remains INACTIVE.<br/>[REQ-MENU-ITM-002, REQ-MENU-PRC-003]"]
        DirectActivationSuccess["Transition to ACTIVE accepted.<br/>administrativeStatus = ACTIVE.<br/>Produce new immutable revision (format: number_ISO8601).<br/>Item published to active catalog.<br/>[REQ-MENU-ITM-002, REQ-MENU-VER-001, REQ-MENU-AVL-001]"]
        DirectDeactivationSuccess["Transition to INACTIVE accepted.<br/>administrativeStatus = INACTIVE.<br/>Produce new immutable revision (format: number_ISO8601).<br/>Item excluded from active customer sales.<br/>[REQ-MENU-ITM-002, REQ-MENU-VER-001]"]

        CatalogReviewNotice["Downstream review notice:<br/>pendingReviewNotice active if any COMBO reviewStatus == REVIEW_REQUIRED.<br/>(CRITICAL: Dependent COMBO administrativeStatus remains UNCHANGED)<br/>[REQ-MENU-REV-002, REQ-MENU-LIF-001]"]

        InitiateCreateItem["Initiate item creation<br/>[control: createItemAction, action: createMenuItem]<br/>(Emits createItemSignal)<br/>[REQ-MENU-ITM-001]"]
        InitiateInspectItem["Inspect existing item<br/>[control: inspectItemAction, action: inspectMenuItem]<br/>(Emits selectedMenuItemId)<br/>[REQ-MENU-ITM-001]"]
    end

    subgraph MenuItemEditorView["MenuItemEditorView"]
        EditorEntry(["Editor Entry<br/>(Inputs: optional menuItemId, initialItemType, initialMenuId)"])
        CheckCreationMode{"Is new item creation?<br/>(menuItemId == null)<br/>[REQ-MENU-ITM-001]"}

        %% Commercial Identity & Type Configuration
        ConfigureNewItemIdentity["State: creationNewItem<br/>Configure commercial identity: name, description, imageRef, category.<br/>Select immutable type discriminator: PREPARED, STOCKED, or COMBO.<br/>[controls: nameInput, descriptionInput, imageRefInput, categorySelector, itemTypeSelector]<br/>[REQ-MENU-ITM-001, BR-MENU-018]"]
        InspectExistingItemIdentity["State: editingExistingItem<br/>Inspect and edit commercial identity fields.<br/>Type discriminator locked and immutable (isTypeImmutable = true).<br/>[data: menuItemIdentity, currentRevision]<br/>[REQ-MENU-ITM-001, C-MIE-001]"]

        CheckItemType{"MenuItem type discriminator?<br/>[REQ-MENU-ITM-001, C-MIE-002]"}

        %% ----------------- LEAF PRODUCTS (PREPARED / STOCKED) -----------------
        CheckLeafVariantMode{"Does leaf item define commercial dimensions?<br/>[REQ-MENU-VAR-001, REQ-MENU-VAR-002]"}

        %% Sub-branch: Single Default Variant
        DefaultVariantMode["State: singleDefaultVariantMode<br/>Single technical DEFAULT variant generated automatically.<br/>Dimensional variant selection suppressed from consumer UI.<br/>[data: defaultVariantState, leafVariants]<br/>[REQ-MENU-VAR-001, REQ-MENU-VAR-005]"]
        SetDefaultVariantPrice["Configure authoritative absolute unitPrice (>= 0)<br/>[control: updateVariantPriceInput, action: setVariantUnitPrice]<br/>[REQ-MENU-PRC-001]"]
        AddDimensionsToDefault["Define VariantDimensions and VariantValues<br/>[controls: addDimensionAction, addDimensionValueAction]<br/>[REQ-MENU-VAR-002, REQ-MENU-VAR-003]"]
        CheckMigrationEligibility{"Dimensions defined with >= 2 values?<br/>(canMigrateToExplicit == true)<br/>[REQ-MENU-VAR-005]"}
        ExecuteDefaultMigration["Execute atomic DEFAULT migration:<br/>Archive technical DEFAULT variant (status = ARCHIVED);<br/>Activate explicit presentations in a single atomic revision.<br/>[control: migrateDefaultVariantAction, action: migrateDefaultVariantToExplicit]<br/>[REQ-MENU-VAR-005, REQ-MENU-VER-001]"]

        %% Sub-branch: Multi-Variant Configuration
        MultiVariantMode["State: multipleVariantsConfigured<br/>Manage dimensions, values, and explicit sellable variants.<br/>[data: variantDimensions, leafVariants]<br/>[REQ-MENU-VAR-002, REQ-MENU-VAR-004]"]
        ManageDimensionsAndValues["Add dimensions and dimension values<br/>(Unique names enforced within item)<br/>[controls: addDimensionAction, addDimensionValueAction]<br/>[REQ-MENU-VAR-002, REQ-MENU-VAR-003]"]
        CreateExplicitVariant["Define sellable variant with unique combination of values<br/>and authoritative absolute unitPrice (>= 0)<br/>[control: createVariantAction, action: createLeafVariant]<br/>[REQ-MENU-VAR-004, REQ-MENU-PRC-001]"]
        UpdateVariantUnitPrice["Update authoritative absolute unitPrice (>= 0)<br/>(Item basePrice discontinued; priced per variant)<br/>[control: updateVariantPriceInput, action: setVariantUnitPrice]<br/>[REQ-MENU-PRC-001, C-MIE-003]"]

        %% Variant Archival
        ArchiveLeafVariant["Archive variant: status = ARCHIVED.<br/>Irreversible; excludes variant from new customer sales.<br/>Dependent ComboOptions become ineligible.<br/>[control: archiveVariantAction, action: archiveLeafVariant]<br/>[REQ-MENU-LIF-001]"]
        DownstreamComboWork["Downstream review impact:<br/>Dependent ComboConfigurations marked REVIEW_REQUIRED if slot capacity broken.<br/>CRITICAL: Dependent COMBO administrativeStatus remains UNCHANGED.<br/>[REQ-MENU-LIF-001, REQ-MENU-REV-001, C-MIE-007]"]

        %% Leaf Supply Configuration
        CheckSupplyType{"Leaf product type discriminator?<br/>[REQ-MENU-FUL-001, REQ-MENU-FUL-002]"}
        ConfigStockedSupply["STOCKED: Specify opaque inventoryItemId (SKU)<br/>and physical stockedQuantity (> 0).<br/>[control: updateStockedSupplyControl, action: configureStockedSupply]<br/>[REQ-MENU-FUL-001, REQ-MENU-VAR-006]"]
        ConfigPreparedSupply["PREPARED: Link immutable recipeRevisionId (format: number_ISO8601).<br/>[control: associateRecipeRevisionInput, action: associateRecipeRevision]<br/>[REQ-MENU-FUL-002, REQ-MENU-VAR-006]"]
        CheckRecipeRevisionCurrent{"Is linked recipe revision up to date?<br/>(recipeRevisionId == latestRecipeRevisionAvailable)<br/>[REQ-MENU-FUL-002, REQ-MENU-REV-001]"]
        RecipeRevisionCurrent["Linked recipe revision is current<br/>[isRecipeRevisionAdopted = true]"]
        RecipeRevisionPending["State: recipeRevisionUpdatePending<br/>Newer recipe revision available in Recipe aggregate.<br/>[isRecipeRevisionAdopted = false]<br/>[REQ-MENU-FUL-004, REQ-MENU-REV-001]"]
        AdoptRecipeRevision["Explicit administrative adoption of new recipe revision:<br/>Updates variant.recipeRevisionId.<br/>(Adoption is explicit; variants do not auto-track revisions).<br/>[control: adoptRecipeRevisionAction, action: adoptNewRecipeRevision]<br/>[REQ-MENU-FUL-004, REQ-MENU-VER-001, REQ-MENU-REV-001]"]

        %% Contextual Transitions from Leaf Item
        TriggerRecipeEditor["Contextual navigation to Recipe Editor<br/>(Payload: optional recipeId or recipeRevisionId, returnContext: MenuItemEditorView)<br/>[control: navigateToRecipeEditorAction, action: navigateToRecipeEditor]<br/>(Emits navigateToRecipeEditorSignal)<br/>[REQ-MENU-FUL-003]"]
        TriggerModifierConfig["Contextual navigation to Modifier Configuration<br/>(Payload: menuItemId, optional initialVariantId, returnContext: MenuItemEditorView)<br/>[control: navigateToModifierConfigurationAction]<br/>[REQ-MENU-MOD-001]"]

        %% ----------------- COMBO PRODUCTS (PACKAGES) -----------------
        ComboItemMode["State: editingComboItem<br/>Leaf variants, dimensions, recipes, inventory references, and modifiers suppressed.<br/>Display comboConfigurationsSummary (counts, structural eligibility, review status).<br/>[data: comboConfigurationsSummary]<br/>[REQ-MENU-COM-001, C-MIE-002]"]
        TriggerComboConfig["Contextual navigation to Combo Configuration<br/>(Payload: menuItemId, optional initialConfigurationId, returnContext: MenuItemEditorView)<br/>[control: navigateToComboConfigurationAction]<br/>[REQ-MENU-COM-001, REQ-MENU-COM-006]"]

        %% ----------------- SAVE, VALIDATION & OUTCOMES -----------------
        SelectSaveOrExit{"Administrative save or exit action?<br/>[REQ-MENU-ITM-001, REQ-MENU-ITM-002, REQ-MENU-LIF-002]"}

        %% Cancel
        ExecuteCancel["Cancel edit: discard working buffer changes.<br/>(Emits returnToCatalogSignal; no revision generated)<br/>[control: cancelEditAction, action: cancelEdit]<br/>[REQ-MENU-ITM-001]"]

        %% Save Draft Inactive
        ExecuteSaveInactive["Save MenuItem in INACTIVE administrative status.<br/>Permits incomplete definitions (missing supply / capacity deficits).<br/>[control: saveDraftInactiveAction, action: saveMenuItemInactive]<br/>[REQ-MENU-LIF-002]"]
        CheckCapacityDeficits{"Are there capacity deficits in modifier groups or combo slots?<br/>(calculatedCapacity < minSelections)<br/>[REQ-MENU-LIF-003]"]
        EmitCapacityWarnings["State: inactiveWithCapacityWarnings<br/>Display structured incompleteCapacityWarnings:<br/>entityId, entityType, entityName, minSelections, calculatedCapacity, deficit.<br/>[data: incompleteCapacityWarnings]<br/>[REQ-MENU-LIF-003]"]
        PersistInactiveItem["Persist MenuItem with administrativeStatus = INACTIVE.<br/>Generate new immutable commercial revision (format: number_ISO8601).<br/>Emit savedMenuItemId, newRevisionToken, and returnToCatalogSignal.<br/>[REQ-MENU-LIF-002, REQ-MENU-VER-001]"]

        %% Save and Activate
        ExecuteSaveActive["Save and Activate MenuItem.<br/>Validate complete structural capacity and preconditions.<br/>[control: saveAndActivateAction, action: saveAndActivateMenuItem]<br/>[REQ-MENU-ITM-002, REQ-MENU-PRC-003]"]
        EvaluateActiveStructuralIntegrity{"Validate structuralValidationStatus.isEligibleForActive:<br/>1. At least 1 eligible sellable unit [REQ-MENU-PRC-003]<br/>2. Leaf: active variants have complete supply [REQ-MENU-VAR-006]<br/>3. Leaf: mandatory modifier groups capacity >= minSelections [REQ-MENU-MOD-001]<br/>4. Combo: >= 1 configuration eligible & mandatory slots capacity >= minSelections [REQ-MENU-COM-006]"}
        ActiveValidationRejected["Validation Error: Transition to ACTIVE rejected.<br/>Display blockingValidationErrors in UI.<br/>Item is NOT silently activated; remains INACTIVE / unpersisted.<br/>Administrator must correct structural errors or save as INACTIVE draft.<br/>[REQ-MENU-ITM-002, REQ-MENU-PRC-003]"]
        PersistActiveItem["State: activeStructurallyComplete<br/>Persist MenuItem with administrativeStatus = ACTIVE.<br/>Generate new immutable commercial revision (format: number_ISO8601).<br/>Emit savedMenuItemId, newRevisionToken, and returnToCatalogSignal.<br/>[REQ-MENU-ITM-002, REQ-MENU-VER-001]"]
    end

    %% ----------------- CONTEXTUAL EXTERNAL VIEWS -----------------
    subgraph RecipeEditorView["RecipeEditorView"]
        RecipeAuthoring["Author culinary recipe components:<br/>opaque inventoryItemId, positive quantity, measurement unit.<br/>Saving produces new immutable recipe revision (format: number_ISO8601).<br/>Never mutates earlier revisions; variants retain prior revision until explicit adoption.<br/>[REQ-MENU-FUL-003, REQ-MENU-FUL-004, INV-MENU-004]"]
        ReturnFromRecipe["Return to MenuItemEditorView<br/>(Emits returnToOriginSignal, savedRecipeId, newRecipeRevisionId)"]
    end

    subgraph ModifierConfigurationView["ModifierConfigurationView"]
        ModifierConfigAuthoring["Configure modifier groups, options, selection boundaries (min/max),<br/>per-variant overrides, and ingredientEffects (ADD / OMIT / empty-effect).<br/>[REQ-MENU-MOD-001 to REQ-MENU-MOD-008]"]
        ReturnFromModifierConfig["Return to MenuItemEditorView<br/>(Emits returnToItemEditorSignal, updated modifier summary)"]
    end

    subgraph ComboConfigurationView["ComboConfigurationView"]
        ComboConfigAuthoring["Configure ComboConfigurations, ComboSlots (min/max selections),<br/>and ComboOptions referencing leaf variants directly (itemVariantId).<br/>[REQ-MENU-COM-001 to REQ-MENU-COM-006]"]
        ReturnFromComboConfig["Return to MenuItemEditorView<br/>(Emits returnToItemEditorSignal, updated combo summary)"]
    end

    subgraph ComboReviewView["ComboReviewView"]
        ReviewCombosWork["Inspect combos with reviewStatus == REVIEW_REQUIRED.<br/>Review observed reviewToken and pending component changes.<br/>(Review confirmation never alters combo administrative status or commercial prices).<br/>[REQ-MENU-REV-001 to REQ-MENU-REV-005]"]
    end

    %% ----------------- EDGES & TRANSITIONS -----------------

    %% Catalog administration entry & actions
    CatalogEntry --> CatalogMonitoring
    CatalogMonitoring --> DirectStatusToggle
    DirectStatusToggle --> CheckDirectToggleTarget

    CheckDirectToggleTarget -->|Target: ACTIVE| CheckDirectStructuralEligibility
    CheckDirectStructuralEligibility -->|isStructurallyEligible == false| DirectActivationBlocked
    DirectActivationBlocked --> CatalogMonitoring
    CheckDirectStructuralEligibility -->|isStructurallyEligible == true| DirectActivationSuccess
    DirectActivationSuccess --> CatalogMonitoring

    CheckDirectToggleTarget -->|Target: INACTIVE| DirectDeactivationSuccess
    DirectDeactivationSuccess --> CatalogMonitoring

    CatalogMonitoring -->|hasPendingReviews == true| CatalogReviewNotice
    CatalogReviewNotice -->|inspectCombosRequiringReviewAction| ReviewCombosWork

    CatalogMonitoring -->|createItemAction| InitiateCreateItem
    CatalogMonitoring -->|inspectItemAction| InitiateInspectItem

    InitiateCreateItem --> EditorEntry
    InitiateInspectItem --> EditorEntry

    %% Editor entry & identity
    EditorEntry --> CheckCreationMode
    CheckCreationMode -->|menuItemId == null (New Item)| ConfigureNewItemIdentity
    ConfigureNewItemIdentity --> CheckItemType

    CheckCreationMode -->|menuItemId != null (Existing Item)| InspectExistingItemIdentity
    InspectExistingItemIdentity --> CheckItemType

    %% Type discriminator branching
    CheckItemType -->|PREPARED or STOCKED (Leaf Product)| CheckLeafVariantMode
    CheckItemType -->|COMBO (Package Product)| ComboItemMode

    %% Leaf item: Single DEFAULT variant path
    CheckLeafVariantMode -->|No commercial dimensions (Single default)| DefaultVariantMode
    DefaultVariantMode --> SetDefaultVariantPrice
    SetDefaultVariantPrice --> AddDimensionsToDefault
    AddDimensionsToDefault --> CheckMigrationEligibility
    CheckMigrationEligibility -->|canMigrateToExplicit == true| ExecuteDefaultMigration
    ExecuteDefaultMigration --> MultiVariantMode
    CheckMigrationEligibility -->|Dimensions not yet complete| CheckSupplyType

    %% Leaf item: Multi-variant path
    CheckLeafVariantMode -->|Commercial dimensions defined| MultiVariantMode
    MultiVariantMode --> ManageDimensionsAndValues
    ManageDimensionsAndValues --> CreateExplicitVariant
    CreateExplicitVariant --> UpdateVariantUnitPrice
    UpdateVariantUnitPrice --> CheckSupplyType

    %% Variant archival
    MultiVariantMode --> ArchiveLeafVariant
    ArchiveLeafVariant --> DownstreamComboWork
    DownstreamComboWork --> CatalogReviewNotice
    DownstreamComboWork --> MultiVariantMode

    %% Leaf supply configuration
    CheckSupplyType -->|STOCKED| ConfigStockedSupply
    CheckSupplyType -->|PREPARED| ConfigPreparedSupply

    ConfigStockedSupply --> TriggerModifierConfig

    ConfigPreparedSupply --> CheckRecipeRevisionCurrent
    CheckRecipeRevisionCurrent -->|recipeRevisionId == latestRecipeRevisionAvailable| RecipeRevisionCurrent
    CheckRecipeRevisionCurrent -->|latestRecipeRevisionAvailable > recipeRevisionId| RecipeRevisionPending
    RecipeRevisionPending --> AdoptRecipeRevision
    AdoptRecipeRevision --> RecipeRevisionCurrent
    RecipeRevisionCurrent --> TriggerModifierConfig

    ConfigPreparedSupply --> TriggerRecipeEditor
    TriggerRecipeEditor --> RecipeAuthoring
    RecipeAuthoring --> ReturnFromRecipe
    ReturnFromRecipe --> ConfigPreparedSupply

    %% Leaf modifier transition
    TriggerModifierConfig --> ModifierConfigAuthoring
    ModifierConfigAuthoring --> ReturnFromModifierConfig
    ReturnFromModifierConfig --> SelectSaveOrExit

    %% Combo item branch
    ComboItemMode --> TriggerComboConfig
    TriggerComboConfig --> ComboConfigAuthoring
    ComboConfigAuthoring --> ReturnFromComboConfig
    ReturnFromComboConfig --> SelectSaveOrExit

    %% Save, validation, and exit paths
    SelectSaveOrExit -->|cancelEditAction| ExecuteCancel
    ExecuteCancel --> CatalogMonitoring

    SelectSaveOrExit -->|saveDraftInactiveAction| ExecuteSaveInactive
    ExecuteSaveInactive --> CheckCapacityDeficits
    CheckCapacityDeficits -->|Deficits detected| EmitCapacityWarnings
    CheckCapacityDeficits -->|No capacity deficits| PersistInactiveItem
    EmitCapacityWarnings --> PersistInactiveItem
    PersistInactiveItem --> CatalogMonitoring

    SelectSaveOrExit -->|saveAndActivateAction| ExecuteSaveActive
    ExecuteSaveActive --> EvaluateActiveStructuralIntegrity
    EvaluateActiveStructuralIntegrity -->|Structural requirements NOT met| ActiveValidationRejected
    ActiveValidationRejected -->|Correct errors or choose draft| SelectSaveOrExit
    EvaluateActiveStructuralIntegrity -->|Structural requirements met| PersistActiveItem
    PersistActiveItem --> CatalogMonitoring
```
