---
id: manage-modifiers
name: Manage Modifiers and Specializations
actors:
  - ADMINISTRATOR
views:
  - ModifierConfigurationView
  - MenuItemEditorView
requirements:
  - REQ-MENU-MOD-001
  - REQ-MENU-MOD-002
  - REQ-MENU-MOD-003
  - REQ-MENU-MOD-004
  - REQ-MENU-MOD-005
  - REQ-MENU-MOD-006
  - REQ-MENU-MOD-007
  - REQ-MENU-MOD-008
  - REQ-MENU-LIF-002
  - REQ-MENU-LIF-003
  - REQ-MENU-VER-001
  - INV-MENU-005
  - INV-MENU-007
  - INV-MENU-008
  - INV-MENU-009
  - INV-MENU-010
  - INV-MENU-011
  - INV-MENU-012
---

# Flow: Manage Modifiers and Specializations

```mermaid
flowchart TD
    subgraph ExternalContext["External Context (MenuItemEditorView)"]
        Entry(["Entry: ADMINISTRATOR<br/>(Inputs: menuItemId, optional initialVariantId, returnContext: MenuItemEditorView)<br/>(REQ-MENU-MOD-001, REQ-MENU-MOD-003)"])
        ExitReturn(["Return to MenuItemEditorView<br/>(Outputs: savedMenuItemId, newRevisionToken, returnToItemEditorSignal)<br/>(REQ-MENU-MOD-001, REQ-MENU-LIF-002, REQ-MENU-VER-001)"])
    end

    subgraph ModifierConfigurationView["ModifierConfigurationView"]
        %% Scope verification
        CheckItemType{"Is target MenuItem a leaf product?<br/>(type == PREPARED or STOCKED)<br/>(REQ-MENU-MOD-001, C-MOD-001)"}
        RejectNonLeafItem["State: nonLeafItemExcluded<br/>Modifiers are exclusive to leaf MenuItems and absent from COMBO in v1.<br/>Modifier authoring blocked for COMBO package items.<br/>(REQ-MENU-MOD-001)"]

        LoadModifierContext["Load leaf MenuItem context and existing modifier groups.<br/>Display leaf item identity, administrative status, read-only ISO 4217 currencyCode, and variants.<br/>(data: leafItemContext, modifierGroups)<br/>(REQ-MENU-MOD-001, REQ-MENU-MOD-003, INV-MENU-007)"]

        %% Focus routing
        SelectFocusMode{"Focus on item baseline generalConfig<br/>or specialize specific variant?<br/>(control: variantFocusSelector, action: selectVariantForSpecialization)<br/>(REQ-MENU-MOD-001, REQ-MENU-MOD-003)"}

        %% ----------------- ITEM-LEVEL BASELINE (generalConfig) -----------------
        StateGeneralConfig["State: viewingGeneralConfiguration<br/>Authoring baseline modifier groups and options for all variants.<br/>(focusedVariantId == null)<br/>(data: modifierGroups)<br/>(REQ-MENU-MOD-001, REQ-MENU-MOD-002)"]

        ManageGroups["Manage ModifierGroup entities<br/>Define group name (1..120 Unicode chars after trim) and selection bounds (integers in 0..99, 0 <= minSelections <= maxSelections <= 99).<br/>(controls: addModifierGroupAction,<br/>updateGroupNameInput, updateMinSelectionsInput, updateMaxSelectionsInput)<br/>(actions: createModifierGroup, setModifierGroupName, setModifierGroupSelectionLimits)<br/>(REQ-MENU-MOD-001, INV-MENU-011, INV-MENU-012)"]

        ManageOptions["Manage ModifierOption entities in group<br/>Define option commercial display name (1..120 Unicode chars after trim).<br/>(controls: addModifierOptionAction, updateOptionNameInput)<br/>(actions: createModifierOption, setModifierOptionName)<br/>(REQ-MENU-MOD-002, INV-MENU-012)"]

        ConfigureGeneralConfig["Configure baseline generalConfig for option:<br/>priceDelta in exact DECIMAL(12,2) within (-9999999999.99, 9999999999.99) in menu ISO 4217 currency (<= 2 decimals, no implicit rounding),<br/>maxQuantity as integer in 0..99, and non-negative effective variant price (unitPrice + priceDelta >= 0.00).<br/>(controls: updateGeneralPriceDeltaInput, updateGeneralMaxQuantityInput)<br/>(actions: setGeneralPriceDelta, setGeneralMaxQuantity)<br/>(REQ-MENU-MOD-002, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011)"]

        SelectGeneralEffectType{"Configure baseline ingredient effects for option?<br/>(REQ-MENU-MOD-002, REQ-MENU-MOD-005, REQ-MENU-MOD-006, REQ-MENU-MOD-007)"}

        ConfigGeneralAdd["Directive ADD:<br/>Specify inventoryItemId (opaque SKU); atomically submit operation='ADD',<br/>positive quantity (> 0), and non-empty metric unit in a single action.<br/>Never enters an invalid partially configured ADD state.<br/>(controls: setGeneralEffectOperationSelector, updateGeneralEffectInventoryItemIdInput,<br/>action: setIngredientEffectOperation)<br/>(REQ-MENU-MOD-005)"]

        EditGeneralAddMetrics["Edit existing ADD metrics:<br/>Subsequent edits to positive quantity (> 0) or metric unit operate on an effect already in ADD state.<br/>Preserves strict IngredientEffect contract (quantity/unit inputs disabled when operation is OMIT).<br/>(controls: updateGeneralEffectQuantityInput, updateGeneralEffectUnitInput,<br/>actions: setIngredientEffectQuantity, setIngredientEffectUnit)<br/>(REQ-MENU-MOD-005)"]

        ConfigGeneralOmit["Directive OMIT:<br/>Specify inventoryItemId (opaque SKU) to exclude from base recipe.<br/>Selecting OMIT atomically clears quantity and unit to null.<br/>(controls: setGeneralEffectOperationSelector, updateGeneralEffectInventoryItemIdInput,<br/>action: setIngredientEffectOperation)<br/>(REQ-MENU-MOD-006)"]

        ConfigGeneralEmptyEffect["State: culinaryInstructionEmptyEffectState<br/>ingredientEffects = (). Cooking/service note without inventory consumption.<br/>(e.g. 'Término medio', 'Salsa aparte').<br/>(control: clearGeneralIngredientEffectsAction, action: clearGeneralIngredientEffects)<br/>(REQ-MENU-MOD-007)"]

        %% ----------------- VARIANT SPECIALIZATION (VariantModifierConfig) -----------------
        StateVariantSpecialization["State: variantSpecializationEditing<br/>Authoring variant-specific overrides on focused variant.<br/>(focusedVariantId != null)<br/>(data: variantSpecializations, resolvedVariantModifiersProjection)<br/>(REQ-MENU-MOD-003)"]

        CheckOptionOverrideExists{"Does option have existing<br/>VariantModifierConfig on this variant?<br/>(REQ-MENU-MOD-003)"}

        OptionInheritsGeneral["Option inherits baseline generalConfig (priceDelta, maxQuantity, ingredientEffects).<br/>Display inherited values with clear inheritance indicator; validate non-negative effective variant price (unitPrice + priceDelta >= 0.00).<br/>(data: variantSpecializations.optionOverrides)<br/>(REQ-MENU-MOD-002, REQ-MENU-MOD-003, INV-MENU-007, INV-MENU-010)"]

        DecideCreateOverride{"Instantiate specialization override<br/>for this option?<br/>(control: selectOptionForOverrideAction, action: initVariantOptionOverride)<br/>(REQ-MENU-MOD-003)"}

        EditVariantOverride["Author VariantModifierConfig specialization:<br/>1. Explicit enablement: toggleVariantOptionEnabledToggle (action: setVariantOptionEnabled)<br/>2. Specialized priceDelta: setVariantPriceDeltaInput (exact DECIMAL(12,2) in (-9999999999.99, 9999999999.99) in menu ISO 4217 currency, <= 2 decimals; action: setVariantPriceDelta)<br/>3. Enforce non-negative effective variant price (unitPrice + priceDelta >= 0.00 under INV-MENU-010)<br/>4. Specialized maxQuantity: setVariantMaxQuantityInput (integer in 0..99; action: setVariantMaxQuantity)<br/>(REQ-MENU-MOD-003, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011)"]

        SelectVariantEffectType{"Configure specialized ingredient effects for variant?<br/>(REQ-MENU-MOD-003, REQ-MENU-MOD-005, REQ-MENU-MOD-006, REQ-MENU-MOD-007)"}

        ConfigVariantAdd["Specialized ADD directive:<br/>Specify inventoryItemId; atomically submit operation='ADD', specialized<br/>positive quantity (> 0), and non-empty metric unit in a single action for focused variant.<br/>Never enters an invalid partially configured ADD state.<br/>(controls: setVariantEffectOperationSelector, updateVariantEffectInventoryItemIdInput,<br/>action: setVariantIngredientEffectOperation)<br/>(REQ-MENU-MOD-003, REQ-MENU-MOD-005)"]

        EditVariantAddMetrics["Edit specialized ADD metrics:<br/>Subsequent edits to specialized quantity (> 0) or metric unit operate on an effect already in ADD state.<br/>Preserves strict IngredientEffect contract (quantity/unit inputs disabled when operation is OMIT).<br/>(controls: updateVariantEffectQuantityInput, updateVariantEffectUnitInput,<br/>actions: setVariantIngredientEffectQuantity, setVariantIngredientEffectUnit)<br/>(REQ-MENU-MOD-003, REQ-MENU-MOD-005)"]

        ConfigVariantOmit["Specialized OMIT directive:<br/>Specify inventoryItemId to exclude for focused variant.<br/>Selecting OMIT atomically clears quantity and unit to null.<br/>(controls: setVariantEffectOperationSelector, updateVariantEffectInventoryItemIdInput,<br/>action: setVariantIngredientEffectOperation)<br/>(REQ-MENU-MOD-003, REQ-MENU-MOD-006)"]

        ConfigVariantEmptyEffect["Specialized Empty Effect:<br/>ingredientEffects = (). Specialized culinary note for this variant.<br/>(control: clearVariantIngredientEffectsAction, action: clearVariantIngredientEffects)<br/>(REQ-MENU-MOD-003, REQ-MENU-MOD-007)"]

        %% ----------------- ADMINISTRATIVE COPY BRANCH -----------------
        InitiateCopy["Initiate administrative copy of VariantModifierConfig overrides.<br/>Select source variant and target variants of the same leaf MenuItem.<br/>(controls: copySourceVariantSelector, copyTargetVariantsMultiSelector)<br/>(actions: setCopySourceVariant, setCopyTargetVariants)<br/>(REQ-MENU-MOD-004)"]

        ChooseCollisionPolicy["Select collision resolution policy:<br/>FAIL (abort on conflict without changes) or REPLACE (overwrite targets).<br/>(control: copyPolicySelector, action: setCopyCollisionPolicy)<br/>(REQ-MENU-MOD-004)"]

        ChooseExecutionMode{"Execution mode:<br/>dryRun simulation or definitive execution?<br/>(REQ-MENU-MOD-004)"}

        %% Dry-run simulation
        ExecuteDryRun["Execute dryRunCopyVariantModifierConfigs<br/>Simulate copy without mutating domain entities.<br/>Detect collisions on target variants and validate non-negative effective variant prices (unitPrice + priceDelta >= 0.00).<br/>(control: dryRunCopyAction, action: dryRunCopyVariantModifierConfigs)<br/>(REQ-MENU-MOD-004, INV-MENU-010)"]

        CheckDryRunCollisions{"Collisions detected in simulation?<br/>(collisionsCount > 0)<br/>(REQ-MENU-MOD-004)"}

        DryRunClean["State: copyDryRunCleanSuccess (outcome: SIMULATION_CLEAN)<br/>0 collisions detected across target variants.<br/>Clean atomic copy anticipated.<br/>(data: administrativeCopyBuffer.lastReport)<br/>(REQ-MENU-MOD-004)"]

        CheckDryRunPolicy{"Simulation collision policy?<br/>(REQ-MENU-MOD-004)"}

        DryRunBlocked["State: copyDryRunCollisionBlocked (outcome: SIMULATION_COLLISIONS_BLOCKED)<br/>Collisions detected under FAIL policy.<br/>Presents collision details: targetVariantId, modifierOptionId, existing vs proposed.<br/>Warns administrator that definitive execution will abort.<br/>(data: administrativeCopyBuffer.lastReport.collisions)<br/>(REQ-MENU-MOD-004)"]

        DryRunReplace["State: copyDryRunReplaceAnticipated (outcome: SIMULATION_REPLACE_ANTICIPATED)<br/>Collisions detected under REPLACE policy.<br/>Presents overrides on target variants that will be overwritten.<br/>(data: administrativeCopyBuffer.lastReport.collisions)<br/>(REQ-MENU-MOD-004)"]

        ReviewDryRunResults["Administrator reviews dry-run report.<br/>Can adjust targets, switch collision policy, or proceed to definitive execution.<br/>(controls: clearCopyBufferAction, copyPolicySelector)<br/>(actions: resetCopyBuffer, setCopyCollisionPolicy)<br/>(REQ-MENU-MOD-004)"]

        %% Definitive execution
        ExecuteDefinitiveCopy["Execute executeCopyVariantModifierConfigs<br/>Definitive atomic copy from source to target variants.<br/>Validates non-negative effective variant prices on target variants.<br/>(control: executeCopyAction, action: executeCopyVariantModifierConfigs)<br/>(REQ-MENU-MOD-004, INV-MENU-010)"]

        CheckDefinitiveCollisions{"Collisions detected on target variants?<br/>(target variant already possesses override for copied option)<br/>(REQ-MENU-MOD-004)"}

        CheckDefinitivePolicy{"Definitive collision policy?<br/>(REQ-MENU-MOD-004)"}

        AbortAndRollback["State: copyExecutionAbortedRollback (outcome: ABORTED_ON_CONFLICT_ROLLBACK)<br/>Collision detected under FAIL policy.<br/>TRANSACTION ABORTED: Complete atomic rollback with ZERO partial writes.<br/>Target variants remain completely unchanged.<br/>isAtomicRollback = true.<br/>(data: administrativeCopyBuffer.lastReport)<br/>(REQ-MENU-MOD-004)"]

        ApplyAtomicCopy["State: copyExecutionSuccess (outcome: EXECUTED_SUCCESSFULLY)<br/>Zero collisions OR policy == REPLACE.<br/>All source overrides copied to target variants in single atomic transaction.<br/>Overwrites conflicting targets when policy == REPLACE.<br/>Recalculates variant capacities and updates projections.<br/>(REQ-MENU-MOD-004)"]

        %% ----------------- CAPACITY EVALUATION & PERSISTENCE -----------------
        EvaluateStructuralCapacity["Evaluate structural capacity and validation rules:<br/>- Capacity: Capacidad(ModifierGroup) >= minSelections for baseline and all active variants<br/>- Non-negative price: unitPrice + effectivePriceDelta >= 0.00 in menu ISO 4217 currency<br/>- Bounds: names 1..120 chars after trim, minSelections/maxSelections/maxQuantity in 0..99, priceDelta DECIMAL(12,2) in (-9999999999.99, 9999999999.99)<br/>(data: structuralValidationStatus)<br/>(REQ-MENU-MOD-001, INV-MENU-005, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011, INV-MENU-012)"]

        DecideSaveAction{"Administrative save or exit action?<br/>(REQ-MENU-MOD-001, REQ-MENU-LIF-002, REQ-MENU-LIF-003)"}

        CancelExit["Cancel configuration: discard pending edits in working buffer.<br/>No commercial revision generated.<br/>(control: cancelConfigurationAction, action: cancelConfiguration)<br/>(Emits returnToItemEditorSignal)"]

        %% Save Inactive
        TriggerSaveInactive["Execute saveDraftInactiveAction<br/>Persist modifier configuration in INACTIVE administrative status.<br/>Validates text length, quantity bounds, precision, and non-negative prices.<br/>Permits incomplete definitions and capacity deficits.<br/>(control: saveDraftInactiveAction, action: saveModifierConfigurationInactive)<br/>(REQ-MENU-LIF-002, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011, INV-MENU-012)"]

        CheckInactiveValidation{"Do blocking bounds, precision, or price violations exist?<br/>(name length not in 1..120, bounds not in 0..99, > 2 decimals, effectivePrice < 0.00)<br/>(INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011, INV-MENU-012)"}

        InactiveValidationBlocked["Validation Error: Save Rejected.<br/>Display blockingValidationErrors in UI.<br/>Violations of text length (1..120), selection/quantity bounds (0..99), precision DECIMAL(12,2), or negative effective price strictly block persistence.<br/>(data: structuralValidationStatus.blockingValidationErrors)<br/>(INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011, INV-MENU-012)"]

        CheckCapacityDeficits{"Are any groups deficient in capacity?<br/>(calculatedCapacity < minSelections for baseline or any variant)<br/>(REQ-MENU-LIF-002, REQ-MENU-LIF-003)"}

        GenerateStructuredWarnings["State: inactiveSavedWithCapacityWarnings<br/>Generate structured incompleteCapacityWarnings:<br/>entityId (group UUID), entityType = 'ModifierGroup',<br/>minSelections, calculatedCapacity, variantId, warningMessage.<br/>(data: incompleteCapacityWarnings)<br/>(REQ-MENU-LIF-002, REQ-MENU-LIF-003)"]

        PersistInactiveModifiers["Persist modifier configuration in INACTIVE status.<br/>Generate new immutable commercial revision '<number>_<ISO8601>'.<br/>Emit savedMenuItemId, newRevisionToken, and returnToItemEditorSignal.<br/>(REQ-MENU-LIF-002, REQ-MENU-VER-001)"]

        %% Save and Activate
        TriggerSaveActivate["Execute saveAndActivateAction<br/>Validate complete structural capacity, bounds, precision, and non-negative prices.<br/>(control: saveAndActivateAction, action: saveModifierConfigurationAndActivate)<br/>(REQ-MENU-MOD-001, INV-MENU-005, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011, INV-MENU-012)"]

        EvaluateActiveEligibility{"Validate structuralValidationStatus.isEligibleForActive:<br/>- Zero blocking validation errors (bounds, precision, effective price >= 0.00)<br/>- All mandatory groups (minSelections > 0) satisfy Capacidad >= minSelections across baseline and all active variants?<br/>(REQ-MENU-MOD-001, INV-MENU-005, INV-MENU-010)"}

        ActiveActivationBlocked["Validation Error: Activation Blocked (isEligibleForActive == false).<br/>Display blockingValidationErrors in UI.<br/>Item is NOT silently activated; remains in working buffer / INACTIVE.<br/>Must correct capacity deficits or bounds/price errors, or save as INACTIVE draft.<br/>(REQ-MENU-MOD-001, INV-MENU-005, INV-MENU-010)"]

        PersistActiveModifiers["State: activeSavedCapacitySatisfied (isEligibleForActive == true)<br/>Persist modifier configuration with administrativeStatus = ACTIVE.<br/>Generate new immutable commercial revision '<number>_<ISO8601>'.<br/>Emit savedMenuItemId, newRevisionToken, and returnToItemEditorSignal.<br/>(REQ-MENU-MOD-001, INV-MENU-005, REQ-MENU-VER-001)"]
    end

    %% ----------------- EDGES & TRANSITIONS -----------------

    %% Entry & scope check
    Entry --> CheckItemType
    CheckItemType -->|MenuItem type == COMBO| RejectNonLeafItem
    RejectNonLeafItem --> ExitReturn
    CheckItemType -->|MenuItem type == PREPARED or STOCKED| LoadModifierContext

    LoadModifierContext --> SelectFocusMode

    %% Item baseline generalConfig path
    SelectFocusMode -->|"focusedVariantId == null (Baseline)"| StateGeneralConfig
    StateGeneralConfig --> ManageGroups
    ManageGroups --> ManageOptions
    ManageOptions --> ConfigureGeneralConfig
    ConfigureGeneralConfig --> SelectGeneralEffectType

    SelectGeneralEffectType -->|"operation == 'ADD' (atomically submits ADD, qty > 0, unit)"| ConfigGeneralAdd
    SelectGeneralEffectType -->|"operation == 'OMIT' (atomically clears qty & unit)"| ConfigGeneralOmit
    SelectGeneralEffectType -->|"ingredientEffects == empty list"| ConfigGeneralEmptyEffect

    %% Baseline OMIT-to-ADD path and ADD-to-OMIT transition
    ConfigGeneralOmit -->|"Switch to ADD (atomically submits ADD, qty > 0, unit)"| ConfigGeneralAdd
    ConfigGeneralAdd -->|"Switch to OMIT (atomically clears qty & unit to null)"| ConfigGeneralOmit

    %% Subsequent baseline ADD metric adjustments
    ConfigGeneralAdd -->|Edit quantity or unit on existing ADD| EditGeneralAddMetrics
    EditGeneralAddMetrics -->|Subsequent adjustments| EditGeneralAddMetrics
    EditGeneralAddMetrics -->|"Switch to OMIT (atomically clears qty & unit to null)"| ConfigGeneralOmit
    EditGeneralAddMetrics --> EvaluateStructuralCapacity

    ConfigGeneralAdd --> EvaluateStructuralCapacity
    ConfigGeneralOmit --> EvaluateStructuralCapacity
    ConfigGeneralEmptyEffect --> EvaluateStructuralCapacity

    %% Variant specialization path
    SelectFocusMode -->|"focusedVariantId != null (Variant override)"| StateVariantSpecialization
    StateVariantSpecialization --> CheckOptionOverrideExists

    CheckOptionOverrideExists -->|hasOverride == false| OptionInheritsGeneral
    OptionInheritsGeneral --> DecideCreateOverride
    DecideCreateOverride -->|initVariantOptionOverride| EditVariantOverride
    DecideCreateOverride -->|Retain baseline inheritance| EvaluateStructuralCapacity

    CheckOptionOverrideExists -->|hasOverride == true| EditVariantOverride
    EditVariantOverride --> SelectVariantEffectType

    SelectVariantEffectType -->|"operation == 'ADD' (atomically submits ADD, qty > 0, unit)"| ConfigVariantAdd
    SelectVariantEffectType -->|"operation == 'OMIT' (atomically clears qty & unit)"| ConfigVariantOmit
    SelectVariantEffectType -->|"ingredientEffects == empty list"| ConfigVariantEmptyEffect

    %% Variant OMIT-to-ADD path and ADD-to-OMIT transition
    ConfigVariantOmit -->|"Switch to ADD (atomically submits ADD, qty > 0, unit)"| ConfigVariantAdd
    ConfigVariantAdd -->|"Switch to OMIT (atomically clears qty & unit to null)"| ConfigVariantOmit

    %% Subsequent specialized ADD metric adjustments
    ConfigVariantAdd -->|Edit specialized quantity or unit on existing ADD| EditVariantAddMetrics
    EditVariantAddMetrics -->|Subsequent adjustments| EditVariantAddMetrics
    EditVariantAddMetrics -->|"Switch to OMIT (atomically clears qty & unit to null)"| ConfigVariantOmit
    EditVariantAddMetrics --> EvaluateStructuralCapacity

    ConfigVariantAdd --> EvaluateStructuralCapacity
    ConfigVariantOmit --> EvaluateStructuralCapacity
    ConfigVariantEmptyEffect --> EvaluateStructuralCapacity

    %% Copy branch transitions
    StateVariantSpecialization -->|Initiate copy from this variant| InitiateCopy
    InitiateCopy --> ChooseCollisionPolicy
    ChooseCollisionPolicy --> ChooseExecutionMode

    ChooseExecutionMode -->|dryRun simulation| ExecuteDryRun
    ExecuteDryRun --> CheckDryRunCollisions
    CheckDryRunCollisions -->|collisionsCount == 0| DryRunClean
    DryRunClean --> ReviewDryRunResults

    CheckDryRunCollisions -->|collisionsCount > 0| CheckDryRunPolicy
    CheckDryRunPolicy -->|policy == 'FAIL'| DryRunBlocked
    CheckDryRunPolicy -->|policy == 'REPLACE'| DryRunReplace
    DryRunBlocked --> ReviewDryRunResults
    DryRunReplace --> ReviewDryRunResults

    ReviewDryRunResults -->|Adjust targets / policy| InitiateCopy
    ReviewDryRunResults -->|Proceed to definitive execution| ExecuteDefinitiveCopy

    ChooseExecutionMode -->|Definitive execution| ExecuteDefinitiveCopy
    ExecuteDefinitiveCopy --> CheckDefinitiveCollisions

    CheckDefinitiveCollisions -->|collisionsCount == 0| ApplyAtomicCopy
    CheckDefinitiveCollisions -->|collisionsCount > 0| CheckDefinitivePolicy

    CheckDefinitivePolicy -->|policy == 'FAIL'| AbortAndRollback
    CheckDefinitivePolicy -->|policy == 'REPLACE'| ApplyAtomicCopy

    AbortAndRollback --> ReviewDryRunResults
    ApplyAtomicCopy --> EvaluateStructuralCapacity

    %% Structural capacity evaluation and save paths
    EvaluateStructuralCapacity --> DecideSaveAction

    DecideSaveAction -->|cancelConfigurationAction| CancelExit
    CancelExit --> ExitReturn

    DecideSaveAction -->|saveDraftInactiveAction| TriggerSaveInactive
    TriggerSaveInactive --> CheckInactiveValidation
    CheckInactiveValidation -->|Blocking violations exist| InactiveValidationBlocked
    InactiveValidationBlocked -->|Correct violations| DecideSaveAction
    CheckInactiveValidation -->|No blocking violations| CheckCapacityDeficits
    CheckCapacityDeficits -->|Capacity deficits detected| GenerateStructuredWarnings
    CheckCapacityDeficits -->|No capacity deficits| PersistInactiveModifiers
    GenerateStructuredWarnings --> PersistInactiveModifiers
    PersistInactiveModifiers --> ExitReturn

    DecideSaveAction -->|saveAndActivateAction| TriggerSaveActivate
    TriggerSaveActivate --> EvaluateActiveEligibility
    EvaluateActiveEligibility -->|isEligibleForActive == false| ActiveActivationBlocked
    ActiveActivationBlocked -->|Correct deficits or save inactive| DecideSaveAction
    EvaluateActiveEligibility -->|isEligibleForActive == true| PersistActiveModifiers
    PersistActiveModifiers --> ExitReturn
```
