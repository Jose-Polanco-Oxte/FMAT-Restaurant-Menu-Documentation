---
id: configure-sellable-item
name: Configure Sellable Item
actors:
  - POS_CLIENT
  - KDS_CLIENT
views:
  - SellableItemConfigurationView
requirements:
  - REQ-MENU-ITM-001
  - REQ-MENU-VAR-001
  - REQ-MENU-VAR-002
  - REQ-MENU-VAR-003
  - REQ-MENU-VAR-004
  - REQ-MENU-VAR-006
  - REQ-MENU-PRC-001
  - REQ-MENU-PRC-002
  - REQ-MENU-MOD-001
  - REQ-MENU-MOD-002
  - REQ-MENU-MOD-003
  - REQ-MENU-MOD-005
  - REQ-MENU-MOD-006
  - REQ-MENU-MOD-007
  - REQ-MENU-MOD-008
  - REQ-MENU-COM-001
  - REQ-MENU-COM-002
  - REQ-MENU-COM-003
  - REQ-MENU-COM-006
  - REQ-MENU-AVL-002
  - REQ-MENU-AVL-004
  - REQ-MENU-AVL-005
  - REQ-MENU-AVL-006
  - REQ-MENU-AVL-007
  - NFR-MENU-PERF-02
  - NFR-MENU-RESI-01
  - BR-MENU-016
  - BR-MENU-017
  - BR-MENU-018
  - OPEN-009
---

# Flow: Configure Sellable Item

```mermaid
flowchart TD
    subgraph ExternalContext["External POS / KDS Context"]
        Entry(["Entry: POS_CLIENT / KDS_CLIENT<br/>(Inputs: menuItemId, optional initialVariantId / initialComboConfigurationId)<br/>[REQ-MENU-ITM-001, NFR-MENU-PERF-02]"])
        ReturnSelection(["Return ConfiguredSelectionHandoff<br/>(Valid commercial selection returned to external ordering context;<br/>Preserves slot/option/component-to-modifier correlation & signed deltas;<br/>No Orders-owned line creation or cart submission;<br/>OPEN-009 unmodeled for fractional/repeat pricing)<br/>[REQ-MENU-ITM-001, REQ-MENU-PRC-001, REQ-MENU-COM-001, BR-MENU-016, BR-MENU-017, OPEN-009]"])
    end

    subgraph SellableItemConfigurationView["SellableItemConfigurationView"]
        CheckItemType{"MenuItem type discriminator?<br/>[REQ-MENU-ITM-001, BR-MENU-018]"}

        %% ----------------- LEAF PRODUCT BRANCH (PREPARED / STOCKED) -----------------
        CheckDimensions{"Does leaf item define<br/>commercial dimensions?<br/>[REQ-MENU-VAR-001, REQ-MENU-VAR-002]"}
        AutoSelectDefault["State: leafSingleDefaultVariant<br/>Automatically select technical DEFAULT variant.<br/>Suppress variant selection controls from UI.<br/>[REQ-MENU-VAR-001, C-SIC-002]"]
        PromptDimensions["State: leafMultiVariantPrompt<br/>Display dimensional variant options<br/>[REQ-MENU-VAR-002, REQ-MENU-VAR-003, REQ-MENU-VAR-004]"]
        SelectVariant["User selects leaf variant<br/>[control: variantSelector, action: selectVariant]"]

        CheckVariantEligible{"Is variant structurally eligible<br/>& operationally available?<br/>(isStructurallyEligible && isAvailable)<br/>[REQ-MENU-VAR-006, REQ-MENU-AVL-004]"}
        VariantUnavailable["State: itemUnavailableGranular<br/>Display variant unavailable notice.<br/>Net inventory cannot cover recipe or supply incomplete.<br/>[REQ-MENU-VAR-006, REQ-MENU-AVL-004]"]

        SetLeafBasePrice["Set base price: baseUnitPrice = variant.unitPrice<br/>Load modifier groups & resolved options<br/>[REQ-MENU-PRC-001, REQ-MENU-MOD-001, REQ-MENU-MOD-008]"]

        CheckGroupCapacity{"For all mandatory groups (minSelections > 0):<br/>groupAvailableCapacity >= minSelections?<br/>[REQ-MENU-MOD-001, REQ-MENU-AVL-004, REQ-MENU-AVL-005]"}
        RequiredGroupCapacityFailed["State: itemUnavailableGranular<br/>Mandatory group capacity insufficient.<br/>Variant deemed operationally unavailable.<br/>[REQ-MENU-MOD-001, REQ-MENU-AVL-004]"]

        InspectModifierOption["Inspect modifier option in group<br/>[REQ-MENU-MOD-001, REQ-MENU-MOD-008]"]
        CheckOptionAdmin{"Option enabled == true?<br/>[REQ-MENU-MOD-008]"}
        OptionDisabledAdmin["Option administratively disabled.<br/>Quantity fixed at 0; cannot be selected.<br/>[REQ-MENU-MOD-008]"]

        CheckNullVsZero{"Operational capacity signal (Null-vs-Zero rule):<br/>evaluatedCapacity from Inventory<br/>[REQ-MENU-AVL-005, C-SIC-007]"}
        CapZero["State: optionCapacityExhausted<br/>availableMaxQuantity = 0, isAvailable = false.<br/>Quantitative capacity exhausted: addition disabled.<br/>[REQ-MENU-AVL-005]"]
        CapNull["availableMaxQuantity = null, isAvailable = true.<br/>(OMIT, preparation notes, non-discrete).<br/>effectiveMaxQuantity = configuredMaxQuantity.<br/>[REQ-MENU-MOD-005, REQ-MENU-MOD-006, REQ-MENU-MOD-007, REQ-MENU-AVL-005]"]
        CapDiscrete["availableMaxQuantity = evaluatedCapacity, isAvailable = true.<br/>effectiveMaxQuantity = min(configuredMaxQuantity, availableMaxQuantity).<br/>[REQ-MENU-MOD-008, REQ-MENU-AVL-005]"]

        AdjustModifierQty["User adjusts option quantity<br/>[control: modifierQuantityAdjuster, action: setModifierQuantity]"]
        CheckQtyBounds{"0 <= requestedQty <= effectiveMaxQuantity AND<br/>group currentSelectionsCount + delta <= maxSelections?<br/>[REQ-MENU-MOD-001, REQ-MENU-MOD-008, REQ-MENU-AVL-005]"}
        RejectModifierQty["Reject quantity adjustment: exceeds option limit or group maxSelections<br/>[REQ-MENU-MOD-001, REQ-MENU-AVL-005]"]
        ApplyModifierQty["Apply quantity selection.<br/>Update runningTotalPrice: modifiersTotalDelta += qty * priceDelta<br/>[REQ-MENU-MOD-001, REQ-MENU-MOD-002, REQ-MENU-PRC-001]"]

        CheckLeafValidation{"For all groups: minSelections <= currentSelectionsCount <= maxSelections?<br/>[REQ-MENU-MOD-001]"}
        LeafPendingNotice["State: configurationValidationStatus.isValid = false<br/>Display pending requirement: mandatory group minSelections not reached.<br/>[REQ-MENU-MOD-001]"]
        LeafValid["State: leafConfigurationComplete<br/>configurationValidationStatus.isValid = true.<br/>totalCalculatedPrice = baseUnitPrice + modifiersTotalDelta<br/>[REQ-MENU-MOD-001, REQ-MENU-PRC-001]"]

        %% ----------------- COMBO PACKAGE BRANCH (COMBO) -----------------
        PresentComboConfigs["State: comboConfigurationSelect<br/>Display available ComboConfigurations<br/>[REQ-MENU-COM-001]"]
        SelectComboConfig["User selects ComboConfiguration<br/>[control: comboConfigurationSelector, action: selectComboConfiguration]"]

        CheckComboConfigEligible{"Is configuration eligible & available?<br/>(isStructurallyEligible && isAvailable)<br/>[REQ-MENU-COM-006, REQ-MENU-AVL-006]"}
        ComboConfigUnavailable["State: itemUnavailableGranular<br/>Display configuration unavailable notice.<br/>Mandatory slots lack required capacity or combo inactive.<br/>[REQ-MENU-COM-006, REQ-MENU-AVL-006]"]

        SetComboBasePrice["Set base price: baseUnitPrice = comboConfiguration.unitPrice (>= 0)<br/>Load comboSlots & options<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002]"]

        EvaluateSlotOptions["For each slot option, evaluate selectability:<br/>isSelectable = enabled && referenced variant eligible && available<br/>[REQ-MENU-COM-003, REQ-MENU-VAR-006, REQ-MENU-AVL-004, REQ-MENU-AVL-006]"]
        ComputeSlotCapacity["Compute availableCapacity per slot:<br/>Count of selectable options (each contributes exactly 1).<br/>ComboOption.quantity does not scale capacity.<br/>[REQ-MENU-AVL-006]"]

        CheckMandatorySlotCapacity{"For all mandatory slots (minSelections > 0):<br/>availableCapacity >= minSelections?<br/>[REQ-MENU-COM-002, REQ-MENU-AVL-006]"}
        RequiredSlotCapacityFailed["State: itemUnavailableGranular<br/>Mandatory slot cannot reach minSelections.<br/>Configuration deemed operationally unavailable.<br/>[REQ-MENU-COM-002, REQ-MENU-AVL-006]"]

        PresentSlotOptions["State: comboSlotsConfiguring<br/>Display options per slot<br/>(Selectability and maxSelections restrict additions;<br/>already-selected options remain removable)<br/>[REQ-MENU-COM-002, REQ-MENU-COM-003, REQ-MENU-AVL-006]"]
        SelectComboOption["User toggles option within slot<br/>[control: comboOptionSelector, action: toggleComboOption]"]

        CheckSlotOptionSelected{"Option already selected in slot?<br/>(matched by slotId and comboOptionId)<br/>[REQ-MENU-COM-002]"}

        CheckSlotOptionValid{"Option isSelectable == true AND<br/>currentSelectedCount < slot.maxSelections?<br/>(Enforced only for unselected additions)<br/>[REQ-MENU-COM-002, REQ-MENU-AVL-006]"}
        RejectSlotOption["Reject option addition: slot maxSelections reached or option not selectable<br/>[REQ-MENU-COM-002, REQ-MENU-AVL-006]"]
        ApplySlotOption["Add option to selectedComboOptions.<br/>Update runningTotalPrice: comboOptionsTotalDelta += option.priceDelta (signed delta).<br/>Initialize component modifier context for referenced leaf variant.<br/>[REQ-MENU-COM-002, REQ-MENU-COM-003, BR-MENU-016, BR-MENU-017]"]

        RemoveSlotOption["Remove option from selectedComboOptions by slotId and comboOptionId.<br/>Delete option's component modifier context.<br/>Subtract option priceDelta and component-modifier deltas from runningTotalPrice.<br/>(Allowed regardless of current selectability or slot maxSelections;<br/>permits temporary reduction below minSelections during editing)<br/>[REQ-MENU-COM-002, REQ-MENU-COM-003, BR-MENU-016, BR-MENU-017]"]

        LoadComboComponentModifiers["Load effective modifier groups & resolved options<br/>for referenced component leaf variant (itemVariantId).<br/>Customizations belong to leaf variant & are confined to component.<br/>[REQ-MENU-MOD-001, REQ-MENU-MOD-008, BR-MENU-016, BR-MENU-017, C-SIC-001, C-SIC-016]"]

        CheckComboComponentGroupCapacity{"For all mandatory component groups (minSelections > 0):<br/>groupAvailableCapacity >= minSelections?<br/>[REQ-MENU-MOD-001, REQ-MENU-AVL-004, REQ-MENU-AVL-005, BR-MENU-016]"}
        ComboComponentCapacityFailed["State: itemUnavailableGranular / optionCapacityExhausted<br/>Mandatory modifier group capacity insufficient on component leaf variant.<br/>Invalid alternative: option cannot be validly configured; select alternative.<br/>[REQ-MENU-MOD-001, REQ-MENU-AVL-004, REQ-MENU-AVL-005, BR-MENU-016]"]

        InspectComboComponentModifierOption["Inspect modifier option in component group<br/>[data: comboSlots.options.modifierGroups, REQ-MENU-MOD-001, REQ-MENU-MOD-008, BR-MENU-016]"]
        CheckComboComponentOptionAdmin{"Option enabled == true?<br/>(from ResolvedVariantModifier for component leaf variant)<br/>[REQ-MENU-MOD-008, BR-MENU-016]"}
        ComboComponentOptionDisabledAdmin["Option administratively disabled for this component.<br/>Quantity fixed at 0; cannot be selected.<br/>[REQ-MENU-MOD-008, BR-MENU-016]"]

        CheckComboComponentNullVsZero{"Operational capacity signal (Null-vs-Zero rule):<br/>evaluatedCapacity from Inventory for component leaf variant<br/>[REQ-MENU-AVL-005, C-SIC-007, BR-MENU-016]"]
        ComboComponentCapZero["State: optionCapacityExhausted<br/>availableMaxQuantity = 0, isAvailable = false.<br/>Quantitative capacity exhausted on component: addition disabled.<br/>[REQ-MENU-AVL-005, BR-MENU-016]"]
        ComboComponentCapNull["availableMaxQuantity = null, isAvailable = true.<br/>(OMIT, preparation notes, non-discrete on component).<br/>effectiveMaxQuantity = configuredMaxQuantity.<br/>[REQ-MENU-MOD-005, REQ-MENU-MOD-006, REQ-MENU-MOD-007, REQ-MENU-AVL-005, BR-MENU-016]"]
        ComboComponentCapDiscrete["availableMaxQuantity = evaluatedCapacity, isAvailable = true.<br/>effectiveMaxQuantity = min(configuredMaxQuantity, availableMaxQuantity).<br/>[REQ-MENU-MOD-008, REQ-MENU-AVL-005, BR-MENU-016]"]

        AdjustComboComponentModifierQty["User adjusts component option quantity<br/>[control: comboComponentModifierQuantityAdjuster, action: setComboComponentModifierQuantity]<br/>(Correlated to slotId, comboOptionId, itemVariantId, modifierGroupId, modifierOptionId)<br/>[REQ-MENU-MOD-001, REQ-MENU-MOD-008, BR-MENU-016, BR-MENU-017]"]
        CheckComboComponentQtyBounds{"0 <= requestedQty <= effectiveMaxQuantity AND<br/>component group currentSelectionsCount + delta <= maxSelections?<br/>[REQ-MENU-MOD-001, REQ-MENU-MOD-008, REQ-MENU-AVL-005, BR-MENU-016]"}
        RejectComboComponentModifierQty["Reject quantity adjustment: exceeds option limit or component group maxSelections<br/>[REQ-MENU-MOD-001, REQ-MENU-AVL-005, BR-MENU-016]"]
        ApplyComboComponentModifierQty["Apply component quantity selection.<br/>Update selectionState.selectedComboOptions.componentModifiers.<br/>Update runningTotalPrice: comboComponentModifiersTotalDelta += qty * priceDelta (signed delta).<br/>(Customizations confined to component; OPEN-009 unmodeled for fractional/repeat pricing)<br/>[REQ-MENU-MOD-001, REQ-MENU-MOD-002, REQ-MENU-PRC-001, BR-MENU-016, BR-MENU-017, OPEN-009]"]

        CheckComboValidation{"For all slots: minSelections <= currentSelectedCount <= maxSelections AND<br/>for all selected combo options: all mandatory modifier groups<br/>of each component leaf variant satisfy minSelections <= currentSelectionsCount <= maxSelections?<br/>[REQ-MENU-COM-002, REQ-MENU-MOD-001, BR-MENU-016, BR-MENU-017]"}
        ComboPendingNotice["State: configurationValidationStatus.isValid = false<br/>Display pending requirement: mandatory slot minSelections not reached.<br/>[REQ-MENU-COM-002]"]
        ComboComponentModifierPendingNotice["State: comboComponentModifierPending (isValid = false)<br/>Display pending requirement: mandatory modifier group on selected component leaf variant not satisfied.<br/>[REQ-MENU-MOD-001, REQ-MENU-COM-002, BR-MENU-016, BR-MENU-017]"]
        ComboValid["State: comboConfigurationComplete<br/>configurationValidationStatus.isValid = true.<br/>totalCalculatedPrice = baseUnitPrice + comboOptionsTotalDelta + comboComponentModifiersTotalDelta (all deltas signed).<br/>(Customizations confined to component leaf variant; fractional/repeat pricing unmodeled per OPEN-009)<br/>[REQ-MENU-COM-001, REQ-MENU-COM-002, REQ-MENU-COM-003, REQ-MENU-MOD-001, REQ-MENU-PRC-001, BR-MENU-016, BR-MENU-017, OPEN-009]"]

        %% ----------------- CONFIRMATION & HANDOFF -----------------
        ConfirmSelection["User confirms valid configuration<br/>(Final confirmation validates configurationValidationStatus.isValid == true;<br/>rejects selections below required slot minSelections)<br/>[control: confirmSelection, action: confirmSelection]"]
        EmitPayload["Emit ConfiguredSelectionHandoff to external ordering context<br/>(menuItemId, itemType, selectedVariantId / selectedConfigurationId,<br/>selectedModifiers [leaf] / selectedComboOptions with componentModifiers [correlated by slotId, comboOptionId, itemVariantId, modifierGroupId, modifierOptionId, qty, signed priceDelta],<br/>totalCalculatedPrice = baseUnitPrice + (modifiersTotalDelta OR comboOptionsTotalDelta + comboComponentModifiersTotalDelta)).<br/>(Customizations confined to component leaf variant; OPEN-009 leaves fractional multipliers & repeat aggregation unmodeled)<br/>[REQ-MENU-ITM-001, REQ-MENU-PRC-001, REQ-MENU-COM-001, REQ-MENU-COM-003, REQ-MENU-MOD-001, REQ-MENU-MOD-008, BR-MENU-016, BR-MENU-017, OPEN-009]"]
    end

    %% Entry and branch
    Entry --> CheckItemType
    CheckItemType -->|PREPARED or STOCKED (Leaf Item)| CheckDimensions
    CheckItemType -->|COMBO (Package)| PresentComboConfigs

    %% Leaf item branch edges
    CheckDimensions -->|No commercial dimensions (Single default)| AutoSelectDefault
    CheckDimensions -->|Commercial dimensions defined| PromptDimensions
    PromptDimensions --> SelectVariant
    AutoSelectDefault --> CheckVariantEligible
    SelectVariant --> CheckVariantEligible

    CheckVariantEligible -->|isStructurallyEligible == false OR isAvailable == false| VariantUnavailable
    VariantUnavailable -->|Select different variant| PromptDimensions
    CheckVariantEligible -->|Eligible & available| SetLeafBasePrice

    SetLeafBasePrice --> CheckGroupCapacity
    CheckGroupCapacity -->|Any mandatory group availableCapacity < minSelections| RequiredGroupCapacityFailed
    RequiredGroupCapacityFailed -->|Select different variant| PromptDimensions
    CheckGroupCapacity -->|All mandatory groups availableCapacity >= minSelections| InspectModifierOption

    InspectModifierOption --> CheckOptionAdmin
    CheckOptionAdmin -->|enabled == false| OptionDisabledAdmin
    CheckOptionAdmin -->|enabled == true| CheckNullVsZero

    CheckNullVsZero -->|evaluatedCapacity == 0| CapZero
    CheckNullVsZero -->|evaluatedCapacity == null| CapNull
    CheckNullVsZero -->|evaluatedCapacity > 0| CapDiscrete

    CapNull --> AdjustModifierQty
    CapDiscrete --> AdjustModifierQty

    AdjustModifierQty --> CheckQtyBounds
    CheckQtyBounds -->|Exceeds option effectiveMaxQuantity or group maxSelections| RejectModifierQty
    RejectModifierQty --> AdjustModifierQty
    CheckQtyBounds -->|Within allowed bounds| ApplyModifierQty

    ApplyModifierQty --> CheckLeafValidation
    CheckLeafValidation -->|Any group minSelections not reached| LeafPendingNotice
    LeafPendingNotice --> AdjustModifierQty
    CheckLeafValidation -->|All groups minSelections <= count <= maxSelections| LeafValid

    %% Combo item branch edges
    PresentComboConfigs --> SelectComboConfig
    SelectComboConfig --> CheckComboConfigEligible

    CheckComboConfigEligible -->|isStructurallyEligible == false OR isAvailable == false| ComboConfigUnavailable
    ComboConfigUnavailable -->|Select different configuration| PresentComboConfigs
    CheckComboConfigEligible -->|Eligible & available| SetComboBasePrice

    SetComboBasePrice --> EvaluateSlotOptions
    EvaluateSlotOptions --> ComputeSlotCapacity
    ComputeSlotCapacity --> CheckMandatorySlotCapacity

    CheckMandatorySlotCapacity -->|Any mandatory slot availableCapacity < minSelections| RequiredSlotCapacityFailed
    RequiredSlotCapacityFailed -->|Select different configuration| PresentComboConfigs
    CheckMandatorySlotCapacity -->|All mandatory slots availableCapacity >= minSelections| PresentSlotOptions

    PresentSlotOptions --> SelectComboOption
    SelectComboOption --> CheckSlotOptionSelected

    %% Addition branch (unselected option)
    CheckSlotOptionSelected -->|Unselected (addition)| CheckSlotOptionValid
    CheckSlotOptionValid -->|Exceeds slot maxSelections or option not selectable| RejectSlotOption
    RejectSlotOption --> PresentSlotOptions
    CheckSlotOptionValid -->|Option selectable & slot max not exceeded| ApplySlotOption

    ApplySlotOption --> LoadComboComponentModifiers

    %% Removal branch (already-selected option)
    CheckSlotOptionSelected -->|Already selected (removal)| RemoveSlotOption
    RemoveSlotOption --> CheckComboValidation
    LoadComboComponentModifiers --> CheckComboComponentGroupCapacity

    CheckComboComponentGroupCapacity -->|Any mandatory component group capacity < minSelections| ComboComponentCapacityFailed
    ComboComponentCapacityFailed -->|Select alternative combo option| PresentSlotOptions
    CheckComboComponentGroupCapacity -->|Mandatory component groups capacity >= minSelections (customize)| InspectComboComponentModifierOption
    CheckComboComponentGroupCapacity -->|Mandatory component groups capacity >= minSelections (keep default / continue)| CheckComboValidation

    InspectComboComponentModifierOption --> CheckComboComponentOptionAdmin
    CheckComboComponentOptionAdmin -->|enabled == false| ComboComponentOptionDisabledAdmin
    ComboComponentOptionDisabledAdmin -->|Inspect other option| InspectComboComponentModifierOption
    CheckComboComponentOptionAdmin -->|enabled == true| CheckComboComponentNullVsZero

    CheckComboComponentNullVsZero -->|evaluatedCapacity == 0| ComboComponentCapZero
    ComboComponentCapZero -->|Inspect other option| InspectComboComponentModifierOption
    CheckComboComponentNullVsZero -->|evaluatedCapacity == null| ComboComponentCapNull
    CheckComboComponentNullVsZero -->|evaluatedCapacity > 0| ComboComponentCapDiscrete

    ComboComponentCapNull --> AdjustComboComponentModifierQty
    ComboComponentCapDiscrete --> AdjustComboComponentModifierQty

    AdjustComboComponentModifierQty --> CheckComboComponentQtyBounds
    CheckComboComponentQtyBounds -->|Exceeds option effectiveMaxQuantity or component group maxSelections| RejectComboComponentModifierQty
    RejectComboComponentModifierQty --> AdjustComboComponentModifierQty
    CheckComboComponentQtyBounds -->|Within allowed bounds| ApplyComboComponentModifierQty

    ApplyComboComponentModifierQty --> CheckComboValidation
    CheckComboValidation -->|Any mandatory slot minSelections not reached| ComboPendingNotice
    ComboPendingNotice --> PresentSlotOptions
    CheckComboValidation -->|Any component mandatory group minSelections not reached| ComboComponentModifierPendingNotice
    ComboComponentModifierPendingNotice --> AdjustComboComponentModifierQty
    CheckComboValidation -->|All slots & component mandatory groups satisfied| ComboValid

    ComboValid -->|Select or change other slot options| PresentSlotOptions
    ComboValid -->|Adjust other component modifiers| AdjustComboComponentModifierQty

    %% Confirmation and emission edges
    LeafValid --> ConfirmSelection
    ComboValid --> ConfirmSelection
    ConfirmSelection --> EmitPayload
    EmitPayload --> ReturnSelection
```
