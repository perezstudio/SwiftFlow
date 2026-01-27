# SwiftFlow Project Instructions

## Build Verification
Always build the project before declaring any task complete to ensure there are no compilation errors.

## Design Principles

### Reusable Components
Create reusable UI components wherever possible to maintain consistency and reduce duplication:
- **Form Components**: CustomTextField, CustomPicker, CustomToggle, CustomStepper
- **Layout Components**: CollapsibleSection, InspectorSection, SectionHeader
- **List Components**: CustomList, TreeView, TreeNode, ListRow
- **Editor Components**: ExpressionEditor, TypeSelector, ColorPicker, IconPicker
- **Feedback Components**: EmptyStateView, LoadingView, ErrorView

### Custom UI (No Large SwiftUI Components)
- Use `ScrollView` + `LazyVStack` instead of `List`
- Use existing `SplitViewContainer` pattern for splits
- Build custom tree views with manual indentation

---

## Implementation Checklist

### Phase 1: Data Models
- [x] `Model/Enums/ViewBlockType.swift` - All view block types
- [x] `Model/Enums/ModifierType.swift` - All modifier types
- [x] `Model/Enums/LogicBlockType.swift` - Logic block types
- [x] `Model/Enums/PropertyWrapperType.swift` - @State, @Binding, etc.
- [x] `Model/Enums/ExpressionType.swift` - Expression node types
- [x] `Model/TypeDefinition.swift` - Type system representation
- [x] `Model/Expression.swift` - Expression tree model
- [x] `Model/FunctionParameter.swift` - Shared parameter model
- [x] `Model/Asset.swift` - Asset model
- [x] `Model/Project.swift` - Root project model
- [x] `Model/ViewFile.swift` - View file model
- [x] `Model/ViewBlock.swift` - Hierarchical block model
- [x] `Model/ViewModifier.swift` - Modifier model
- [x] `Model/ViewProperty.swift` - View property model
- [x] `Model/ViewFunction.swift` - View function model
- [x] `Model/DataModel.swift` - SwiftData model definition
- [x] `Model/ModelVersion.swift` - Schema version model
- [x] `Model/ModelProperty.swift` - Model property model
- [x] `Model/ModelRelationship.swift` - Relationship model
- [x] `Model/QueryFile.swift` - Query file model
- [x] `Model/QueryProperty.swift` - Query property model
- [x] `Model/QueryFunction.swift` - Query function model
- [x] `Model/LogicBlock.swift` - Workflow block model
- [x] `Model/ModelContainer+SwiftFlow.swift` - Container config with CloudKit

### Phase 2: Stores
- [x] `Store/AppStore.swift` - Central store coordinator
- [x] `Store/ProjectStore.swift` - Project CRUD operations
- [x] `Store/SelectionStore.swift` - Selection state tracking
- [x] `Store/EditorStore.swift` - Editor state (zoom, pan, mode)
- [x] `Store/ClipboardStore.swift` - Copy/paste operations
- [x] `Store/UndoStore.swift` - Undo/redo stack
- [x] `Store/DragCoordinator.swift` - Drag & drop state
- [x] Wire stores to SwiftFlowApp entry point

### Phase 3: Reusable Components
- [x] `View/Components/CollapsibleSection.swift` - Expandable section
- [x] `View/Components/InspectorSection.swift` - Inspector section layout
- [x] `View/Components/SectionHeader.swift` - Section header with actions
- [x] `View/Components/CustomTextField.swift` - Styled text field
- [x] `View/Components/CustomList.swift` - ScrollView + LazyVStack list
- [x] `View/Components/TreeView.swift` - Generic tree component
- [x] `View/Components/TreeNode.swift` - Tree node with expand/collapse
- [x] `View/Components/ListRow.swift` - Selectable list row
- [x] `View/Components/TypeSelector.swift` - Type picker component
- [x] `View/Components/EmptyStateView.swift` - Empty state placeholder
- [x] `View/Components/DropIndicatorView.swift` - Drop target indicator

### Phase 4: Sidebar UI
- [ ] `View/Sidebar/SidebarView.swift` - Sidebar container
- [ ] `View/Sidebar/FileSelectorView.swift` - File list with sections
- [ ] `View/Sidebar/FileRowView.swift` - Individual file row
- [ ] `View/Sidebar/FileNavigatorView.swift` - Context-switching navigator
- [ ] `View/Sidebar/ViewNavigatorView.swift` - View block tree + vars
- [ ] `View/Sidebar/ModelNavigatorView.swift` - Model version list
- [ ] `View/Sidebar/QueryNavigatorView.swift` - Query vars + functions
- [ ] `View/Sidebar/AssetsLibraryView.swift` - Asset browser
- [ ] Update ContentView to use SidebarView

### Phase 5: View Editor Core
- [ ] `View/Editor/ContentEditorView.swift` - Editor switcher
- [ ] `View/Editor/WelcomeView.swift` - No selection state
- [ ] `View/Editor/View/ViewEditorView.swift` - View editor container
- [ ] `View/Editor/View/BlockPaletteView.swift` - Block picker
- [ ] `View/Editor/View/BlockPaletteItem.swift` - Palette block item
- [ ] `View/Editor/View/BlockCanvasView.swift` - Zoomable canvas
- [ ] `View/Editor/View/GridBackgroundView.swift` - Canvas grid
- [ ] `View/Editor/View/BlockTreeView.swift` - Block hierarchy render
- [ ] `View/Editor/View/BlockNodeView.swift` - Single block node
- [ ] `View/Editor/View/ConnectionLineView.swift` - Parent-child lines
- [ ] Update ContentView to use ContentEditorView

### Phase 6: Inspector UI
- [ ] `View/Inspector/InspectorView.swift` - Inspector switcher
- [ ] `View/Inspector/EmptyInspectorView.swift` - No selection state
- [ ] `View/Inspector/FileInspectorView.swift` - File settings
- [ ] `View/Inspector/BlockInspectorView.swift` - Block configuration
- [ ] `View/Inspector/BlockConfigurationEditor.swift` - Block-specific config
- [ ] `View/Inspector/ModifierListEditor.swift` - Modifier list
- [ ] `View/Inspector/ModifierRowView.swift` - Single modifier row
- [ ] `View/Inspector/AddModifierMenu.swift` - Add modifier picker
- [ ] `View/Inspector/ModifierConfigEditor.swift` - Modifier settings
- [ ] Update ContentView to use InspectorView

### Phase 7: View Properties & Functions
- [ ] `View/Inspector/PropertyListEditor.swift` - Property list
- [ ] `View/Inspector/PropertyRowView.swift` - Single property row
- [ ] `View/Inspector/AddPropertySheet.swift` - New property form
- [ ] `View/Inspector/FunctionListEditor.swift` - Function list
- [ ] `View/Inspector/FunctionRowView.swift` - Single function row
- [ ] `View/Components/ExpressionEditorView.swift` - Expression builder
- [ ] `View/Components/VariablePickerView.swift` - Variable selector
- [ ] `View/Editor/View/FunctionEditorView.swift` - Function body editor

### Phase 8: Data Model Editor
- [ ] `View/Editor/Model/ModelEditorView.swift` - Model editor container
- [ ] `View/Editor/Model/SchemaEditorView.swift` - Property list editor
- [ ] `View/Editor/Model/PropertyRowEditor.swift` - Property editor row
- [ ] `View/Editor/Model/RelationshipEditor.swift` - Relationship config
- [ ] `View/Editor/Model/VersionListView.swift` - Version sidebar
- [ ] `View/Inspector/ModelInspectorView.swift` - Model settings
- [ ] `View/Inspector/PropertyInspectorView.swift` - Property settings

### Phase 9: Query Editor
- [ ] `View/Editor/Query/QueryEditorView.swift` - Query editor container
- [ ] `View/Editor/Query/WorkflowEditorView.swift` - Block workflow canvas
- [ ] `View/Editor/Query/LogicBlockNodeView.swift` - Logic block render
- [ ] `View/Editor/Query/LogicBlockPalette.swift` - Logic block picker
- [ ] `View/Inspector/QueryInspectorView.swift` - Query settings
- [ ] `View/Inspector/QueryPropertyEditor.swift` - Query property config
- [ ] `View/Inspector/LogicBlockInspector.swift` - Logic block config

### Phase 10: Code Generation
- [ ] `CodeGen/CodeGenContext.swift` - Generation context
- [ ] `CodeGen/CodeGeneratable.swift` - Protocol definition
- [ ] `CodeGen/ViewCodeGenerator.swift` - SwiftUI code output
- [ ] `CodeGen/ModelCodeGenerator.swift` - SwiftData code output
- [ ] `CodeGen/QueryCodeGenerator.swift` - @Observable code output
- [ ] `CodeGen/ProjectExporter.swift` - Xcode project export
- [ ] iOS + macOS target configuration

### Phase 11: CloudKit & Polish
- [ ] CloudKit container configuration
- [ ] Sync status indicator UI
- [ ] Conflict resolution UI
- [ ] Implement undo/redo in UndoStore
- [ ] Wire undo/redo to all operations
- [ ] Keyboard shortcuts
- [ ] Performance optimization

---

## Verification

After completing each phase:
1. Build project (`xcodebuild -scheme SwiftFlow`)
2. Run app and test new functionality
3. Verify SwiftData persistence (quit and relaunch)
4. Test CloudKit sync (when implemented)
