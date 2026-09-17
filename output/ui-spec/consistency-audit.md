# Semantic UI Specification Consistency Audit

## 1. Audit Overview and Authorities

### 1.1 Audited Authorities
This consistency audit evaluates the pre-wireframe semantic UI specification for the Menu Service. The evaluation is governed by and benchmarked strictly against the following authoritative inputs:

1. **Authoritative Requirements Specification**:  
   - **Document**: *Especificación Final Vigente del Servicio Menu* (`output/ers/spec.md`)
   - **Version**: **1.1.11 (Consolidada Vigente)**
   - **Baseline Content**: 46 consolidated functional requirements (Section 4), 5 non-functional requirements (Section 5), domain rules (Section 6), domain models (Section 7), and Open Items (Section 13).
2. **Governing UI Architecture Directive**:  
   - **Document**: *UI Specification Architecture* (`docs/ui-spec-arch.md`)
   - **Core Directives**: Separation of UI Semantics from Visual Design, YAML as canonical source for views, Mermaid as canonical source for flows and navigation, Minimal Duplication Principle, No-Unjustified-Inference Rule, and avoidance of manually maintained element-level matrices.
3. **Supporting Contextual Documents**:  
   - `docs/md/Decisiones-cierre-invariantes.md` (ADR-001 through ADR-008)
   - `docs/md/Consultoria-1.md` and `docs/md/Consultoria-2.md`
   - `docs/requests/create-ui-spec.md` (Phase 1 specification scope)

### 1.2 Scope and Boundary of Audit
> [!IMPORTANT]
> **Audit Nature**: This document represents a **documentary semantic-specification audit**.
> It verifies semantic consistency, requirement coverage, topological reachability, and boundary adherence among the canonical specification artifacts (`views/*.yaml`, `flows/*.md`, `navigation/screen-navigation.md`).
>
> This audit **does not constitute**:
> - Runtime execution or end-to-end integration testing;
> - Automated accessibility (WCAG/ARIA) compliance validation;
> - System performance, load, or latency measurement;
> - Rendered graphical UI, visual layout, or design acceptance.

---

## 2. Inventory Summary: Views and Major Flows

In accordance with the Minimal Duplication Principle, the following summaries provide a concise overview of the 8 canonical view specifications and 6 major interaction flow areas without replicating their complete internal YAML schemas or Mermaid syntax.

### 2.1 Summary of the Eight Canonical Views

| View Identifier | Canonical File | Surface / Actor | Primary Responsibility Summary |
| :--- | :--- | :--- | :--- |
| **`CatalogBrowseView`** | [`CatalogBrowseView.yaml`](views/CatalogBrowseView.yaml) | Public POS / KDS<br/>`POS_CLIENT`, `KDS_CLIENT` | Public catalog exploration, keyword search, category filtering, display price projection (`$X`, `Desde $X`), and operational availability consultation without cart or ordering mechanics. |
| **`SellableItemConfigurationView`** | [`SellableItemConfigurationView.yaml`](views/SellableItemConfigurationView.yaml) | Public POS / KDS<br/>`POS_CLIENT`, `KDS_CLIENT` | Leaf variant and modifier personalization (hiding technical `DEFAULT` variant) or combo slot option selection with personalization of selected component leaf variants and their deltas within capacity rules (BR-MENU-016, BR-MENU-017), producing a valid selection handoff payload. |
| **`MenuCatalogAdministrationView`** | [`MenuCatalogAdministrationView.yaml`](views/MenuCatalogAdministrationView.yaml) | Administrative<br/>`ADMINISTRATOR` | Administrative monitoring and search across four orthogonal status axes (administrative status, structural eligibility, operational availability, review status) and transition control. |
| **`MenuItemEditorView`** | [`MenuItemEditorView.yaml`](views/MenuItemEditorView.yaml) | Administrative<br/>`ADMINISTRATOR` | Authoring commercial identity, image URI, categories, type discriminator, leaf variants, absolute unit prices, supply linkage, DEFAULT migration, incomplete-INACTIVE save validation, and contextual recipe navigation (`navigateToRecipeEditorAction`). Uses design-neutral terminology (e.g., summary entries). |
| **`RecipeEditorView`** | [`RecipeEditorView.yaml`](views/RecipeEditorView.yaml) | Administrative<br/>`ADMINISTRATOR` | Culinary recipe formulation with opaque inventory item components, quantities, units, and immutable recipe revision creation (`<number>_<ISO8601>`). |
| **`ModifierConfigurationView`** | [`ModifierConfigurationView.yaml`](views/ModifierConfigurationView.yaml) | Administrative<br/>`ADMINISTRATOR` | Configuration of leaf-item modifier groups, baseline options, per-variant overrides, and atomic copy operations (`FAIL` / `REPLACE` with dry-run support). |
| **`ComboConfigurationView`** | [`ComboConfigurationView.yaml`](views/ComboConfigurationView.yaml) | Administrative<br/>`ADMINISTRATOR` | Authoring combo packages, configurations (requiring at least one slot for any persisted configuration), slots, direct leaf variant options, structural capacity limits (full structural eligibility predicate without momentary stock), atomic copy, and bulk option assignments without unsupported destructive slot removal. |
| **`ComboReviewView`** | [`ComboReviewView.yaml`](views/ComboReviewView.yaml) | Administrative<br/>`ADMINISTRATOR` | Supervisory detection, inspection, and atomic token-bound confirmation of `REVIEW_REQUIRED` combo configurations without mutating commercial prices or composition. |

### 2.2 Summary of the Six Major Interaction Flow Areas

Across the 7 canonical flow documents, the interaction model addresses 6 major functional workflow areas:

1. **Browse Menu Catalog** ([`browse-catalog.md`](flows/browse-catalog.md)):  
   Enables POS/KDS client actors to enter the public catalog, execute keyword searches, filter by commercial categories, inspect projected availability, handle empty or no-result states, and transition to configuration for eligible sellable items. Preserves browsing navigation even when external inventory evaluations expire.
2. **Configure Sellable Item** ([`configure-sellable-item.md`](flows/configure-sellable-item.md)):  
   Enables POS/KDS client actors to formulate valid purchase selections. Branches into:
   - *Leaf Items*: Variant dimension selection (hiding technical `DEFAULT`), modifier selection within effective min/max bounds, quantity stepping capped by operational residual stock (`availableMaxQuantity`), and handling zero vs null capacity.
   - *Combos*: Selection of eligible combo configurations, slot-by-slot option choice satisfying min/max selection bounds, toggle behavior permitting unconditional removal of already-selected options regardless of slot capacity or momentary availability while restricting additions to available options below max selections, personalization of selected leaf variants with their modifier options and signed price deltas (confined strictly to the component leaf variant per BR-MENU-016 and BR-MENU-017), and validation against slot `availableCapacity`.
   Concludes by returning a valid `ConfiguredSelectionHandoff` payload with fully defined nested selection correlation identifiers to the external ordering caller.
3. **Manage Menu Item Commercial Lifecycle** ([`manage-menu-item.md`](flows/manage-menu-item.md)):  
   Enables administrators to create items, manage explicit `ACTIVE` / `INACTIVE` state toggles, migrate technical `DEFAULT` variants to dimensioned presentations, assign supply strategies (`PREPARED` vs `STOCKED`), permanently archive variants with non-blocking dependency re-evaluation, and route contextually to specialized domain editors (including explicit contextual recipe authoring navigation via `navigateToRecipeEditorAction` emitting `navigateToRecipeEditorSignal` with return context).
4. **Manage Culinary Recipe Lifecycle** ([`manage-recipe.md`](flows/manage-recipe.md)):  
   Enables administrators (`ADMINISTRATOR`) to author recipe ingredient lists with opaque inventory IDs, validate positive quantities, commit immutable recipe revisions, and maintain revision histories without silently mutating active variant references.
5. **Manage Modifiers and Specializations** ([`manage-modifiers.md`](flows/manage-modifiers.md)):  
   Enables administrators to establish modifier groups on leaf items, configure baseline options (with atomic `ADD` transitions carrying positive quantity and unit, and `OMIT` setting them to null, or empty preparation directives), define per-variant overrides (`VariantModifierConfig`), and execute atomic configuration copies with collision detection (`FAIL` vs `REPLACE`).
6. **Manage and Review Combos** ([`manage-combo.md`](flows/manage-combo.md) and [`review-combo.md`](flows/review-combo.md)):  
   Enables administrators to construct multi-slot combo packages (enforcing that every persisted configuration contains at least one slot, with zero-option slots permitted only when INACTIVE with warnings), validate structural capacity using the complete leaf variant structural eligibility predicate excluding momentary stock, perform atomic option distribution without destructive slot removal, and independently inspect downstream dependency changes (`PRICE`, `COMPOSITION`, `MODIFIERS`, `STATUS`). Provides atomic token-bound confirmation (`reviewToken`) that acknowledges observed changes while leaving concurrent later updates pending, and routes to commercial editing for slot creation, bound adjustment, and option reconfiguration without unsupported destructive slot removal.

---

## 3. Requirement-by-Requirement UI-Impact Classification

This section accounts for all **46 Functional Requirements** from Section 4 of `output/ers/spec.md` (v1.1.11) and the **5 Non-Functional Requirements** from Section 5. Each requirement receives an explicit classification as either **UI-Relevant (Covered)** or **Intentionally Not Mapped to UI (Non-UI Rationale)**.

### 3.1 Functional Requirements (46 Total)

| Requirement ID | Requirement Name | Classification | Primary Mapping / Non-UI Rationale |
| :--- | :--- | :--- | :--- |
| **REQ-MENU-ITM-001** | Definición del MenuItem Comercial | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (identity, image URI, categories, type discriminator, initial status), `MenuCatalogAdministrationView`, and `CatalogBrowseView`. |
| **REQ-MENU-ITM-002** | Transición de Estado Administrativo | **UI-Relevant (Covered)** | Mapped to `MenuCatalogAdministrationView` (action toggle) and `MenuItemEditorView` (save actions for ACTIVE/INACTIVE). Flow: `manage-menu-item`. |
| **REQ-MENU-VAR-001** | Presentación Vendible de Item Hoja (Default Variant) | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (DEFAULT creation/management) and `SellableItemConfigurationView` (hides DEFAULT variant from customer selection). |
| **REQ-MENU-VAR-002** | Definición de Dimensión de Variante | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (dimension name authoring, ownership scoped to leaf item). Flow: `manage-menu-item`. |
| **REQ-MENU-VAR-003** | Valor de Dimensión de Variante | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (dimension value list authoring). Flow: `manage-menu-item`. |
| **REQ-MENU-VAR-004** | Definición de Variantes Vendibles | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (combination matrix, uniqueness constraint) and `SellableItemConfigurationView` (variant selection controls). |
| **REQ-MENU-VAR-005** | Migración Atómica de Variante Predeterminada | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (action to replace DEFAULT variant with explicit dimensioned variants in a single immutable revision). Flow: `manage-menu-item`. |
| **REQ-MENU-VAR-006** | Elegibilidad Estructural de Variante Hoja | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (structural capacity validation), `MenuCatalogAdministrationView` (structural eligibility display), and `SellableItemConfigurationView` (filtering). |
| **REQ-MENU-PRC-001** | Precio Absoluto Autoritativo de la Variante | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (variant `unitPrice` editing) and `SellableItemConfigurationView` (displays absolute unit price). |
| **REQ-MENU-PRC-002** | Proyección del Precio de Catálogo | **UI-Relevant (Covered)** | Mapped to `CatalogBrowseView` (`displayPrice` projections: `$X`, `Desde $X`, or omitted). Flow: `browse-catalog`. |
| **REQ-MENU-PRC-003** | Exclusión de Catálogo sin Unidades Elegibles | **UI-Relevant (Covered)** | Mapped to `CatalogBrowseView` (automatic exclusion of items lacking eligible units) and `MenuCatalogAdministrationView` (monitoring). |
| **REQ-MENU-FUL-001** | Configuración de Suministro Almacenado (Stocked) | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (stocked supply inputs: opaque `inventoryItemId`, withdrawal quantity). Flow: `manage-menu-item`. |
| **REQ-MENU-FUL-002** | Vinculación de Receta para Presentación Preparada | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (`recipeRevisionId` association and adoption) and `RecipeEditorView`. Flows: `manage-menu-item`, `manage-recipe`. |
| **REQ-MENU-FUL-003** | Definición de Recetas Culinarias | **UI-Relevant (Covered)** | Mapped to `RecipeEditorView` (recipe name, component list, opaque inventoryItemId, quantity, unit). Flow: `manage-recipe`. |
| **REQ-MENU-FUL-004** | Historial y Versionado Inmutable de Recetas | **UI-Relevant (Covered)** | Mapped to `RecipeEditorView` (immutable revision history display, commit action) and `MenuItemEditorView` (explicit adoption). |
| **REQ-MENU-MOD-001** | Definición de Grupos de Modificadores en el Item Hoja | **UI-Relevant (Covered)** | Mapped to `ModifierConfigurationView` (group authoring, min/max limits, absence of modifier groups from COMBO structure in v1 per BR-MENU-017) and `SellableItemConfigurationView` (selection rules on leaf items and customization of selected component leaf variants within combo slots, confined to the component per BR-MENU-016). |
| **REQ-MENU-MOD-002** | Opciones de Modificador y Configuración General | **UI-Relevant (Covered)** | Mapped to `ModifierConfigurationView` (`generalConfig` authoring: priceDelta, maxQuantity, ingredientEffects) and `SellableItemConfigurationView` (baseline modifier choices on leaf items and for component leaf variants selected within combo slots per BR-MENU-016, BR-MENU-017). |
| **REQ-MENU-MOD-003** | Especialización de Modificador por Variante | **UI-Relevant (Covered)** | Mapped to `ModifierConfigurationView` (per-variant override selectors for `VariantModifierConfig`) and `SellableItemConfigurationView` (resolves variant-specialized modifiers for standalone leaf variants and component leaf variants within combo slots per BR-MENU-016). Flow: `manage-modifiers`. |
| **REQ-MENU-MOD-004** | Copia Administrativa de Modificadores | **UI-Relevant (Covered)** | Mapped to `ModifierConfigurationView` (source and destination variant selectors, policy selection FAIL/REPLACE, dry-run mode, collision resolution notification). Flow: `manage-modifiers`. |
| **REQ-MENU-MOD-005** | Directiva de Adición de Insumo (ADD) | **UI-Relevant (Covered)** | Mapped to `ModifierConfigurationView` (effect authoring: operation ADD, inventoryItemId, quantity, unit). |
| **REQ-MENU-MOD-006** | Directiva de Omisión de Insumo (OMIT) | **UI-Relevant (Covered)** | Mapped to `ModifierConfigurationView` (effect authoring: operation OMIT, target inventoryItemId). |
| **REQ-MENU-MOD-007** | Modificadores de Preparación sin Efectos sobre Insumos | **UI-Relevant (Covered)** | Mapped to `ModifierConfigurationView` (empty effect list authoring) and `SellableItemConfigurationView` (kitchen instruction choices). |
| **REQ-MENU-MOD-008** | Proyección Publicada de Modificadores Efectivos | **UI-Relevant (Covered)** | Mapped to `SellableItemConfigurationView` (renders resolved commercial options and enforces configured maxQuantity distinct from operational availableMaxQuantity for standalone leaf items and component leaf variants selected within combo slots per BR-MENU-016, BR-MENU-017). |
| **REQ-MENU-COM-001** | Configuración de Combo (ComboConfiguration) | **UI-Relevant (Covered)** | Mapped to `ComboConfigurationView` (authoring configuration name, absolute unitPrice, slots) and `SellableItemConfigurationView`. |
| **REQ-MENU-COM-002** | Definición del Espacio de Selección (ComboSlot) | **UI-Relevant (Covered)** | Mapped to `ComboConfigurationView` (slot authoring, minSelections, maxSelections bounds) and `SellableItemConfigurationView` (slot selection validation). |
| **REQ-MENU-COM-003** | Opciones de Combo Vinculadas a la Variante Hoja | **UI-Relevant (Covered)** | Mapped to `ComboConfigurationView` (option authoring referencing itemVariantId, quantity > 0, priceDelta) and `SellableItemConfigurationView` (slot option selection and customization of selected leaf variants with signed deltas per BR-MENU-016, BR-MENU-017). |
| **REQ-MENU-COM-004** | Copia Administrativa de Configuración de Combo | **UI-Relevant (Covered)** | Mapped to `ComboConfigurationView` (action to copy slots/options to another configuration with regenerated IDs). Flow: `manage-combo`. |
| **REQ-MENU-COM-005** | Asignación Múltiple Atómica de Opciones de Combo | **UI-Relevant (Covered)** | Mapped to `ComboConfigurationView` (bulk option assignment operation across multiple configurations). Flow: `manage-combo`. |
| **REQ-MENU-COM-006** | Elegibilidad Estructural de Configuración de Combo | **UI-Relevant (Covered)** | Mapped to `ComboConfigurationView` (structural eligibility indicator), `MenuCatalogAdministrationView`, and `SellableItemConfigurationView`. |
| **REQ-MENU-LIF-001** | Archivado de Variante y Reevaluación No Obstructiva | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (irreversible archive action), `MenuCatalogAdministrationView` (downstream review status), and `ComboReviewView`. |
| **REQ-MENU-LIF-002** | Guardado de Definiciones Incompletas en Inactivo | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView`, `ModifierConfigurationView`, and `ComboConfigurationView` (permits save when containing item is INACTIVE). |
| **REQ-MENU-LIF-003** | Advertencias de Capacidad Faltante | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView`, `ModifierConfigurationView`, and `ComboConfigurationView` (validation banner reporting entityId, type, minSelections, and calculated capacity). |
| **REQ-MENU-ING-001** | Resolución Neta de Insumos para Líneas de Comanda | **Intentionally Not Mapped to UI** | **Non-UI Rationale**: Logical resolution interface invoked by Orders to calculate and return the flattened net ingredient requirements for a confirmed order line (evaluating base recipes, combo option quantity multipliers, and component-confined OMIT-before-ADD directives). Operates entirely as a server-side process beneath the presentation layer; the UI boundary terminates at the commercial selection payload (`ConfiguredSelectionHandoff`). Formal technical contracts, serialization, and transport protocols remain open under OPEN-007. |
| **REQ-MENU-VER-001** | Generación de Revisión Inmutable de MenuItem | **UI-Relevant (Covered)** | Mapped to `MenuItemEditorView` (displays revision token, creates new version upon accepted commercial save) and `MenuCatalogAdministrationView`. |
| **REQ-MENU-REV-001** | Detección Automática de Revisión de Combo | **UI-Relevant (Covered)** | Mapped to `ComboReviewView` (exposes review reasons: PRICE, COMPOSITION, MODIFIERS, STATUS) and `MenuCatalogAdministrationView`. |
| **REQ-MENU-REV-002** | Visibilidad Administrativa del Estado de Revisión | **UI-Relevant (Covered)** | Mapped to `MenuCatalogAdministrationView` (reviewStatus status indicator/filter) and `ComboReviewView` (detailed inspection display). |
| **REQ-MENU-REV-003** | Confirmación Atómica Mediante Token Observado | **UI-Relevant (Covered)** | Mapped to `ComboReviewView` (selection of configurationId/reviewToken pairs, confirm action, confirmation outcome display showing attended vs pending changes). |
| **REQ-MENU-REV-004** | Conservación de la Configuración Comercial | **UI-Relevant (Covered)** | Mapped to `ComboReviewView` (confirms review token without mutating commercial unitPrice, slots, or options). |
| **REQ-MENU-REV-005** | Referencia Visual del Slot (Precios Informativos) | **UI-Relevant (Covered)** | Mapped to `ComboReviewView` (displays saved, current, and signed difference values for slot component prices). |
| **REQ-MENU-AVL-001** | Publicación y Notificación de Invalidación de Catálogo | **UI-Relevant (Covered)** | Mapped to `CatalogBrowseView` for active catalog consultation by client runtimes (`POS_CLIENT`, `KDS_CLIENT`). The complementary backend invalidation notifications, emission transport, and event payloads remain an open technical integration concern documented under OPEN-007. Flow: `browse-catalog`. |
| **REQ-MENU-AVL-002** | Frontera General de Disponibilidad Desacoplada | **UI-Relevant (Covered)** | Mapped to `CatalogBrowseView`, `SellableItemConfigurationView`, and `MenuCatalogAdministrationView` (displays operational availability without mutating commercial status). |
| **REQ-MENU-AVL-003** | Publicación Desacoplada de Requerimientos Base e Incrementales | **Intentionally Not Mapped to UI** | **Non-UI Rationale**: Server-to-server asynchronous integration pipeline between Menu and Inventory. Defines the flat data exchange format for `BaseRequirements` and `ModifierRequirements` sent over message channels, operating entirely beneath user interface interaction. |
| **REQ-MENU-AVL-004** | Cálculo Granular de Disponibilidad de Variante | **UI-Relevant (Covered)** | Mapped to `SellableItemConfigurationView` (disables unavailable variants; enforces satisfiable modifier combinations) and `MenuCatalogAdministrationView`. |
| **REQ-MENU-AVL-005** | Cálculo de Disponibilidad y Límite de Modificadores | **UI-Relevant (Covered)** | Mapped to `SellableItemConfigurationView` (enforces dynamic stepper limits via `availableMaxQuantity`, handles null vs zero capacity). |
| **REQ-MENU-AVL-006** | Disponibilidad de Combo por Capacidad de Slots | **UI-Relevant (Covered)** | Mapped to `SellableItemConfigurationView` (enforces slot `availableCapacity` counting selectable options) and `MenuCatalogAdministrationView`. |
| **REQ-MENU-AVL-007** | Disponibilidad Agregada de MenuItem para Catálogo | **UI-Relevant (Covered)** | Mapped to `CatalogBrowseView` (displays aggregated item availability badge and filter) and `MenuCatalogAdministrationView`. |

### 3.2 Non-Functional Requirements (5 Total)

| Requirement ID | Requirement Name | Classification | Primary Mapping / Non-UI Rationale |
| :--- | :--- | :--- | :--- |
| **NFR-MENU-PERF-01** | Presupuesto de Rendimiento de Aceptación (ADR-004) | **Intentionally Not Mapped to UI** | **Non-UI Rationale**: Engineering acceptance performance budget validated via automated stress/load testing tools (k6, Gatling). Represents an architectural capacity target rather than an interactive screen behavior. |
| **NFR-MENU-PERF-02** | Perfil Nominal de Operación | **UI-Relevant (Covered)** | Mapped to `CatalogBrowseView` and `SellableItemConfigurationView`. Defines user-facing operational latency requirements: UI tactile feedback ($\le 100\text{ ms}$), keyword search/filtering response ($\le 200\text{ ms}$), and dynamic configuration recalculation ($\le 300\text{ ms}$). |
| **NFR-MENU-PERF-03** | Capacidad ante Ráfagas (Burst) | **Intentionally Not Mapped to UI** | **Non-UI Rationale**: System resilience target under 100 req/s burst load, verifying zero lost orders and transaction log integrity at the service layer. |
| **NFR-MENU-CONS-01** | Concurrencia e Integridad Transaccional | **Intentionally Not Mapped to UI** | **Non-UI Rationale**: Delineates the Transactional Outbox pattern as an exclusive responsibility of the Orders service, confirming that Menu does not enforce local outbox transactional guarantees on external message delivery. |
| **NFR-MENU-RESI-01** | Resiliencia y Desacoplamiento de Inventory | **UI-Relevant (Covered)** | Mapped to `CatalogBrowseView` (catalog navigation and commercial definitions remain non-blocking even during total Inventory disconnection) and `SellableItemConfigurationView` (handles `validUntil` expiration gracefully). |

---

## 4. Architectural Consistency Verifications

### 4.1 View Consistency Check
- **Responsibility Centered**: Each of the 8 views defines a single, cohesive functional responsibility without functional overlap. Administrative monitoring (`MenuCatalogAdministrationView`), commercial entity authoring (`MenuItemEditorView`), recipe formulation (`RecipeEditorView`), modifier specialization (`ModifierConfigurationView`), combo configuration (`ComboConfigurationView`), and review acknowledgement (`ComboReviewView`) operate on distinct domain aggregates.
- **Consumer vs Administrative Partitioning**: Consumer-facing views (`CatalogBrowseView`, `SellableItemConfigurationView`) are cleanly decoupled from back-office management. No administrative actions leak into POS/KDS views, and no cart/checkout concepts leak into Menu views.
- **Requirement Justification**: Every view explicitly enumerates its source requirement identifiers in its YAML metadata header. There are zero unbacked or speculative views.
- **Combo Configuration Persistence Bounds**: In `ComboConfigurationView`, every persisted `ComboConfiguration` is strictly required to contain at least one `ComboSlot` (REQ-MENU-COM-001). Zero-slot configurations are rejected for both INACTIVE and ACTIVE persistence. Slots with zero options are permitted only while the parent COMBO `MenuItem` is in INACTIVE status, generating structured incomplete definition warnings (`incompleteCapacityWarnings`). Destructive removal of configurations, slots, or options is strictly omitted.
- **Structural Capacity and Variant Eligibility**: In `ComboConfigurationView`, `calculatedCapacity` counts enabled options whose referenced leaf variant satisfies the complete `REQ-MENU-VAR-006` structural eligibility predicate (owning leaf MenuItem ACTIVE, variant ACTIVE and not ARCHIVED, complete PREPARED or STOCKED supply linkage, and satisfiable mandatory modifier groups), with each option contributing at most one selection regardless of physical delivered quantity. Momentary inventory stock availability (`availableCapacity`, `VariantAvailability`) is strictly excluded from structural capacity and activation checks.
- **Atomic Ingredient Effect Transitions**: In `ModifierConfigurationView`, `setIngredientEffectOperation` and `setVariantIngredientEffectOperation` enforce atomic transitions between `ADD` and `OMIT`. Transitioning to `ADD` requires and validates positive `quantity (> 0)` and non-empty `unit` in the same operation, while transitioning to `OMIT` atomically clears `quantity` and `unit` to null, preventing invalid intermediate states with missing metrics.
- **Explicit Transient Selection Schema**: In `SellableItemConfigurationView`, the transient selection model `selectionState.selectedComboOptions` and its nested `componentModifiers` are confirmed resolved with an explicit nested schema defining `slotId`, `comboOptionId`, `itemVariantId`, `modifierGroupId`, `modifierOptionId`, `quantity`, and signed `priceDelta`, eliminating any undefined transient shapes and matching the `ConfiguredSelectionHandoff` payload.
- **Semantic Neutrality and Navigational Triggers**: In `MenuItemEditorView`, design-neutral terminology is strictly enforced, replacing visual descriptions (such as "summary cards") with "summary entries". Contextual navigation to recipe authoring is formalized through the semantic control `navigateToRecipeEditorAction` triggering the `navigateToRecipeEditor` action with explicit parameters (`recipeId`, `recipeRevisionId`, `returnContext`), with `navigateToRecipeEditorSignal` modeled strictly as the emitted output rather than an invocable control.

### 4.2 Flow Consistency Check
- **Referenced-View Existence**: All views referenced in the 7 canonical flows exist as validated files in `output/ui-spec/views/`. No flow targets a non-existent or renamed view.
- **Transition Coherence**: Branching logic preserves valid business states (e.g., distinguishing between leaf items and combos in `configure-sellable-item`, and enforcing `FAIL` vs `REPLACE` copy policies in `manage-modifiers`).
- **Alternative Paths**: All relevant negative and edge paths identified in the SRS are represented (e.g., search yielding no results, incomplete definitions triggering warnings in INACTIVE mode, concurrent token updates leaving changes pending in combo review).
- **Removability of Selected Combo Options**: In `configure-sellable-item.md`, `toggleComboOption` explicitly branches based on whether the target option is already selected. Unselected options enforce `isSelectable == true` and `currentSelectedCount < maxSelections` before addition. Already-selected options can be unconditionally removed by `slotId` and `comboOptionId` even if the slot is at maximum capacity or the option's operational availability has lapsed, deleting associated component modifier contexts and subtracting price deltas.
- **Strict Combo Persistence and Activation Paths**: In `manage-combo.md`, the inactive-save path rejects zero-slot configurations and permits zero-option slots only with structured warnings (REQ-MENU-LIF-002, REQ-MENU-LIF-003). The active-save path strictly enforces that every configuration contains at least one slot, every slot contains at least one option, and all mandatory slots satisfy `calculatedCapacity >= minSelections` using the complete `REQ-MENU-VAR-006` structural predicate without momentary stock. Destructive slot removal paths are eliminated.
- **Atomic Modifier Effect Transitions in Flows**: In `manage-modifiers.md`, interaction paths for editing effect directives explicitly demonstrate atomic submission of operation, positive quantity, and non-empty unit for `ADD`, or atomic clearing for `OMIT`, eliminating invalid intermediate states.
- **Defined Contextual Recipe Navigation**: In `manage-menu-item.md`, `TriggerRecipeEditor` invokes the concrete semantic control `navigateToRecipeEditorAction` and action `navigateToRecipeEditor` defined in `MenuItemEditorView`, carrying the contextual payload and return path, rather than referencing an output signal as a control.
- **Preservation of Commercial Configuration during Review**: In `review-combo.md`, review confirmation remains strictly non-mutating (REQ-MENU-REV-004), while navigation to commercial editing (`TransitionToComboEditor`) describes supported operations (unit price adjustment, slot creation, bound editing, option reconfiguration) and explicitly avoids advertising unsupported destructive slot removal.

### 4.3 Navigation Consistency and Reachability Check
- **Zero Orphan Views**: In `output/ui-spec/navigation/screen-navigation.md`, every one of the 8 canonical views possesses at least one inbound transition and at least one outbound transition:
  - `CatalogBrowseView`: Inbound from POS Entry; Outbound to `SellableItemConfigurationView`.
  - `SellableItemConfigurationView`: Inbound from POS Entry and `CatalogBrowseView`; Outbound to External Ordering Handoff.
  - `MenuCatalogAdministrationView`: Inbound from Admin Entry and return transitions; Outbound to `MenuItemEditorView` and `ComboReviewView`.
  - `MenuItemEditorView`: Inbound from `MenuCatalogAdministrationView`, `ComboReviewView`, and editor return paths; Outbound to `RecipeEditorView`, `ModifierConfigurationView`, `ComboConfigurationView`, and return to Catalog.
  - `ComboReviewView`: Inbound from `MenuCatalogAdministrationView`; Outbound to `MenuItemEditorView` and return to Catalog.
  - `RecipeEditorView`: Inbound from Admin Entry and `MenuItemEditorView`; Outbound return to `MenuItemEditorView`.
  - `ModifierConfigurationView`: Inbound from `MenuItemEditorView`; Outbound return to `MenuItemEditorView`.
  - `ComboConfigurationView`: Inbound from `MenuItemEditorView`; Outbound return to `MenuItemEditorView`.
- **Flow Alignment**: Every topological edge in the global navigation diagram corresponds 1:1 with an action or transition defined in the canonical Mermaid flows. The `MenuItemEditorView` to `RecipeEditorView` transition and its navigation table entry formally reference `navigateToRecipeEditorAction` and `navigateToRecipeEditor`, with `navigateToRecipeEditorSignal` defined as the emitted payload rather than an invocable control.
- **Topological Purity**: The navigation model defines adjacency only, strictly avoiding the assumption of visual app shells, tabs, breadcrumbs, or drawer widgets.

### 4.4 Control and Action Consistency Check
- **Semantic Intent**: Controls express functional intent with design-neutral identifiers (e.g., `itemInspection`, `modifierQuantityAdjuster`, `variantSelector`, `executeCopyAction`, `navigateToRecipeEditorAction`) without imposing graphical representations (e.g., chips, dropdowns, sliders, summary cards, or concrete dialog widgets).
- **Defined Actions and Payloads**: Every interactive control specifies the data it operates upon, the validation constraints that govern it, and the resulting payload/signal emitted upon execution. Interactive controls are cleanly separated from emitted output signals.
- **Atomic Operations**: Directive switching controls (`setIngredientEffectOperation`, `setVariantIngredientEffectOperation`) enforce atomic payload validation, guaranteeing that `ADD` cannot be selected without positive quantity and metric unit, and `OMIT` cannot retain quantity/unit values.
- **Symmetric and Asymmetric Selection Actions**: Selection toggle controls (`comboOptionSelector` / `toggleComboOption`) cleanly separate constraints: additions are restricted by selectability and slot maximums, while removals remain unconditionally available by identifier to ensure options are never trapped.
- **Elimination of Unsupported and Visual Controls**: Unsupported destructive operations (such as destructive slot deletion) have been eliminated from all controls, actions, and flows. Visual terminology (such as "summary cards") has been replaced with design-neutral semantic descriptors ("summary entries").
- **No Redundant Controls**: Actions are deduplicated across regions and scoped strictly to the responsibilities of each view.

### 4.5 State Consistency Check
- **Orthogonal State Dimensions Preserved**: The specification strictly enforces the separation of:
  1. Administrative Status (`ACTIVE`, `INACTIVE`, `ARCHIVED`)
  2. Structural Eligibility (`true` / `false`)
  3. Operational Availability (`AVAILABLE`, `UNAVAILABLE` via decoupled read models)
  4. Review Status (`UP_TO_DATE`, `REVIEW_REQUIRED`)
- **Structural Capacity vs Operational Availability**: Structural eligibility and capacity (`calculatedCapacity`) for combo configurations are strictly governed by the full `REQ-MENU-VAR-006` structural predicate (parent item ACTIVE, variant ACTIVE and non-archived, complete supply linkage, satisfiable mandatory modifier groups) where each option contributes at most 1, completely excluding momentary inventory stock (`availableCapacity`, `VariantAvailability`). In contrast, operational availability is dynamically determined by Inventory read models and residual stock without altering structural or administrative state.
- **Transient Configuration State Formality**: In `SellableItemConfigurationView`, selection state (`selectionState.selectedComboOptions`) is rigorously defined with nested correlation identifiers, quantity, and signed price deltas, ensuring deterministic state transitions during configuration and handoff.
- **Incomplete vs Valid Persistence States**: Inactive persistence permits incomplete definitions (such as zero-option slots or capacity deficits) with structured warning objects (`incompleteCapacityWarnings` reporting `entityId`, `entityType: 'ComboSlot'`, `minSelections`, `calculatedCapacity`) under REQ-MENU-LIF-002 and REQ-MENU-LIF-003, while strictly rejecting zero-slot configurations. Active persistence enforces complete structural validity across all configurations and slots.
- **Avoidance of Redundant State Machines**: In accordance with Decision D-003 and the Minimal Duplication Principle, simple declared states (`normal`, `empty`, `noResults`, `unavailable`, `reviewRequired`) are maintained directly within view YAML schemas and flow branches without generating redundant state-machine diagrams.

### 4.6 Traceability and Minimal Duplication Check
- **Bidirectional Traceability**: The specification supports complete end-to-end tracing from Requirement ID $\rightarrow$ Flow $\rightarrow$ View $\rightarrow$ Region $\rightarrow$ Control $\rightarrow$ Action.
- **Grounding of Repaired Capabilities**:
  - `REQ-MENU-COM-001`, `REQ-MENU-COM-002`, `REQ-MENU-COM-006`, and `INV-MENU-005`: Ground the requirement that every persisted configuration must have at least one slot, that slots define selection spaces, and that structural capacity is governed by variant eligibility without momentary stock.
  - `REQ-MENU-VAR-006`: Grounds the complete structural eligibility predicate for component leaf variants (active status, non-archived, complete supply linkage, satisfiable mandatory modifiers).
  - `REQ-MENU-MOD-005`, `REQ-MENU-MOD-006`: Ground the atomic transition rules for `ADD` (positive quantity and unit) and `OMIT` (null quantity and unit) ingredient effect directives.
  - `REQ-MENU-FUL-003`: Grounds recipe authoring and the formal contextual navigation control and action (`navigateToRecipeEditorAction` / `navigateToRecipeEditor`).
  - `REQ-MENU-LIF-002`, `REQ-MENU-LIF-003`: Ground the persistence of incomplete definitions in INACTIVE status with structured capacity warnings.
  - `REQ-MENU-REV-003`, `REQ-MENU-REV-004`: Ground non-mutating review confirmation and its clean decoupling from commercial authoring.
- **No Manual Matrices**: In adherence to `docs/ui-spec-arch.md`, no manually maintained element-level traceability matrices, static screen inventories, or duplicated prose documentation files were created, preventing drift and maintenance divergence.

### 4.7 No-Unjustified-Inference Check
- **Boundary Discipline**: The specification strictly adheres to bounded context limits:
  - No Orders/cart/checkout functionality (e.g., cart lines, tax calculations, payment processing, or order submission) is introduced.
  - No Inventory warehouse management (e.g., stock counts, warehouse transfers, reorder levels) is introduced.
  - No user authentication, credential storage, or identity session mechanisms are invented.
- **Visual Design Independence**: The specification is 100% free of layout and styling prescriptions: no colors, typography, hex codes, border radii, shadows, margins, padding, or pixel measurements are present. Prescriptive visual phrases (such as "summary cards") have been eliminated in favor of semantic terminology ("summary entries").
- **Elimination of Unsupported Operations**: Destructive slot removal was eliminated rather than invented, aligning with domain boundaries and avoiding unsupported operations across all canonical artifacts. Unresolved advanced pricing rules remain documented under `OPEN-009` rather than being arbitrarily decided.

---

## 5. Low-Confidence Mappings and Open Issues Tracking

Where the SRS and domain sources do not provide sufficient technical detail to specify UI behavior with full confidence, the specification deliberately avoids inventing arbitrary functionality. The table below correlates these low-confidence areas to the formal entries in [`docs/issues-tracker.md`](../../docs/issues-tracker.md).

| Requirement / Scope Area | Description of UI Ambiguity | Affected Artifacts | Target Heading in Issues Tracker |
| :--- | :--- | :--- | :--- |
| **REQ-MENU-ITM-001**, **REQ-MENU-ITM-002**, **REQ-MENU-REV-003** | Lack of human actor, role, and permission definitions. Only generic actors (`ADMINISTRATOR`, `POS_CLIENT`, `KDS_CLIENT`) exist without granular RBAC or authentication boundaries. | All administrative views (`MenuCatalogAdministrationView`, `MenuItemEditorView`, `ComboReviewView`) | [`docs/issues-tracker.md#missing-human-actor-role-and-permission-assignments`](../../docs/issues-tracker.md#missing-human-actor-role-and-permission-assignments) |
| **All Views** | Undefined outer application shell, top bar, persistent navigation sidebar, breadcrumbs, and deep-linking URL route structures. | Global navigation (`screen-navigation.md`) | [`docs/issues-tracker.md#undefined-global-navigation-and-application-shell-entry-points`](../../docs/issues-tracker.md#undefined-global-navigation-and-application-shell-entry-points) |
| **REQ-MENU-ITM-001**, **REQ-MENU-PRC-002** | Undefined category administration interface (`ItemCategory`, `ComboCategory`) and unspecified search algorithms (exact match vs tokenized, accents/diacritics handling). | `CatalogBrowseView.yaml`, `MenuItemEditorView.yaml`, `browse-catalog.md` | [`docs/issues-tracker.md#undefined-category-administration-and-search-semantics`](../../docs/issues-tracker.md#undefined-category-administration-and-search-semantics) |
| **REQ-MENU-ITM-001** | Missing media asset acquisition, validation, and upload mechanics. The SRS provides only an opaque image URI string. | `MenuItemEditorView.yaml`, `manage-menu-item.md` | [`docs/issues-tracker.md#missing-image-reference-acquisition-and-upload-interface`](../../docs/issues-tracker.md#missing-image-reference-acquisition-and-upload-interface) |
| **REQ-MENU-FUL-001**, **REQ-MENU-FUL-003** | Missing discovery and search UI for external inventory items (`inventoryItemId`) and recipes (`recipeRevisionId`). Treated as raw opaque text inputs. | `MenuItemEditorView.yaml`, `RecipeEditorView.yaml` | [`docs/issues-tracker.md#missing-inventory-item-and-recipe-discovery-interface`](../../docs/issues-tracker.md#missing-inventory-item-and-recipe-discovery-interface) |
| **REQ-MENU-MOD-001**, **REQ-MENU-COM-002** | Unspecified text character limits, field length bounds, and currency formatting standards (documented under SRS `OPEN-010`). | `MenuItemEditorView.yaml`, `ModifierConfigurationView.yaml`, `ComboConfigurationView.yaml` | [`docs/issues-tracker.md#unspecified-ui-input-maxima-and-text-length-limits-open-010`](../../docs/issues-tracker.md#unspecified-ui-input-maxima-and-text-length-limits-open-010) |
| **REQ-MENU-COM-004** | Undefined algorithm for slot matching and partial collision handling during bulk combo configuration copy (documented under SRS `OPEN-002`). | `ComboConfigurationView.yaml`, `manage-combo.md` | [`docs/issues-tracker.md#undefined-combo-slot-matching-and-partial-collision-resolution-open-002`](../../docs/issues-tracker.md#undefined-combo-slot-matching-and-partial-collision-resolution-open-002) |
| **REQ-MENU-REV-005**, **REQ-MENU-COM-001** | Unresolved advanced combo pricing edge cases for fractionated components and repeated modifiers across combo slots (documented under SRS `OPEN-009`). | `ComboReviewView.yaml`, `review-combo.md` | [`docs/issues-tracker.md#unresolved-advanced-combo-pricing-behavior-open-009`](../../docs/issues-tracker.md#unresolved-advanced-combo-pricing-behavior-open-009) |
| **REQ-MENU-VAR-001**, **REQ-MENU-MOD-008**, **REQ-MENU-COM-003** | Absent formal contract for the `ConfiguredSelectionHandoff` payload across the Menu-to-Orders system boundary. (Note: The internal specification of selectionState.selectedComboOptions and its nested componentModifiers is confirmed resolved with an explicit canonical schema). | `SellableItemConfigurationView.yaml`, `configure-sellable-item.md` | [`docs/issues-tracker.md#undefined-menu-to-orders-configured-selection-handoff-contract`](../../docs/issues-tracker.md#undefined-menu-to-orders-configured-selection-handoff-contract) |

---

## 6. Audit Conclusion and Certification

1. **Completeness**: All 46 functional requirements and 5 non-functional requirements have been analyzed and accounted for. 44 functional requirements and 2 non-functional requirements are directly represented in canonical UI artifacts, while 2 functional requirements and 3 non-functional requirements are explicitly justified as non-UI backend responsibilities.
2. **Structural Integrity**: The 8 canonical view definitions and 7 interaction flow specifications exhibit zero orphan views, complete bidirectional topological reachability, and strict adherence to the four orthogonal domain status axes.
3. **Traceability and Discipline**: Every UI element traces directly to authoritative SRS statements without unwarranted inferences, visual design decisions, or leakage of external Orders/Inventory responsibilities.
4. **Resolution of Prior Audit Findings**: All prior audit defects have been verified as resolved in the canonical artifacts:
   - *Combo Configuration Persistence*: Every persisted `ComboConfiguration` requires at least one `ComboSlot` (REQ-MENU-COM-001); zero-slot configurations are rejected across both inactive and active persistence; zero-option slots are allowed only under INACTIVE status with structured warnings (REQ-MENU-LIF-002, REQ-MENU-LIF-003).
   - *Structural Capacity Predicate*: Combo structural capacity (`calculatedCapacity`) and activation use the complete `REQ-MENU-VAR-006` structural eligibility predicate (active parent, active non-archived variant, complete supply linkage, satisfiable mandatory modifier groups) with each enabled option contributing at most 1, strictly excluding momentary inventory stock.
   - *Transient Selection Schema Resolution*: `selectionState.selectedComboOptions` (and nested `componentModifiers`) explicitly defines all nested correlation identifiers (`slotId`, `comboOptionId`, `itemVariantId`, `modifierGroupId`, `modifierOptionId`, `quantity`, `priceDelta`), confirming resolution of the transient selection shape.
   - *Atomic Ingredient Effect Transitions*: `setIngredientEffectOperation` and `setVariantIngredientEffectOperation` atomically enforce positive quantity and non-empty unit when transitioning to `ADD`, and clear them to null when transitioning to `OMIT`.
   - *Removability of Selected Combo Options*: In `configure-sellable-item.md`, `toggleComboOption` permits unconditional removal of already-selected options by `slotId` and `comboOptionId` even if the slot is full or an option becomes unavailable, restricting additions only.
   - *Defined Recipe Navigation Trigger*: Recipe navigation is formalized as an interactive control `navigateToRecipeEditorAction` and action `navigateToRecipeEditor` on `MenuItemEditorView` emitting `navigateToRecipeEditorSignal`, with agreeing flow and navigation definitions.
   - *Elimination of Visual Terminology and Unsupported Actions*: Visual wording ("summary cards") has been replaced with design-neutral "summary entries", and unsupported destructive slot removal has been eliminated across all views and flows.
5. **Documentary Scope and Resolution**: This evaluation is strictly a documentary semantic-specification audit of pre-wireframe artifacts. It confirms that the specification is internally consistent, fully traceable to the SRS, aligned with the UI Specification Architecture, and free of contradictions. In accordance with the documentary boundary, this audit does not constitute runtime, integration, accessibility, performance, or visual design acceptance. The semantic specification provides an unambiguous, design-neutral foundation ready for subsequent low-fidelity wireframe generation upon resolution of the documented open tracker issues.
