---
id: manage-combo
name: Manage Combo Configurations, Slots, and Options
actors:
  - ADMINISTRATOR
views:
  - ComboConfigurationView
  - MenuItemEditorView
requirements:
  - REQ-MENU-COM-001
  - REQ-MENU-COM-002
  - REQ-MENU-COM-003
  - REQ-MENU-COM-004
  - REQ-MENU-COM-005
  - REQ-MENU-COM-006
  - REQ-MENU-VAR-006
  - REQ-MENU-LIF-002
  - REQ-MENU-LIF-003
  - REQ-MENU-VER-001
  - INV-MENU-005
---

# Flow: Manage Combo Configurations, Slots, and Options

```mermaid
flowchart TD
    subgraph ExternalContext["External Context (MenuItemEditorView)"]
        Entry(["Entry: ADMINISTRATOR<br/>(Inputs: menuItemId, optional initialConfigurationId, returnContext: MenuItemEditorView)<br/>[REQ-MENU-COM-001]"])
        ExitReturn(["Return to MenuItemEditorView<br/>(Outputs: savedMenuItemId, newRevisionToken, returnToItemEditorSignal)<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-002, REQ-MENU-VER-001]"])
    end

    subgraph ComboConfigurationView["ComboConfigurationView"]
        %% Aggregate Boundary & Type Check
        CheckItemType{"Is target MenuItem a COMBO package item?<br/>(type == COMBO)<br/>[REQ-MENU-COM-001, C-COM-001]"}
        RejectNonComboItem["State: nonComboItemExcluded<br/>Combo configuration is exclusive to COMBO MenuItems.<br/>Leaf items (PREPARED / STOCKED) manage variants and modifiers.<br/>[REQ-MENU-COM-001, C-COM-001]"]

        LoadComboContext["Load COMBO MenuItem context and existing configurations.<br/>Display commercial identity: name, immutable type COMBO,<br/>parent administrativeStatus (ACTIVE / INACTIVE), and revision token.<br/>CRITICAL: COMBO items possess NO MenuItemVariants or ModifierGroups.<br/>ComboConfiguration entities possess NO administrative status.<br/>[data: comboItemContext, comboConfigurations]<br/>[REQ-MENU-COM-001, C-COM-001, C-COM-002]"]

        SelectConfigurationFocus{"Focus on existing configuration<br/>or manage configurations collection?<br/>[control: configurationFocusSelector, action: selectConfigurationForFocus]<br/>[REQ-MENU-COM-001]"}

        %% ----------------- CONFIGURATION MANAGEMENT -----------------
        StateViewingConfigurations["State: viewingConfigurationsList<br/>Authoring and monitoring ComboConfigurations collection.<br/>(focusedConfigurationDetails.configurationId == null)<br/>[data: comboConfigurations]<br/>[REQ-MENU-COM-001]"]

        CreateConfiguration["Create new ComboConfiguration entity:<br/>Define commercial name and authoritative absolute unitPrice (>= 0).<br/>reviewStatus initialized to UP_TO_DATE. Slots initialized empty.<br/>(NOTE: At least one ComboSlot must be added before persistence;<br/>configurations with zero slots are strictly rejected upon save).<br/>[control: addComboConfigurationAction, action: createComboConfiguration]<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, C-COM-002, C-COM-003, INV-MENU-005]"]

        StateEditingConfiguration["State: editingConfigurationSlots<br/>Focused on specific ComboConfiguration.<br/>Inspect and edit configuration commercial attributes.<br/>[data: focusedConfigurationDetails]<br/>[REQ-MENU-COM-001]"]

        UpdateConfigurationAttributes["Update configuration commercial attributes:<br/>1. Commercial display name: updateConfigurationNameInput<br/>2. Authoritative absolute unitPrice (>= 0): updateConfigurationUnitPriceInput<br/>(Price is absolute, not an adjustment; basePrice discontinued).<br/>[controls: updateConfigurationNameInput, updateConfigurationUnitPriceInput,<br/>actions: setConfigurationName, setConfigurationUnitPrice]<br/>[REQ-MENU-COM-001, INV-MENU-005]"]

        CheckReviewFlag{"Does configuration have<br/>reviewStatus == REVIEW_REQUIRED?<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-001]"}

        StateReviewRequired["State: reviewRequiredFlaggedState<br/>Configuration flagged REVIEW_REQUIRED due to component variant archival or edit.<br/>Parent COMBO administrative status remains completely unchanged.<br/>[data: focusedConfigurationDetails.reviewStatus]<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-001]"]

        ReviewPendingIndication["Semantic Notice: reviewPendingIndication<br/>Informational supervisory indication: configuration reviewStatus is REVIEW_REQUIRED.<br/>Separation of responsibility: review confirmation cannot be performed in this view;<br/>confirmation responsibility belongs solely to ComboReviewView (review-combo.md).<br/>Commercial editing continues with reviewStatus remaining REVIEW_REQUIRED.<br/>[data: focusedConfigurationDetails.reviewStatus]<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-001]"]

        %% ----------------- SLOT MANAGEMENT -----------------
        CheckConfigurationSlots{"Does focused configuration contain slots?<br/>(slots.count > 0)<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002]"}

        EmptyConfigurationState["State: emptyConfigurationState<br/>Configuration currently contains zero ComboSlots.<br/>Persistence is strictly rejected in both INACTIVE and ACTIVE status<br/>until at least one ComboSlot is created.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002]"]

        CreateSlot["Add new ComboSlot selection space:<br/>Define slot display name (e.g. 'Platillo Principal', 'Bebida').<br/>Initial bounds: minSelections = 0, maxSelections = 1.<br/>[control: addComboSlotAction, action: createComboSlot]<br/>[REQ-MENU-COM-002, INV-MENU-005]"]

        ConfigureSlotBounds["Configure selection bounds and display name:<br/>1. Update slot name: updateSlotNameInput<br/>2. Update minSelections (integer >= 0)<br/>3. Update maxSelections (integer >= minSelections)<br/>[controls: updateSlotNameInput, updateSlotMinSelectionsInput, updateSlotMaxSelectionsInput,<br/>actions: setSlotName, setSlotSelectionBounds]<br/>[REQ-MENU-COM-002, INV-MENU-005]"]

        ValidateSlotBounds{"Validate selection bounds invariant:<br/>0 <= minSelections <= maxSelections?<br/>[REQ-MENU-COM-002, C-COM-004, INV-MENU-005]"}

        SlotBoundsRejected["Validation Error: Invalid selection boundaries.<br/>minSelections > maxSelections is strictly invalid and rejected.<br/>Bounds restored to prior valid state.<br/>[REQ-MENU-COM-002, C-COM-004]"]

        %% ----------------- OPTION MANAGEMENT -----------------
        ManageSlotOptions["Manage ComboOption entities within slot<br/>Options reference concrete leaf MenuItemVariants directly.<br/>(CRITICAL: Combos do NOT own modifier groups in v1).<br/>[data: focusedConfigurationDetails.slots.options]<br/>[REQ-MENU-COM-003, C-COM-005, C-COM-006]"]

        CreateOption["Add ComboOption to slot:<br/>[control: addComboOptionAction, action: createComboOption]<br/>[REQ-MENU-COM-003, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]"]

        ConfigureDirectVariant["Select concrete leaf MenuItemVariant directly (itemVariantId):<br/>Must reference a PREPARED or STOCKED item variant.<br/>Combos cannot reference other combos.<br/>Deprecated menuItemId + AllowedVariant model is discontinued.<br/>[control: selectOptionItemVariantInput, action: setOptionItemVariant]<br/>[REQ-MENU-COM-003, REQ-MENU-COM-006, REQ-MENU-VAR-006, C-COM-005]"]

        ConfigureQuantityAndPriceDelta["Configure delivered quantity and signed price adjustment:<br/>1. Positive physical quantity multiplier: quantity >= 1 (updateOptionQuantityInput)<br/>   Dictates runtime inventory/recipe consumption;<br/>   contributes at most 1 selection to slot capacity.<br/>2. Explicit signed priceDelta: e.g. +15.00, 0.00 (updateOptionPriceDeltaInput)<br/>   Added to configuration base unitPrice when chosen.<br/>[controls: updateOptionQuantityInput, updateOptionPriceDeltaInput,<br/>actions: setOptionQuantity, setOptionPriceDelta]<br/>[REQ-MENU-COM-003, REQ-MENU-ING-001, C-COM-005]"]

        ToggleOptionEnablement["Toggle administrative option enablement:<br/>enabled = true / false.<br/>Disabled options excluded from slot capacity and runtime ordering.<br/>[control: toggleOptionEnabledToggle, action: setOptionEnabled]<br/>[REQ-MENU-COM-003, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005, C-COM-004]"]

        %% ----------------- SAME-ITEM ADMINISTRATIVE CONFIGURATION COPY -----------------
        InitiateCopy["Initiate same-item administrative configuration copy.<br/>Select source configuration from SAME COMBO MenuItem.<br/>(Cross-item copying is unsupported).<br/>[control: copySourceConfigurationSelector, action: setCopySourceConfiguration]<br/>[REQ-MENU-COM-004, C-COM-007]"]

        SelectCopyTarget["Select destination configuration of same item:<br/>Existing target ComboConfiguration OR instantiate brand new configuration.<br/>[control: copyTargetConfigurationSelector, action: setCopyTargetConfiguration]<br/>[REQ-MENU-COM-004, C-COM-007]"]

        CheckCopyTargetType{"Is target an existing configuration<br/>already containing prior slots?<br/>[REQ-MENU-COM-004, C-COM-012]"}

        RecordCopyConflictIssue["State: copyConflictPolicyUndefined<br/>Referenced Issue (docs/issues-tracker.md):<br/>Undefined slot-matching and conflict resolution policy when copying<br/>into an existing configuration with prior slots.<br/>SRS does not define merge heuristics; algorithm is NOT invented.<br/>Behavior deferred to issues tracker.<br/>[C-COM-012, docs/issues-tracker.md]"]

        ExecuteConfigurationCopy["Execute executeCopyConfiguration:<br/>Clones all ComboSlots and contained ComboOptions from source.<br/>REGENERATES UNIQUE IDENTITIES: Every copied ComboSlot receives a new UUID;<br/>every copied ComboOption receives a new UUID and references new slot UUID.<br/>Attributes (name, min/max selections, itemVariantId, quantity, priceDelta, enabled)<br/>duplicated faithfully.<br/>[control: executeCopyConfigurationAction, action: executeCopyConfiguration]<br/>[REQ-MENU-COM-004, C-COM-007]"]

        CopyExecutionSuccess["State: copyConfigurationExecutionSuccess<br/>Administrative copy completed successfully.<br/>Emits copyConfigurationReportNotification with regeneratedCounts.<br/>Recalculates structural capacity across modified configuration.<br/>[data: administrativeCopyBuffer.lastCopyReport]<br/>[REQ-MENU-COM-004, C-COM-007]"]

        %% ----------------- ATOMIC MULTI-CONFIGURATION BULK OPTION ASSIGNMENT -----------------
        InitiateBulkAssignment["Initiate atomic bulk option assignment across configurations.<br/>Select batch of ComboOption definitions (itemVariantId, quantity >= 1, priceDelta, enabled).<br/>[control: selectBulkOptionsToAssignSelector, action: setBulkOptionsToAssign]<br/>[REQ-MENU-COM-005, C-COM-008]"]

        SelectBulkTargetConfigs["Select multiple target ComboConfigurations of SAME COMBO item.<br/>[control: selectBulkTargetConfigurationsSelector, action: setBulkTargetConfigurations]<br/>[REQ-MENU-COM-005, C-COM-008]"]

        SpecifyTargetSlotName["Specify explicit destination slot name (targetSlotName, e.g. 'Bebida'):<br/>Heuristic auto-matching across disparate topologies is strictly excluded.<br/>Referenced Issue (docs/issues-tracker.md): Heuristic slot-matching deferred.<br/>[control: selectBulkTargetSlotNameInput, action: setBulkTargetSlotName]<br/>[REQ-MENU-COM-005, C-COM-008, C-COM-012]"]

        ExecuteBulkAssignmentAction["Execute executeBulkOptionAssignment:<br/>Initiate atomic administrative transaction across all targeted configurations.<br/>[control: executeBulkOptionAssignmentAction, action: executeBulkOptionAssignment]<br/>[REQ-MENU-COM-005, C-COM-008]"]

        EvaluateBulkAssignmentEligibility{"Do ALL target configurations contain a ComboSlot<br/>matching targetSlotName AND pass all entity validations?<br/>[REQ-MENU-COM-005, C-COM-008]"}

        BulkAssignmentRollback["State: bulkAssignmentAbortedRollback (outcome: ABORTED_ON_VALIDATION_ERROR)<br/>Validation failure or missing matching slot on at least one target configuration.<br/>TRANSACTION ABORTED: Complete atomic rollback with ZERO partial writes.<br/>isAtomicRollback = true. All target configurations remain untouched.<br/>[data: bulkAssignmentBuffer.lastBulkReport]<br/>[REQ-MENU-COM-005, C-COM-008]"]

        BulkAssignmentSuccess["State: bulkAssignmentExecutionSuccess (outcome: EXECUTED_SUCCESSFULLY)<br/>All targeted configurations validated and updated in a single atomic transaction.<br/>New ComboOptions created with newly regenerated unique UUIDs in each target slot.<br/>Emits bulkAssignmentReportNotification.<br/>Recalculates structural capacities across all affected configurations.<br/>[data: bulkAssignmentBuffer.lastBulkReport]<br/>[REQ-MENU-COM-005, C-COM-008]"]

        %% ----------------- STRUCTURAL CAPACITY EVALUATION -----------------
        EvaluateSlotCapacity["Real-time structural capacity evaluation per ComboSlot:<br/>calculatedCapacity = count of enabled options whose referenced leaf variants<br/>satisfy the complete REQ-MENU-VAR-006 structural predicate:<br/>- Owning leaf MenuItem is ACTIVE<br/>- Variant is ACTIVE and not ARCHIVED<br/>- Complete PREPARED supply linkage (valid recipe revision) or STOCKED supply linkage (inventoryItemId, quantity)<br/>- All mandatory modifier groups (minSelections > 0) are satisfiable.<br/>Physical quantity multiplier (>= 1) contributes at most 1 selection.<br/>VariantAvailability and momentary Inventory stock availability are explicitly excluded.<br/>[data: structuralValidationStatus, focusedConfigurationDetails.slots]<br/>[REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005, C-COM-004, C-COM-009]"]

        CheckSlotCapacityRequirements{"Do all mandatory slots (minSelections > 0)<br/>satisfy calculatedCapacity >= minSelections?<br/>[REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]"]

        StateCapacityDeficit["State: mandatorySlotCapacityDeficit<br/>One or more mandatory slots lack sufficient eligible options.<br/>isCapacitySatisfied = false. isStructurallyEligible = false.<br/>Parent item transition to ACTIVE blocked.<br/>Permitted to persist ONLY while parent COMBO MenuItem is INACTIVE (with warnings).<br/>Does NOT imply slot deletion.<br/>[REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, REQ-MENU-LIF-002, INV-MENU-005]"]

        StateCapacitySatisfied["State: mandatorySlotCapacitySatisfied<br/>All mandatory slots meet or exceed required selection capacity<br/>based on the complete REQ-MENU-VAR-006 structural predicate.<br/>isCapacitySatisfied = true. isStructurallyEligible = true.<br/>[REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]"]

        %% ----------------- PERSISTENCE & LIFECYCLE OUTCOMES -----------------
        SelectSaveOrExit{"Administrative save or exit action?<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-002, REQ-MENU-LIF-003]"}

        CancelExit["Cancel configuration: discard pending working buffer changes.<br/>No commercial revision generated.<br/>[control: cancelConfigurationAction, action: cancelConfiguration]<br/>(Emits returnToItemEditorSignal)"]

        %% Save Draft Inactive
        TriggerSaveInactive["Execute saveDraftInactiveAction<br/>Persist combo configurations with parent COMBO MenuItem status INACTIVE.<br/>Requires at least one ComboSlot per configuration (zero-slot configurations strictly rejected).<br/>Permits incomplete slot definitions (zero-option slots or capacity deficits) with structured warnings.<br/>Preserves all configured slots without slot deletion.<br/>[control: saveDraftInactiveAction, action: saveComboConfigurationsInactive]<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002, REQ-MENU-LIF-003, C-COM-010]"]

        CheckInactiveSlots{"Does every ComboConfiguration<br/>contain at least one ComboSlot?<br/>(slots.count >= 1 for all configurations)<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002]"}

        InactiveZeroSlotRejected["Validation Error: Inactive Save Blocked.<br/>Every ComboConfiguration must contain at least one ComboSlot.<br/>Zero-slot configurations cannot be persisted in INACTIVE or ACTIVE status.<br/>Returned to slot authoring to create required slot.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002]"]

        CheckInactiveIncompleteCases{"Are there incomplete slot definitions or capacity deficits?<br/>(Any slot has options.count == 0 OR<br/>mandatory slot calculatedCapacity < minSelections)<br/>[REQ-MENU-COM-002, REQ-MENU-COM-003, REQ-MENU-LIF-002, REQ-MENU-LIF-003]"}

        GenerateCapacityWarnings["State: inactiveSavedWithCapacityWarnings<br/>Generate structured incompleteCapacityWarnings:<br/>entityId (ComboSlot UUID), entityType = 'ComboSlot',<br/>configurationId, configurationName, slotName, minSelections, calculatedCapacity.<br/>Diagnostic message exposed in administrative UI for zero-option slots or capacity deficits.<br/>All configured slots are preserved and persisted (no slot deletion).<br/>[data: incompleteCapacityWarnings]<br/>[REQ-MENU-COM-002, REQ-MENU-LIF-002, REQ-MENU-LIF-003, C-COM-010]"]

        PersistInactiveCombo["Persist COMBO MenuItem with administrativeStatus = INACTIVE.<br/>Persists all configurations, slots (including zero-option slots), and options.<br/>Generate new immutable commercial revision token '<number>_<ISO8601>'.<br/>Emit savedMenuItemId, newRevisionToken, and returnToItemEditorSignal.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002, REQ-MENU-VER-001, C-COM-011]"]

        %% Save and Activate
        TriggerSaveActivate["Execute saveAndActivateAction<br/>Validate complete structural capacity and persist with status ACTIVE.<br/>Requires at least one configuration, at least one slot in every configuration,<br/>no zero-option slots, valid bounds/prices, and sufficient capacity for all mandatory slots.<br/>[control: saveAndActivateAction, action: saveComboConfigurationsAndActivate]<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]"]

        EvaluateActiveIntegrity{"Validate structuralValidationStatus.isEligibleForActive:<br/>1. Total configurations count >= 1 [REQ-MENU-COM-001]<br/>2. At least one ComboSlot in EVERY configuration (zero-slot configs strictly rejected) [REQ-MENU-COM-001, REQ-MENU-COM-002]<br/>3. Every ComboSlot contains at least one ComboOption (zero-option slots prohibited in ACTIVE) [REQ-MENU-COM-002, REQ-MENU-COM-003, REQ-MENU-COM-006]<br/>4. Every mandatory ComboSlot across ALL configs satisfies calculatedCapacity >= minSelections<br/>   using complete REQ-MENU-VAR-006 predicate (excluding momentary stock) [REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]<br/>5. All selection bounds satisfy 0 <= minSelections <= maxSelections [REQ-MENU-COM-002, INV-MENU-005]<br/>6. All configuration unitPrice >= 0 [REQ-MENU-COM-001, INV-MENU-005]<br/>7. All option quantities >= 1 [REQ-MENU-COM-003]"}

        ActiveValidationRejected["Validation Error: Activation Blocked (isEligibleForActive == false).<br/>Display blockingValidationErrors in UI.<br/>Item is NOT silently activated; remains in working buffer / INACTIVE.<br/>Zero-slot configurations, zero-option slots, and capacity deficits are strictly blocked.<br/>Administrator must correct structural deficits in slot authoring or save as INACTIVE draft.<br/>Does NOT imply slot deletion.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, REQ-MENU-LIF-002, INV-MENU-005]"]

        PersistActiveCombo["State: activeSavedCapacitySatisfied (isEligibleForActive == true)<br/>Persist COMBO MenuItem with administrativeStatus = ACTIVE.<br/>All configurations have >= 1 slot, no zero-option slots, and sufficient mandatory slot capacity.<br/>Generate new immutable commercial revision token '<number>_<ISO8601>'.<br/>Publish updated combo configurations to active catalog.<br/>Emit savedMenuItemId, newRevisionToken, and returnToItemEditorSignal.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, REQ-MENU-VER-001, INV-MENU-005, C-COM-011]"]
    end

    %% ----------------- EDGES & TRANSITIONS -----------------

    %% Entry & scope check
    Entry --> CheckItemType
    CheckItemType -->|type != COMBO| RejectNonComboItem
    RejectNonComboItem --> ExitReturn
    CheckItemType -->|type == COMBO| LoadComboContext

    LoadComboContext --> SelectConfigurationFocus

    %% Viewing configurations list vs focusing configuration
    SelectConfigurationFocus -->|configurationId == null| StateViewingConfigurations
    StateViewingConfigurations --> CreateConfiguration
    CreateConfiguration --> StateEditingConfiguration

    SelectConfigurationFocus -->|configurationId != null| StateEditingConfiguration

    %% Configuration attributes & review flag
    StateEditingConfiguration --> UpdateConfigurationAttributes
    UpdateConfigurationAttributes --> CheckReviewFlag

    CheckReviewFlag -->|reviewStatus == 'REVIEW_REQUIRED'| StateReviewRequired
    StateReviewRequired --> ReviewPendingIndication
    ReviewPendingIndication --> CheckConfigurationSlots

    CheckReviewFlag -->|reviewStatus == 'UP_TO_DATE'| CheckConfigurationSlots

    %% Slot management
    CheckConfigurationSlots -->|slots.count == 0| EmptyConfigurationState
    EmptyConfigurationState --> CreateSlot
    EmptyConfigurationState -->|Attempt save or exit| SelectSaveOrExit

    CheckConfigurationSlots -->|slots.count > 0| ConfigureSlotBounds
    ConfigureSlotBounds --> ValidateSlotBounds

    ValidateSlotBounds -->|minSelections > maxSelections| SlotBoundsRejected
    SlotBoundsRejected --> ConfigureSlotBounds

    ValidateSlotBounds -->|0 <= minSelections <= maxSelections| ManageSlotOptions

    StateEditingConfiguration --> CreateSlot
    CreateSlot --> ConfigureSlotBounds

    %% Option management
    ManageSlotOptions --> CreateOption
    ManageSlotOptions -->|Zero options authored| EvaluateSlotCapacity

    CreateOption --> ConfigureDirectVariant
    ConfigureDirectVariant --> ConfigureQuantityAndPriceDelta
    ConfigureQuantityAndPriceDelta --> ToggleOptionEnablement
    ToggleOptionEnablement --> EvaluateSlotCapacity

    %% Administrative Copy Branch
    StateEditingConfiguration -->|Initiate copy from this configuration| InitiateCopy
    InitiateCopy --> SelectCopyTarget
    SelectCopyTarget --> CheckCopyTargetType

    CheckCopyTargetType -->|Target already contains prior slots| RecordCopyConflictIssue
    RecordCopyConflictIssue --> ExecuteConfigurationCopy

    CheckCopyTargetType -->|Target is brand new or empty| ExecuteConfigurationCopy

    ExecuteConfigurationCopy --> CopyExecutionSuccess
    CopyExecutionSuccess --> EvaluateSlotCapacity

    %% Atomic Bulk Assignment Branch
    StateEditingConfiguration -->|Initiate bulk option assignment| InitiateBulkAssignment
    InitiateBulkAssignment --> SelectBulkTargetConfigs
    SelectBulkTargetConfigs --> SpecifyTargetSlotName
    SpecifyTargetSlotName --> ExecuteBulkAssignmentAction
    ExecuteBulkAssignmentAction --> EvaluateBulkAssignmentEligibility

    EvaluateBulkAssignmentEligibility -->|Slot missing or validation failed on any config| BulkAssignmentRollback
    BulkAssignmentRollback --> SpecifyTargetSlotName

    EvaluateBulkAssignmentEligibility -->|All target configurations pass validation| BulkAssignmentSuccess
    BulkAssignmentSuccess --> EvaluateSlotCapacity

    %% Structural Capacity Evaluation
    EvaluateSlotCapacity --> CheckSlotCapacityRequirements
    CheckSlotCapacityRequirements -->|calculatedCapacity < minSelections| StateCapacityDeficit
    CheckSlotCapacityRequirements -->|calculatedCapacity >= minSelections| StateCapacitySatisfied

    StateCapacityDeficit --> SelectSaveOrExit
    StateCapacitySatisfied --> SelectSaveOrExit

    %% Persistence & Outcomes
    SelectSaveOrExit -->|cancelConfigurationAction| CancelExit
    CancelExit --> ExitReturn

    SelectSaveOrExit -->|saveDraftInactiveAction| TriggerSaveInactive
    TriggerSaveInactive --> CheckInactiveSlots
    CheckInactiveSlots -->|Any config has slots.count == 0| InactiveZeroSlotRejected
    InactiveZeroSlotRejected -->|Return to slot authoring| CreateSlot
    CheckInactiveSlots -->|All configs have slots.count >= 1| CheckInactiveIncompleteCases
    CheckInactiveIncompleteCases -->|Zero-option slots or capacity deficits detected| GenerateCapacityWarnings
    CheckInactiveIncompleteCases -->|No deficits or incomplete slots| PersistInactiveCombo
    GenerateCapacityWarnings --> PersistInactiveCombo
    PersistInactiveCombo --> ExitReturn

    SelectSaveOrExit -->|saveAndActivateAction| TriggerSaveActivate
    TriggerSaveActivate --> EvaluateActiveIntegrity
    EvaluateActiveIntegrity -->|Integrity check fails| ActiveValidationRejected
    ActiveValidationRejected -->|Return to slot authoring to correct deficits| StateEditingConfiguration
    ActiveValidationRejected -->|Or choose another action| SelectSaveOrExit
    EvaluateActiveIntegrity -->|Integrity check passes| PersistActiveCombo
    PersistActiveCombo --> ExitReturn
```
