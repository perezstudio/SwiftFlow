//
//  ViewNavigatorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Navigator for View files showing block hierarchy and properties/functions
struct ViewNavigatorView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @State private var expandedBlocks: Set<UUID> = []
    @State private var isBlocksExpanded = true
    @State private var isPropertiesExpanded = true
    @State private var isFunctionsExpanded = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if let viewFile = currentViewFile {
                    // Block hierarchy section
                    CollapsibleSection("Hierarchy", isExpanded: $isBlocksExpanded) {
                        if let rootBlock = viewFile.rootBlock {
                            blockTree(rootBlock, depth: 0)
                        } else {
                            CompactEmptyState(message: "No blocks", systemImage: "square.dashed")
                        }
                    }

                    Divider()
                        .padding(.vertical, 4)

                    // Properties section
                    propertiesSection(viewFile)

                    Divider()
                        .padding(.vertical, 4)

                    // Functions section
                    functionsSection(viewFile)
                } else {
                    CompactEmptyState(message: "No view selected", systemImage: "doc")
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Current View File

    private var currentViewFile: ViewFile? {
        guard let fileId = appStore.selectedFileId,
              appStore.selectedFileType == .view else {
            return nil
        }

        let descriptor = FetchDescriptor<ViewFile>(
            predicate: #Predicate { $0.id == fileId }
        )

        return try? modelContext.fetch(descriptor).first
    }

    // MARK: - Block Tree

    private func blockTree(_ block: ViewBlock, depth: Int) -> AnyView {
        let isExpanded = expandedBlocks.contains(block.id)
        let isSelected = appStore.selectedBlockId == block.id
        let hasChildren = block.hasChildren

        return AnyView(
            VStack(spacing: 0) {
                TreeNodeView(
                    title: block.displayName,
                    systemImage: block.blockType.iconName,
                    depth: depth,
                    hasChildren: hasChildren,
                    isExpanded: isExpanded,
                    isSelected: isSelected,
                    onToggleExpand: {
                        if isExpanded {
                            expandedBlocks.remove(block.id)
                        } else {
                            expandedBlocks.insert(block.id)
                        }
                    },
                    onSelect: {
                        appStore.selection.selectBlock(id: block.id)
                    }
                )

                if isExpanded {
                    ForEach(block.sortedChildren) { child in
                        blockTree(child, depth: depth + 1)
                    }
                }
            }
        )
    }

    // MARK: - Properties Section

    @ViewBuilder
    private func propertiesSection(_ viewFile: ViewFile) -> some View {
        CollapsibleSection(
            isExpanded: $isPropertiesExpanded,
            header: {
                HStack {
                    Text("Properties")
                        .font(.headline)

                    Spacer()

                    Button(action: addProperty) {
                        Image(systemName: "plus")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            },
            content: {
                if viewFile.sortedProperties.isEmpty {
                    CompactEmptyState(message: "No properties", systemImage: "list.bullet")
                } else {
                    ForEach(viewFile.sortedProperties) { property in
                        PropertyListRow(
                            wrapper: property.propertyWrapper.displayName,
                            name: property.name,
                            type: property.typeDefinition.toSwiftCode(),
                            isSelected: appStore.selection.selectedPropertyId == property.id
                        ) {
                            appStore.selection.selectProperty(id: property.id)
                        }
                    }
                }
            }
        )
    }

    // MARK: - Functions Section

    @ViewBuilder
    private func functionsSection(_ viewFile: ViewFile) -> some View {
        CollapsibleSection(
            isExpanded: $isFunctionsExpanded,
            header: {
                HStack {
                    Text("Functions")
                        .font(.headline)

                    Spacer()

                    Button(action: addFunction) {
                        Image(systemName: "plus")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            },
            content: {
                if viewFile.sortedFunctions.isEmpty {
                    CompactEmptyState(message: "No functions", systemImage: "function")
                } else {
                    ForEach(viewFile.sortedFunctions) { function in
                        FunctionListRow(
                            name: function.name,
                            signature: "(\(function.sortedParameters.map { $0.internalName }.joined(separator: ", ")))",
                            isAsync: function.isAsync,
                            throws_: function.throwsError,
                            isSelected: appStore.selection.selectedFunctionId == function.id
                        ) {
                            appStore.selection.selectFunction(id: function.id)
                        }
                    }
                }
            }
        )
    }

    // MARK: - Actions

    private func addProperty() {
        // Will be implemented with property editor
    }

    private func addFunction() {
        // Will be implemented with function editor
    }
}

// MARK: - ViewBlock Extension

extension ViewBlock {
    var hasChildren: Bool {
        !(children ?? []).isEmpty
    }
}

#Preview {
    ViewNavigatorView()
        .environment(AppStore())
        .frame(width: 250, height: 500)
}
