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
  - BR-MENU-026
  - BR-MENU-027
  - BR-MENU-028
  - BR-MENU-029
  - INV-MENU-005
  - INV-MENU-007
  - INV-MENU-008
  - INV-MENU-009
  - INV-MENU-010
  - INV-MENU-011
  - INV-MENU-012
---

# Flow: Manage Combo Configurations, Slots, and Options

```mermaid
flowchart TD
    subgraph ExternalContext["External Context (MenuItemEditorView)"]
        Entry(["Entry: ADMINISTRATOR<br/>(Inputs: menuItemId, optional initialConfigurationId, returnContext: MenuItemEditorView)<br/>[REQ-MENU-COM-001]"])
        ExitReturn(["Return to MenuItemEditorView<br/>(Outputs: savedMenuItemId, newRevisionToken, returnToItemEditorSignal, optional batchCopyReportNotification)<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-002, REQ-MENU-VER-001]"])
    end

    subgraph ComboConfigurationView["ComboConfigurationView"]
        %% Aggregate Boundary & Type Check
        CheckItemType{"Is target MenuItem a COMBO package item?<br/>(type == COMBO)<br/>[REQ-MENU-COM-001, C-COM-001]"}
        RejectNonComboItem["Precondition Exclusion: Non-COMBO MenuItem Excluded.<br/>Combo configuration is exclusive to COMBO MenuItems.<br/>Leaf items (PREPARED / STOCKED) manage variants and modifiers.<br/>[REQ-MENU-COM-001, C-COM-001]"]

        LoadComboContext["Load COMBO MenuItem context and existing configurations.<br/>Display commercial identity: name, immutable type COMBO,<br/>parent administrativeStatus (ACTIVE / INACTIVE), currencyCode (ISO 4217), and revision token.<br/>CRITICAL: COMBO items possess NO MenuItemVariants or ModifierGroups.<br/>ComboConfiguration entities possess NO administrative status.<br/>[data: comboItemContext, comboConfigurations]<br/>[REQ-MENU-COM-001, C-COM-001, C-COM-002, INV-MENU-007]"]

        SelectConfigurationFocus{"Focus on existing configuration<br/>or manage configurations collection?<br/>[control: configurationFocusSelector, action: selectConfigurationForFocus]<br/>[REQ-MENU-COM-001]"}

        %% ----------------- CONFIGURATION MANAGEMENT -----------------
        StateViewingConfigurations["State: viewingConfigurationsList<br/>Authoring and monitoring ComboConfigurations collection.<br/>(focusedConfigurationDetails.configurationId == null)<br/>[data: comboConfigurations]<br/>[REQ-MENU-COM-001]"]

        CreateConfiguration["Create new ComboConfiguration entity:<br/>Define commercial name (1..120 Unicode chars after trim) and authoritative absolute unitPrice in DECIMAL(12,2) [0.00..9999999999.99] in menu ISO 4217 currency.<br/>reviewStatus initialized to UP_TO_DATE. Slots initialized empty.<br/>(NOTE: At least one ComboSlot must be added before persistence;<br/>configurations with zero slots are strictly rejected upon save).<br/>[control: addComboConfigurationAction, action: createComboConfiguration]<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, C-COM-002, C-COM-003, INV-MENU-005, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-012]"]

        StateEditingConfiguration["State: editingConfigurationSlots<br/>Focused on specific ComboConfiguration.<br/>Inspect and edit configuration commercial attributes.<br/>[data: focusedConfigurationDetails]<br/>[REQ-MENU-COM-001]"]

        UpdateConfigurationAttributes["Update configuration commercial attributes:<br/>1. Commercial display name: updateConfigurationNameInput (1..120 Unicode chars after trim)<br/>2. Authoritative absolute unitPrice: updateConfigurationUnitPriceInput<br/>   (exact DECIMAL(12,2) in range 0.00..9999999999.99 in menu ISO 4217 currency context;<br/>   price is absolute, not an adjustment; validates resulting combo price >= 0.00).<br/>[controls: updateConfigurationNameInput, updateConfigurationUnitPriceInput,<br/>actions: setConfigurationName, setConfigurationUnitPrice]<br/>[REQ-MENU-COM-001, INV-MENU-005, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-012, BR-MENU-008]"]

        CheckReviewFlag{"Does configuration have<br/>reviewStatus == REVIEW_REQUIRED?<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-001]"}

        StateReviewRequired["State: reviewRequiredFlaggedState<br/>Configuration flagged REVIEW_REQUIRED due to component variant archival or edit.<br/>Parent COMBO administrative status remains completely unchanged.<br/>[data: focusedConfigurationDetails.reviewStatus]<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-001]"]

        ReviewPendingIndication["Semantic Notice: reviewPendingIndication<br/>Informational supervisory indication: configuration reviewStatus is REVIEW_REQUIRED.<br/>Separation of responsibility: review confirmation cannot be performed in this view;<br/>confirmation responsibility belongs solely to ComboReviewView (review-combo.md) via configurationId/reviewToken.<br/>Commercial editing continues with reviewStatus remaining REVIEW_REQUIRED.<br/>[data: focusedConfigurationDetails.reviewStatus]<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-001]"]

        %% ----------------- SLOT MANAGEMENT -----------------
        CheckConfigurationSlots{"Does focused configuration contain slots?<br/>(slots.count > 0)<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002]"}

        EmptyConfigurationState["State: emptyConfigurationState<br/>Configuration currently contains zero ComboSlots.<br/>Persistence is strictly rejected in both INACTIVE and ACTIVE status<br/>until at least one ComboSlot is created.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002]"]

        CreateSlot["Add new ComboSlot selection space:<br/>Define slot display name (1..120 Unicode chars after trim, e.g. 'Platillo Principal', 'Bebida').<br/>Initial bounds: minSelections = 0, maxSelections = 1 in range 0..99.<br/>[control: addComboSlotAction, action: createComboSlot]<br/>[REQ-MENU-COM-002, INV-MENU-005, INV-MENU-011, INV-MENU-012, BR-MENU-011]"]

        ConfigureSlotBounds["Configure selection bounds and display name:<br/>1. Update slot name: updateSlotNameInput (1..120 chars after trim)<br/>2. Update minSelections: updateSlotMinSelectionsInput (integer in 0..99)<br/>3. Update maxSelections: updateSlotMaxSelectionsInput (integer in 0..99, >= minSelections)<br/>[controls: updateSlotNameInput, updateSlotMinSelectionsInput, updateSlotMaxSelectionsInput,<br/>actions: setSlotName, setSlotSelectionBounds]<br/>[REQ-MENU-COM-002, INV-MENU-005, INV-MENU-011, INV-MENU-012, BR-MENU-011]"]

        ValidateSlotBounds{"Validate selection bounds invariant:<br/>0 <= minSelections <= maxSelections <= 99?<br/>[REQ-MENU-COM-002, C-COM-004, INV-MENU-005, INV-MENU-011, BR-MENU-011]"}

        SlotBoundsRejected["Validation Error: Invalid selection boundaries.<br/>minSelections > maxSelections or limits outside 0..99 are strictly invalid and rejected.<br/>Bounds restored to prior valid state.<br/>[REQ-MENU-COM-002, C-COM-004, INV-MENU-011]"]

        %% ----------------- OPTION MANAGEMENT -----------------
        ManageSlotOptions["Manage ComboOption entities within slot.<br/>Options reference concrete leaf MenuItemVariants directly.<br/>(CRITICAL: Combos do NOT own modifier groups in v1).<br/>[data: focusedConfigurationDetails.slots.options]<br/>[REQ-MENU-COM-003, C-COM-005, C-COM-006]"]

        CheckSlotOptionsCount{"Are options defined in slot?<br/>(options.count > 0)<br/>[REQ-MENU-COM-002, REQ-MENU-COM-003]"}

        StateEmptySlotDraft["State: emptySlotIncompleteDraftState<br/>Slot contains zero ComboOptions.<br/>Permitted only while parent COMBO MenuItem is INACTIVE (with incomplete-definition warnings).<br/>Prohibited from activation in ACTIVE status.<br/>[REQ-MENU-COM-002, REQ-MENU-COM-003, REQ-MENU-LIF-002]"]

        CreateOption["Add ComboOption to slot:<br/>[control: addComboOptionAction, action: createComboOption]<br/>[REQ-MENU-COM-003, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]"]

        ConfigureDirectVariant["Select concrete leaf MenuItemVariant directly (itemVariantId):<br/>Must reference a PREPARED or STOCKED item variant.<br/>Combos cannot reference other combos.<br/>Deprecated menuItemId + AllowedVariant model is discontinued.<br/>[control: selectOptionItemVariantInput, action: setOptionItemVariant]<br/>[REQ-MENU-COM-003, REQ-MENU-COM-006, REQ-MENU-VAR-006, C-COM-005]"]

        ConfigureQuantityAndPriceDelta["Configure delivered quantity and signed price adjustment:<br/>1. Positive physical delivered quantity multiplier: integer quantity in 1..99 (updateOptionQuantityInput)<br/>   Whole physical units without fractional coefficients;<br/>   dictates runtime inventory/recipe consumption;<br/>   contributes at most 1 selection to slot capacity.<br/>   (Commercial fractional portions require concrete leaf variant).<br/>2. Explicit signed priceDelta: DECIMAL(12,2) [-9999999999.99..+9999999999.99] (updateOptionPriceDeltaInput)<br/>   Added to configuration unitPrice; resulting combo price must satisfy final price >= 0.00.<br/>[controls: updateOptionQuantityInput, updateOptionPriceDeltaInput,<br/>actions: setOptionQuantity, setOptionPriceDelta]<br/>[REQ-MENU-COM-003, REQ-MENU-ING-001, C-COM-005, INV-MENU-007, INV-MENU-008, INV-MENU-009, INV-MENU-010, INV-MENU-011, BR-MENU-008]"]

        ToggleOptionEnablement["Toggle administrative option enablement:<br/>enabled = true / false.<br/>Disabled options excluded from slot capacity and runtime ordering.<br/>[control: toggleOptionEnabledToggle, action: setOptionEnabled]<br/>[REQ-MENU-COM-003, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005, C-COM-004]"]

        %% ----------------- ADMINISTRATIVE BATCH COPY & ASSIGNMENT -----------------
        InitiateBatchCopy["Initiate administrative batch copy:<br/>Select source ComboConfiguration (sourceConfigurationId).<br/>Toggle predictive dryRun simulation (true/false).<br/>[controls: selectBatchCopySourceSelector, toggleBatchCopyDryRunToggle,<br/>actions: setBatchCopySourceConfiguration, toggleBatchCopyDryRun]<br/>[REQ-MENU-COM-004, REQ-MENU-COM-005, BR-MENU-026, BR-MENU-027]"]

        ConfigureBatchOperations["Configure copy destination operations in batchCopyBuffer:<br/>Add/remove destination items.<br/>Select mode: FULL_CLONE vs COPY_TO_EXISTING.<br/>[controls: addBatchCopyOperationAction, removeBatchCopyOperationAction, selectOperationModeSelector,<br/>actions: addBatchCopyOperation, removeBatchCopyOperation, configureBatchCopyOperation]<br/>[REQ-MENU-COM-004, REQ-MENU-COM-005, BR-MENU-026]"]

        CheckOperationMode{"Which mode is configured<br/>for the destination operation?<br/>[control: selectOperationModeSelector]<br/>[REQ-MENU-COM-004, BR-MENU-026]"}

        ConfigureFullClone["Configure FULL_CLONE mode:<br/>1. Destination owner: inputOperationTargetMenuItemInput (targetMenuItemId)<br/>   (Supports cross-item and same-item targetMenuItemId).<br/>2. Cloned configuration name: inputOperationNewConfigNameInput<br/>   (newConfigurationName is explicitly optional; omission retains the source configuration name;<br/>   1..120 Unicode chars after trim applies only when supplied).<br/>Clones source structure and descriptive slot order.<br/>Regenerates unique UUID identities for configuration, all slots, and all options.<br/>[controls: inputOperationTargetMenuItemInput, inputOperationNewConfigNameInput,<br/>action: configureBatchCopyOperation]<br/>[REQ-MENU-COM-004, BR-MENU-026, INV-MENU-012]"]

        ConfigureCopyToExisting["Configure COPY_TO_EXISTING mode:<br/>1. Destination configuration: selectOperationTargetConfigSelector (targetConfigurationId)<br/>2. Local conflict policy: selectOperationConflictPolicySelector (conflictPolicy: 'FAIL' | 'REPLACE')<br/>3. Explicit slot mappings: configureOperationSlotMappingsAction<br/>   Every sourceSlotId maps explicitly to targetSlotId OR createNewSlot = true.<br/>   Automatic matching, name-based heuristics, or positional alignment strictly prohibited.<br/>[controls: selectOperationTargetConfigSelector, selectOperationConflictPolicySelector,<br/>configureOperationSlotMappingsAction,<br/>actions: configureBatchCopyOperation, setBatchCopySlotMappings]<br/>[REQ-MENU-COM-004, REQ-MENU-COM-005, BR-MENU-026, BR-MENU-027]"]

        ReadyToExecuteBatchCopy["Review batch copy buffer:<br/>Verify operations, mode parameters, explicit slot mappings, conflict policies, and dryRun selection.<br/>(Optional: resetBatchCopyBufferAction to clear buffer).<br/>[controls: executeBatchCopyAction, resetBatchCopyBufferAction,<br/>actions: executeBatchCopy, resetBatchCopyBuffer]<br/>[REQ-MENU-COM-005]"]

        CheckResetBatchCopy{"Reset buffer or execute batch copy?<br/>[REQ-MENU-COM-005]"}

        ExecuteResetBatchCopy["Reset batch copy buffer:<br/>Clears operations, selections, and last report.<br/>[control: resetBatchCopyBufferAction, action: resetBatchCopyBuffer]<br/>[REQ-MENU-COM-005]"]

        ExecuteBatchCopyAction["Execute executeBatchCopyAction:<br/>Submit batch operations with optional client idempotencyKey.<br/>[control: executeBatchCopyAction, action: executeBatchCopy]<br/>[REQ-MENU-COM-004, REQ-MENU-COM-005, BR-MENU-026, BR-MENU-027, BR-MENU-028]"]

        EvaluateIdempotencyAndValidation{"Evaluate idempotencyKey and payload validity:<br/>1. Is idempotencyKey reused in same mode with altered parameters?<br/>2. Are operation inputs valid (exhaustive mappings, valid IDs, names)?<br/>[REQ-MENU-COM-005, BR-MENU-026, BR-MENU-027]"}

        IdempotencyConflictOutcome["Outcome: IDEMPOTENCY_CONFLICT / Validation Error.<br/>Idempotency key reuse with differing parameters within the same mode is rejected.<br/>Execution blocked with structured error diagnostics without modifying state.<br/>Administrator prompted to provide distinct idempotencyKey or match payload.<br/>[data: batchCopyBuffer.lastBatchReport]<br/>[REQ-MENU-COM-005, BR-MENU-027]"]

        ProcessBatchTransactions["Process batch operations with per-destination atomicity:<br/>- Each destination is an independent atomic transaction.<br/>- Indivisibility per destination: within each target configuration, all mapped slots/options succeed or entire destination fails (no partial slot rollback).<br/>- Local conflict policy in COPY_TO_EXISTING: 'FAIL' marks destination FAILED; 'REPLACE' clears prior options in target slot and writes copied options.<br/>- Complete idMappings: successful destinations return complete ID mappings (|slots| == createdSlotsCount, |options| == createdOptionsCount; config mapping for FULL_CLONE).<br/>- Emits batchCopyReportNotification and populates lastBatchReport.<br/>[REQ-MENU-COM-004, REQ-MENU-COM-005, BR-MENU-026, BR-MENU-027, BR-MENU-028]"]

        EvaluateBatchOutcomes{"Evaluate batch execution outcome:<br/>Check dryRun mode and per-destination results.<br/>[data: batchCopyBuffer.lastBatchReport]<br/>[REQ-MENU-COM-004, REQ-MENU-COM-005, BR-MENU-026, BR-MENU-027, BR-MENU-028]"}

        StateSimulationSuccess["State: batchCopySimulationSuccess<br/>Predictive simulation (dryRun == true) completed successfully across all destinations.<br/>- Zero database persistence, zero Pub/Sub events, zero revision increments, zero status changes.<br/>- Deterministic simulated UUID idMappings and projected created counts.<br/>- Mode-separated idempotency preserves key for subsequent definitive execution.<br/>Administrator may inspect projections and toggle dryRun to false.<br/>[data: batchCopyBuffer.lastBatchReport]<br/>[REQ-MENU-COM-005, BR-MENU-027]"]

        StateExecutionSuccess["State: batchCopyExecutionSuccess<br/>Administrative batch copy executed definitively (dryRun == false) with all destinations SUCCESS.<br/>- Cloned/created configurations and slots receive newly regenerated unique UUIDs.<br/>- Complete idMappings exposed for all created entities.<br/>- Increments COMBO MenuItem commercial revision token (<number>_<ISO8601>).<br/>- Recalculates structural capacities across modified configurations.<br/>[data: batchCopyBuffer.lastBatchReport]<br/>[REQ-MENU-COM-004, REQ-MENU-COM-005, BR-MENU-026, BR-MENU-027, REQ-MENU-VER-001]"]

        StatePartialSuccess["State: batchCopyPartialSuccess<br/>Administrative batch copy completed with mixed success across destinations.<br/>- Partial batch success: at least one destination SUCCESS and at least one FAILED.<br/>- Per-destination atomicity: confirmed destination modifications are preserved (no cross-destination rollback).<br/>- FAILED destinations report structured diagnostics (field, issue, rejectedValue, message) with retryable = true.<br/>- Complete idMappings returned for SUCCESS destinations.<br/>- Commercial revision token increments if dryRun == false.<br/>[data: batchCopyBuffer.lastBatchReport]<br/>[REQ-MENU-COM-005, BR-MENU-027, BR-MENU-028, REQ-MENU-VER-001]"]

        StateExecutionFailed["State: batchCopyExecutionFailed<br/>Administrative batch copy failed across all destination operations.<br/>- Zero corruption: indivisibility per destination ensures zero partial writes.<br/>- Each destination provides structured diagnostics and retryable status.<br/>- No commercial revision increment.<br/>[data: batchCopyBuffer.lastBatchReport]<br/>[REQ-MENU-COM-005, BR-MENU-027, BR-MENU-028]"]

        %% ----------------- STRUCTURAL CAPACITY EVALUATION -----------------
        EvaluateSlotCapacity["Real-time structural capacity evaluation per ComboSlot:<br/>calculatedCapacity = count of enabled options whose referenced leaf variants<br/>satisfy the complete REQ-MENU-VAR-006 structural predicate:<br/>- Owning leaf MenuItem is ACTIVE<br/>- Variant is ACTIVE and not ARCHIVED<br/>- Complete PREPARED supply linkage (valid recipe revision) or STOCKED supply linkage (inventoryItemId, quantity)<br/>- All mandatory modifier groups (minSelections > 0) are satisfiable.<br/>Physical delivered quantity multiplier (1..99) contributes at most 1 selection regardless of quantity.<br/>VariantAvailability and momentary Inventory stock availability are explicitly excluded.<br/>[data: structuralValidationStatus, focusedConfigurationDetails.slots]<br/>[REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005, C-COM-004, C-COM-009]"]

        CheckSlotCapacityRequirements{"Do all mandatory slots (minSelections > 0)<br/>satisfy calculatedCapacity >= minSelections?<br/>[REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]"}

        StateCapacityDeficit["State: mandatorySlotCapacityDeficit<br/>One or more mandatory slots lack sufficient eligible options.<br/>isCapacitySatisfied = false. isStructurallyEligible = false.<br/>Parent item transition to ACTIVE blocked.<br/>Permitted to persist ONLY while parent COMBO MenuItem is INACTIVE (with warnings).<br/>Does NOT imply slot deletion.<br/>[REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, REQ-MENU-LIF-002, INV-MENU-005]"]

        StateCapacitySatisfied["State: mandatorySlotCapacitySatisfied<br/>All mandatory slots meet or exceed required selection capacity<br/>based on the complete REQ-MENU-VAR-006 structural predicate.<br/>isCapacitySatisfied = true. isStructurallyEligible = true.<br/>[REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]"]

        %% ----------------- PERSISTENCE & LIFECYCLE OUTCOMES -----------------
        SelectSaveOrExit{"Administrative save or exit action?<br/>[REQ-MENU-COM-001, REQ-MENU-LIF-002, REQ-MENU-LIF-003]"}

        CancelExit["Cancel configuration: discard pending working buffer changes.<br/>No commercial revision generated.<br/>[control: cancelConfigurationAction, action: cancelConfiguration]<br/>(Emits returnToItemEditorSignal)"]

        %% Save Draft Inactive
        TriggerSaveInactive["Execute saveDraftInactiveAction<br/>Persist combo configurations with parent COMBO MenuItem status INACTIVE under single menu ISO 4217 currency.<br/>Requires at least one ComboSlot per configuration (zero-slot configurations strictly rejected).<br/>Permits incomplete slot definitions (zero-option slots or capacity deficits) with structured warnings.<br/>Preserves all configured slots without slot deletion.<br/>[control: saveDraftInactiveAction, action: saveComboConfigurationsInactive]<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002, REQ-MENU-LIF-003, C-COM-010, INV-MENU-007]"]

        CheckInactiveSlots{"Does every ComboConfiguration<br/>contain at least one ComboSlot?<br/>(slots.count >= 1 for all configurations)<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002]"}

        InactiveZeroSlotRejected["Validation Error: Inactive Save Blocked.<br/>Every ComboConfiguration must contain at least one ComboSlot.<br/>Zero-slot configurations cannot be persisted in INACTIVE or ACTIVE status.<br/>Returned to slot authoring to create required slot.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002]"]

        CheckInactiveIncompleteCases{"Are there incomplete slot definitions or capacity deficits?<br/>(Any slot has options.count == 0 OR<br/>mandatory slot calculatedCapacity < minSelections)<br/>[REQ-MENU-COM-002, REQ-MENU-COM-003, REQ-MENU-LIF-002, REQ-MENU-LIF-003]"}

        GenerateCapacityWarnings["State: inactiveSavedWithCapacityWarnings<br/>Generate structured incompleteCapacityWarnings:<br/>entityId (ComboSlot UUID), entityType = 'ComboSlot',<br/>configurationId, configurationName, slotName, minSelections, calculatedCapacity.<br/>Diagnostic message exposed in administrative UI for zero-option slots or capacity deficits.<br/>All configured slots are preserved and persisted (no slot deletion).<br/>[data: incompleteCapacityWarnings]<br/>[REQ-MENU-COM-002, REQ-MENU-LIF-002, REQ-MENU-LIF-003, C-COM-010]"]

        PersistInactiveCombo["Persist COMBO MenuItem with administrativeStatus = INACTIVE.<br/>Persists all configurations, slots (including zero-option slots), and options.<br/>Generate new immutable commercial revision token '<number>_<ISO8601>'.<br/>Emit savedMenuItemId, newRevisionToken, and returnToItemEditorSignal.<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-LIF-002, REQ-MENU-VER-001, C-COM-011]"]

        %% Save and Activate
        TriggerSaveActivate["Execute saveAndActivateAction<br/>Validate complete structural capacity and persist with status ACTIVE under single menu ISO 4217 currency.<br/>Requires at least one configuration, at least one slot in every configuration,<br/>no zero-option slots, valid bounds/prices, and sufficient capacity for all mandatory slots.<br/>[control: saveAndActivateAction, action: saveComboConfigurationsAndActivate]<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005, INV-MENU-007]"]

        EvaluateActiveIntegrity{"Validate structuralValidationStatus.isEligibleForActive:<br/>1. Total configurations count >= 1 [REQ-MENU-COM-001]<br/>2. At least one ComboSlot in EVERY configuration (zero-slot configs strictly rejected) [REQ-MENU-COM-001, REQ-MENU-COM-002]<br/>3. Every ComboSlot contains at least one ComboOption (zero-option slots prohibited in ACTIVE) [REQ-MENU-COM-002, REQ-MENU-COM-003, REQ-MENU-COM-006]<br/>4. Every mandatory ComboSlot across ALL configs satisfies calculatedCapacity >= minSelections<br/>   using complete REQ-MENU-VAR-006 predicate (excluding momentary stock) [REQ-MENU-COM-006, REQ-MENU-VAR-006, INV-MENU-005]<br/>5. All selection bounds satisfy 0 <= minSelections <= maxSelections <= 99 [REQ-MENU-COM-002, INV-MENU-011, BR-MENU-011]<br/>6. All configuration unitPrice in DECIMAL(12,2) [0.00..9999999999.99] and resulting prices >= 0.00 under menu ISO 4217 currency [INV-MENU-007..010, BR-MENU-008]<br/>7. All option quantities are integers in 1..99 [REQ-MENU-COM-003, INV-MENU-011]<br/>8. All configuration and slot names trimmed 1..120 Unicode chars [INV-MENU-012]"}

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
    StateEditingConfiguration --> CreateSlot
    CreateSlot --> ConfigureSlotBounds

    ConfigureSlotBounds --> ValidateSlotBounds
    ValidateSlotBounds -->|minSelections > maxSelections or limits outside 0..99| SlotBoundsRejected
    SlotBoundsRejected --> ConfigureSlotBounds
    ValidateSlotBounds -->|0 <= minSelections <= maxSelections <= 99| ManageSlotOptions

    %% Option management
    ManageSlotOptions --> CheckSlotOptionsCount
    CheckSlotOptionsCount -->|options.count == 0| StateEmptySlotDraft
    StateEmptySlotDraft --> CreateOption
    StateEmptySlotDraft -->|Evaluate capacity or inactive draft save| EvaluateSlotCapacity

    CheckSlotOptionsCount -->|options.count > 0| CreateOption
    CheckSlotOptionsCount -->|Evaluate capacity| EvaluateSlotCapacity

    CreateOption --> ConfigureDirectVariant
    ConfigureDirectVariant --> ConfigureQuantityAndPriceDelta
    ConfigureQuantityAndPriceDelta --> ToggleOptionEnablement
    ToggleOptionEnablement --> EvaluateSlotCapacity

    %% Administrative Batch Copy & Assignment
    StateViewingConfigurations -->|Initiate batch copy| InitiateBatchCopy
    StateEditingConfiguration -->|Initiate batch copy| InitiateBatchCopy
    InitiateBatchCopy --> ConfigureBatchOperations
    ConfigureBatchOperations --> CheckOperationMode
    CheckOperationMode -->|mode == 'FULL_CLONE'| ConfigureFullClone
    CheckOperationMode -->|mode == 'COPY_TO_EXISTING'| ConfigureCopyToExisting
    ConfigureFullClone --> ReadyToExecuteBatchCopy
    ConfigureCopyToExisting --> ReadyToExecuteBatchCopy

    ReadyToExecuteBatchCopy --> CheckResetBatchCopy
    CheckResetBatchCopy -->|resetBatchCopyBufferAction| ExecuteResetBatchCopy
    ExecuteResetBatchCopy --> StateEditingConfiguration

    CheckResetBatchCopy -->|executeBatchCopyAction| ExecuteBatchCopyAction
    ExecuteBatchCopyAction --> EvaluateIdempotencyAndValidation

    EvaluateIdempotencyAndValidation -->|Idempotency conflict or invalid mappings| IdempotencyConflictOutcome
    IdempotencyConflictOutcome --> ReadyToExecuteBatchCopy

    EvaluateIdempotencyAndValidation -->|Valid key and operation payload| ProcessBatchTransactions
    ProcessBatchTransactions --> EvaluateBatchOutcomes

    EvaluateBatchOutcomes -->|dryRun == true and all SUCCESS| StateSimulationSuccess
    EvaluateBatchOutcomes -->|dryRun == false and all SUCCESS| StateExecutionSuccess
    EvaluateBatchOutcomes -->|At least one SUCCESS and at least one FAILED| StatePartialSuccess
    EvaluateBatchOutcomes -->|All destinations FAILED| StateExecutionFailed

    StateSimulationSuccess --> ReadyToExecuteBatchCopy
    StateExecutionSuccess --> EvaluateSlotCapacity
    StatePartialSuccess --> ReadyToExecuteBatchCopy
    StatePartialSuccess --> EvaluateSlotCapacity
    StateExecutionFailed --> ReadyToExecuteBatchCopy

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
